#import "@preview/polylux:0.3.1": *
#import "theme.typ": *

#show: doc => setup(footer: [Anton Wetzel | #datetime.today().display("[day].[month].[year]")], doc)

#title-slide(
	title: [Kolloquium],
	subtitle: [Analyse von Bäumen mit 3D-Punktwolken],
)

#new-section[Problem]

#normal-slide(
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
	},
)

#new-section[Segmentierung]

#new-section[Analyse von Bäumen]

#new-section[Technische Details]

#normal-slide[
	- `https://github.com/antonWetzel/treee`
	- Rust
	- WebGPU

]

#new-section[Demonstration]

#new-section[Referenzen]

#normal-slide[
	- `https://github.com/antonWetzel/masterarbeit`
		- Arbeit
		- Vortrag
	- `https://github.com/antonWetzel/treee`
		- Softwareprojekt
]

#final-slide(title: [Danke für ihre Aufmerksamkeit], e-mail: [anton.wetzel\@tu-ilmenau.de])
