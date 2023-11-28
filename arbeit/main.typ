#import "setup.typ": *
#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *

#show: setup

#todo-outline()

#include "deckblatt.typ"

#outline(indent: auto)

#set page(numbering: "1")
#counter(page).update(1)

#pagebreak()

#include "glossar.typ"
#pagebreak()

#include "überblick.typ"
#pagebreak()

#include "berechnung.typ"
#pagebreak()

#part([Meshing])

#todo([Meshing]) #pagebreak()

#include "visualisierung.typ"
#pagebreak()

#bibliography("bibliographie.bib")
