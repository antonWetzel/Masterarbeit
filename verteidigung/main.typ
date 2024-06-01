#import "@preview/polylux:0.3.1": *
#import "theme.typ": *
#import "@preview/cetz:0.2.0" as cetz

#show: doc => setup(footer: [Anton Wetzel | #datetime.today().display("[day].[month].[year]")], doc)

#title-slide(
	title: [Kolloquium],
	subtitle: [Analyse von Bäumen mit 3D-Punktwolken],
)

#new-section[Überblick]

#normal-slide(
	title: [Eingabedaten],
)[
	- Lidar-Scan von einem Wald
	- Quelle
		- (`TLS`) Terrestrial
		- (`ULS`) Drohne
		- (`ALS`) Flugzeug
][
	#import cetz.draw: *

	#let l = (
		3.46,
		3.25,
		3.1,
		3.05,
		3.0,
		3.05,
		3.1,
		3.25,
		3.46,
		3.78,
		2.7,
		2.65,
		6,
	)

	#let outer() = {
		rect((-2, 1), (6, -3.5))
	}
	#let base() = {
		rect((-2, -2.99), (6, -3.5), fill: gray, stroke: none)
		line((-2, -3), (2.3, -3), (2.3, -2), (2.5, -2), (2.5, -3), (6, -3), fill: gray)
		circle((2.4, -2), fill: gray, radius: 0.5)
	}

	#let lines() = {
		for i in range(0, l.len()) {
			line((0, 0), (240deg + i * 7.5deg, l.at(i)))
		}
	}

	#let points() = {
		for i in range(0, l.len()) {
			circle((240deg + i * 7.5deg, l.at(i)), radius: 0.1, fill: black, stroke: none)
		}
	}

	#let scanner() = {
		circle((0, 0), stroke: black, fill: red, radius: 0.1)

	}

	#only(1, cetz.canvas(length: 1.2cm, {
		outer()
		base()
		scanner()
	}))

	#only(2, cetz.canvas(length: 1.2cm, {
		outer()
		base()
		lines()
		scanner()
	}))

	#only(3, cetz.canvas(length: 1.2cm, {
		outer()
		points()
	}))
]

#normal-slide(
	title: [Ziel],
	alignment: (2fr, 3fr),
)[
	Segmentierung
	- Ein Segment für jeden Baum
	- Punkte in Segmente unterteilen
][
	#image("../images/auto-crop/segments-br05-als.png")
]

#normal-slide(
	title: [Ziel],
)[
	Baumdaten
	+ Kronendurchmesser
	+ Stammdurchmesser bei #number(1.3, unit: [m])
	+ Gesamthöhe
	+ Kronenhöhe
	+ Stammhöhe
][
	#cetz.canvas(length: 1.5cm, {
		import cetz.draw: *

		line((-0.2, 0.0), (-0.2, -3.0), (0.2, -3.0), (0.2, 0.0), fill: gray)
		line((-0.2, -3.0), (0.2, -3.0), (1, -3.2), (-1, -3.2), close: true, fill: gray)
		circle((0.0, 0.0), radius: 1, fill: gray)

		line((-1.1, 0.0), (1.1, 0.0), mark: (start: "|", end: "|"))
		content((-1.1, 0.0), $1$, anchor: "east", padding: 0.15)

		line((-0.25, -2.5), (0.25, -2.5), mark: (start: "|", end: "|"))
		content((-0.2, -2.5), $2$, anchor: "east", padding: 0.15)

		line((1.5, -3.0), (1.5, 1.0), mark: (start: "|", end: "|"))
		content((1.5, -1.0), $3$, anchor: "west", padding: 0.15)

		line((2.5, -0.95), (2.5, 1.0), mark: (start: "|", end: "|"))
		content((2.5, 0.0), $4$, anchor: "west", padding: 0.15)

		line((2.5, -1.05), (2.5, -3.0), mark: (start: "|", end: "|"))
		content((2.5, -2.0), $5$, anchor: "west", padding: 0.15)

	})
]

#new-section[Segmentierung]

#normal-slide(
	title: [To-do],
)[

]

#new-section[Analyse von Bäumen]

#normal-slide(
	alignment: (2fr, 3fr),
	title: [Gesamter Baum],
)[
	- Gesamthöhe
	- Stamm
		- Höhe
		- Durchmesser
	- Krone
		- Höhe
		- Durchmesser
][
	#grid(
		columns: 1 * 2,
		column-gutter: 2em,
		image("../images/klassifkation_slices.svg"),
		image("../images/crop/prop_classification.png"),
	)
]

#normal-slide(
	alignment: (2fr, 3fr),
	title: [Einzelne Punkte],
)[
	- Höhe
	- Krümmung
	- Ausdehnung
][
	#grid(
		columns: 1 * 4,
		column-gutter: 2em,
		image("../images/crop/prop_height.png"),
		image("../images/crop/prop_curve_all.png"),
		image("../images/crop/prop_var_all.png"),
	)
]

#new-section[Umsetzung]

#normal-slide(
	alignment: (3fr, 1fr),
	title: [Überblick],
)[
	- Repository
		- `https://github.com/antonWetzel/treee`
	- Technologie
		- Rust
		- WebGPU
	- Betriebssystem
		- Beliebig

][
	#align(center, grid(
		rows: (1fr, 1fr),
		image("./assets/rust.png"),
		image("./assets/webgpu.svg"),
	))
]

#let box-offset = 7; #let box-width = 5;

#normal-slide(title: [Quelltext])[
	#set align(center)
	#cetz.canvas(length: 1.0cm, {
		import cetz.draw: *

		let box(x, y, name, stroke: 1pt) = {
			rect((x, y), (x + box-width, y + 1), name: name, stroke: stroke)
			content(name, raw(name))
		}
		set-style(mark: (end: ">", fill: black, scale: 1.4, width: 3.5pt), stroke: black)

		box(0, -1, "project")
		box(0, 1, "data-file")
		box(0, -3, "k-nearest")
		box(0, 3, "input")
		box(box-offset, -1, "triangulation")
		box(box-offset, 3, "render")
		box(box-offset, -3, "importer", stroke: 3pt)
		box(box-offset, 1, "viewer", stroke: 3pt)
		box(box-offset * 2, -1, "treee", stroke: 3pt)

		line("k-nearest.east", "triangulation.west")
		line("project.east", "render.west")
		line("input.east", "render.west")
		line("data-file.east", "importer.west")
		line("data-file.east", "viewer.west")
		line("render.south", "viewer.north")
		line("triangulation.north", "viewer.south")
		line("k-nearest.east", "importer.west")
		line("project.east", "importer.west")

		line("importer.east", "treee.west")
		line("viewer.east", "treee.west")
	})
]

#normal-slide(title: [Import])[
	#set align(center)
	#cetz.canvas(length: 1cm, {
		import cetz.draw: *

		let box(x, y, name, node, stroke: 1pt) = {
			rect((x, y), (x + box-width, y + 1), name: node, stroke: stroke)
			content(node, raw(name))
		}

		set-style(mark: (end: ">", fill: black, scale: 1.4, width: 3.5pt), stroke: black)

		box(0, 2, "Punktdaten", "daten")
		// rect((0, 2), (3, 3), name: "daten")
		// content("daten", [Punktdaten])
		box(box-offset, 4, "Segment 1", "seg0")
		box(box-offset, 2, "Segment 2", "seg1")
		box(box-offset, 0, "...", "seg2")

		line("daten.east", "seg0.west")
		line("daten.east", "seg1.west")
		line("daten.east", "seg2.west")
		box(box-offset * 2, 3, "Octree", "octree")
		box(box-offset * 2, 1, "Punktwolke", "punktwolke")
		line("seg0.east", "octree.west")
		line("seg1.east", "octree.west")
		line("seg2.east", "octree.west")
		line("seg0.east", "punktwolke.west")
		line("seg1.east", "punktwolke.west")
		line("seg2.east", "punktwolke.west")
		line("octree.south", "punktwolke.north")
	})
]

#focus-slide(background: luma(20%), foreground: luma(80%), size: 90pt, [Demonstration])

#new-section[Referenzen]

#let referenz(content) = {
	set text(size: 0.8em)
	link(content, raw(content))
}

#normal-slide(
	title: [Quellen],
)[
	- Arbeit und Vortrag
		- #referenz("https://github.com/antonWetzel/masterarbeit")
	- Softwareprojekt
		- #referenz("https://github.com/antonWetzel/treee")
	- Präsentationvorlage
		- #referenz("https://intranet.tu-ilmenau.de/site/moef/SitePages/Dokumente.aspx")
]

#final-slide(title: [Danke für ihre Aufmerksamkeit], e-mail: [anton.wetzel\@tu-ilmenau.de])

#new-section[Appendix]

#normal-slide(
	title: [Auswertung],
)[

]
