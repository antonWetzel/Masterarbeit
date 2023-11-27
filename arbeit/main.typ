#import "setup.typ": *
#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *

#show: setup

#todo-outline()

#include "deckblatt.typ"

#set page(numbering: "1")
#counter(page).update(1)

#outline(indent: auto)

#pagebreak()

#include "glossar.typ"
#pagebreak()

#include "überblick.typ"
#pagebreak()

#include "stand-der-technik.typ"
#pagebreak()

#include "berechnung.typ"

#part([Meshing])

#todo([Meshing])

#include "visualisierung.typ"
#pagebreak()

#bibliography("bibliographie.bib")
