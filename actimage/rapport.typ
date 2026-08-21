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
#let ecm = acronym("ECM", "état civil militaire")
#let cpmivg = acronym("CPMIVG", "Code des pensions militaires d'invalidité et des victimes de guerre")

#set document(author: author, title: "Rapport de stage de fin d'études")

#set text(lang: "fr")
#set heading(numbering: (..nums) => { if nums.pos().len() < 4 { numbering("1.", ..nums) } })
#show heading: set block(below: 1.5em)
#show heading.where(level: 4): set text(style: "italic", weight: "regular")

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

Mes remerciements s'étendent à l'ensemble de mes collègues de l'agence Actimage Paris-Arcueil et d'ailleurs. Par ordre alphabétique: Aurélie, ma co-stagiaire solidaire pour son amitié, sa politesse et sa conversation ; Marine pour sa jovialité, sa créativité et son attention aux détails ; Romain pour sa curiosité et nos discussions technophiles ; et enfin Thomas, pour sa spontanéité et sa précieuse expertise footballistique.

Mes remerciements vont bien sûr également à Madeleine, ma fiancée, qui y est sûrement pour quelque chose dans la réussite de ce stage.

#pagebreak()

#show outline.entry.where(level: 1): set block(above: 1em)
#outline()

#pagebreak()

= Introduction

== Présentation de l'entreprise

Actimage est une #esn française créée en 1995 par Christophe Megel, l'actuel PDG. Le travail de l'entreprise est divisé en 3 pôles principaux communicants: le développement, le conseil et la #rd. Mon stage s'est déroulé dans le pôle développement mais j'ai eu l'occasion d'interagir avec le pôle #rd sur certains sujets. Les effectifs d'Actimage sont répartis entre 8 agences dans 5 pays. Celles avec lesquelles j'ai le plus été en contact sont Paris, Arcueil, Colmar, Strasbourg, Metz et Luxembourg.

=== Réalisations

==== DSFR

L'expertise d'Actimage en développement brille tout particulièrement sur les marchés publics. L'entreprise a notamment participé à la conception du  #dsfr. Le #dsfr regroupe un ensemble de règles et de composants réutilisables pour les interfaces officielles des sites en `.gouv.fr`. Il permet à l'État d'offrir des services numériques simples, accessibles et reconnaissables. C'est notamment celui que vous retrouvez sur #monolink("impots.gouv.fr"), #monolink("ants.gouv.fr") et #monolink("sante.gouv.fr").

==== Site officiel du Gouvernement

L'un des sites majeurs du gouvernement est #monolink("info.gouv.fr"). C'est aussi un des projets principaux d'Actimage qui en réalise le développement dorsal et une partie du développement frontal. Plusieurs développeurs travaillent à temps plein sur ce projet, dont même certains physiquement au #sig.

==== BDnf

Actimage est également l'entreprise derrière BDnF#footnote[https://bdnf.bnf.fr], un outil ludo-éducatif de création de bandes dessinées et de récits multimédias développé pour le compte de la #bnf. Destinée principalement au milieu scolaire, l'application se connecte à la bibliothèque numérique Gallica via un module d'import permettant aux utilisateurs d'intégrer directement des corpus d'images d'archives dans leurs projets.

Techniquement, l'application a été développée de manière multi-support avec le moteur Unity 3D. L'architecture logicielle repose sur un noyau commun partagé entre les environnements de bureau (macOS, Windows) et tablettes (Android, iOS), tout en implémentant des fonctionnalités spécifiques adaptées aux contraintes des versions mobiles. Afin d'accélérer le développement des nouvelles fonctionnalités et de garantir la cohérence des interfaces sur toutes ces plateformes, l'équipe s'est appuyée sur la mise en place d'un système de design strict. Enfin, la conception a fait l'objet de tests d'utilisabilité itératifs menés directement auprès d'élèves pour valider l'ergonomie.

==== Hol'Autisme

Actimage s'inscrit fortement dans l'innovation et la #rd avec des projets à fort impact sociétal à l'image de Hol'Autisme#footnote[https://www.holautisme.com]. Ce projet novateur propose le premier catalogue d'applications en réalité mixte destiné à aider les enfants et adolescents atteints de troubles du spectre autistique à développer leurs compétences sociales. Développée notamment avec le moteur Unity pour le casque HoloLens, la solution permet de simuler des situations du public ou du quotidien dans un environnement interactif et contrôlé. Le but est d'aider les patients à appréhender les codes sociaux et à gagner progressivement en autonomie sans subir l'angoisse du monde réel.

L'expertise technologique du projet va bien au-delà de la simple réalité mixte : le système intègre un bracelet connecté permettant de mesurer le niveau d'anxiété de l'apprenant en temps réel, couplé à une plateforme web de contrôle et de suivi. Grâce à l'analyse de données et à des outils statistiques avancés, le personnel médico-éducatif peut analyser finement les sessions. La pertinence de ce dispositif global, dont la première preuve de concept s'intitule PopBalloons, a d'ailleurs été saluée par l'écosystème technologique, le projet étant lauréat des concours French IOT 2017 et Futur.e.s 2018.

=== Pôle développement

=== Pôle R et D

== Contexte du stage

== Gestion de projet

== Projet #onacvg

Le projet principal sur lequel j'ai eu l'occasion de travailler tout au long des 6 mois de stage est une application web à destination de l'#onacvg. // TODO: étoffer

=== Présentation du client et genèse du besoin

// TODO: étoffer

=== Présentation du client et genèse du besoin

L'#onacvg est un établissement public administratif français placé sous la tutelle du ministère des Armées et des Anciens Combattants. Fondé en 1916, cet organisme a pour vocation d'assurer des missions de reconnaissance, de réparation, de solidarité et de mémoire envers les combattants, les anciens combattants et les victimes de guerre. L'Office opère au bénéfice d'environ 1,81 million de ressortissants (selon des estimations de 2023) à travers un réseau de services de proximité et s'impose comme l'opérateur majeur de la politique mémorielle du ministère des Armées.

Parmi ses prérogatives, l'#onacvg exerce une compétence juridique spécifique en matière de sépultures militaires, un domaine encadré par le #cpmivg. L'institution est explicitement chargée de la mise en œuvre de l'entretien, de la rénovation et de la valorisation des sépultures de guerre. En effet, la loi pose le principe d'une sépulture perpétuelle pour les militaires déclarés « Mort pour la France », qu'ils reposent au sein de nécropoles nationales ou de carrés militaires communaux, et dont l'entretien incombe à l'État.

C'est dans le cadre de la gestion de ce vaste patrimoine funéraire et historique, et afin de moderniser ses outils numériques, que l'institution a lancé un appel d'offres visant à concevoir une nouvelle application centralisée de gestion des sépultures. Ce marché a été remporté par Actimage en (*TODO : insérer date*). Le périmètre du contrat couvre la conception, le développement, la #tma ainsi que l'hébergement du futur service. L'application logicielle développée s'adresse exclusivement à un usage interne, ses utilisateurs finaux étant principalement les chefs de secteur de l'#onacvg œuvrant sur le terrain et les administrateurs du pôle #ecm.

=== L'existant : un défi de taille et de structure de la donnée

Le principal enjeu de ce projet réside dans l'héritage technique des données. La base de données existante (sous format MS Access) recense plus de 800 000 sépultures, dont certaines remontent aux guerres napoléoniennes. Cette base historique compile une multitude d'informations : état civil militaire, nom et type du site, mentions honorifiques (telles que "Mort pour la France"), nationalité, informations de recrutement, unité militaire, ou encore causes du décès.

Cependant, le départ de la personne en charge de sa maintenance a entraîné une dégradation de l'intégrité des données, transformant la base en un document tabulaire peu rigoureux. Pour pallier ce manque d'outil centralisé, plusieurs chefs de secteur avaient dupliqué la "base mère" pour maintenir leurs données localement. Cette pratique a conduit à l'émergence de multiples "bases filles" désynchronisées, comportant des identifiants conflictuels, des doublons et des incohérences.

=== Migration et regroupement familial

La première mission de mon stage, qui s'est étendue sur un mois, a consisté à développer un outil de migration indépendant. Son objectif était de regrouper les bases filles avec la base mère en détectant les conflits et en proposant des stratégies de résolution : historisation des entrées conflictuelles ou conservation des deux versions via une renumérotation intelligente. Ce premier projet, qui fera l'objet d'une section détaillée ultérieurement, a constitué une excellente porte d'entrée pour m'approprier l'environnement technique de l'entreprise (PHP, Symfony, Doctrine, PostgreSQL, Docker) et les données de l'#onacvg.

=== Phase 2 : Refonte Logicielle et application de gestion #ecm.

Une fois les données fusionnées (toujours sous un format tabulaire plat d'environ quarante colonnes), la mission principale de mon stage a pu débuter : le développement de l'application de gestion complète, structurée autour de trois grands axes fonctionnels.

==== Modélisation et consultation (Base #ecm)

Afin d'éviter la duplication et de garantir l'intégrité future des données, une refonte complète du modèle de données a été nécessaire. Nous sommes passés d'un format plat hérité du CSV à une architecture relationnelle stricte (création d'entités distinctes pour les pays, départements, communes, grades, unités, bureaux de recrutement, etc.). Une part majeure de mon travail a été consacrée à l'élaboration de la commande d'importation, capable de transformer des données libres et peu rigoureuses en entités standardisées.
Sur cette base saine, un module de consultation a été développé, offrant des interfaces de recherche avancée avec de multiples filtres pour explorer les données des soldats et des sites.

==== Module d'inspection en mobilité

L'#onacvg ayant la charge de sépultures à perpétuité, les chefs de secteur doivent inspecter leurs sites (parfois plus de 300 par secteur) au moins une fois par an. J'ai participé au développement d'une interface optimisée pour tablettes permettant la saisie d'inspections sur le terrain. L'agent peut y corriger les informations de la base et évaluer l'état des infrastructures (sol, barrières, stèles, plaques). Ces relevés alimentent ensuite un algorithme de calcul estimant les coûts de restauration pour les tombes et sites concernés.

==== Administration et flux de validation

Le troisième volet de l'application concerne les administrateurs #ecm. Pour garantir la qualité de la base de données sur le long terme, un flux de travail (workflow) a été mis en place. Bien que certaines actions soient libres, la modification de champs sensibles par un chef de secteur nécessite l'approbation d'un administrateur. Ce processus est accompagné d'un système de notifications intra-application et de courriels automatisés.

=== Contraintes d'interopérabilité

Enfin, le système devait respecter une contrainte forte d'interopérabilité avec les services de l'État. Les données n'étant pas strictement confidentielles, elles sont rendues accessibles au grand public via le portail gouvernemental Mémoire des Hommes#footnote[https://memoiredeshommes.defense.gouv.fr]. L'application développée intègre donc une fonctionnalité d'export mensuel générant un format de fichier très spécifique, garantissant l'alimentation continue et conforme de ce portail national.

== Poste de travail et outillage de développement

=== Environnement d'exécution et philosophie de travail

Au sein d'Actimage, le matériel mis à ma disposition était un poste opérant sous Windows 11. Afin de retrouver un environnement de développement familier, performant et conforme à la philosophie Unix qui guide mon flux de travail quotidien, j'ai fait le choix d'exploiter le sous-système Windows pour Linux @wsl. J'y ai déployé une distribution Arch Linux. Cette approche m'a permis de répliquer quasi à l'identique l'environnement modulable que j'utilise à titre personnel, tout en m'affranchissant des limitations inhérentes au système d'exploitation hôte pour le développement d'applications web.

=== L'éditeur de code: le choix de Neovim

Face à la complexité de l'écosystème PHP/Symfony, j'ai dans un premier temps évalué l'utilisation d'un #ide classique, tel que PhpStorm @phpstorm. Bien que cet outil propose des intégrations natives puissantes, sa lourdeur d'exécution et son manque de flexibilité (même pallié par l'extension IdeaVim @ideavim) ont constitué des freins à ma productivité. J'ai donc réintégré Neovim @neovim comme éditeur principal.

Le langage PHP étant interprété et historiquement peu strict sur le typage, il ne bénéficie pas nativement des mêmes garanties à l'écriture qu'un langage compilé. Pour pallier cela et atteindre une rigueur de développement similaire à celle qu'offre TypeScript dans l'écosystème JavaScript, j'ai dû configurer un outillage robuste basé sur le Language Server Protocol (LSP) @lsp.

- J'ai principalement utilisé Phpactor @phpactor et Intelephense @intelephense pour l'autocomplétion et l'analyse statique.
- J'ai également expérimenté avec PHPantom @phpantom un serveur de langage récent développé en Rust @rust, offrant des performances d'exécution nettement supérieures.
- L'intégration récente d'un serveur de langage dédié spécifiquement à Symfony @symfony-language-tools est venue parfaire cette configuration, me permettant d'avoir un retour intelligent sur les spécificités du cadriciel.

L'analyse de la qualité du code est restée isolée localement pour chaque projet, tout en étant exploitée par les serveurs de langage pour remonter les erreurs directement dans l'éditeur.

=== Contributions aux logiciels libres et outillage sur mesure

Constatant que certains outils de l'écosystème manquaient de maturité par rapport à d'autres langages, j'ai adopté une démarche proactive en contribuant à des projets à code source ouvert. J'ai notamment signalé et résolu des anomalies sur Twiggy @twiggy (un serveur de langage pour le moteur de gabarits Twig) et amélioré la grammaire Tree-sitter @tree-sitter de Twig, utilisée par Neovim pour l'analyse syntaxique. Cette implication m'a également amené à échanger avec Fabien Potencier, créateur de Symfony, autour du développement de leur nouveau serveur de langage.

Pour optimiser la navigation dans les bases de code PHP, j'ai également développé des requêtes Tree-sitter personnalisées pour le greffon `vim-matchup` @vim-matchup. Celles-ci offrent une navigation syntaxique avancée en définissant des portées spécifiques pour les balises et les structures de contrôle du langage. Il devient ainsi possible de naviguer intelligemment entre les différentes clauses d'une condition ou d'une boucle, de parcourir aisément les blocs complexes (tels que `switch`, `match` ou `try/catch`), et de sauter instantanément de la signature d'une fonction à ses instructions de retour.

=== Le terminal comme espace de travail unifié

La reproduction de mon environnement s'arrêtant aux frontières du WSL et donc du terminal, j'ai optimisé ce dernier pour limiter au maximum l'usage de la souris et la friction liée aux changements de contexte. Le multiplexeur `tmux` @tmux a été central dans cette démarche en me permettant de gérer de multiples invites de commande au sein d'une même fenêtre.

Afin de fluidifier mon flux de travail, j'ai enrichi cet espace de scripts et de raccourcis sur mesure. Ces personnalisations me permettent d'invoquer des interfaces interactives telles que `lazygit` @lazygit et `lazydocker` @lazydocker sous forme de fenêtres superposées sans jamais quitter mon contexte d'édition, mais également d'interagir nativement au clavier avec des liens hypertextes ou d'accéder instantanément à l'interface web du dépôt Git du projet courant.

=== Conteneurisation et exécution locale

L'ensemble des projets, tels que PIAWEB, s'exécutaient au sein de conteneurs Docker @docker. Après une première phase d'utilisation de Docker Desktop pour Windows, j'ai rapidement constaté un manque de granularité et une interface graphique ralentissant mon flux de travail.

J'ai par conséquent migré vers une installation native du démon Docker exclusivement au sein de WSL. Ce choix m'a garanti un contrôle absolu sur les ressources et les conteneurs, pilotables intégralement en ligne de commande ou via l'interface terminale de `lazydocker`, en parfaite adéquation avec le reste de mon outillage.

=== Évolution du poste de travail

Travaillant pour la première fois dans un contexte extra-scolaire et extra-personnel pendant aussi longtemps, je trouve encore chaque semaine des points de friction, des tâches répétitives à optimiser ou automatiser. Mon poste de travail est en évolution constante, s'adaptant aux besoins de mon environnement de travail et de mes projets.

= Initiation - Migration ONaCVG

= PIAWEB : Une histoire de DevOps

L'application PIAWEB#footnote[Contraction de Programme d'Investissements d'Avenir (PIA) et de Web.]  dont Actimage réalise les développements et dirige les déploiements sur les serveurs clients est un projet de répertoire pour suivre les différentes actions du plan d'investissement France 2030 qui relèvent spécifiquement du #mesr.

Ce projet est actuellement en phase de #tma, peu de développements sont réalisés, majoritairement des corrections de bogues ou des évolutions mineures. La pile technologique repose sur du Spring et du Angular, une solution légèrement plus élaborée que celle proposée pour l'onacvg puisqu'elle requiert deux conteneurs serveur distincts pour le web frontal et dorsal.

== Le bogue

Étant l'un des développeurs les moins coûteux, j'ai été assigné à la correction d'un bogue d'affichage ordinaire pour lequel plusieurs de mes collègues avaient déjà imputé du temps. La plongée laborieuse dans le code source d'un projet dont la teneur m'échappait encore et dont le cadriciel frontal ne m'était pas familier m'a contraint à optimiser mon débogage afin d'identifier la source du problème sans avoir à explorer l'entièreté de l'application. Quelques échanges de tickets avec le client plus tard et j'arrivais à reproduire le comportement anormal sur mon poste. Le problème venait d'un bête formulaire de recherche dont la pagination n'était pas rapportée à 1 lorsque l'utilisateur changeait les critères de recherche, permettant ainsi d'accéder à la troisième page pour une recherche ne remontant qu'une page de résultats par exemple.

Si l'implémentation du correctif ne nécessita que quelques minutes, la validation de la demande de fusion sur la branche de développement `dev` fut actée en une demi-heure. L'intervention aurait pu s'achever sur cette bonne note, mais l'équipe DevOps m'a confié la responsabilité de l'intégralité du cycle de livraison de cette version, incluant la montée sur les différents environnements et le déploiement final chez le client.

== Le châtaignier // branches à bogues

== Appareillage sur lest // conteneur parti sans contenu

= Conclusion

#pagebreak()

#bibliography("sources.yml", style: "ieee")

#bibliography("references.yml", style: "ieee", title: "Références logicielles")

#pagebreak()

= Annexes
