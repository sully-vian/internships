#set document(author: "Vianney HERVY", title: "Rapport de PFE: Actimage")
#set text(lang: "fr")
#set heading(numbering: "1.")

#show title: it => {
  set text(size: 24pt)
  align(center, it)
}

#set page(numbering: none)

#let logo-width = 70%
#grid(
  columns: (1fr, 1fr),
  align(left + horizon, image("assets/logos/n7.svg", width: logo-width)),
  align(right + horizon, image("assets/logos/actimage.svg", width: logo-width)),
)

#v(8em)
#title()

Tuteur de stage: David KOLIN, Directeur d'agence Paris-Arcueil

Superviseur académique: Marc PANTEL, Maître de conférence en Informatique à l'IRIT / Toulouse INP - ENSEEIHT / Université de Toulouse

Établissement:

Entreprise d'accueil: Actimage

#pagebreak()
#set page(numbering: "1.")
#counter(page).update(1)

#outline()

#pagebreak()

= Contexte

= Introduction

= Partie 1

= Annexes

#bibliography("bibliography.yml", style: "ieee")
