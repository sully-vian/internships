#let author = "Vianney HERVY"

#let monolink(content) = link(content, raw(content))

#let acronyms-state = state("acronyms", (:))
#let acronym(short, long, note: none) = context {
  let seen = acronyms-state.get()
  if short in seen {
    short
  } else {
    acronyms-state.update(seen => seen + ((short): true))
    if note != none {
      [#long#footnote[#note] (#short)]
    } else {
      [#long (#short)]
    }
  }
}

#let tma = acronym("TMA", "tierce maintenance applicative")
#let dsfr = acronym("DSFR", "Système de Design de l'État Français", note: "https://www.systeme-de-design.gouv.fr")
#let sig = acronym(
  "SIG",
  "Service d'information du Gouvernement",
  note: "https://www.info.gouv.fr/organisation/service-d-information-du-gouvernement-sig",
)
#let bnf = acronym("BnF", "Bibliothèque nationale de France", note: "https://www.bnf.fr")
#let esn = acronym("ESN", "entreprise de services numériques")
#let mesr = acronym("MESR", "Ministère de l'Enseignement Supérieur et de la Recherche")
#let onacvg = acronym(
  "ONaCVG",
  "Office national des combattants et des victimes de guerre",
  note: "https://www.onac-vg.fr",
)
#let rd = acronym("R et D", "recherche et développement")
#let ide = acronym("IDE", "environnement de développement integré")

#set document(author: author, title: "Rapport de stage de fin d'études")

#set text(lang: "fr")
#set heading(numbering: "I.1.1.1")
#show heading: set block(below: 1.5em)

#set page(paper: "a4", margin: (top: 1.5cm, bottom: 2cm, left: 2cm, right: 2cm))

#show title: it => {
  set text(size: 18pt, weight: "regular")
  smallcaps(it)
}

#set page(numbering: none)

#let logo-width = 60%
#grid(
  columns: (1fr, 1fr),
  align(left + horizon, image("assets/logos/n7.svg", width: logo-width)),
  align(right + horizon, image("assets/logos/actimage.svg", width: logo-width)),
)

#v(2em)

#align(center)[
  #text(size: 14pt)[
    Toulouse INP - ENSEEIHT \
    École Nationale Supérieure d'Électrotechnique, d'Électronique, d'Informatique, d'Hydraulique et des Télécommunications
  ]

  #v(2em)

  #title()

  #text(size: 12pt)[
    effectué chez Actimage
    #v(0.5em)
    16 mars 2026 - 18 septembre 2026, 6 mois
  ]

  #v(3em)
  #line(length: 100%, stroke: 0.2mm)
  #v(3em)

  #text(size: 24pt, weight: "bold")[
    Ingénierie Logicielle Full-Stack et DevOps
  ]

  #v(3em)
  #line(length: 100%, stroke: 0.2mm)
  #v(3em)

  #text(size: 14pt, author + " - Ingénieur Logiciel")
  #v(0.1em)
  #text(size: 12pt)[vianney.hervy\@etu.toulouse-inp.fr]
]

#v(1fr)

#grid(
  columns: (1fr, 1fr),
  align(left)[
    #text(size: 12pt)[
      *Toulouse INP - ENSEEIHT* \
      2 rue Charles Camichel \
      31071 Toulouse
      #v(1em)
      *Responsable académique* \
      Marc PANTEL \
      Maître de conférence en Informatique à l'IRIT / ENSEEIHT
    ]
  ],
  align(right)[
    #text(size: 12pt)[
      *Actimage* \
      5 avenue Franco-Russe \
      75007 Paris
      #v(1em)
      *Encadrant chez Actimage* \
      David KOLIN \
      (ex-)Directeur de l'agence Paris-Arcueil \
    ]
  ],
)

#pagebreak()

#set par(justify: true)

#set page(
  footer: context [
    #line(length: 100%, stroke: 0.2mm)
    #grid(
      columns: (1fr, 1fr, 1fr),
      align(left, image("assets/n7-banner.svg", width: 50%)),
      align(center)[PFE Vianney HERVY],
      align(right, counter(page).display("1/1", both: true)),
    )],
)

= Remerciements

Avant tout, je tiens à remercier mes deux encadrants sur cette expérience enrichissante qu'a été ce stage de fin d'étude. David pour son accompagnement, ses conseils et son humour, Matthias pour sa patience, sa bienveillance et ses succulents repas de fin de semaine.

Mes remerciements s'étendent à l'ensemble de mes collègues de l'agence Actimage Paris-Arcueil et d'ailleurs. par ordre alphabétique: Aurélie, ma co-stagiaire solidaire pour son amitié, sa politesse et sa conversation ; Marine pour sa jovialité, sa créativité et son attention aux détails ; Romain pour sa curiosité et no discussions technophiles ; et enfin Thomas, pour sa spontanéité et sa précieuse expertise footbalistique.

Mes remerciements vont bien sûr également à Madeleine, ma fiancée, qui y est sûrement pour quelque chose dans la réussite de ce stage.

#pagebreak()

#outline()

#pagebreak()

= Introduction

== Présentation de l'entreprise

Actimage est une #esn française créée en 1995 par Christophe Megel, l'actuel PDG. Le travail de l'entreprise est divisé en 3 pôles principaux communiquants: le développement, le conseil et la #rd. Mon stage s'est déroulé dans le pôle développement mais j'ai eu l'occasion d'interagir avec le pôle #rd sur certains sujets. Les effectifs d'Actimage sont répartis entre 8 agences dans 5 pays. Celles avec lesquelles j'ai le plus été en contact sont Paris, Arcueil, Colmar, Strasbourg, Metz et Luxembourg.

=== Réalisations

==== DSFR

L'expertise d'Actimage en développement brille tout particulièrement sur les marchés publics. L'entreprise a notamment participé à la conception du  #dsfr. Le #dsfr regroupe un ensemble de règles et de composants réutilisables pour les interfaces officielles des sites en `.gouv.fr`. Il permet à l'État d'offrir des services numériques simples, accessibles et reconnaissables. C'est notamment celui que vous retrouvez sur #monolink("impots.gouv.fr"), #monolink("ants.gouv.fr") et #monolink("sante.gouv.fr").

==== Site officiel du Gouvernement

L'un des sites majeurs du gouvernement est #monolink("info.gouv.fr"). C'est aussi un des projets principaux d'Actimage qui en réalise le développement dorsal et une partie du développement frontal. Plusieurs développeurs travaillent à temps plein sur ce projet, dont même certains physiquement au #sig.

==== BDnf

Actimage est également l'entreprise derrière BDnF#footnote[https://bdnf.bnf.fr], un outil ludo-éducatif de création de bandes dessinées et de récits multimédias développé pour le compte de la #bnf. Destinée principalement au milieu scolaire, l'application se connecte à la bibliothèque numérique Gallica via un module d'import permettant aux utilisateurs d'intégrer directement des corpus d'images d'archives dans leurs projets.

Techniquement, l'application a été développée de manière multi-support avec le moteur Unity 3D. L'architecture logicielle repose sur un noyau commun partagé entre les environnements de bureau (Mac, Windows) et tablettes (Android, iOS), tout en implémentant des fonctionnalités spécifiques adaptées aux contraintes des versions mobiles. Afin d'accélérer le développement des nouvelles fonctionnalités et de garantir la cohérence des interfaces sur toutes ces plateformes, l'équipe s'est appuyée sur la mise en place d'un design system strict. Enfin, la conception a fait l'objet de tests d'utilisabilité itératifs menés directement auprès d'élèves pour valider l'ergonomie.

==== Hol'Autisme

Actimage s'inscrit fortement dans l'innovation et la #rd avec des projets à fort impact sociétal à l'image de Hol'Autisme#footnote[https://www.holautisme.com]. Ce projet novateur propose le premier catalogue d'applications en réalité mixte destiné à aider les enfants et adolescents atteints de troubles du spectre autistique à développer leurs compétences sociales. Développée notamment avec le moteur Unity pour le casque HoloLens, la solution permet de simuler des situations du public ou du quotidien dans un environnement interactif et contrôlé. Le but est d'aider les patients à appréhender les codes sociaux et à gagner progressivement en autonomie sans subir l'angoisse du monde réel.

L'expertise technologique du projet va bien au-delà de la simple réalité mixte : le système intègre un bracelet connecté permettant de mesurer le niveau d'anxiété de l'apprenant en temps réel, couplé à une plateforme web de contrôle et de suivi. Grâce à l'analyse de données et à des outils statistiques avancés, le personnel médico-éducatif peut analyser finement les sessions. La pertinence de ce dispositif global, dont la première preuve de concept s'intitule PopBalloons, a d'ailleurs été saluée par l'écosystème technologique, le projet étant lauréat des concours French IOT 2017 et Futur.e.s 2018.

=== Pôle développement

=== Pôle R et D

== Contexte du stage

== Gestion de projet

== Poste de travail et outillage de développement

=== Environnement d'exécution et philosophie de travail

Au sein d'Actimage, le matériel mis à ma disposition était un poste opérant sous Windows 11. Afin de retrouver un environnement de développement familier, performant et conforme à la philosophie Unix qui guide mon flux de travail quotidien, j'ai fait le choix d'exploiter le sous-système Windows pour Linux @wsl. J'y ai déployé une distribution Arch Linux. Cette approche m'a permis de répliquer quasi à l'identique l'environnement minimaliste et modulable que j'utilise à titre personnel, tout en m'affranchissant des limitations inhérentes au système d'exploitation hôte pour le développement d'applications web.

=== Léditeur de code: le choix de Neovim

Face à la complexité de l'écosystème PHP/Symfony, j'ai dans un premier temps évalué l'utilisation d'un #ide classique, tel que PhpStorm @phpstorm Bien que cet outil propose des intégrations natives puissantes, sa lourdeur d'exécution et son manque de flexibilité (même pallié par l'extension IdeaVim @ideavim) ont constitué des freins à ma productivité. J'ai donc réintégré Neovim @neovim comme éditeur principal.

Le langage PHP étant interprété et historiquement peu strict sur le typage, il ne bénéficie pas nativement des mêmes garanties à l'écriture qu'un langage compilé. Pour pallier cela et atteindre une rigueur de développement similaire à celle qu'offre TypeScript dans l'écosystème JavaScript, j'ai dû configurer un outillage robuste basé sur le protocole LSP (Language Server Protocol) :

- J'ai principalement utilisé Phpactor @phpactor et Intelephense @intelephense pour l'autocomplétion et l'analyse statique.
- J'ai également expérimenté avec PHPantom @phpantom un serveur LSP récent développé en Rust, offrant des performances d'exécution nettement supérieures.
- L'intégration récente d'un LSP dédié spécifiquement à Symfony @symfony-language-tools est venue parfaire cette configuration, me permettant d'avoir un retour intelligent sur les spécificités du framework.

L'analyse de la qualité du code (via PHPStan et PHP CS Fixer) est restée isolée localement pour chaque projet, tout en étant exploitée par les serveurs LSP pour remonter les erreurs directement dans l'éditeur.

=== Contributions Open Source et outillage sur mesure

Constatant que certains outils de l'écosystème manquaient de maturité par rapport à d'autres langages, j'ai adopté une démarche proactive en contribuant à des projets open source. J'ai notamment ouvert et corrigé des tickets sur Twiggy @twiggy (un serveur LSP pour le moteur de template Twig) et amélioré la grammaire Tree-sitter @tree-sitter de Twig, utilisée par Neovim pour l'analyse syntaxique. Cette implication m'a également amené à échanger avec Fabien Potencier, créateur de Symfony, autour du développement de leur nouvel outil LSP.

Pour améliorer ma navigation dans les bases de code PHP, j'ai développé des requêtes Tree-sitter personnalisées pour le plugin `vim-matchup` @vim-matchup:

- Ces requêtes définissent des portées spécifiques pour les structures de contrôle et les balises PHP.
- Elles permettent un saut intelligent entre les différentes clauses d'une condition (`if`, `elseif`, `else`) ou d'une boucle.
- Elles facilitent le déplacement depuis la signature d'une fonction directement vers ses instructions de retour.
- Elles offrent une navigation fluide au sein des blocs `match`, `try/catch` et `switch`.

=== Le terminal comme espace de travail unifié

La reproduction de mon environnement s'arrêtant aux frontières du terminal WSL, j'ai optimisé ce dernier pour limiter au maximum l'usage de la souris et la friction liée aux changements de contexte. L'utilisation du multiplexeur `tmux` @tmux a été centrale dans cette démarche, me permettant de gérer de multiples invites de commande au sein d'une même fenêtre.

J'ai enrichi cet environnement par des scripts et des raccourcis sur mesure :

- Intégration d'outils en fenêtres volantes (popups) : J'ai configuré des raccourcis `tmux` dédiés (Ctrl+g et Ctrl+d) pour ouvrir respectivement `lazygit` @lazygit et `lazydocker` @lazydocker dans des fenêtres superposées, sans quitter mon contexte d'édition en cours.
- Navigation hypertexte clavier : J'ai reproduit le comportement de la touche gx de Vim directement dans le mode copie de `tmux`, me permettant de sélectionner et d'ouvrir des liens URL sans intervention de la souris.
- Script de navigation Git (`git-origin`) : J'ai adapté un script shell permettant d'ouvrir instantanément le dépôt distant d'un projet dans le navigateur web

=== Conteneurisation et exécution locale

L'ensemble des projets, tels que PIAWEB, s'exécutaient au sein de conteneurs Docker @docker Après une première phase d'utilisation de Docker Desktop pour Windows, j'ai rapidement constaté un manque de granularité et une interface graphique ralentissant le flux de travail.

J'ai par conséquent migré vers une installation native du démon Docker exclusivement au sein de WSL. Ce choix m'a garanti un contrôle absolu sur les ressources et les conteneurs, pilotables intégralement en ligne de commande ou via l'interface terminale (TUI) `lazydocker`, en parfaite adéquation avec le reste de mon outillage.

= Initiation - Migration ONaCVG

= PIAWEB : Une histoire de DevOps

L'application PIAWEB#footnote[Contraction de Programme d'Investissements d'Avenir (PIA) et de Web.]  dont Actimage réalise les développements et dirige les déploiements sur les serveurs clients est un projet de répertoire pour suivre les différentes actions du plan d'investissement France 2030 qui relèvent spécifiquement du #mesr;

Ce projet est actuellement en phase de #tma, peu de développements sont réalisés, majoritairement des corrections de bogues ou des évolutions mineures. La pile technologique repose sur du Spring et du Angular, une solution légèrement plus élaborée que celle proposée pour l'onacvg puisqu'elle requiert deux conteneurs serveur distincts pour le web frontal et dorsal.

== Le bogue

Étant l'un des développeurs les moins coûteux, j'ai été assigné à la correction d'un bogue d'affichage ordinaire pour lequel plusieurs de mes collègues avaient déjà imputé du temps. La plongée laborieuse dans le code source d'un projet dont la teneur m'échappait encore et dont le cadriciel frontal ne m'était pas familier m'a contraint à optimiser mon débogage afin d'identifier la source du problème sans avoir à explorer l'entièreté de l'application. Quelques échanges de tickets avec le client plus tard et j'arrivais à reproduire le comportement anormal sur mon poste. Le problème venait d'un bête formulaire de recherche dont la pagination n'était pas rapportée à 1 lorsque l'utilisateur changeait les critères de recherche, permettant ainsi d'accéder à la troisième page pour une recherche ne remontant qu'une page de résultats par exemple.

Si l'implémentation du correctif ne nécessita que quelques minutes, la validation de la demande de fusion sur la branche de développement `dev` fut actée en une demi-heure. L'intervention aurait pû s'achever sur cette bonne note, mais l'équipe DevOps m'a confié la responsabilité de l'intégralité du cycle de livraison, incluant la montée sur les différents environnements et le déploiement final chez le client.

== Le châtaignier // branches à bogues

== Appareillage sur lest // conteneur parti sans contenu

= Conclusion

#pagebreak()

#bibliography("sources.yml", style: "ieee")

#bibliography("references.yml", style: "ieee", title: "Références logicielles")

#pagebreak()

= Annexes
