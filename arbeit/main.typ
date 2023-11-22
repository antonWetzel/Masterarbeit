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

#part([Überblick])


= Punktwolke

- Menge von Punkten
- mindestens Position


= Daten

- Waldstücke
- Deutschland
- terrestrial und arial
- zusätzlich manuelle Datenbestimmung
- nur Position bekannt

#todo([Mehr Überblick])

#include "stand-der-technik.typ"
#pagebreak()

#include "berechnung.typ"

#part([Meshing])

#todo([Meshing])

#include "visualisierung.typ"
