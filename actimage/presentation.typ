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
    columns: (1fr, 1fr),
    align(left + horizon)[#image("assets/logos/n7.svg", width: 50%)],
    align(right + horizon)[#image("assets/logos/actimage.svg", width: 50%)],
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

#slide("Le Contexte : l'ONaCVG")[
  #v(1em)
  #grid(
    columns: (1fr, 3fr),
    align(center + horizon, image("assets/logos/onacvg.svg", width: 70%)),
    align(center + horizon, image("assets/notre-dame-de-lorette.jpg", width: 70%)),
  )]

#slide("DÉFI 1 : Migration & Résolution de Conflits", align(center + horizon, render(
  read("assets/migration.dot"),
  width: 100%,
)))

#slide("DÉFI 1 : Architecture Asynchrone", align(center + horizon, render(
  read("assets/onacvg-migration.dot"),
  width: 100%,
)))

#slide("DÉFI 1 : Interface de résolution", align(center, image("assets/details-conflit.png", width: 78%)))

#slide("DÉFI 2 : Du plat au relationnel", align(center, image("assets/base-mere.png", width: 92%)))

#slide("DÉFI 2 : Modélisation en étoile (Thésaurus)", align(center + horizon, image("assets/uml/soldat.svg")))

#slide("DÉFI 2 : La contrainte astucieuse", align(center, image("assets/places.svg")))

#slide("DÉFI 3 : Thésaurus & Normalisation", align(center, image("assets/logos/mdh.svg")))

#slide("DÉFI 3 : Commandes de synchronisation", align(center, image("assets/sync-all.png")))

#slide("DÉFI 4 : Inspection hors-ligne", align(center, image("assets/ossuaire-douaumont.jpg", width: 60%)))

#slide("DÉFI 4 : Le cache du navigateur", align(center + horizon, render(read("assets/service-worker.dot"))))


#slide("Conclusion")[
  #v(3em)
  #align(center)[
    #text(size: 40pt, weight: "bold", fill: primary-color)[Questions ?]

    #v(2em)
    #text(size: 18pt)[Merci de votre attention.]
  ]
]

#slide("Bonus")[
  - *Philosophie* : "Make Illegal States Unrepresentable" (leçon tirée d'OCaml et Ada, appliquée à PHP).
  - *Pragmatisme* : La qualité et la rigueur d'un logiciel ne viennent pas que du langage, mais de ses outils (PHPStan niveau 9, CI stricte).
  - *Impact* : Apporter une vraie solution de terrain pour des agents de l'ONaCVG, donnant du sens au code.
]

