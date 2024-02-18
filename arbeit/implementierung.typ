#import "setup.typ": *


= Implementierung <implementierung>


== Technik

Das Projekt ist unter #link("https://github.com/antonWetzel/treee") verfügbar. Als Programmiersprache wird Rust und als Grafikkartenschnittstelle WebGPU verwendet. Rust ist eine performante Programmiersprache mit einfacher Integration für WebGPU. WebGPU bildet eine Abstraktionsebene über der nativen Grafikkartenschnittstelle, dadurch ist die Implementierung unabhängig vom Betriebssystem. Alle verwendeten Bibliotheken sind in @implementierung_bilbiotheken gelistet.

#figure(
	caption: [Benutzte Bibliotheken],
	table(
		columns: (auto, auto, 1fr),
		align: (x, y) => if y == 0 { center } else { (left, right, left).at(x) },
		[*Name*],            [*Version*], [*Funktionalität*],
		`pollster`,          `0.3`,       [Auf asynchrone Ergebnisse warten],
		`rfd`,               `0.13`,      [Dialogfenster zum Öffnen und Speichern von Dateien],
		`crossbeam`,         `0.8`,       [Synchronisierung zwischen Threads],
		`log`,               `0.4`,       [Logs erzeugen],
		`simple_logger`,     `4.3`,       [Wiedergabe von Logs],
		`image`,             `0.24`,      [Laden und Speichern von Bildern],
		`wgpu`,              `0.19`,      [WebGPU Implementierung],
		`winit`,             `0.29`,      [Fenstermanagement],
		`bytemuck`,          `1.14`,      [Konversation von Daten zu Bytes],
		`serde`,             `1.0`,       [Serialisierung von Datentypen],
		`bincode`,           `1.3.3`,     [Serialisierung als Binary],
		`serde_json`,        `1.0`,   [Serialisierung als JSON],
		`rand`,              `0.8`,       [Generierung von Zufallszahlen],
		`num_cpus`,          `1.15`,      [Prozessoranzahl bestimmen],
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
	),
) <implementierung_bilbiotheken>

Als Datensätze werden Dateien im LASzip-Format verwendet. Dieses Format wird häufig für Punktwolken verwendet. Weitere Formate können einfach eingebunden werden, solange eine Rust-Bibliothek existiert, welche das Format einlesen kann.


== Benutzung


=== Installation

Für den Import und die Visualisierung wird das kompilierte Programm benötigt. Dieses kann mit dem Quelltext selber kompiliert werden oder bereits kompilierte Versionen können von #todo-inline[GitHub-Release] heruntergeladen werden. Die Schritte zum selber kompilieren sind im #link("https://github.com/antonWetzel/treee?tab=readme-ov-file#treee", [Readme])#footnote(`https://github.com/antonWetzel/treee?tab=readme-ov-file#treee`) verfügbar.

=== Ausführen

In @implementierung_befehle sind die die Kommandos gelistet, um den Importer und die Visualisierung zu starten. Für den Import können weitere Optionen angegeben werden, um den Ablauf an den Datensatz anzupassen.

#figure(
	table(
		align: (x, y) => if y == 0 { center } else { left},
		columns: (auto, 1fr),
		[*Kommando*], [*Funktion*],
		`treee importer`, [Importer starten],
		`treee help importer`, [Verfügbare Optionen für den Importer anzeigen],
		`treee viewer`, [Visualisierung starten],
	)
) <implementierung_befehle>

=== Import

Für den Import wird der Datensatz und der Ordner zum Speichern der Ergebnisse benötigt. Beide können über die Befehlszeile angegeben werden oder über ein Dialogfenster ausgewählt werden. Alle weiteren Optione sind in @implementierung_import_optionen gelistet.

#figure(
	table(
		align: (x, y) => if y == 0 { top + center } else { top + (left, right, left).at(x)},
		columns: (auto,  auto, 1fr),
		[*Flag*], [*Standartwert*], [*Funktion*],
		`--max-threads`, [unbegrenzt], [Maximal Anzahl an parallel benutzen Threads],
		`--min-segment-size`, $100$, [Mindestanzahl von Punkten für ein Segment],
		`--segmenting-slice-width`, $1.0$, [Breite der horizontalen Scheiben für die Segmentierung in Meter],
		`--segmenting-max-distance`, $1.0$, [Mindestabstand zwischen Bereichen in Meter],
		`--neighbors-count`, $31$, [Maximale Anzahl der Punkte in der Nachbarschaft von einem Punkt],
		`--neighbors-max-distance`, $1.0$, [Maximale Distanz vom Punkt zu den Punkten in der Nachbarschaft],
		`--lod-size-scale`, $0.95$, [Skalierungfaktor für die Fläche der kombinierten Punkte],
	)
) <implementierung_import_optionen>

=== Visualisierung

Um eine Punktewolke zu öffnet wrid die `project.epc` Datei geladen In der Datei ist die Struktur vom Octree und  Informationen über die Segmente enthalten. Die Punktdaten werden noch nicht geladen.

Je nach Position der Kamera werden die benötigten Punkte geladen, welche momentan sichtbar sind. Dadurch können auch Punktwolken angezeigt werden, die mehr Punkte enthalten als gleichzeitig interaktiv anzeigbar. Auch bei den Segmenten wird nur das Segment geladen, welches ausgewählt wurde.

Mit dem Benutzerinterface kann die Visualisierung angepasst werden. Die Optionen sind in @implementierung_ui erklärt.

#figure(
	caption: [Benutzerinterface mit allen Optionen. ],
	grid(
		gutter: 3em,
		columns: 1 * (1fr, 2fr),
		rect(image("../images/ui.png"), radius: 4pt, inset: 2pt, stroke: rgb(27, 27, 27) + 4pt),
		align(left)[
			- *Load Project*
				- Die geladene Punktwolke ändern
			- *Property*
				- Die angezeigte Eigenschaft ändern
			- *Segment*
				- Informationen über das ausgewählte Segment
				- Triangulation starten und anzeigen
				- Punkte speichern
			- *Visual*
				- Punktegröße ändern
				- Punkte basierend auf der ausgewählten Eigenschaft filtern
				- Farbpalette und Hintergrundfarbe ändern
				- Screenshot speichern
				- Knoten der momentanen Detailstufen anzeigen
			- *Eye Dome*
				- Stärke und Farbe vom Eye-Dome-Lighting ändern
			- *Level of Detail*
				- Auswahl und Qualität der Detailstufen anpassen
			- *Camera*
				- Steuerung der Kamera ändern
				- Kameraposition speichern oder wiederherstellen

		],
	),
) <implementierung_ui>


== Import

Um einen Datensatz zu analysieren, muss dieser zuerst importiert werden, bevor er von der Visualisierung angezeigt werden kann. Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird der Berechnungsaufwand für eine Phase so weit wie möglich parallelisiert. Die Phasen sind:

+ Daten laden
+ Segmente bestimmen
+ Segmente analysieren und die Ergebnisse speichern und zum Octree hinzufügen
+ Detailstufen bestimmten und Octree speichern

Der zugehörige Datenfluss ist in @überblick_datenfluss zu sehen. Nach der ersten Phase sind die Segmente bekannt, nach der zweiten Phase analysiert und zum Octree hinzugefügt. Die Stuktur von der Punktwolke ist bereits bekannt. Nach der dritten Phase sind auch die Detailstufen vom Octree erstellt.

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

		rect((10, 1), (14, 2), name: "punktwolke")
		content("punktwolke", [Punktwolke])
		line("seg0.east", "punktwolke.west")
		line("seg1.east", "punktwolke.west")
		line("seg2.east", "punktwolke.west")
		line("octree.south", "punktwolke.north")
	}),
) <überblick_datenfluss>


=== Parallelisierung

Die Punktdaten werden in LASzip-Dateien zu Blöcken zusammengefasst. Jeder Block wird separat komprimiert, wodurch mehrere Blöcke auch parallel dekomprimiert werden können. Ein weiterer Thread sammelt die dekomprimierten Blöcke für die Segmentierung.

Für die Segmentierung wird über die einzelnen horizontalen Scheiben parallelisiert. Der genaue Ablauf ist in @implementierung_segment_parallel erklärt. Die Segmenter werden wieder von einem weiteren Thread gesammelt.

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
			+ Zusammenhängenden Bereiche von den Punkten bestimmen
			+ Mit den Bereichen und den Koordinaten der vorherigen Scheibe die Koordinaten der Bäume berechnen
			+ Jeder Punkte zur nächsten Koordinate zugeordnet

			Dabei wird für die zweite Stufe die Koordinaten aus der vorherigen Scheibe benötigt.

			In der Grafik ist der Arbeitsaufwand abgebildet. Von oben nach unten sind die Scheiben und von links nach rechts die Zeit abgebildet. Die erste Stufe ist in Blau, das Warten auf die vorherige Scheibe in Rot und die dritte Stufe in Orange. Der Berechnungsaufwand der zweiten Stufe ist sehr kurz, wodurch diese nicht in der Grafik sichtbar ist.

			Die Berechnung wurde mit sieben Threads durchgeführt, wodurch bis zu sieben Scheiben in parallel verarbeitet werden können. Durch die Datenabhängigkeit kann aber die zweite Stufe erst gestartet werden, wenn von der vorherigen Scheibe die zweite Stufe beendet ist. Wenn die erste Stufe länger dauert, müssen deshalb andere Threads warten.
		]
	),
) <implementierung_segment_parallel>

Die Analyse der Segmente und die Berechnung der Detailstufen sind trivial parallelisierbar. Die Analyse der Segmente wird für mehrere Segmente parallel durchgeführt, weil keine Abhängigkeiten zwischen den Daten existieren. Bei den Detailstufen können alle Kinderknoten parallel verarbeitet werden.


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


== Segmentierung


=== Auswahl

Um ein bestimmtes Segment auszuwählen, wird das momentan sichtbare Segment bei der Mausposition berechnet. Als Erstes werden die Koordinaten der Maus mit der Kamera in dreidimensionalen Position und Richtung umgewandelt. Die Position und Richtung bilden zusammen einen Strahl.

Im Octree wird vom Root-Knoten aus die Leaf-Knoten gefunden, welche den Strahl enthalten. Dafür wird rekursive bei einem Branch-Knoten die Kinderknoten gesucht, die den Strahl enthalten. Weil der Voxel zugehörig zum Knoten entlang der Achsen vom Koordinatensystem ausgerichtet ist, kann leicht überprüft werden, ob der Strahl den Voxel berührt. @ray_aabb

#todo[Bild Ray-AABB Schnitt]

Die Test kann so angepasst werden, das gegebenfalls der Abstand vom Anfang vom Strahl zum ersten Schnittpunkt bestimmt wird. Für einen Branch-Knoten werden die Kinderknoten nach Abstand aufsteigend überprüft.

Für einen Leaf-Knoten wird der Punkte gesucht, welcher zuerst vom Strahl berührt wird. Dafür wird zuerst die Distanz vom Strahl zum Punkt bestimmt. Wenn die Distanz kleiner als der Radius vom Punkt ist, wird der Abstand zum Ursprung vom Strahl berechnet. Der Punkt mit dem kleinsten Abstand ist der ausgwählte Punkt.

#todo[Bild Abstand Ray-Punkt]

Weil die Knoten nach Distanz sortiert betrachtet werden, kann die Suche abgebrochen werden, sobald ein Punkt gefunden wurde. Alle weiteren Knoten sind weiter entfernt, wodurch die enthaltenen Punkt nicht näher zum Urprung vom Strahl liegen können.


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
