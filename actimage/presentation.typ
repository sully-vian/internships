#import "@preview/diagraph:0.3.7": render
#set text(lang: "fr", size: 20pt)
#let primary-color = rgb("#10305a")
#let secondary-color = rgb("#d32f2f")
#let accent-color = rgb("#4caf50")

#set page(
  paper: "presentation-16-9",
  margin: (top: 2em, bottom: 3em, left: 2em, right: 2em),
  header: context {
    if counter(page).get().first() > 1 {
      align(right)[#text(size: 12pt, fill: luma(120))[Actimage & INP ENSEEIHT - ONaCVG]]
    }
  },
  footer: context {
    if counter(page).get().first() > 1 {
      line(length: 100%, stroke: 0.2mm + primary-color)
      grid(
        columns: (1fr, 1fr, 1fr),
        align(left)[#text(size: 12pt)[PFE Vianney HERVY]],
        align(center)[#text(size: 12pt)[Soutenance de Stage]],
        align(right)[#text(size: 12pt)[#counter(page).display("1 / 1", both: true)]],
      )
    }
  },
)

#let slide(title, body) = {
  pagebreak(weak: true)
  block(below: 0.5em)[
    #text(size: 28pt, weight: "bold", fill: primary-color, title)
    #v(-0.5em)
    #line(length: 100%, stroke: 0.5pt + primary-color)
  ]
  body
}

// Page de garde
#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    align(left + horizon)[#image("assets/logos/n7.svg", width: 50%)],
    align(center + horizon)[#image("assets/logos/actimage.svg", width: 50%)],
    align(right + horizon)[#image("assets/logos/onacvg.svg", width: 30%)],
  )
  #text(size: 18pt)[Toulouse INP - ENSEEIHT] \
  #v(1em)
  #text(size: 24pt, fill: primary-color)[SOUTENANCE DE STAGE DE FIN D'ÉTUDES] \
  #v(1em)
  #text(size: 32pt, weight: "bold")[Ingénierie Logicielle Full-Stack et DevOps] \
  #text(size: 24pt, weight: "semibold")[Projet ONaCVG] \
  #v(1em)
  #text(size: 20pt)[*Vianney HERVY*] \
  #text(size: 16pt)[16 mars 2026 - 18 septembre 2026]
]

#slide("Le Contexte : ONaCVG")[
  - *L'Institution* : Gestion d'un patrimoine funéraire de plus de 800 000 sépultures militaires.
  - *L'Existant* : Une base MS Access historique, copiée et décentralisée localement.
  - *Conséquence* : Un chaos de données (bases filles désynchronisées de la base mère).
  - *Mission* : Consolider, normaliser, et construire une application de gestion moderne et pérenne.
]

#slide("DÉFI 1 : Migration & Résolution de Conflits")[
  #align(center, render(read("assets/migration.dot"), width: 100%))
  *Le Problème :*
  - Les identifiants (`sdr_num`) se chevauchent entre la base mère et les bases filles.
  - Plus de 80 000 collisions d'identifiants détectées.
  - *Ambiguïté* : S'agit-il d'une vraie collision (deux soldats) ou d'un enrichissement légitime (même soldat) ?
  - Une fusion naïve ou entièrement automatisée est impossible.
]

#slide("DÉFI 1 : Architecture Asynchrone")[
  #align(center, render(read("assets/onacvg-migration.dot"), width: 100%))
  *La Solution :*
  - Mise en place d'un pipeline asynchrone (Symfony/Messenger).
  - *Processus* :
    1. Upload du CSV par l'utilisateur.
    2. Découpage par lots (évaluation paresseuse).
    3. Tri SQL intelligent.
    4. Isolation des conflits pour résolution manuelle par interface.
]

#slide("DÉFI 1 : Les 3 Stratégies de Résolution")[
  // [VISUEL ICI : Capture d'écran ou diagramme des 3 carrés de résolution : Insérer, Écraser, Supprimer]
  #v(1em)
  L'opérateur humain garde le contrôle et choisit la stratégie pour chaque conflit :
  - #text(fill: accent-color)[*Insertion*] : Nouveau soldat détecté -> création d'un nouvel identifiant.
  - #text(fill: rgb("#f57c00"))[*Écrasement*] : Version enrichie légitime -> remplacement (avec archivage dans l'historique).
  - #text(fill: secondary-color)[*Suppression*] : Donnée erronée -> rejetée et tracée.
]

#slide("DÉFI 1 : Pourquoi ce choix architectural ?")[
  - *Simplicité* : Pas de stack front lourde (Node/Webpack), juste Docker Compose + Symfony.
  - *Performance (Lazy Evaluation)* : Les générateurs PHP lisent le CSV ligne par ligne -> Aucun débordement mémoire (O(1) en RAM).
  - *Robustesse* : Garantie ACID via le transactionnel au niveau de la base de données.
]

#slide("DÉFI 2 : Du plat au relationnel")[
  // [VISUEL ICI : Une table SQL plate avec 40 colonnes en désordre (Grade, Nationalité...)]
  #v(1em)
  *Le Problème : l'héritage du chaos*
  - Table unique de plus de 40 colonnes sans aucune intégrité référentielle.
  - Redondance massive (ex: "Sergent" écrit de 3 façons différentes).
  - Mises à jour centralisées impossibles, maintenance intenable à long terme.
]

#slide("DÉFI 2 : Modélisation en étoile (Thésaurus)")[
  #align(center, image("assets/uml/soldat.svg"))
  *La Solution :*
  - Extraction d'une quinzaine d'entités fortes (Grade, Unité, Nationalité, Conflit...).
  - Les entités *Soldat* et *Site* deviennent les pivots centraux.
  - Mise en place de 15 clés étrangères pour garantir l'intégrité référentielle _BDD-side_.
]

#slide("DÉFI 2 : La contrainte astucieuse")[
  #align(center, image("assets/places.svg"))
  *Garantir que la commune et son département appartiennent au même pays :*
  - *Contrainte* : Pas possible via un simple `CHECK` (cross-table), et la validation applicative (Symfony) est sujette à l'erreur humaine.
  - *Solution* : Clé étrangère composite sur `(departement_id, pays_id)`.
  - La base de données elle-même rend l'état invalide impossible à représenter.
]

#slide("DÉFI 3 : Thésaurus & Normalisation")[
  // [VISUEL ICI : Extrait du CSV brut avec "1914-1918", "WW1", "Première Guerre"]
  #v(1em)
  *Le Problème :*
  - Données textuelles libres = chaos orthographique.
  - Près de 850 000 lignes à valider et importer.
  - *Impératif* : Les erreurs ne doivent pas bloquer l'import global.
]

#slide("DÉFI 3 : Commandes de synchronisation")[
  #align(center, image("assets/sync-all.png"))
  #v(1em)
  *La Solution :*
  - Création d'une famille de commandes génériques (`AbstractSyncCommand`).
  - Tolérance aux fautes : si une ligne échoue (ex: violation d'unicité), elle est loggée et ignorée, l'import continue.
  - Utilisation de `league/csv` avec générateurs pour une *lazy evaluation* efficace.
]

#slide("DÉFI 4 : Inspection hors-ligne")[
  #align(center, image("assets/ossuaire-douaumont.jpg", width: 60%))
  #v(1em)
  *Le Problème :*
  - Les chefs de secteur inspectent des carrés militaires dans des lieux isolés (montagnes, petits hameaux).
  - Absence de signal internet sur le terrain.
  - *Besoin* : Le formulaire d'inspection sur tablette doit fonctionner sans réseau.
]

#slide("DÉFI 4 : Le cache du navigateur")[
  #align(center, render(read("assets/service-worker.dot")))
  *La Solution :*
  - Refus d'un framework frontend lourd (SPA) complexe à maintenir.
  - *Mécanisme* : Utilisation du cache natif du navigateur (Service Worker).
  - Phase online : Préchargement des données critiques.
  - Phase offline : Requêtes GET interceptées et servies par le cache local.
  - Phase de retour online : Les soumissions de formulaires (POST) accumulées sont rejouées.
]

#slide("Bilan Technico-Humain")[
  - *Philosophie* : "Make Illegal States Unrepresentable" (leçon tirée d'OCaml et Ada, appliquée à PHP).
  - *Pragmatisme* : La qualité et la rigueur d'un logiciel ne viennent pas que du langage, mais de ses outils (PHPStan niveau 9, CI stricte).
  - *Impact* : Apporter une vraie solution de terrain pour des agents de l'ONaCVG, donnant du sens au code.
]

#slide("Conclusion")[
  #v(3em)
  #align(center)[
    #text(size: 40pt, weight: "bold", fill: primary-color)[Questions ?]

    #v(2em)
    #text(size: 18pt)[Merci de votre attention.]
  ]
]
