<?php
require __DIR__ . '/db.php';

// seul un de ces noms peut être inséré dans la requête.
$tables = ['commune', 'station', 'distance', 'modele', 'velo', 'adherent', 'emprunt', 'intervention'];
$table  = (isset($_GET['table']) && in_array($_GET['table'], $tables, true)) ? $_GET['table'] : null;

$chiffres = ligne("
    SELECT (SELECT COUNT(*) FROM station)                                   AS stations,
           (SELECT COUNT(*) FROM velo)                                      AS velos,
           (SELECT COUNT(*) FROM velo WHERE etat = 'disponible'
                                        AND niveau_batterie >= :min)        AS velos_empruntables,
           (SELECT COUNT(*) FROM velo WHERE etat = 'maintenance')           AS en_maintenance,
           (SELECT COUNT(*) FROM adherent)                                  AS adherents,
           (SELECT COUNT(*) FROM emprunt WHERE date_heure_arrivee IS NULL)   AS emprunts_en_cours",
    ['min' => BATTERIE_MIN]);

entete('Accueil');
?>
<p>Gestion d'une flotte de vélos électriques en libre-service : stations, vélos,
   adhérents, emprunts et maintenance.</p>

<div class="chiffres">
  <?php foreach ($chiffres as $nom => $valeur): ?>
    <div><strong><?= h($valeur) ?></strong><span><?= h(str_replace('_', ' ', $nom)) ?></span></div>
  <?php endforeach; ?>
</div>

<h2>Contenu des tables</h2>
<p class="onglets">
  <?php foreach ($tables as $t): ?>
    <a href="?table=<?= $t ?>"<?= $t === $table ? ' class="actif"' : '' ?>><?= $t ?></a>
  <?php endforeach; ?>
</p>
<?php
if ($table) {
    afficher_table(requete("SELECT * FROM $table ORDER BY 1 LIMIT 200"));
}
pied();
