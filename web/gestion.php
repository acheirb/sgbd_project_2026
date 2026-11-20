<?php
// gestion.php : mises à jour de la base (emprunts, adhérents, maintenance).
require __DIR__ . '/db.php';

// Erreur « métier » : règle de l'énoncé non respectée.
function refuser($message) {
    throw new Exception($message);
}

// Nombre de bornes libres dans une station.
function places_libres($id_station) {
    $l = ligne("SELECT s.nb_bornes - COUNT(v.reference) AS libres
                FROM station s LEFT JOIN velo v ON v.id_station = s.id_station
                WHERE s.id_station = :s GROUP BY s.id_station", ['s' => $id_station]);
    return $l ? (int) $l['libres'] : 0;
}

// Chaque action est exécutée dans une transaction : tout réussit ou rien n'est modifié.
$message = null;
$erreur  = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $p = $_POST;
    try {
        $pdo->beginTransaction();
        switch (isset($p['action']) ? $p['action'] : '') {

        case 'emprunter':
            // FOR UPDATE verrouille les lignes jusqu'à la fin de la transaction :
            // deux emprunts simultanés du même vélo (ou du même adhérent) sont impossibles.
            if (!ligne("SELECT 1 FROM adherent WHERE id_adherent = :a FOR UPDATE", ['a' => $p['adherent']]))
                refuser('Adhérent inconnu.');
            $velo = ligne("SELECT * FROM velo WHERE reference = :r FOR UPDATE", ['r' => $p['velo']]);
            if (!$velo || $velo['etat'] !== 'disponible' || $velo['id_station'] === null)
                refuser("Ce vélo n'est pas disponible.");
            if ($velo['niveau_batterie'] < BATTERIE_MIN)
                refuser('Batterie insuffisante (minimum ' . BATTERIE_MIN . ' %).');
            if (ligne("SELECT 1 FROM emprunt WHERE id_adherent = :a AND date_heure_arrivee IS NULL",
                      ['a' => $p['adherent']]))
                refuser('Cet adhérent a déjà un emprunt en cours.');
            executer("INSERT INTO emprunt (id_adherent, reference, id_station_depart)
                      VALUES (:a, :r, :s)",
                     ['a' => $p['adherent'], 'r' => $velo['reference'], 's' => $velo['id_station']]);
            executer("UPDATE velo SET etat = 'en_utilisation', id_station = NULL WHERE reference = :r",
                     ['r' => $velo['reference']]);
            $message = "Emprunt du vélo {$velo['reference']} enregistré.";
            break;

        case 'rendre':
            $e = ligne("SELECT * FROM emprunt WHERE id_emprunt = :e AND date_heure_arrivee IS NULL FOR UPDATE",
                       ['e' => $p['emprunt']]);
            if (!$e) refuser("Cet emprunt n'est pas en cours.");
            if (places_libres($p['station']) <= 0) refuser("Plus de borne libre dans cette station.");
            $distance = (float) str_replace(',', '.', $p['distance']);
            if ($distance < 0) refuser('La distance doit être positive.');
            executer("UPDATE emprunt SET date_heure_arrivee = CURRENT_TIMESTAMP,
                             id_station_arrivee = :s, distance_parcourue = :d
                      WHERE id_emprunt = :e",
                     ['s' => $p['station'], 'd' => $distance, 'e' => $e['id_emprunt']]);
            executer("UPDATE velo SET etat = 'disponible', id_station = :s,
                             kilometrage = kilometrage + :d
                      WHERE reference = :r",
                     ['s' => $p['station'], 'd' => $distance, 'r' => $e['reference']]);
            $message = "Vélo {$e['reference']} rendu.";
            break;

        case 'ajouter_adherent':
            executer("INSERT INTO adherent (nom, prenom, adresse, email, telephone, id_commune)
                      VALUES (:nom, :prenom, :adresse, :email, :tel, :commune)",
                     ['nom' => trim($p['nom']), 'prenom' => trim($p['prenom']),
                      'adresse' => trim($p['adresse']), 'email' => trim($p['email']),
                      'tel' => trim($p['telephone']), 'commune' => $p['commune']]);
            $message = 'Adhérent ajouté.';
            break;

        case 'renouveler':
            executer("UPDATE adherent SET date_adhesion = CURRENT_DATE WHERE id_adherent = :a",
                     ['a' => $p['adherent']]);
            $message = 'Adhésion renouvelée pour un an.';
            break;

        case 'supprimer_adherent':
            // On garde l'historique : un adhérent qui a déjà emprunté n'est pas supprimé.
            if (ligne("SELECT 1 FROM emprunt WHERE id_adherent = :a", ['a' => $p['adherent']]))
                refuser("Suppression impossible : cet adhérent a des emprunts dans l'historique.");
            executer("DELETE FROM adherent WHERE id_adherent = :a", ['a' => $p['adherent']]);
            $message = 'Adhérent supprimé.';
            break;

        case 'intervention':
            $velo = ligne("SELECT * FROM velo WHERE reference = :r FOR UPDATE", ['r' => $p['velo']]);
            if (!$velo || $velo['etat'] === 'en_utilisation')
                refuser("Ce vélo est en cours d'utilisation.");
            executer("INSERT INTO intervention (date_intervention, nature, duree_heures, reference)
                      VALUES (CURRENT_DATE, :n, :d, :r)",
                     ['n' => trim($p['nature']), 'd' => str_replace(',', '.', $p['duree']),
                      'r' => $velo['reference']]);
            executer("UPDATE velo SET etat = 'maintenance', id_station = NULL WHERE reference = :r",
                     ['r' => $velo['reference']]);
            $message = "Vélo {$velo['reference']} envoyé en maintenance.";
            break;

        case 'remettre':
            $velo = ligne("SELECT * FROM velo WHERE reference = :r FOR UPDATE", ['r' => $p['velo']]);
            if (!$velo || $velo['etat'] !== 'maintenance') refuser("Ce vélo n'est pas en maintenance.");
            if (places_libres($p['station']) <= 0) refuser("Plus de borne libre dans cette station.");
            executer("UPDATE velo SET etat = 'disponible', niveau_batterie = 100, id_station = :s
                      WHERE reference = :r", ['s' => $p['station'], 'r' => $velo['reference']]);
            $message = "Vélo {$velo['reference']} remis en service (batterie rechargée).";
            break;

        default:
            refuser('Action inconnue.');
        }
        $pdo->commit();
    } catch (Exception $ex) {          // PDOException hérite aussi de Exception
        if ($pdo->inTransaction()) $pdo->rollBack();
        $erreur = $ex->getMessage();
    }
}

// Listes déroulantes (recalculées après la mise à jour).
$adherents      = "SELECT id_adherent, nom || ' ' || prenom FROM adherent ORDER BY nom, prenom";
$adherents_dispo = "SELECT id_adherent, nom || ' ' || prenom FROM adherent a
                    WHERE NOT EXISTS (SELECT 1 FROM emprunt e
                                      WHERE e.id_adherent = a.id_adherent AND e.date_heure_arrivee IS NULL)
                    ORDER BY nom, prenom";
$velos_dispo = "SELECT v.reference, v.reference || ' – ' || s.nom_station || ' (' || v.niveau_batterie || ' %)'
                FROM velo v JOIN station s ON s.id_station = v.id_station
                WHERE v.etat = 'disponible' AND v.niveau_batterie >= " . BATTERIE_MIN . "
                ORDER BY s.nom_station, v.niveau_batterie DESC";
$emprunts_en_cours = "SELECT e.id_emprunt, e.reference || ' – ' || a.prenom || ' ' || a.nom
                      FROM emprunt e JOIN adherent a ON a.id_adherent = e.id_adherent
                      WHERE e.date_heure_arrivee IS NULL ORDER BY e.reference";
$stations_libres = "SELECT s.id_station, s.nom_station || ' (' || (s.nb_bornes - COUNT(v.reference)) || ' places)'
                    FROM station s LEFT JOIN velo v ON v.id_station = s.id_station
                    GROUP BY s.id_station, s.nom_station, s.nb_bornes
                    HAVING s.nb_bornes > COUNT(v.reference) ORDER BY s.nom_station";
$velos_reparables = "SELECT reference, reference || ' (' || etat || ')' FROM velo
                     WHERE etat IN ('disponible', 'hors_service') ORDER BY reference";
$velos_maintenance = "SELECT reference AS valeur, reference AS texte FROM velo
                      WHERE etat = 'maintenance' ORDER BY reference";
$communes = "SELECT id_commune, nom_commune FROM commune ORDER BY nom_commune";

entete('Gestion');
if ($message) echo '<p class="succes">' . h($message) . '</p>';
if ($erreur)  echo '<p class="erreur">' . h($erreur) . '</p>';
?>
<div class="cartes">
  <form method="post" class="carte">
    <h2>Emprunter un vélo</h2>
    <input type="hidden" name="action" value="emprunter">
    <label>Adhérent <select name="adherent" required><?= options($adherents_dispo) ?></select></label>
    <label>Vélo <select name="velo" required><?= options($velos_dispo) ?></select></label>
    <button>Emprunter</button>
  </form>

  <form method="post" class="carte">
    <h2>Rendre un vélo</h2>
    <input type="hidden" name="action" value="rendre">
    <label>Emprunt en cours <select name="emprunt" required><?= options($emprunts_en_cours) ?></select></label>
    <label>Station d'arrivée <select name="station" required><?= options($stations_libres) ?></select></label>
    <label>Distance (km) <input type="number" name="distance" step="0.1" min="0" required></label>
    <button>Rendre</button>
  </form>

  <form method="post" class="carte">
    <h2>Nouvel adhérent</h2>
    <input type="hidden" name="action" value="ajouter_adherent">
    <label>Nom <input name="nom" maxlength="40" required></label>
    <label>Prénom <input name="prenom" maxlength="40" required></label>
    <label>Adresse <input name="adresse" maxlength="100" required></label>
    <label>Commune <select name="commune" required><?= options($communes) ?></select></label>
    <label>E-mail <input type="email" name="email" maxlength="100" required></label>
    <label>Téléphone <input name="telephone" maxlength="20" required></label>
    <button>Ajouter</button>
  </form>

  <div class="carte">
    <h2>Adhésion</h2>
    <form method="post">
      <label>Adhérent <select name="adherent" required><?= options($adherents) ?></select></label>
      <button name="action" value="renouveler">Renouveler</button>
      <button name="action" value="supprimer_adherent" class="danger"
              onclick="return confirm('Supprimer cet adhérent ?')">Supprimer</button>
    </form>
  </div>

  <form method="post" class="carte">
    <h2>Envoyer en maintenance</h2>
    <input type="hidden" name="action" value="intervention">
    <label>Vélo <select name="velo" required><?= options($velos_reparables) ?></select></label>
    <label>Nature <input name="nature" maxlength="100" required placeholder="Freins défectueux"></label>
    <label>Durée (heures) <input type="number" name="duree" step="0.5" min="0.5" required></label>
    <button>Enregistrer</button>
  </form>

  <form method="post" class="carte">
    <h2>Remettre en service</h2>
    <input type="hidden" name="action" value="remettre">
    <label>Vélo <select name="velo" required><?= options($velos_maintenance) ?></select></label>
    <label>Station <select name="station" required><?= options($stations_libres) ?></select></label>
    <button>Remettre</button>
  </form>
</div>
<?php pied();
