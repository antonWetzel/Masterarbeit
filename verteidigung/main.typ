#import "@preview/polylux:0.3.1": *
#import themes.metropolis: *

#set page(paper: "presentation-16-9")
#set text(size: 25pt, lang: "de", region: "DE", font: "Noto Serif")
#show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
#show raw: set text(size: 1.2em)

#show: metropolis-theme.with(footer: utils.current-section)

// Use #polylux-slide to create a slide and style it using your favourite Typst functions
#title-slide(
	title: [Kolloquium ],
	subtitle: [Berechnung von charakteristischen Eigenschaften von botanischen Bäumen mithilfe von 3D-Punktwolken.],
	author: [Anton Wetzel],
	date: datetime.today().display("[day].[month].[year]"),
)

#new-section-slide[Problem]

#slide[
	#grid(
		columns: 1 * (1fr, 1fr),
		[
			- Scan von einem Wald
			- Lidar
			- 3D-Punktwolke
		],
		{
			only(1, rect(width: 100%, height: 100%, [Komprimierte Daten]))
			only(2, rect(width: 100%, height: 100%, [Liste von Punkten]))
			only(3, rect(width: 100%, height: 100%, [3D-Render]))
			only(4, rect(width: 100%, height: 100%, [3D-Render mit extra]))
		}
	)
]

#new-section-slide[Segmentierung]

#new-section-slide[Analyse von Bäumen]

#new-section-slide[Technische Details]

#slide[
	- `https://github.com/antonWetzel/treee`
	- Rust
	- WebGPU

]

#focus-slide[Demonstration]

#new-section-slide[Referenzen]

#slide[
	- `https://github.com/antonWetzel/masterarbeit`
		- Arbeit
		- Vortrag
	- `https://github.com/antonWetzel/treee`
		- Softwareprojekt
]

#new-section-slide[Rückfragen]
