#import "setup.typ": *
#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *

#show: setup

#set document(
	author: "Anton Wetzel",
	title: "Berechnung charakteristischen Eigenschaften von botanischen Bäumen mithilfe von 3D-Punktwolken.",
	keywords: ("Punktwolken", "botanische Bäume", "Rust", "WebGPU", "Visualisierung"),
)

#todo-outline()

#include "deckblatt.typ"
#pagebreak()

#include "abstrakt.typ"
#pagebreak()

#outline(depth: 3)

#set page(numbering: "1")
#counter(page).update(1)

#pagebreak()

#include "überblick.typ"
#pagebreak()

#include "berechnung.typ"
#pagebreak()

#include "triangulierung.typ"
#pagebreak()

#include "visualisierung.typ"
#pagebreak()

#include "ergebnisse.typ"
#pagebreak()

#include "appendix.typ"
#pagebreak()

#include "glossar.typ"
#pagebreak()

#bibliography("bibliographie.bib")
