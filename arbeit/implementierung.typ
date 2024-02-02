#import "setup.typ": *


= Implementierung <implementierung>


== Technik

Das Projekt ist unter #link("https://github.com/antonWetzel/treee") verfügbar. Als Programmiersprache wird Rust und als Grafikkartenschnittstelle WebGPU verwendet. Rust ist eine performante Programmiersprache mit einfacher Integration für WebGPU. WebGPU bildet eine Abstraktionsebene über der nativen Grafikkartenschnittstelle, dadurch ist die Implementierung unabhängig vom Betriebssystem. Alle verwendeten Bibliotheken sind in @implementierung_bilbiotheken gelistet.

Als Eingabeformat werden Dateien im LASzip-Format verwendet. Dieses wird häufig für Punktwolken verwendet. Weiter Formate können einfach eingebunden werden, solange eine Rust-Bibliothek existiert, welche das Format einlesen kann.

#figure(
	caption: [Benutzte Bibliotheken],
	table(
		columns: 3,
		align: (x, y) => if y == 0 { center } else { (left, right, left).at(x) },
		[*Name*],        [*Version*], [*Funktionalität*],
		`pollster`,      `0.3`,       [Auf asynchrone Ergebnisse warten],
		`rfd`,           `0.13`,      [Dialogfenster zum Öffnen und Speichern von Dateien],
		`crossbeam`,     `0.8`,       [Synchronisierung zwischen Threads],
		`log`,           `0.4`,       [Logs erzeugen],
		`simple_logger`, `4.3`,       [Wiedergabe von Logs],
		`image`,         `0.24`,      [Laden und Speichern von Bildern],
		`wgpu`,          `0.19`,      [WebGPU Implementierung],
		`winit`,         `0.29`,      [Fenstermanagement],
		`bytemuck`,      `1.14`,      [Konversation von Daten zu Bytes],
		`serde`,         `1.0`,       [Serialisierung von Datentypen],
		`bincode`,       `1.3.3`,     [Serialisierung als Binary],
		`serde_json`,    `1.0.113`,   [Serialisierung als JSON],
		`rand`,          `0.8`,       [Generierung von Zufallszahlen],
		`num_cpus`,      `1.15`,      [Prozessoranzahl bestimmen],
		`las`,           `0.8`,       [Einlesen von LAS und LASzip Dateien],
		`thiserror`,     `1.0`,       [Fehlermanagement],
		`tempfile`,      `3.8.1`,     [Temporäre Dateien erstellen],
		`rayon`,         `1.8.0`,     [Multithreading],
		`termsize`,      `0.1`,       [Größe vom Terminal bestimmen],
		`egui`,          `todo`,      [Benutzerinterface],
		`egui-winit`,    `todo`,      [Systemereignisse zum Interface weiterleiten],
		`egui-wgpu`,     `todo`,      [Interface anzeigen],
		`clap`,          `4.4`,       [Kommandozeilenargumente verarbeiten],
		`voronator`,     `0.2.1`,     [Voronoi-Diagramm bestimmen],
	),
) <implementierung_bilbiotheken>


== Ablauf

Um einen Datensatz zu analysieren, muss dieser zuerst importiert werden, bevor er von der Visualisierung angezeigt werden kann.


=== Import

Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird der Berechnungsaufwand für eine Phase so weit wie möglich parallelisiert. Die Phasen sind:

+ Daten laden
+ Segmente bestimmen
+ Segmente analysieren und die Ergebnisse speichern und zum Octree hinzufügen
+ Detailstufen bestimmten und Octree speichern

Der zugehörige Datenfluss ist in @überblick_datenfluss zu sehen. Nach der ersten Phase sind die Segmente bekannt, nach der zweiten Phase analysiert und zum Octree hinzugefügt und nach der dritten Phase ist die Projektdatei und die Detailstufen vom Octree erstellt.

#figure(
	caption: [Datenfluss für den Import.],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *

		set-style(mark: (end: ">", fill: black))
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

		rect((10, 1), (14, 2), name: "projekt")
		content("projekt", [Projekt])
		line("seg0.east", "projekt.west")
		line("seg1.east", "projekt.west")
		line("seg2.east", "projekt.west")
		line("octree.south", "projekt.north")
	}),
) <überblick_datenfluss>

#todo[Messwerte wie lange die Phasen für die einzelen Punkte]

#todo[Messwerte wie groß die Datenmengen]

#let data = {
	let data = json("../data/br01.json")
	let mapped = ()
	for (name, value) in data {
		if name == "times" {
			for (name, value) in value {
				mapped.push((name, value))
			}
		} else {
			mapped.push((name, value))
		}
	}
	mapped
}

#cetz.canvas({
	import cetz.draw: *
	cetz.chart.barchart(
		size: (10, 4),
		mode: "stacked",
		value-key: (0, 0),
		(("test", 1), ("test", 2)),
	)
})


=== Visualisierung

Bei der Visualisierung wird ein Projekt geöffnet. Das Projekt besteht dabei aus der Struktur vom Octree und Informationen über die Segmente. Die Daten für die einzelnen Punkte werden zuerst nicht geladen.

Je nach Position der Kamera werden die benötigten Punkte geladen, welche momentan sichtbar sind. Dadurch können auch Punktwolken angezeigt werden, die mehr Punkte enthalten als gleichzeitig interaktiv anzeigbar. Auch bei den Segmenten wird nur das Segment geladen, welches ausgewählt wurde.

#todo[Messwertel laden Projekt?]


== Punkte

Die benötigten Daten für einen Punkt sind das Polygon als Basis, Position, Normale, Größe und ausgewählte Eigenschaft. Das Polygon ist gleich für alle Punkte und muss deshalb nur einmal zur Grafikkarte übertragen werden und wird für alle Punkte wiederverwendet.

Die ausgewählte Eigenschaft wird durch Einfärbung der Punkte angezeigt. Dabei kann die ausgewählte Eigenschaft geändert werden, ohne die anderen Informationen über die Punkte neu zu laden. Die Eigenschaften sind separat als Wert zwischen $0$ und $2^(32)-1$ gespeichert und werden mit einer Farbpalette in einen Farbverlauf umgewandelt. Dabei kann die Farbpalette umgewandelt werden.


=== Kreis

Die Grafikpipeline bestimmt alle Pixel, welche im transformierten Polygon liegen. Für jedes Pixel kann entschieden werden, ob dieser im Ergebnis gespeichert wird. Dafür wird bei den Eckpunkten die untransformierten Koordinaten abgespeichert, dass diese später verfügbar sind. Für jedes Pixel wird von der Pipeline die interpolierten Koordinaten berechnet. Nur wenn der Betrag der interpolierten Koordinaten kleiner als eins ist, wird der Pixel im Ergebnis abgespeichert.

#todo[Performancevergleich Dreieck und Quadrat]


== Segmente


=== Auswahl

Um ein bestimmtes Segment auszuwählen, wird das momentan sichtbare Segment bei der Mausposition berechnet. Als Erstes werden die Koordinaten der Maus mit der Kamera in dreidimensionalen Position und Richtung umgewandelt. Die Position und Richtung bilden zusammen einen Strahl.

Im Octree wird vom Root-Knoten aus die Leaf-Knoten gefunden, welche den Strahl enthalten. Dabei werden die Knoten näher an der Position der Kamera bevorzugt. Für den Leaf-Knoten sind die Segmente bekannt, welche Punkte in diesem Knoten haben. Für jedes mögliche Segment wird für jeden Punkt überprüft, ob er entlang des Strahls liegt.

Sobald ein Punkt gefunden ist, müssen nur noch Knoten überprüft werden, die näher an der Kamera liegen, weil alle Punkte in weiter entfernten Knoten weiter als der momentan beste gefundene Punkt liegen.

#todo[Messung Laufzeit]


=== Anzeige

Im Octree kann zu den Punkten in einem Leaf-Knoten mehrere Segmente gehören. Um die Segmente einzeln anzuzeigen, wird jedes Segment separat abgespeichert. Sobald ein einzelnes Segment ausgewählt wurde, wird dieses geladen und anstatt des Octrees angezeigt. Dabei werden alle Punkte des Segments ohne vereinfachte Detailstufen verwendet. Beispiele sind in @segment_example gegeben.

Die momentan geladenen Knoten vom Octree bleiben dabei geladen, um einen schnellen Wechsel zu ermöglichen.


== Eye-Dome-Lighting

#todo[Messung (viele und wenige Punkte gleich weil Screen space effect)]


== Detailstufen

Beim Anzeigen wird vom Root-Knoten aus zuerst geprüft, ob der momentane Knoten von der Kamera aus sichtbar ist. Für die Knoten entschieden, ob die zugehörige vereinfachte Punktwolke gerendert werden soll oder rekursiv die Kinderknoten betrachtet werden sollen.

#todo[Auswahl der Detailstufen]


=== Abstand zur Kamera


==== Normal

- Schwellwert
- Abstand zur kleinsten Kugel, die den Voxel inkludiert
- Abstand mit Größe des Voxels dividieren
- wenn Abstand größer als Schwellwert
	- Knoten rendern
- sonst
	- Kinderknoten überprüfen


==== Auto

- wie Abstand zur Kamera
- messen, wie lang rendern dauert
- Dauer kleiner als Mindestdauer
	- Schwellwert erhöhen
- Dauer kleiner als die Maximaldauer
	- Schwellwert verringern


==== Gleichmäßig

- gleich für alle Knoten
- auswahl der Stufe


=== Filtern mit dem Kamerafrustrum

#todo[Frustrum-Culling]

#figure(
	caption: [Unterschiedliche Detailstufen mit den unterschiedlichen sichtbaren Knoten.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		box(image("../images/culling_0.png"), stroke: 1pt),
		box(image("../images/culling_1.png"), stroke: 1pt),
		box(image("../images/culling_2.png"), stroke: 1pt),
		box(image("../images/culling_3.png"), stroke: 1pt),
		box(image("../images/culling_4.png"), stroke: 1pt),
		box(image("../images/culling_5.png"), stroke: 1pt),
	),
)

#todo[
	Messwerte
	- detailstufen ja nein bild und zeit
	- culling ja nein bild(?) und zeit
]
