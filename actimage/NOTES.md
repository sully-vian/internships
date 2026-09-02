# NOTES

## Le Contexte: l'ONaCVG

- Gestion d'un patrimoine funéraire de plus de 800 000 sépultures militaires.
- Inspection et entretien des sépultures, commandes de plaques
- Actuellement : base MS Access historique dont l'auteur ne travaille plus avec l'Office
- **Conséquence** : Un chaos de données (bases filles désynchronisées de la base mère).

## DÉFI 1 : Migration et Résolution de Conflits

**Le Problème :**
- Bases filles tirées de la base mère
- Les identifiants (`sdr_num`) se chevauchent entre la base mère et les bases filles.
- Plus de 80 000 collisions d'identifiants détectées.
- **Ambiguïté** : S'agit-il d'une vraie collision (deux soldats) ou d'un enrichissement légitime (même soldat) ?
- Une fusion naïve ou entièrement automatisée est impossible.

## DÉFI 1 : Architecture Asynchrone

**La Solution :**
- Mise en place d'un pipeline asynchrone (Symfony/Messenger).
- **Processus** :
  1. Upload du CSV par l'utilisateur.
  2. Découpage par lots (évaluation paresseuse).
  3. Tri SQL intelligent.
  4. Isolation des conflits pour résolution manuelle par interface.


## DÉFI 1 : Les 3 Stratégies de Résolution

L'opérateur humain garde le contrôle et choisit la stratégie pour chaque conflit :

- **Insertion** : Nouveau soldat détecté -> création d'un nouvel identifiant.
- **Écrasement** : Version enrichie légitime -> remplacement (avec archivage dans l'historique).
- **Suppression** : Donnée erronée -> rejetée et tracée.


## DÉFI 2 : Du plat au relationnel

  **Le Problème : l'héritage du chaos**
  - Table unique de plus de 40 colonnes sans aucune intégrité référentielle.
  - Redondance massive (ex: "Sergent" écrit de 3 façons différentes).
  - Mises à jour centralisées impossibles, maintenance intenable à long terme.

## DÉFI 2 : Modélisation en étoile (Thésaurus)


  **La Solution :**
  - Extraction d'une quinzaine d'entités fortes (Grade, Unité, Nationalité, Conflit...).
  - Les entités **Soldat** et **Site** deviennent les pivots centraux.
  - Mise en place de 15 clés étrangères pour garantir l'intégrité référentielle _BDD-side_.

## DÉFI 2 : La contrainte astucieuse

  **Garantir que la commune et son département appartiennent au même pays :**
  - **Contrainte** : Pas possible via un simple `CHECK` (cross-table), et la validation applicative (Symfony) est sujette à l'erreur humaine.
  - **Solution** : Clé étrangère composite sur `(departement_id, pays_id)`.
  - La base de données elle-même rend l'état invalide impossible à représenter.

## DÉFI 3 : Thésaurus & Normalisation

  **Le Problème :**
  - Thésurus MdH
  - Données textuelles libres = chaos orthographique.
  - Près de 850 000 lignes à valider et importer.
  - **Impératif** : Les erreurs ne doivent pas bloquer l'import global.

## DÉFI 3 : Commandes de synchronisation

  **La Solution :**
  - Création d'une famille de commandes génériques (`AbstractSyncCommand`).
  - Tolérance aux fautes : si une ligne échoue (ex: violation d'unicité), elle est loggée et ignorée, l'import continue.
  - Utilisation de `league/csv` avec générateurs pour une **lazy evaluation** efficace.

## DÉFI 4 : Inspection hors-ligne

  **Le Problème :**
  - Les chefs de secteur inspectent des carrés militaires dans des lieux isolés (montagnes, petits hameaux).
  - Absence de signal internet sur le terrain.
  - **Besoin** : Le formulaire d'inspection sur tablette doit fonctionner sans réseau.

## DÉFI 4 : Le cache du navigateur

  **La Solution :**
  - Refus d'un framework frontend lourd (SPA) complexe à maintenir.
  - **Mécanisme** : Utilisation du cache natif du navigateur (Service Worker).
  - Phase online : Préchargement des données critiques.
  - Phase offline : Requêtes GET interceptées et servies par le cache local.
  - Phase de retour online : Les soumissions de formulaires (POST) accumulées sont rejouées.

## Conclusion

## Bonus

  - **Philosophie** : "Make Illegal States Unrepresentable" (leçon tirée d'OCaml, appliquée à PHP).
  - **Pragmatisme** : La qualité et la rigueur d'un logiciel ne viennent pas que du langage, mais de ses outils (PHPStan niveau 9, CI stricte).
  - **Impact** : Apporter une vraie solution de terrain pour des agents de l'ONaCVG, donnant du sens au code.
