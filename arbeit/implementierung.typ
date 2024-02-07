#import "setup.typ": *


= Implementierung <implementierung>


== Technik

Das Projekt ist unter #link("https://github.com/antonWetzel/treee") verfügbar. Als Programmiersprache wird Rust und als Grafikkartenschnittstelle WebGPU verwendet. Rust ist eine performante Programmiersprache mit einfacher Integration für WebGPU. WebGPU bildet eine Abstraktionsebene über der nativen Grafikkartenschnittstelle, dadurch ist die Implementierung unabhängig vom Betriebssystem. Alle verwendeten Bibliotheken sind in @implementierung_bilbiotheken gelistet.

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
		`egui`,          `0.26`,      [Benutzerinterface],
		`egui-winit`,    `0.26`,      [Systemereignisse zum Interface weiterleiten],
		`egui-wgpu`,     `0.26`,      [Interface rendern],
		`clap`,          `4.4`,       [Kommandozeilenargumente verarbeiten],
		`voronator`,     `0.2.1`,     [Voronoi-Diagramm bestimmen],
		`cfg-if`,        `1.0.0`,     [Konditionales Kompilieren von Quelltext],
	),
) <implementierung_bilbiotheken>

Als Eingabeformat werden Dateien im LASzip-Format verwendet. Dieses wird häufig für Punktwolken verwendet. Weiter Formate können einfach eingebunden werden, solange eine Rust-Bibliothek existiert, welche das Format einlesen kann.

#todo[Benutzung aus dem Readme hier?]


== Ablauf


=== Installation

Für den Import und die Visualisierung wird das kompilierte Programm benötigt. Dieses kann mit dem Quelltext selber kompiliert werden oder bereits kompilierte Versionen können von #todo-inline[GitHub-Release] heruntergeladen werden. Die Schritte zum selber kompilieren sind im #link("https://github.com/antonWetzel/treee?tab=readme-ov-file#treee", [Readme])#footnote(`https://github.com/antonWetzel/treee?tab=readme-ov-file#treee`) verfügbar.


=== Benutzung

#todo[Benutzung aus dem Readme]


=== Import

Um einen Datensatz zu analysieren, muss dieser zuerst importiert werden, bevor er von der Visualisierung angezeigt werden kann. Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird der Berechnungsaufwand für eine Phase so weit wie möglich parallelisiert. Die Phasen sind:

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


=== Visualisierung

Bei der Visualisierung wird ein Projekt geöffnet. Das Projekt besteht dabei aus der Struktur vom Octree und Informationen über die Segmente. Die Daten für die einzelnen Punkte werden zuerst nicht geladen. In @implementierung_ui ist das Benutzerinterface erklärt.

Je nach Position der Kamera werden die benötigten Punkte geladen, welche momentan sichtbar sind. Dadurch können auch Punktwolken angezeigt werden, die mehr Punkte enthalten als gleichzeitig interaktiv anzeigbar. Auch bei den Segmenten wird nur das Segment geladen, welches ausgewählt wurde.

#figure(
	caption: [Benutzerinterface mit allen Optionen. ],
	grid(
		gutter: 3em,
		columns: 1 * (1fr, 2fr),
		rect(image("../images/ui.png"), radius: 4pt, inset: 2pt, stroke: rgb(27, 27, 27) + 4pt),
		align(left)[
			- *Load Project*
				- Projekt
			- *Property*
				- Eigenschaft zum Anzeigen ändern
			- *Segment*
				- Informationen über das ausgewählte Segment
				- Triangulation starten und anzeigen
				- Punkte speichern
			- *Visual*
				- Punktegröße ändern
				- Punkte basierend auf der ausgewählten Eigenschaft filtern
				- Farbpalette und Hintergrund ändern
				- Screenshot speichern
				- Knoten für Detailstufen anzeigen
			- *Eye Dome*
				- Farbe und Stärke vom Eye-Dome-Lighting ändern
			- *Level of Detail*
				- Algorithmus und Qualität der Detailstufen anpassen
			- *Camera*
				- Bewegung der Kamera ändern
				- Kameraposition speichern

		],
	),
) <implementierung_ui>


== Punkte

Die benötigten Daten für einen Punkt sind das Polygon als Basis, Position, Normale, Größe und ausgewählte Eigenschaft. Das Polygon ist gleich für alle Punkte und muss deshalb nur einmal zur Grafikkarte übertragen werden und wird für alle Punkte wiederverwendet.

Für die Grafikpipeline wird das Polygon in Dreiecke zerlegt. In @implementierung_polygon_zerlegung sind die getesteten Varianten gegeben. Die Dreiecke werden dann projiziert und es werden alle Pixel bestimmt, welche in den Dreiecken liegen. Für jedes Pixel kann entschieden werden, ob dieser im Ergebnis gespeichert wird. Dafür wird bei den Eckpunkten die untransformierten Koordinaten abgespeichert, dass diese später verfügbar sind. Für jedes Pixel wird von der Pipeline die interpolierten Koordinaten berechnet. Nur wenn der Betrag der interpolierten Koordinaten kleiner als eins ist, wird der Pixel im Ergebnis abgespeichert.

#figure(
	caption: [Zerlegung von unterschiedlichen Polygonen in Dreiecke.],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *

		let x = calc.tan(60deg);
		circle((0, 0), radius: 1, stroke: none, fill: gray)
		line((-x, -1), (x, -1), (0, 2), close: true)

		translate(x: 3.0)

		circle((0, 0), radius: 1, stroke: none, fill: gray)
		line((-1, -1), (1, -1), (1, 1), (-1, 1), close: true)
		line((1, 1), (-1, -1))

		translate(x: 3.0)

		let x = calc.tan(22.5deg);
		circle((0, 0), radius: 1, stroke: none, fill: gray)
		line((x, -1), (-x, -1), (-1, -x), (-1, x), (-x, 1), (x, 1), (1, x), (1, -x), close: true)
		line((x, -1), (-1, -x), (1, -x), (-1, x), (1, x), (-x, 1))
	}),
) <implementierung_polygon_zerlegung>

In @implementierung_polygon sind die Renderzeiten für unterschiedliche Polygone als Basis gegeben. Die beste Option ist das Dreieck als Polygon. Für die Zerlegung vom Polygon mit $n$ Ecken in Dreiecke werden $n-2$ Dreiecke und somit $3n-6$ Ecken benötigt. Der benötigte Aufwand entsteht größtenteils durch die Ecken, wodurch das Quadrat circa doppelt und das Achteck sechsmal so lange zum Rendern benötigen.

#figure(
	caption: [Renderzeit bei unterschiedlichen Polygonen als Basis in Sekunden abhängig von der Anzahl der Punkte.],
	image("../data/polygon.svg"),
) <implementierung_polygon>

Die ausgewählte Eigenschaft wird durch Einfärbung der Punkte angezeigt. Dabei kann die ausgewählte Eigenschaft geändert werden, ohne die anderen Informationen über die Punkte neu zu laden. Die Eigenschaften sind separat als Wert zwischen $0$ und $2^(32)-1$ gespeichert und werden mit einer Farbpalette in einen Farbverlauf umgewandelt. Dabei kann die Farbpalette unabhängig von den Daten ausgewählt werden. Die verfügbaren Farbpaletten sind in @implementierung_farbpaletten zu sehen.

#figure(
	caption: [Verfügbare Farbpaletten.],
	grid(
		columns: 1,
		gutter: 0.5em,
		rect(image("../images/grad_warm.png"), inset: 0pt),
		rect(image("../images/grad_cold.png"), inset: 0pt),
		rect(image("../images/grad_turbo.png"), inset: 0pt),
	),
) <implementierung_farbpaletten>


== Segmente


=== Auswahl

Um ein bestimmtes Segment auszuwählen, wird das momentan sichtbare Segment bei der Mausposition berechnet. Als Erstes werden die Koordinaten der Maus mit der Kamera in dreidimensionalen Position und Richtung umgewandelt. Die Position und Richtung bilden zusammen einen Strahl.

Im Octree wird vom Root-Knoten aus die Leaf-Knoten gefunden, welche den Strahl enthalten. Dabei werden die Knoten näher an der Position der Kamera bevorzugt. Für den Leaf-Knoten sind die Segmente bekannt, welche Punkte in diesem Knoten haben. Für jedes mögliche Segment wird für jeden Punkt überprüft, ob er entlang des Strahls liegt.

Sobald ein Punkt gefunden ist, müssen nur noch Knoten überprüft werden, die näher an der Kamera liegen, weil alle Punkte in weiter entfernten Knoten weiter als der momentan beste gefundene Punkt liegen.


=== Visualisierung

Im Octree kann zu den Punkten in einem Leaf-Knoten mehrere Segmente gehören. Um die Segmente einzeln anzuzeigen, wird jedes Segment separat abgespeichert. Sobald ein einzelnes Segment ausgewählt wurde, wird dieses geladen und anstatt des Octrees angezeigt. Dabei werden alle Punkte des Segments ohne vereinfachte Detailstufen verwendet.

Die momentan geladenen Knoten vom Octree bleiben dabei geladen, um einen schnellen Wechsel zu ermöglichen.


=== Exportieren

#todo[Implementierung Segment export]

// == Eye-Dome-Lighting

// #todo[Messung (viele und wenige Punkte gleich weil Screen space effect)]


== Detailstufen

Beim Anzeigen wird vom Root-Knoten aus zuerst geprüft, ob der momentane Knoten von der Kamera aus sichtbar ist. In @implementierung_culling ist ein Beispiel für das Filtern bei unterschiedlichen Detailstufen gegeben.

#figure(
	caption: [Sichtbare Knoten für unterschiedliche Detailstufen. Ein Knoten wird gerendert, solange ein Teil vom Knoten im Kamerafrustrum enthalten ist.],
	grid(
		columns: 1 * 2,
		gutter: 1em,
		box(image("../images/culling_0.png"), stroke: 1pt),
		box(image("../images/culling_1.png"), stroke: 1pt),
		box(image("../images/culling_2.png"), stroke: 1pt),
		box(image("../images/culling_3.png"), stroke: 1pt),
		box(image("../images/culling_4.png"), stroke: 1pt),
		box(image("../images/culling_5.png"), stroke: 1pt),
	),
) <implementierung_culling>

Die Auswahl der Detailstufen kann dabei geändert werden. Im Normalfall wird die gewünschte Detailstufe abhängig vom Abstand zur Kamera ausgewählt. Dadurch wird in der Nähe der Kamera genauere Detailstufen oder die unvereinfachten Punkte angezeigt und weit von der Kamera entfernt immer weiter vereinfachte Versionen. Eine andere Option ist es, die gleiche Detailstufe für alle Knoten zu verwenden.
