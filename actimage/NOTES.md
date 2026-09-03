# NOTES

## Le Contexte: l'ONaCVG

- Gestion d'un patrimoine funéraire de plus de 800 000 sépultures militaires.
- Inspection et entretien des sépultures, commandes de plaques
- Actuellement : base MS Access historique dont l'auteur ne travaille plus avec l'Office
- **Conséquence** : Un chaos de données (bases filles désynchronisées de la base mère).
## DÉFI 1

### DÉFI 1 : Migration et Résolution de Conflits

**Le Problème :**
- Bases filles extraites de la base mère
- Les identifiants (`sdr_num`) se chevauchent entre la base mère et les bases filles.
- Plus de 80 000 collisions d'identifiants détectées.
- **Ambiguïté** : S'agit-il d'une vraie collision (deux soldats) ou d'un enrichissement légitime (même soldat) ?
- Une fusion naïve ou entièrement automatisée est impossible.

### DÉFI 1 : Architecture Asynchrone

**La Solution :**
- Mise en place d'un traitement asynchrone (Symfony/Messenger).
- **Processus** :
  1. Upload du CSV par l'utilisateur.
  2. Découpage par lots (évaluation paresseuse).
  3. Insertion automatique des entrées sans conflit.
  4. Isolation des conflits pour résolution manuelle par interface.
    1. Vraie collision (soldats différents): insertion de l'entrée fille dans la base mère.
    2. Entrée fille enrichie entrée mère: écrasemetnt de la mère par la fille et historisation de la mère.
    3. Entrée fille non pertinente (inférieure ou égale  mère): Historisation de la fille.

### DÉFI 1 : Les 3 Stratégies de Résolution

- Interface d'affichage de conflit
- Mise en avant des différences enre entrées
- Boutons d'action pour les 3 stratégies présentées

## DÉFI 2

### DÉFI 2 : Du plat au relationnel

- Conflits et doublons éliminés de la base mère
- Table unique de plus de 40 colonnes sans aucune intégrité référentielle.
- Redondance massive
    - "Sergent" écrit de 3 façons différentes
    - Changer le nom d'une commune requiert de changer de nombreuses cellules
- Mises à jour centralisées impossibles, maintenance intenable à long terme.

### DÉFI 2 : Modélisation en étoile (Thésaurus)

- Extraction d'une quinzaine d'entités fortes (Pays, Departement, Commune, Grade, Unité, Nationalité...).
- Les entités **Soldat** et **Site** deviennent les pivots centraux.
- Mise en place de 15 clés étrangères pour garantir l'intégrité référentielle côté BDD

### DÉFI 2 : La contrainte astucieuse

**Garantir que la commune et son département appartiennent au même pays :**
- **Contrainte** : Pas possible via un simple `CHECK` (cross-table), et la validation applicative (Symfony) est sujette à l'erreur humaine.
- **Solution** : Clé étrangère composite sur `(departement_id, pays_id)`.
- La base de données elle-même rend l'état invalide impossible à représenter.

## DÉFI 3

### DÉFI 3 : Thésaurus & Normalisation

**Le Problème :**
- base utilisée comme source pour Mémoire des Hommes (portail du ministère des armées)
- Contrainte de n'avoir que des valeurs de leurs thésurus
- Données textuelles libres = chaos orthographique.
- Près de 850 000 lignes à valider et importer.
- **Impératif** : Les erreurs ne doivent pas bloquer l'import global.

### DÉFI 3 : Commandes de synchronisation

**La Solution :**
- Création d'une famille de commandes génériques de synchro (une par entité)
- Import des thésaurus
    1. d'entités autoportantes (sans dépendance)
    2. d'entités dépendantes sur les premières
- Import des soldats (sans thésaurus, base mère moche à 40 colonnes)
- Tolérance aux fautes : si une ligne échoue (ex: violation d'unicité), elle est loggée et ignorée, l'import continue.
- Utilisation de `league/csv` avec générateurs pour une **lazy evaluation** efficace.

## DÉFI 4

### DÉFI 4 : Inspection hors-ligne

- Inspection des sites pour évaluer leurs états
- Localisation reculée des sites
- Absence potentielle de signal internet sur le terrain.
- **Besoin** : Le formulaire d'inspection sur tablette doit fonctionner sans réseau.

### DÉFI 4 : Le cache du navigateur

- Refus d'un framework frontend lourd (SPA) complexe à maintenir.
- **Mécanisme** : Utilisation du cache natif du navigateur (Service Worker).
- Phase online : Préchargement des données critiques.
- Phase offline : Requêtes GET interceptées et servies par le cache local.
- Phase de retour online : Les soumissions de formulaires (POST) accumulées sont rejouées.

## Conclusion

- Sujet principal: **les données**
- 800 000 * 40 = 32 000 000 cellules
- Données datant de 2 siècles => espérance de vie raisonnable d'encore 2 siècles
- Besoin de créer une structure de modélisation et de stockage rigide
- Phases de la base:
    - Écriture initiale des données pour la postérité (papier)
    - Numérisation pour le traitement et l'accès (Base MS Access)
    - Normalisation et restructuration pour la stabilité dans le temps (nous)

## Bonus

- **Philosophie** : *"Make Illegal States Unrepresentable"* (leçon tirée d'OCaml, appliquée à PHP, Symfony, PostgreSQL)
- **Pragmatisme** : La qualité et la rigueur d'un logiciel ne viennent pas que du langage, mais de ses outils (PHPStan niveau 9, CI stricte).
- **Impact** : Apporter une vraie solution de terrain pour des agents de l'ONaCVG, donnant du sens au code.
