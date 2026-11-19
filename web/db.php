<?php
// db.php : connexion à la base et fonctions communes à toutes les pages.

date_default_timezone_set('Europe/Paris');

const BATTERIE_MIN = 20;  // niveau de batterie minimum (%) pour emprunter un vélo

// Échappe un texte avant de l'afficher dans la page (évite l'injection HTML).
function h($texte) {
    return htmlspecialchars((string) $texte, ENT_QUOTES, 'UTF-8');
}

if (!file_exists(__DIR__ . '/config.php')) {
    die('Fichier config.php manquant : copiez config.example.php en config.php.');
}
require __DIR__ . '/config.php';

try {
    $pdo = new PDO("pgsql:host=$DB_HOST;port=$DB_PORT;dbname=$DB_NAME", $DB_USER, $DB_PASS, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,  // erreur SQL => exception
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,        // lignes = tableaux 'colonne' => valeur
    ]);
    $pdo->exec("SET client_encoding TO 'UTF8'");
} catch (PDOException $e) {
    die('Connexion à la base impossible : ' . h($e->getMessage()));
}

// ---------- Accès aux données (toujours des requêtes préparées) ----------

// Exécute un SELECT et renvoie toutes les lignes.
function requete($sql, $params = []) {
    global $pdo;
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}

// Exécute un SELECT et renvoie la première ligne (ou null).
function ligne($sql, $params = []) {
    $lignes = requete($sql, $params);
    return $lignes ? $lignes[0] : null;
}

// Exécute un INSERT / UPDATE / DELETE et renvoie le nombre de lignes touchées.
function executer($sql, $params = []) {
    global $pdo;
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->rowCount();
}

// ---------- Affichage ----------

// Génère les <option> d'une liste déroulante à partir d'un SELECT (valeur, texte).
function options($sql, $choisi = null) {
    $html = '';
    foreach (requete($sql) as $l) {
        list($valeur, $texte) = array_values($l);
        $sel = ((string) $valeur === (string) $choisi) ? ' selected' : '';
        $html .= '<option value="' . h($valeur) . '"' . $sel . '>' . h($texte) . '</option>';
    }
    return $html;
}

// Affiche le résultat d'une requête sous forme de tableau HTML.
function afficher_table($lignes) {
    if (!$lignes) {
        echo '<p class="vide">Aucun résultat.</p>';
        return;
    }
    echo '<table><tr>';
    foreach (array_keys($lignes[0]) as $colonne) {
        echo '<th>' . h(str_replace('_', ' ', $colonne)) . '</th>';
    }
    echo '</tr>';
    foreach ($lignes as $l) {
        echo '<tr>';
        foreach ($l as $v) {
            if ($v === null)      $v = '—';
            elseif ($v === true)  $v = 'oui';
            elseif ($v === false) $v = 'non';
            else $v = preg_replace('/^(\d{4}-\d\d-\d\d \d\d:\d\d):\d\d(\.\d+)?$/', '$1', $v); // date sans secondes
            echo '<td>' . h($v) . '</td>';
        }
        echo '</tr>';
    }
    echo '</table><p class="compte">' . count($lignes) . ' ligne(s)</p>';
}

function entete($titre) {
    $pages = ['index.php' => 'Accueil', 'consultation.php' => 'Consultations',
              'statistiques.php' => 'Statistiques', 'gestion.php' => 'Gestion'];
    $courante = basename($_SERVER['SCRIPT_NAME']);
    echo '<!DOCTYPE html><html lang="fr"><head><meta charset="utf-8">';
    echo '<meta name="viewport" content="width=device-width, initial-scale=1">';
    echo '<title>' . h($titre) . ' – Flotte de vélos</title>';
    echo '<link rel="stylesheet" href="style.css"></head><body>';
    echo '<header><strong>🚲 Flotte de vélos</strong><nav>';
    foreach ($pages as $fichier => $nom) {
        $classe = ($fichier === $courante) ? ' class="actif"' : '';
        echo '<a href="' . $fichier . '"' . $classe . '>' . $nom . '</a>';
    }
    echo '</nav></header><main><h1>' . h($titre) . '</h1>';
}

function pied() {
    echo '</main></body></html>';
}

// ---------- Pages « liste de requêtes » (consultation et statistiques) ----------

// Paramètres possibles : libellé et, pour une liste déroulante, le SELECT (valeur, texte).
$PARAMETRES = [
    'commune'  => ['Commune',  "SELECT id_commune, nom_commune FROM commune ORDER BY nom_commune"],
    'station'  => ['Station',  "SELECT id_station, nom_station FROM station ORDER BY nom_station"],
    'adherent' => ['Adhérent', "SELECT id_adherent, nom || ' ' || prenom FROM adherent ORDER BY nom, prenom"],
    'velo'     => ['Vélo',     "SELECT reference AS valeur, reference AS texte FROM velo ORDER BY reference"],
    'date'     => ['Semaine contenant le', null],
    'mois'     => ['Mois',     null],
];

function valeur_defaut($nom) {
    global $PARAMETRES;
    if ($nom === 'date') return date('Y-m-d');
    if ($nom === 'mois') return date('Y-m');
    $l = ligne($PARAMETRES[$nom][1]);     // premier élément de la liste
    return $l ? array_values($l)[0] : '';
}

function champ($nom, $valeur) {
    global $PARAMETRES;
    list($libelle, $sql) = $PARAMETRES[$nom];
    if ($sql !== null) {
        $champ = '<select name="' . $nom . '">' . options($sql, $valeur) . '</select>';
    } else {
        $type = ($nom === 'mois') ? 'month' : 'date';
        $champ = '<input type="' . $type . '" name="' . $nom . '" value="' . h($valeur) . '" required>';
    }
    return '<label>' . h($libelle) . ' ' . $champ . '</label>';
}

// Enlève l'indentation commune du code SQL pour l'afficher proprement.
function sql_lisible($sql) {
    $sql = trim($sql, "\r\n");
    preg_match('/^ */', $sql, $m);
    return preg_replace('/^' . $m[0] . '/m', '', rtrim($sql));
}

// Menu des requêtes à gauche, requête choisie (?q=numéro) à droite.
function page_requetes($requetes) {
    $i = isset($_GET['q']) ? (int) $_GET['q'] : 0;
    if (!isset($requetes[$i])) $i = 0;
    $r = $requetes[$i];
    $params = isset($r['params']) ? $r['params'] : [];

    echo '<div class="requetes"><nav class="menu">';
    foreach ($requetes as $j => $req) {
        $classe = ($j === $i) ? ' class="actif"' : '';
        echo '<a href="?q=' . $j . '"' . $classe . '>' . h($req['titre']) . '</a>';
    }
    echo '</nav><section>';
    echo '<h2>' . h($r['titre']) . '</h2>';

    // Valeur de chaque paramètre : celle du formulaire, sinon une valeur par défaut.
    $valeurs = [];
    foreach ($params as $p) {
        $valeurs[$p] = isset($_GET[$p]) ? $_GET[$p] : valeur_defaut($p);
    }
    if ($params) {
        echo '<form method="get" class="parametres"><input type="hidden" name="q" value="' . $i . '">';
        foreach ($params as $p) echo champ($p, $valeurs[$p]);
        echo '<button>Afficher</button></form>';
    }

    try {
        afficher_table(requete($r['sql'], $valeurs));
    } catch (PDOException $e) {
        echo '<p class="erreur">' . h($e->getMessage()) . '</p>';
    }
    echo '<details><summary>Voir la requête SQL</summary><pre>' . h(sql_lisible($r['sql'])) . '</pre></details>';
    echo '</section></div>';
}
