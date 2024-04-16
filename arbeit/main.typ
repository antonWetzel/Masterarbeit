#import "setup.typ": *

#set document(
	author: "Anton Wetzel",
	title: "Berechnung charakteristischen Eigenschaften von botanischen Bäumen mithilfe von 3D-Punktwolken.",
	keywords: ("Punktwolken", "botanische Bäume", "Rust", "WebGPU", "Visualisierung"),
)

// #show: word-count

// Wörter: #total-words

// #todo-outline() #pagebreak()

#show: (doc) => setup(doc, print: false)

#include "deckblatt.typ"

#include "abstrakt.typ"

#outline(depth: 3)

#set page(numbering: "1")
#counter(page).update(1)

#include "einleitung.typ"

#include "stand_der_technik.typ"

#include "segmentierung.typ"

#include "visualisierung.typ"

#include "triangulierung.typ"

#include "analyse.typ"

#include "implementierung.typ"

#include "auswertung.typ"

#include "fazit.typ"

#include "appendix.typ"

#include "eigenständigkeitserklärung.typ"

#bibliography("bibliographie.bib")
