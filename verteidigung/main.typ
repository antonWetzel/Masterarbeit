#import "@preview/polylux:0.3.1": *
#import "theme.typ": *
#import "@preview/cetz:0.2.0" as cetz

#show: doc => setup(footer: [Anton Wetzel | #datetime.today().display("[day].[month].[year]")], doc)

#title-slide(
	title: [Analyse und Visualisierung von Bäumen mit 3D-Punktwolken],
)

#set figure(numbering: none)

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
		1.97,
		1.77,
		1.75,
		1.94,
		2.7,
		2.65,
		6,
	)

	#let outer() = {
		rect((-2, 1), (6, -3.5))
	}
	#let base() = {
		rect((-2, -2.99), (6, -3.5), fill: gray, stroke: none)
		line((-2, -3), (0.9, -3), (0.9, -2), (1.1, -2), (1.1, -3), (2.3, -3), (2.3, -2), (2.5, -2), (2.5, -3), (6, -3), fill: gray)
		circle((2.4, -2), fill: gray, radius: 0.5)
		circle((1, -2), fill: gray, radius: 0.5)
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
		line((-2, -3), (0.9, -3), (0.9, -2), (1.1, -2), (1.1, -3), (2.3, -3), (2.3, -2), (2.5, -2), (2.5, -3), (6, -3), stroke: stroke)
		circle((2.4, -2), radius: 0.5, stroke: stroke, fill: white)
		circle((1.0, -2), radius: 0.5, stroke: stroke, fill: white)
		rect((2.325, -3), (2.4675, -2), fill: white, stroke: none)
		rect((2.325 - 1.4, -3), (2.4675 - 1.4, -2), fill: white, stroke: none)
	}))
]

#normal-slide(
	title: [Testdaten],
	expand-content: true,
)[
	- ALS-, ULS- und TLS-Daten
	- Teilweise in Bäume unterteilt
	- Messungen für einzelne Bäume
][
	#set align(bottom)
	#figure(caption: [Punktanzahl], image("../data/total_points.svg"))
]

#normal-slide(
	title: [Segmentierung],
	columns: (auto, 1fr),
	expand-content: true,
)[
	- Ein Segment für jeden Baum
	- Punkte zuordnen
][
	#set align(horizon)
	#image("../images/auto-crop/segments-br05-als.png")
]

#normal-slide(
	title: [Analyse],
	expand-content: true,
)[
	+ Gesamthöhe
	+ Kronenhöhe
	+ Stammhöhe
	+ Kronendurchmesser
	+ Stammdurchmesser bei #number(1.3, unit: [m])
][
	#cetz.canvas(length: 2.6cm, {
		import cetz.draw: *

		line((-0.2, 0.0), (-0.2, -3.0), (0.2, -3.0), (0.2, 0.0), fill: gray)
		line((-0.2, -3.0), (0.2, -3.0), (1, -3.2), (-1, -3.2), close: true, fill: gray)
		circle((0.0, 0.0), radius: 1, fill: gray)

		line((-2.5, -3.0), (-2.5, 1.0), mark: (start: "|", end: "|"))
		content((-2.5, -1.0), $1$, anchor: "east", padding: 0.1)

		line((-1.8, -0.95), (-1.8, 1.0), mark: (start: "|", end: "|"))
		content((-1.8, 0.0), $2$, anchor: "east", padding: 0.1)

		line((-1.8, -1.05), (-1.8, -3.0), mark: (start: "|", end: "|"))
		content((-1.8, -2.0), $3$, anchor: "east", padding: 0.1)

		line((-1.1, 0.0), (1.1, 0.0), mark: (start: "|", end: "|"))
		content((-1.1, 0.0), $4$, anchor: "east", padding: 0.1)

		line((-0.25, -2.5), (0.25, -2.5), mark: (start: "|", end: "|"))
		content((-0.2, -2.5), $5$, anchor: "east", padding: 0.1)
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

	let images = range(1, 9).map(i => image("../images/crop/layers_" + str(i) + ".png"));
	only(1, {
		image("../images/crop/layers_ori.png")
	})
	only(2, {
		image("../images/crop/layers.png")
	})
	for (i, img) in images.enumerate() {
		only(i + 3, img)
	}
}]

#let double-image(a, b, text) = {
	grid(
		columns: 1 * (1fr, 1fr),
		gutter: 1em,
		rect(image(a), inset: 0.5pt),
		rect(image(b), inset: 0.5pt),
		grid.cell(colspan: 2, align(center, text))
	)
}

#normal-slide(
	title: [Ablauf],
	columns: (1.1fr, 2fr),
)[
	+ Horizontale Scheiben
	+ *Bereiche*
	+ Koordinaten
	+ Punkte zuordnen
][
	#double-image("../images/test_5-areas.svg", "../images/test_6-areas.svg", [Zusammenhängende Bereiche])
]

#normal-slide(
	title: [Ablauf],
	columns: (1.1fr, 2fr),
)[
	+ Horizontale Scheiben
	+ Bereiche
	+ *Koordinaten*
	+ Punkte zuordnen
][
	#double-image("../images/test_5-coords.svg", "../images/test_6-coords.svg", [Koordinaten der Bäume])
]

#normal-slide(
	title: [Ablauf],
	columns: (1.1fr, 2fr),
)[
	+ Horizontale Scheiben
	+ Bereiche
	+ Koordinaten
	+ *Punkte zuordnen*
][
	#double-image("../images/test_5-moved.svg", "../images/test_6-moved.svg", [Bereiche für die Bäume])
]

#normal-slide(
	title: [Ergebnisse],
	expand-content: true,
)[
	#image("../images/auto-crop/segments-ka11-als.png")
][
	#set align(bottom)
	#image("../images/auto-crop/segmentation_uls.png")
]

#new-section[Analyse]

#normal-slide(
	columns: (2fr, 4fr),
	title: [Klassifizierung],
	expand-content: true,
)[
	+ Horizontale Scheiben
	+ Zugehörige Flächen
	+ Klassifizierung
		- Boden
		- Stamm
		- Krone
][

	#set align(center + bottom)

	#grid(
		columns: 1 * 4,
		column-gutter: 2em,
		row-gutter: 0.2em,
		image("../images/crop/prop_height.png"),
		image("../images/klassifkation_slices copy.svg"),
		image("../images/klassifkation_slices copy 2.svg", height: 82%),
		image("../images/crop/prop_classification-recolor.png"),
		[Punkte],
		[Scheiben],
		[Flächen],
		[Klassifizierung],
	)
]

#normal-slide(
	columns: (1fr, 1fr),
	title: [Eigenschaften],
	expand-content: true,
)[
	+ Gesamthöhe
	+ Kronenhöhe
	+ Stammhöhe
	+ Kronendurchmesser
	+ Stammdurchmesser bei #number(1.3, unit: [m])
][

	#place(pad(left: 3cm, image("../images/crop/prop_classification-recolor.png")))

	#cetz.canvas(length: 1cm, {
		import cetz.draw: *

		rect((0, 0.0), (10, 11), stroke: none, fill: rgb(0, 0, 0, 0))
		line((1.0, 0), (1.0, 11), mark: (start: "|", end: "|"))
		content((1.0, 5.5), $1$, anchor: "east", padding: 0.1)

		line((2.0, 3.8), (2.0, 11), mark: (start: "|", end: "|"))
		content((2.0, 7.5), $2$, anchor: "east", padding: 0.1)

		line((2.0, 3.6), (2.0, 0), mark: (start: "|", end: "|"))
		content((2.0, 1.8), $3$, anchor: "east", padding: 0.1)

		line((3.1, 8.7), (6.8, 8.7), mark: (start: "|", end: "|"))
		content((3.1, 8.7), $4$, anchor: "east", padding: 0.1)

		line((5, 0.5), (5.3, 0.5), mark: (start: "|", end: "|"))
		content((5, 0.5), $5$, anchor: "east", padding: 0.1)
	})
]

#normal-slide(
	columns: (2fr, 3fr),
	title: [Einzelne Punkte],
	expand-content: true,
)[
	- Daten
		- Höhe
		- Krümmung
		- Ausdehnung
	- Visualisierung
		- Größe
		- Orientierung
][
	#set align(bottom)
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

#new-section[Ergebnisse]

#normal-slide(
	title: [Vergleich],
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
	title: [Vergleich],
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
	title: [Vergleich],
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
	title: [Vergleich],
	expand-content: true,
)[
	- Gesamthöhe vom Baum
	- Stammdurchmesser bei #number(130, unit: [cm])
	- Anfangshöhe der Baumkrone
	- *Durchmesser der Baumkrone*
][
	#image("../data/data_crown_diameter.svg")
] #new-section[Referenzen]

#let link-ref(content) = {
	set text(size: 0.8em)
	link(content, raw(content))
}

#normal-slide(
	title: [Quellen],
)[
	- Arbeit und Vortrag
		- #link-ref("https://github.com/antonWetzel/masterarbeit")
	- Programm
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

- General
	- Laptop am Strom anschließen
	- Webex
	- Gesamtdauer: 25 bis 30 Minuten
	- Alle Folien selbsterklärend
	- Analyse Punkte nur Anschneiden
	- Programm statt Softwareprojekt sagen
- 2
	- Beispielbilder
- Einfügen (nach Demo)
	- Folie mit ALS, ULS und TLS Daten
	- Ergebnis Folien

- SOFTWARE
	- Punkte entfernen
	- Werte neu Berechnen
	- Werte händisch anpassen
