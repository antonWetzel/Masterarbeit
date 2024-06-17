#import "@preview/polylux:0.3.1": *
#import "theme.typ": *
#import "@preview/cetz:0.2.0" as cetz

#show: doc => setup(footer: [Anton Wetzel | #datetime.today().display("[day].[month].[year]")], doc)

#title-slide(
	title: [Analyse und Visualisierung von Bäumen mit 3D-Punktwolken],
)

#new-section[Überblick]

#normal-slide(
	title: [Ablauf],
)[
	#set align(center + horizon)
	#cetz.canvas(length: 1.0cm, {
		import cetz.draw: *
		let box-width = 5.0

		let box(x, y, name, stroke: 1pt) = {
			rect((x, y), (x + box-width, y + 1), name: name, stroke: stroke)
			content(name, raw(name))
		}
		set-style(mark: (end: ">", fill: black, scale: 1.4, width: 3.5pt), stroke: black)

		box(0, 0, "Wald")
		box(6, -6, "Punktwolke")
		box(12, 0, "Segmente")
		box(18, -6, "Informationen")

		line("Wald", "Punktwolke")
		line("Punktwolke", "Segmente")
		line("Segmente", "Informationen")
		content(("Wald", 50%, "Punktwolke"), angle: -45deg, anchor: "south", padding: 0.1cm, [Lidar-Scan])
		content(("Punktwolke", 50%, "Segmente"), angle: 45deg, anchor: "south", padding: 0.1cm, [
			#only(1)[Segmentierung] #only(2)[*Segmentierung*]
		])
		content(("Segmente", 50%, "Informationen"), angle: -45deg, anchor: "south", padding: 0.1cm, [
			#only(1)[Analyse] #only(2)[*Analyse*]
		])
	})
]

#normal-slide(
	title: [Eingabedaten],
)[
	- Lidar-Scan von einem Wald
	- Quelle
		- (`TLS`) Terrestrial
		- (`ULS`) Drohne
		- (`ALS`) Flugzeug
	- Kombination von mehreren Messungen
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

	#let length = 1.4cm

	#only(1, cetz.canvas(length: length, {
		outer()
		base()
		scanner()
	}))

	#only(2, cetz.canvas(length: length, {
		outer()
		base()
		lines()
		scanner()
	}))

	#only(3, cetz.canvas(length: length, {
		outer()
		points()
	}))

	#only(4, cetz.canvas(length: length, {
		outer()
		let stroke = (dash: "dotted", thickness: 2pt)
		line((-2, -3), (2.3, -3), (2.3, -2), (2.5, -2), (2.5, -3), (6, -3), stroke: stroke)
		circle((2.4, -2), radius: 0.5, stroke: stroke, fill: white)
		rect((2.325, -3), (2.4675, -2), fill: white, stroke: none)
	}))
]

#normal-slide(
	title: [Ziel],
	columns: (2fr, 3fr),
)[
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
	title: [Ablauf],
	columns: (1.1fr, 2fr),
)[
	+ *Horizontale Scheiben*
	+ Bereiche
	+ Koordinaten
	+ Punkte zuordnen
][#{
	set align(right)
	only(1, image("../images/crop/layers_1.png"))
	only(2, image("../images/crop/layers_2.png"))
	only(3, image("../images/crop/layers_3.png"))
	only(4, image("../images/crop/layers_4.png"))
	only(5, image("../images/crop/layers_5.png"))
	only(6, image("../images/crop/layers_6.png"))
	only(7, image("../images/crop/layers_7.png"))
	only(8, image("../images/crop/layers_8.png"))
}]

#normal-slide(
	title: [Ablauf],
	columns: (1.1fr, 1fr, 1fr),
)[
	+ Horizontale Scheiben
	+ *Bereiche*
	+ Koordinaten
	+ Punkte zuordnen
][
	#rect(image("../images/test_5-areas.svg"), inset: 0.5pt)
][
	#rect(image("../images/test_6-areas.svg"), inset: 0.5pt)
]

#normal-slide(
	title: [Ablauf],
	columns: (1.1fr, 1fr, 1fr),
)[
	+ Horizontale Scheiben
	+ Bereiche
	+ *Koordinaten*
	+ Punkte zuordnen
][
	#rect(image("../images/test_5-coords.svg"), inset: 0.5pt)
][
	#rect(image("../images/test_6-coords.svg"), inset: 0.5pt)
]

#normal-slide(
	title: [Ablauf],
)[
	+ Horizontale Scheiben
	+ Bereiche
	+ Koordinaten
	+ *Punkte zuordnen*
][
	#rect(image("../images/test_5-moved.svg"), inset: 0.5pt)
][
	#rect(image("../images/test_6-moved.svg"), inset: 0.5pt)
]

#normal-slide(
	title: [Ergebnis],
)[
	#grid(
		columns: (1fr, 1fr),
		image("../images/auto-crop/segments-ka11-als.png"), image("../images/auto-crop/segmentation_uls.png")
	)
]

#new-section[Analyse von Bäumen]

#normal-slide(
	columns: (2fr, 3fr),
	title: [Gesamter Baum],
)[
	+ Scheiben
	+ Unterteilung
		- Boden
		- Stamm
		- Krone
	+ Höhen
	+ Durchmesser
][
	#grid(
		columns: 1 * 2,
		column-gutter: 2em,
		image("../images/klassifkation_slices.svg"),
		image("../images/crop/prop_classification.png"),
	)
]

#normal-slide(
	columns: (2fr, 3fr),
	title: [Einzelne Punkte],
)[
	- Daten
		- Höhe
		- Krümmung
		- Ausdehnung
	- Visualisierung
		- Größe
		- Orientierung
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
	columns: (3fr, 1fr),
	title: [Überblick],
	expand-content: true,
)[
	- Repository
		- `https://github.com/antonWetzel/treee`
	- Technologie
		- Rust
		- WebGPU
	- Systemanforderungen
		- Keine

][
	#align(center, grid(
		rows: (1fr, 1fr),
		image("./assets/rust.png"),
		image("./assets/webgpu.svg"),
	))
]

#let box-offset = 7; #let box-width = 5;

#normal-slide(title: [Quelltext])[
	#set align(center + horizon)
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
	#set align(center + horizon)
	#cetz.canvas(length: 1cm, {
		import cetz.draw: *

		let box(x, y, name, node, stroke: 1pt) = {
			rect((x, y), (x + box-width, y + 1), name: node, stroke: stroke)
			content(node, raw(name))
		}

		set-style(mark: (end: ">", fill: black, scale: 1.4, width: 3.5pt), stroke: black)

		box(0, 2, "Punktdaten", "daten")
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

#normal-slide(
	title: [Detailstufen],
	expand-content: true,
)[
	- Originalen Punkte für Leaf-Knoten
		- Maximale Punktanzahl
	- Detailstufen für Branch-Knoten
][
	#{
		set align(center)
		only(1, image("../images/crop/lod_0.png"))
		only(2, image("../images/crop/lod_1.png"))
		only(3, image("../images/crop/lod_2.png"))
		only(4, image("../images/crop/lod_3.png"))
		only(5, image("../images/crop/lod_4.png"))
		only(6, image("../images/crop/lod_5.png"))
	}
]

#normal-slide(
	title: [Culling],
	expand-content: true,
)[
	- Nur sichtbare Knoten anzeigen
	- Genauer für kleinere Knoten
][
	#{
		set align(center + horizon)
		only(1, rect(image("../images/culling_0.png"), inset: 0.5pt))
		only(2, rect(image("../images/culling_1.png"), inset: 0.5pt))
		only(3, rect(image("../images/culling_2.png"), inset: 0.5pt))
		only(4, rect(image("../images/culling_3.png"), inset: 0.5pt))
		only(5, rect(image("../images/culling_4.png"), inset: 0.5pt))
		only(6, rect(image("../images/culling_5.png"), inset: 0.5pt))
		only(7, rect(image("../images/culling_6.png"), inset: 0.5pt))
	}
]

#focus-slide(size: 90pt, [Demonstration])

#new-section[Referenzen]

#let link-ref(content) = {
	set text(size: 0.8em)
	link(content, raw(content))
}

#normal-slide(
	title: [Quellen],
)[
	- Arbeit und Vortrag
		- #link-ref("https://github.com/antonWetzel/masterarbeit")
	- Softwareprojekt
		- #link-ref("https://github.com/antonWetzel/treee")
	- Präsentationsvorlage
		- #link-ref("https://intranet.tu-ilmenau.de/site/moef/SitePages/Dokumente.aspx")
]

#final-slide(title: [Danke für ihre Aufmerksamkeit], e-mail: [anton.wetzel\@tu-ilmenau.de])

#focus-slide(size: 90pt, [Nachfragen])

#new-section[Appendix]

#normal-slide(
	title: [Import (Punkte pro Sekunde)],
	expand-content: true,
)[
	#image("../data/punkte_pro_sekunde.svg")
]

#normal-slide(
	title: [Anzeigen von Punkten],
)[
	- Benötigt
		- Position
		- Größe
		- Orientierung
	- Dreieck + Discard
	- Instancing
][
	#cetz.canvas(length: 1.8cm, {
		import cetz.draw: *
		circle((0, 0), radius: 1, fill: silver)
		line((-1.73, -1), (1.73, -1), (0, 2), close: true)
	})
][
	#rect(image("../images/auto-crop/properties.png"), inset: 0.5pt)
]

#normal-slide(
	title: [Auswertung],
	expand-content: true,
)[
	- *Gesamthöhe vom Baum*
	- Stammdurchmesser bei #number(130, unit: [cm])
	- Anfangshöhe der Baumkrone
	- Durchmesser der Baumkrone
][
	#image("../data/data_tree_height.svg")
]

#normal-slide(
	title: [Auswertung],
	expand-content: true,
)[
	- Gesamthöhe vom Baum
	- *Stammdurchmesser bei #number(130, unit: [cm])*
	- Anfangshöhe der Baumkrone
	- Durchmesser der Baumkrone
][
	#image("../data/data_trunk_diameter.svg")
]

#normal-slide(
	title: [Auswertung],
	expand-content: true,
)[
	- Gesamthöhe vom Baum
	- Stammdurchmesser bei #number(130, unit: [cm])
	- *Anfangshöhe der Baumkrone*
	- Durchmesser der Baumkrone
][
	#image("../data/data_crown_start.svg")
]

#normal-slide(
	title: [Auswertung],
	expand-content: true,
)[
	- Gesamthöhe vom Baum
	- Stammdurchmesser bei #number(130, unit: [cm])
	- Anfangshöhe der Baumkrone
	- *Durchmesser der Baumkrone*
][
	#image("../data/data_crown_diameter.svg")
]

#let lines_and_mesh(prec) = {
	grid(
		rows: (1fr, 1fr, auto),
		image("../images/crop/triangulation_mesh_" + prec + ".png"),
		image("../images/crop/triangulation_lines_" + prec + ".png"),
		align(center, number(prec, unit: [m])),
	)
}

#normal-slide(
	title: [Triangulierung],
	columns: (1fr, 2fr),
	expand-content: true,
)[

	- Ball-Pivoting Algorithmus
	- Konvexe Hülle
	- $alpha$ für Genauigkeit
][
	#grid(
		columns: 1 * 5,
		stroke: silver,
		inset: 2pt,
		lines_and_mesh("0.2"),
		lines_and_mesh("0.5"),
		lines_and_mesh("1.0"),
		lines_and_mesh("2.0"),
		lines_and_mesh("5.0"),
	)
]
