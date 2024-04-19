#import "setup.typ": *


= Implementierung <implementierung>


== Technik

Das Softwareprojekt ist auf #link-footnote("https://github.com/antonWetzel/treee", [GitHub]) verfügbar. Als Programmiersprache wird Rust und als Grafikkartenschnittstelle WebGPU verwendet. Rust ist eine performante Programmiersprache mit einfacher Integration für WebGPU. WebGPU bildet eine Abstraktionsebene über der nativen Grafikkartenschnittstelle, dadurch ist die Implementierung unabhängig vom Betriebssystem. Alle verwendeten Bibliotheken sind in @implementierung_bilbiotheken gelistet.

#{
	show table.cell: set text(size: 0.8em)
	[#figure(
		caption: [Benutzte Bibliotheken],
		table(
			columns: (auto, auto, 1fr),
			align: (x, y) => if y == 0 { center } else { (left, right, left).at(x) },
			[*Name*],            [*Version*], [*Funktionalität*],
			`nalgebra`,          `0.32.4`,    [Lineare Algebra],
			`pollster`,          `0.3`,       [Auf asynchrone Berechnungen warten],
			`rfd`,               `0.14`,      [Dialogfenster zum Öffnen und Speichern von Dateien],
			`crossbeam`,         `0.8`,       [Synchronisierung zwischen Threads],
			`log`,               `0.4`,       [Logs erzeugen],
			`env_logger`,        `0.11`,      [Wiedergabe von Logs],
			`image`,             `0.24`,      [Laden und Speichern von Bildern],
			`wgpu`,              `0.19`,      [WebGPU Implementierung],
			`winit`,             `0.29`,      [Fenstermanagement],
			`bytemuck`,          `1.14`,      [Konversation von Daten zu Bytes],
			`serde`,             `1.0`,       [Serialisierung von Datentypen],
			`serde_json`,        `1.0`,       [Serialisierung als JSON],
			`rand`,              `0.8`,       [Generierung von Zufallszahlen],
			`num_cpus`,          `1.15`,      [Anzahl von Prozessorkernen bestimmen],
			`laz`,               `0.8`,       [Dekomprimieren von LASzip Dateien],
			`thiserror`,         `1.0`,       [Fehlermanagement],
			`tempfile`,          `3.8.1`,     [Temporäre Dateien erstellen],
			`rayon`,             `1.8.0`,     [Multithreading],
			`termsize`,          `0.1`,       [Größe vom Terminal bestimmen],
			`egui`,              `0.26`,      [Benutzerinterface],
			`egui-winit`,        `0.26`,      [Systemereignisse zum Interface weiterleiten],
			`egui-wgpu`,         `0.26`,      [Interface rendern],
			`clap`,              `4.4`,       [Kommandozeilenargumente verarbeiten],
			`voronator`,         `0.2.1`,     [Voronoi-Diagramm bestimmen],
			`cfg-if`,            `1.0.0`,     [Konditionales Kompilieren von Quelltext],
			`static_assertions`, `1.1.0`,     [Systemeigenschaften überprüfen],
			`colored`,           `2.1.0`,     [Farben für Text im Terminal],
		),
	) <implementierung_bilbiotheken>]
}

Als Eingabe werden Datensätze im LASzip-Format verwendet. Weitere Formate können einfach eingebunden werden, solange eine Rust-Bibliothek existiert, welche das Format einlesen kann.


== Benutzung


=== Installation

Für den Import und die Visualisierung wird das kompilierte Programm `treee` benötigt. Dieses kann mit dem Quelltext selber kompiliert werden oder bereits kompilierte Versionen können vom #link-footnote("https://github.com/antonWetzel/treee/releases", [GitHub-Release]) heruntergeladen werden. Die Schritte zum selber kompilieren sind im #link-footnote("https://github.com/antonWetzel/treee?tab=readme-ov-file#treee", [Readme]) verfügbar.


=== Ausführen

In @implementierung_befehle sind die Befehle gelistet, um den Importer und die Visualisierung zu starten. Um `treee` von der Befehlszeile auszuführen, muss das Programm im `PATH` verfügbar sein oder anstelle von `treee` muss der absolute Pfad vom Programm verwendet werden.

#figure(
	caption: [Mögliche Befehle für das Programm.],
	table(
		align: (x, y) => if y == 0 { center } else { left },
		columns: (auto, 1fr),
		[*Befehl*],            [*Funktion*],
		`treee`,               [Interaktive Umgebung starten],
		`treee importer`,      [Importer starten],
		`treee help importer`, [Verfügbare Optionen für den Importer anzeigen],
		`treee viewer`,        [Visualisierung starten],
	),
) <implementierung_befehle>

Wenn das Programm ohne Argumente oder außerhalb vom Terminal gestartet wird, kann die gewünschte Funktion interaktiv ausgewählt werden. Für den Import können weitere Optionen mit der Befehlszeile angegeben werden, um den Ablauf an den Datensatz anzupassen.


=== Import

Für den Import wird der Datensatz und der Ordner zum Speichern der Ergebnisse benötigt. Beide können in der Befehlszeile angegeben werden oder über ein Dialogfenster ausgewählt werden. Alle weiteren Optionen mit der zugehörigen Funktion sind in @implementierung_import_optionen gelistet. Am Ende vom Import wird im Ordner für die Ergebnisse die `project.json` Datei und zugehörige Daten abgespeichert, welche von der Visualisierung geöffnet werden können.

#figure(
	caption: [Optionen für den Import.],
	table(
		align: (x, y) => if y == 0 { horizon + center } else { horizon + (left, right, left).at(x) },
		columns: (1fr, auto, 2fr),
		[*Flag*],                      [*Standardwert*], [*Funktion*],
		`--max-threads`,               [unbegrenzt],     [Maximale Anzahl an parallelen Threads],
		`--min-segment-size`,          $100$,            [Mindestanzahl von Punkten für ein Segment],
		`--segmenting-slice-width`,    [#number(1) m],   [Breite der horizontalen Scheiben für die Segmentierung],
		`--segmenting-max-distance`,   [#number(1) m],   [Mindestabstand zwischen Bereichen für die Segmentierung],
		`--calculations-slice-width`,  [#number(0.1) m], [Breite der horizontalen Scheiben für die Analyse von einem Baum],
		`--ground-min-area-scale`,     number(1.5),      [Mindestgröße vom Boden im Vergleich zu der kleinsten Scheibe],
		`--ground-max-search-height`,  [#number(1.0) m], [Maximale Suchhöhe für den Anfang vom Boden],
		`--trunk-diameter-height`,     [#number(1.3) m], [Höhe für den Durchmesser vom Stamm],
		`--trunk-diameter-range`,      [#number(0.2) m], [Bereich für den Durchmesser vom Stamm],
		`--crown-diameter-difference`, [#number(1.0) m], [Unterschied vom Durchmesser zwischen dem Stamm und dem Anfang von der Baumkrone],
		`--neighbors-count`,           number(31),       [Maximale Punktanzahl in der Nachbarschaft für die Analyse von Punkten],
		`--neighbors-max-distance`,    [#number(1.0) m], [Maximale Distanz vom Punkt zu den Punkten in der Nachbarschaft],
		`--lod-size-scale`,            number(0.95),     [Skalierungsfaktor für die Fläche der kombinierten Punkte für die Detailstufen],
		`--proj-location`,             [`+proj=utm`\
		`+ellps=GRS80`\
		`+zone=32`], [Region für die geographischen Koordinaten],
	),
) <implementierung_import_optionen>


=== Visualisierung

Um eine Punktwolke zu öffnen, wird die `project.json` Datei eingelesen. In der Datei ist die Struktur vom Octree und Informationen über die Segmente enthalten. Die Punktdaten sind in separaten Dateien gespeichert und werden noch nicht geladen.

Je nach Position der Kamera werden die benötigten Punkte geladen, welche momentan sichtbar sind. Dadurch können auch Punktwolken angezeigt werden, die mehr Punkte enthalten als gleichzeitig interaktiv anzeigbar sind. Auch wenn ein einzelnes Segment angezeigt wird, ist nur das Segment geladen, welches ausgewählt wurde.

Mit dem Benutzerinterface kann die Visualisierung angepasst und Informationen angezeigt werden. Die Optionen und einsehbare Informationen sind in @implementierung_ui erklärt.

#figure(
	caption: [Benutzerinterface mit den verfügbaren Optionen und Informationen. ],
	box(width: 80%, grid(
		gutter: 2em,
		columns: 1 * (1fr, 1.4fr),
		rect(image("../images/ui.png"), radius: 4pt, inset: 2pt, stroke: rgb(27, 27, 27) + 4pt),
		align(horizon + left)[
			- *Load Project*
				- Andere Punktwolke öffnen
			- *Property*
				- Die angezeigte Eigenschaft ändern
			- *Segment*
				- Punkte, Linien oder Dreiecke anzeigen
				- Triangulation starten
				- Informationen über das ausgewählte Segment anzeigen
				- Segment speichern
			- *Visual*
				- Punktgröße ändern
				- Punkte basierend auf der ausgewählten Eigenschaft filtern
				- Farbpalette wechseln
				- Hintergrundfarbe ändern
				- Screenshot speichern
				- Unterteilung der Detailstufen anzeigen
			- *Eye Dome*
				- Stärke und Farbe vom Eye-Dome-Lighting ändern
			- *Level of Detail*
				- Auswahl und Qualität der Detailstufen anpassen
			- *Camera*
				- Steuerung der Kamera ändern
				- Kameraposition speichern oder wiederherstellen
		],
	)),
) <implementierung_ui>


== Struktur vom Quelltext

Das Softwareprojekt ist in mehrere Module unterteilt, um den Quelltext zu strukturieren. In @appendix_crates und @appendix_crates_abhängigkeiten sind die Module mit zugehöriger Funktionalität und Abhängigkeiten gelistet. Die wichtigsten Module sind `importer` und `viewer`, welche den Import und die Visualisierung beinhalten. Das Modul `treee` ist ein gemeinsames Interface für `importer` und `viewer`, wodurch ein ausführbares Programm für das ganze Projekt erstellt werden kann.

#figure(
	caption: [Module vom Projekt mit zugehöriger Funktionalität.],
	table(
		columns: (auto, 1fr),
		align: (x, y) => if y == 0 { center } else { (left, left).at(x) },
		[*Name*],        [*Funktionalität*],
		`input`,         [Maus- und Tastatureingaben verarbeiten],
		`data-file`,     [Daten zusammengefasst in einer Datei speichern],
		`project`,       [Format für eine Punktwolke und zugehörige Daten],
		`k-nearest`,     [Nachbarschaftssuche mit KD-Bäumen],
		`render`,        [Rendern von Punktwolken, Linien und Dreiecken mit `wgpu`],
		`viewer`,        [Visualisierung von Punktwolken],
		`triangulation`, [Triangulation von einer Punktwolke],
		`importer`,      [Import von Punktwolken],
		`treee`,         [Gemeinsames Interface für `importer` und `viewer`],
	),
) <appendix_crates>

#figure(
	caption: [Abhängigkeiten der Module untereinander.],
	cetz.canvas(length: 1.0cm, {
		import cetz.draw: *

		let box(x, y, name) = {
			rect((x, y), (x + 3, y + 1), name: name)
			content(name, raw(name))
		}
		set-style(mark: (end: ">", fill: black, scale: 1.4, width: 3.5pt), stroke: black)

		box(4, -1, "project")
		box(4, 1, "data-file")
		box(4, -3, "k-nearest")
		box(4, 3, "input")
		box(9, -1, "triangulation")
		box(9, 3, "render")
		box(9, -3, "importer")
		box(9, 1, "viewer")
		box(14, -1, "treee")

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
	}),
) <appendix_crates_abhängigkeiten>


== Import

Um einen Datensatz zu analysieren, muss dieser zuerst importiert werden, bevor er von der Visualisierung angezeigt werden kann. Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird der Berechnungsaufwand für eine Phase so weit wie möglich parallelisiert. Die Phasen sind:

#align(center, box(width: 80%, align(left, [
	+ Daten laden
	+ Segmente bestimmen
	+ Segmente analysieren und den Octree erstellen
	+ Detailstufen bestimmten und Octree speichern
])))

Der zugehörige Datenfluss ist in @überblick_datenfluss zu sehen. Nach der ersten Phase sind die Punktdaten bekannt und nach der zweiten Phase auf die Segmente aufgeteilt. In der dritten Phase werden dann die Segmente verarbeiten und der Octree aufgebaut. Nach der vierten Phase ist auch der Octree vollständig und die Punktwolke wird abgespeichert.

#figure(
	caption: [Datenfluss beim Import.],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *

		set-style(mark: (end: ">", fill: black, scale: 1.4, width: 3.5pt), stroke: black)
		rect((0, 2), (3, 3), name: "daten")
		content("daten", [Punktdaten])

		rect((5, 4), (8, 5), name: "seg0");
		content("seg0", [Segment 1])
		line("daten.east", "seg0.west")

		rect((5, 2), (8, 3), name: "seg1");
		content("seg1", [Segment 2])
		line("daten.east", "seg1.west")

		rect((5, 0), (8, 1), name: "seg2");
		content("seg2", [Segment ...])
		line("daten.east", "seg2.west")

		rect((10, 3), (14, 4), name: "octree")
		content("octree", [Octree])
		line("seg0.east", "octree.west")
		line("seg1.east", "octree.west")
		line("seg2.east", "octree.west")

		rect((10, 1), (14, 2), name: "punktwolke")
		content("punktwolke", [Punktwolke])
		line("seg0.east", "punktwolke.west")
		line("seg1.east", "punktwolke.west")
		line("seg2.east", "punktwolke.west")
		line("octree.south", "punktwolke.north")
	}),
) <überblick_datenfluss>


=== Parallelisierung

Die Punktdaten werden in LASzip Dateien zu Blöcken zusammengefasst. Jeder Block wird separat komprimiert, wodurch mehrere Blöcke auch parallel dekomprimiert werden können. Ein weiterer Thread sammelt die dekomprimierten Blöcke für die Segmentierung.

Für die Segmentierung wird über die einzelnen horizontalen Scheiben parallelisiert. Der genaue Ablauf ist in @implementierung_segment_parallel erklärt. Mit einem weiteren Thread werden die Segmente gesammelt.

Die Analyse der Segmente und die Berechnung der Detailstufen sind trivial parallelisierbar. Die Segmente haben untereinander keine Datenabhängigkeiten, wodurch diese parallel verarbeitete werden können. Bei den Detailstufen haben die Kinderknoten untereinander keine Abhängigkeiten.

#figure(
	caption: [
		Parallelisierung der Segmentierung.
	],
	grid(
		columns: (1fr, ) + (2fr, ),
		gutter: 2em,
		rect(image("../images/segmentierung_parallel.svg"), inset: 0pt, stroke: gray),
		align(top + left)[
			Bei der Segmentierung werden die Punkte von oben nach unten in Scheiben verarbeitet. Jede Scheibe wird in den folgenden Stufen verarbeitet.
			+ Zusammenhängenden Bereiche von den Punkten bestimmen.
			+ Mit den Bereichen und den Koordinaten der vorherigen Scheibe die Koordinaten für die momentane Scheibe berechnen.
			+ Punkte auf die Koordinaten verteilen.

			Dabei wird für die zweite Stufe die Koordinaten aus der vorherigen Scheibe benötigt.

			In der Grafik ist der Arbeitsaufwand dargestellt. Von oben nach unten sind die Scheiben und von links nach rechts die Zeit abgebildet. Die erste Stufe ist in Blau, das Warten auf die vorherige Scheibe in Rot und die dritte Stufe in Orange. Der Berechnungsaufwand der zweiten Stufe ist sehr kurz, wodurch diese nicht in der Grafik sichtbar ist.

			Die Berechnung wurde mit sieben Threads durchgeführt, wodurch bis zu sieben Scheiben in parallel verarbeitet werden können. Durch die Datenabhängigkeit kann aber die zweite Stufe erst verarbeitet werden, wenn von der vorherigen Scheibe die zweite Stufe beendet ist. Wenn die erste Stufe länger dauert, müssen deshalb andere Threads warten.
		]
	),
) <implementierung_segment_parallel>


== Format für eine Punktwolke

Die Struktur von einer Punktwolke ist in der `project.json` Datei gespeichert. Dazu gehören die verfügbaren Eigenschaften und der Octree. Alle benötigten Daten für `project.json` werden in #link-footnote("https://github.com/antonWetzel/treee/blob/main/project/src/lib.rs", `project/src/lib.rs`) definiert.


=== Daten

In separaten Dateien werden die Daten für die Punkte oder Eigenschaften gespeichert. Das verwendete Dateiformat ermöglicht es, die Dateien inkrementell zu erstellen. Am Anfang wird nur benötigt, wie viele Einträge die Datei speichern kann. Danach können die Einträge in beliebiger Reihenfolge abgespeichert werden.

Die Struktur ist in @implementierung_datafile gegeben. Am Anfang der Datei wird für jeden Eintrag die Startposition $s_i$ und die Länge $l_i$ vom zugehörigen Datensegment $d_i$ gespeichert. Danach folgen die Datensegmente in beliebiger Reihenfolge $pi$.

#figure(
	caption: [Struktur einer Datei zum Speichern von Daten.],
	table(
		align: center + horizon,
		columns: 11 *(1fr, ),
		table.cell(colspan: 7)[*Informationen*],
		table.cell(colspan: 4)[*Daten*],
		$s_0$,
		$l_0$,
		$s_1$,
		$l_1$,
		[...],
		$s_(n-1)$,
		$l_(n-1)$,
		$d_(pi(0))$,
		$d_(pi(1))$,
		[...],
		$d_(pi(n-1))$
	),
) <implementierung_datafile>

Um den Eintrag $i$ mit den Daten $d$ zur Datei hinzufügen, wird zuerst $s_i$ auf das momentane Ende der Datei und $l_i$ auf die Länge von $d$ gesetzt. Danach wird $d$ am Ende der Datei hinzugefügt. Um die Daten für den Eintrag $i$ zu lesen, wird zuerst $s_i$ und $l_i$ ausgelesen und danach der zugehörige Bereich geladen.


== Visualisierung


=== Punkte

Die benötigten Daten für die Visualisierung von einem Punkt sind das verwendete Polygon, Position, Normale, Größe und ausgewählte Eigenschaft. Das Polygon ist gleich für alle Punkte und muss deshalb nur einmal zur Grafikkarte übertragen werden und wird für alle Punkte wiederverwendet.

Für die Grafikpipeline wird das Polygon in Dreiecke zerlegt. In @implementierung_polygon_zerlegung sind die getesteten Varianten gegeben. Die Dreiecke werden dann mit der Kamera projiziert und es werden alle Pixel bestimmt, welche in den Dreiecken liegen. Für jedes Pixel kann entschieden werden, ob dieser im Ergebnis gespeichert wird. Dafür wird bei den Eckpunkten die Koordinaten ohne die Transformation der Kamera abgespeichert, dass diese später verfügbar sind. Für jedes Pixel wird von der Pipeline die interpolierten Koordinaten berechnet. Nur wenn der Betrag der interpolierten Koordinaten kleiner als eins ist, wird der Pixel im Ergebnis abgespeichert.

#figure(caption: [Zerlegung von unterschiedlichen Polygonen in Dreiecke.], grid(
	columns: 1 * 3,
	subfigure(
		caption: [Dreieck],
		cetz.canvas(length: 1cm, {
			import cetz.draw: *

			let x = calc.tan(60deg);
			circle((0, 0), radius: 1, stroke: none, fill: gray)
			line((-x, -1), (x, -1), (0, 2), close: true)
		}),
	),
	subfigure(
		caption: [Viereck],
		cetz.canvas(length: 1cm, {
			import cetz.draw: *

			circle((0, 0), radius: 1, stroke: none, fill: gray)
			line((-1, -1), (1, -1), (1, 1), (-1, 1), close: true)
			line((1, 1), (-1, -1))
		}),
	),
	subfigure(
		caption: [Achteck],
		cetz.canvas(length: 1cm, {
			import cetz.draw: *

			let x = calc.tan(22.5deg);
			circle((0, 0), radius: 1, stroke: none, fill: gray)
			line((x, -1), (-x, -1), (-1, -x), (-1, x), (-x, 1), (x, 1), (1, x), (1, -x), close: true)
			line((x, -1), (-1, -x), (1, -x), (-1, x), (1, x), (-x, 1))
		}),
	),
)) <implementierung_polygon_zerlegung>

In @implementierung_polygon sind die Zeiten für das Rendern von Punkten mit unterschiedlichen Polygonen gegeben. Die beste Option ist das Dreieck als Polygon. Für die Zerlegung vom Polygon mit $n$ Ecken in Dreiecke werden $n-2$ Dreiecke und somit $3n-6$ Ecken benötigt. Der benötigte Aufwand entsteht größtenteils durch die Ecken, wodurch das Quadrat circa doppelt und das Achteck sechsmal so lange zum Rendern benötigen.

#figure(
	caption: [Renderzeit bei unterschiedlichen Polygonen abhängig von der Anzahl der Punkte.],
	image("../data/polygon.svg"),
) <implementierung_polygon>

Die ausgewählte Eigenschaft wird durch das Einfärbung der Punkte angezeigt. Dabei kann die ausgewählte Eigenschaft geändert werden, ohne die anderen Informationen über die Punkte neu zu laden. Dafür wird die Eigenschaften separat als Wert zwischen $0$ und $n$ gespeichert und mit einer Farbpalette in einen Farbverlauf umgewandelt. $n$ kann dabei maximal $2^32-1$ sein, weil $32$ Bit für das Speichern der Eigenschaften verwendet werden. Mit $n$ und einer Farbpalette unabhängig von den Daten wird der Wert in die Farbe für den Punkt umgewandelt. Die verfügbaren Farbpaletten sind in @implementierung_farbpaletten zu sehen.

#figure(
	caption: [Verfügbare Farbpaletten.],
	grid(
		columns: 1,
		gutter: 1.5em,
		subfigure(caption: [Warm], rect(image("../images/grad_warm.png"), inset: 0pt)),
		subfigure(caption: [Kalt], rect(image("../images/grad_cold.png"), inset: 0pt)),
		subfigure(caption: [Turbo], rect(image("../images/grad_turbo.png"), inset: 0pt)),
	),
) <implementierung_farbpaletten>


=== Segmente


==== Auswahl

Um ein bestimmtes Segment auszuwählen, wird das momentan sichtbare Segment bei der Mausposition berechnet. Als Erstes werden die Koordinaten der Maus mit der Position und Orientierung der Kamera in einen dreidimensionalen Ursprung und Richtung umgewandelt. Der Ursprung und die Richtung bilden zusammen einen Strahl.

Im Octree wird vom Root-Knoten aus die Leaf-Knoten gesucht, welche den Strahl enthalten. Dafür wird bei einem Branch-Knoten die acht Kinderknoten betrachtet. Für jeden Kinderknoten wird überprüft, ob der Strahl den Bereich vom Knoten scheidet und gegebenenfalls wird der Abstand zur Kamera berechnet. Weil der Voxel zugehörig zum Knoten entlang der Achsen vom Koordinatensystem ausgerichtet ist, kann mit dem Algorithmus in @implementierung_ray_aabb überprüft werden, ob der Strahl den Voxel berührt @ray_aabb. Zuerst wird für jede Achse der Bereich bestimmt, für den der Strahl im Quadrat liegen kann. Die Schnittmenge ist die Überschneidung von den Bereichen für alle Achsen.

#figure(
	caption: [
		Schnittmenge von Strahl und Quadrat in 2D.
	],
	grid(
		columns: 1 * 2,
		subfigure(caption: [Bereich für jede Achse bestimmen], cetz.canvas(length: 0.5cm, {
			import cetz.draw: *

			for i in range(1, 11) {
				let x = -2.0 + i * 1.0
				let y = -0.5 + i * 0.5
				line((x, -0.5), (x, y), stroke: silver)
				line((-2.0, y), (x, y), stroke: silver)
			}

			rect((0, 0), (4, 4), stroke: 2pt)

			line((-2.0, -0.5), (8, 4.5), mark: (end: ">", fill: black), stroke: 2pt)

			line((-2.0, -0.5), (8.5, -0.5), mark: (end: ">", fill: black))
			line((-2.0, -0.5), (-2.0, 5.0), mark: (end: ">", fill: black))

			line((-0.0, -0.5), (-0.0, 0))
			content((0.0, -0.5), $x_0=2$, anchor: "north", padding: 5pt)
			line((4.0, -0.5), (4.0, 0))
			content((4.0, -0.5), $x_1=6$, anchor: "north", padding: 5pt)

			line((-2.0, 0.0), (-0.0, 0))
			content((-2.0, -0.0), $y_0=1$, anchor: "east", padding: 5pt)
			line((-2.0, 4.0), (0.0, 4.0))
			content((-2.0, 4.0), $y_1=9$, anchor: "east", padding: 5pt)
		})),
		subfigure(caption: [Bereiche kombinieren], cetz.canvas(length: 0.5cm, {
			import cetz.draw: *

			line((0, 0), (0, -3.5), stroke: white)
			rect((2, 1), (6, -2), stroke: none, fill: gray)

			line((0.0, 0.0), (10.0, 0.0))
			content((0.0, 0.0), $X$, anchor: "east", padding: 5pt)
			line((0.0, -1.0), (10.0, -1.0))
			content((0.0, -1.0), $Y$, anchor: "east", padding: 5pt)
			line((0.0, 1.0), (0.0, -2.0))
			content((0.0, 1.0), $0$, anchor: "south", padding: 5pt)
			line((10.0, 1.0), (10.0, -2.0))
			content((10.0, 1.0), $10$, anchor: "south", padding: 5pt)

			line((2, 0), (6, 0), stroke: 5pt)
			line((1, -1), (9, -1), stroke: 5pt)

			line((2.0, 1.0), (2.0, -2.0))
			content((2.0, 1.0), $s_0 = 2$, anchor: "south", padding: 5pt)
			line((6.0, 1.0), (6.0, -2.0))
			content((6.0, 1.0), $s_1 = 6$, anchor: "south", padding: 5pt)
		})),
	),
) <implementierung_ray_aabb>

Nachdem alle Kinderknoten gefunden wurden, die den Strahl enthalten, werden diese nach Abstand zur Kamera sortiert. Die weitere Suche wird zuerst für die näheren Knoten durchgeführt.

Für einen Leaf-Knoten wird der Punkt gesucht, welcher zuerst vom Strahl berührt wird. Dafür werden alle Punkte im Knoten betrachtet. Für jeden Punkt wird zuerst die Distanz vom Strahl bestimmt. Wenn die Distanz kleiner als der Radius vom Punkt ist, wird der Abstand zum Ursprung vom Strahl berechnet. Der Punkt mit dem kleinsten Abstand zum Ursprung ist der ausgewählte Punkt. Wenn kein Punkt gefunden wird, wird der nächste Knoten entlang des Strahls betrachtet.

Weil die Knoten nach Distanz sortiert betrachtet werden, kann die Suche abgebrochen werden, sobald ein Punkt gefunden wurde. Alle weiteren Knoten sind weiter entfernt, wodurch die enthaltenen Punkte nicht näher zum Ursprung vom Strahl liegen können.


==== Visualisierung

Im Octree kann zu den Punkten in einem Leaf-Knoten mehrere Segmente gehören. Um die Segmente einzeln anzuzeigen, wird jedes Segment zusätzlich separat abgespeichert. Sobald ein Segment ausgewählt wurde, wird dieses geladen und anstatt des Octrees angezeigt. Dabei werden alle Punkte des Segments ohne vereinfachte Detailstufen verwendet.

Die momentan sichtbaren Knoten vom Octree bleiben dabei geladen, um einen schnellen Wechsel zurück zur vollständigen Punktwolke zu ermöglichen.


==== Exportieren

Die Segmente können im Stanford Polygon Format (PLY) exportiert werden. Jeder Punkt wird dabei so transformiert, dass die Höhe entlang der z-Achse mit $0$ für den tiefsten Punkt gespeichert wird. Die horizontale Position der Punkte wird entlang der x- und y-Achse so verschoben, dass die Ausdehnung vom Segment in der positiven und negativen Richtung gleich ist.


=== Detailstufen

Beim Anzeigen vom Octree wird vom Root-Knoten aus zuerst geprüft, ob der momentane Knoten von der Kamera aus sichtbar ist. Wenn ein Knoten nicht sichtbar ist, so wird dieser nicht geladen und angezeigt. In @implementierung_culling ist ein Beispiel für das Filtern bei unterschiedlichen Detailstufen gegeben. Weil nur ein Teil vom Knoten von der Kamera aus sichtbar sein muss, können bei größeren Knoten der Großteil der Punkte außerhalb der Kamera liegen und werden trotzdem angezeigt.

#figure(
	caption: [Sichtbare Knoten für unterschiedliche Detailstufen.],
	grid(
		columns: 1 * 2,
		column-gutter: 3em,
		row-gutter: 1em,
		box(image("../images/culling_0.png"), stroke: 1pt),
		box(image("../images/culling_1.png"), stroke: 1pt),
		box(image("../images/culling_2.png"), stroke: 1pt),
		box(image("../images/culling_3.png"), stroke: 1pt),
		box(image("../images/culling_4.png"), stroke: 1pt),
		box(image("../images/culling_5.png"), stroke: 1pt),
	),
) <implementierung_culling>

Die Auswahl der Detailstufen kann dabei geändert werden. Im Normalfall wird die gewünschte Detailstufe abhängig vom Abstand zur Kamera ausgewählt. Dadurch werden in der Nähe der Kamera genauere Detailstufen oder die originalen Punkte angezeigt und weit von der Kamera entfernt werden die Detailstufen immer weiter vereinfacht. Eine andere Option ist es, die gleiche Detailstufe für alle Knoten zu verwenden.
