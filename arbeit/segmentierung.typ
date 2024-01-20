#import "setup.typ": *


= Segmentierung in Bäume <seperierung_in_segmente>


== Ablauf

Die Punkte werden in gleichbreite parallele Scheiben entlang der Höhe unterteilt. Danach werden die Scheiben von Oben nach Unten einzeln verarbeitet, um die Segmente zu bestimmen. Dafür werden die Punkte in einer Scheibe zu Bereichen zusammengefasst. Für die Bereiche werden die zugehörigen Mittelpunkte bestimmt und jeder Punkte wird zum nächsten Mittelpunkt zugeordnet.


== Bereiche bestimmen

#let points = (
	(0, 1.9),
	(-0.5, 2.0),
	(-0.3, 2.3),
	(0.4, 2.5),
	(0.7, 2.1),
	(0.6, 1.8),
	(-0.1, 1.6),
	//
	(1.8, 1.0),
	(2.3, 1.1),
	(2.7, 1.4),
	(1.8, 0.8),
	(1.9, 0.4),
	(2.5, 0.5),
	//
	(-0.5, -0.9),
	(-1.2, -1.1),
	(-0.8, -1.3),
	(-1.1, -1.9),
	(-0.5, -1.8),
)

Für jede Scheibe werden konvexe zusammenhängende Bereiche bestimmt, dass die Punkte in unterschiedlichen Bereichen einen Mindestabstand voneinander entfernt sind. Dafür wird mit einer leeren Menge von Bereichen gestartet und jeder Punkt zu der Menge hinzugefügt. Wenn ein Punkt in einem Bereich ist, ändert der Punkt nicht den Bereich. Ist der Punkt näher als den Mindestabstand zu einem der Bereiche, so wird der Bereich erweitert. Ist der Punkt von allen bisherigen Bereichen entfernt, so wird ein neuer Bereich angefangen.

// #figure(
// 	caption: [Todo.],
// 	cetz.canvas(length: 1cm, {
// 		import cetz.draw: *

// 		line(
// 			points.at(1),
// 			points.at(2),
// 			points.at(3),
// 			points.at(4),
// 			points.at(5),
// 			points.at(6),
// 			close: true,
// 			fill: gray,
// 		)

// 		line(
// 			points.at(7),
// 			points.at(9),
// 			points.at(12),
// 			points.at(11),
// 			points.at(10),
// 			close: true,
// 			fill: gray,
// 		)

// 		line(
// 			points.at(13),
// 			points.at(14),
// 			points.at(16),
// 			points.at(17),
// 			close: true,
// 			fill: gray,
// 		)

// 		for p in points {
// 			circle(p, radius: 0.1, fill: black, stroke: none)
// 		}
// 	}),
// )
#figure(
	caption: [Beispiel für berechnete Segmente. Größere Bereiche gehören zu mehreren Bäumen.],
	box(clip: true, width: 100%, height: 30%, {
		rect(image("../images/segmente.svg", width: 500%), stroke: black, inset: 0pt)
	}),
)

Die Bereiche sind als Liste gespeichert, wobei für jeden Bereich die Eckpunkte als Liste gegeben sind. Die Eckpunkte sind dabei sortiert, dass für einen Eckpunkt der nächste Punkt entlang der Umrandung der nächste Punkt in der Liste ist. Für den letzten Punkt ist der erste Punkt in der Liste der nächste Punkt.

Um die Distanz von einem Punkt zu einem Bereich zu berechnen, wird der größte Abstand mit Vorzeichen vom Punkt zu allen Kanten berechnet. Für jede Kante mit den Eckpunkten $a = (a_x, a_y)$ und $b = (b_x, b_y)$ wird zuerst der Vektor $d = (d_x, d_y) = b - a$ berechnet. Der normalisierte Vektor $o = (d_y, -d_x) / (|d|)$ ist orthogonal zu $d$ und zeigt aus dem Bereich hinaus, solange $a$ im Uhrzeigersinn vor $b$ auf der Umrandung liegt. Für den Punkt $p$ kann nun der Abstand zur Kante mit dem Skalarprodukt $o dot (p - a)$ berechnet werden. Der Abstand ist dabei negative, wenn der Punkt im Bereich liegt.

#side-caption(amount: (2fr, 3fr), figure(
	caption: [Berechnung vom Abstand vom Punkt $p$ zur Kange zwischen $a$ und $b$.],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *

		line((-1, -1), (0, 0), (3, 0), (4, -1), close: true, stroke: black, fill: silver)
		line((0, 0), (3, 0), name: "edge", mark: (end: ">", fill: black))
		line((-1, -1), (0, 0))
		line((3, 0), (4, -1))

		content("edge.start", anchor: "north", $a$, padding: 0.15)

		circle((-1, -1), fill: black, stroke: none, radius: 0.1)
		circle((4, -1), fill: black, stroke: none, radius: 0.1)
		circle("edge.end", fill: black, stroke: none, radius: 0.1)
		content("edge.end", anchor: "north", $b$, padding: 0.15)

		content((1.5, 0), anchor: "north", $d$, padding: 0.15)

		line((0, 0), (0, 2), name: "out", mark: (end: ">", fill: black))
		content((0, 1), $o$, anchor: "east", padding: 0.1)

		line((0, 0), (2, 1.5), stroke: gray, mark: (end: ">", fill: gray))
		content((2, 1.5), anchor: "south", padding: 0.15, $p$)
		line((2, 0), (2, 1.5), stroke: gray)
		content((2, 0.75), anchor: "west", padding: 0.1, $o dot (p - a)$)
		circle((2, 1.5), fill: black, stroke: none, radius: 0.1)
		circle("edge.start", fill: black, stroke: none, radius: 0.1)
	}),
))

Um einen Punkt zu einem Bereich hinzuzufügen, werden alle Kanten entfernt, bei denen der Punkt auf der Seite außerhalb liegt, entfernt und zwei neue Kanten zum Punkt werden hinzugefügt. Dafür werden die beiden Eckpunkte gesucht, bei denen eine zugehörige Kante entfernt wird und die andere nicht. Um die Kanten zwischen den Punkten zu entfernt, werden alle Punkte zwischen den beiden Punkte entfernt und stattdessen der neue Punkt eingefügt, um die beiden neuen Kanten zu ergänzen.

#side-caption(amount: (2fr, 3fr), figure(
	caption: [Hinzufügen vom Punkt $p$ zum Bereich. Die Kanten in Rot werden entfernt und die Kanten in Grün werden hinzugefügt.],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *

		line((-2, 0), (5, 0), stroke: silver)
		line((-2, -1), (5, -1), stroke: silver)
		line((-2, -2), (3, 3), stroke: silver)
		line((5, -2), (0, 3), stroke: silver)

		line((-1, -1), (0, 0), (3, 0), (4, -1), close: true, stroke: none, fill: silver)

		line((0, 0), (3, 0), (4, -1), stroke: red)
		line((0, 0), (2, 1.5), (4, -1), stroke: green)
		line((0, 0), (-1, -1), (4, -1), stroke: black)

		circle((2, 1.5), fill: green, stroke: none, radius: 0.1)
		content((2, 1.5), anchor: "south", padding: 0.15, $p$)

		circle((-1, -1), fill: black, stroke: none, radius: 0.1)
		circle((4, -1), fill: black, stroke: none, radius: 0.1)
		circle((0, 0), fill: black, stroke: none, radius: 0.1)
		circle((3, 0), fill: red, stroke: none, radius: 0.1)

	}),
))

Nachdem alle Punkte zu den Bereichen hinzugefügt würden, können Bereiche so gewachsen sein, dass Bereiche sich überlappen. Um diese zu verbinden wird wiederholt überlappende Bereiche gesucht und alle Punkte von einem Bereich zum anderen hinzugefügt. Um zu überprüfen, ob Bereiche sich überlappen, wird für einen der Bereiche alle Kanten überprüft, ob der andere Bereich vollständig außerhalb der Kante liegt. Wenn alle Punkte vom anderen Bereich außerhalb der Kante liegen, trennt die Kante die Bereiche. Wenn keine trennende Kante existiert, so überlappen sich die Bereiche.


== Mittelpunkte bestimmen

Mit den Bereichen und den Mittelpunkten aus der vorherigen Scheibe werden die Mittelpunkte für die momentane Scheibe berechnet. Für die erste Scheibe wird die leere Menge als vorherigen Mittelpunkte verwendet. Für jeden Bereich werden dann die Mittelpunkte aus der vorherigen Scheibe gesucht, die im Bereich liegen.

Wenn keine Mittelpunkte in dem Bereich liegt, so fängt der Bereich ein neues Segment an. Als Mittelpunkt wird der geometrische Schwerpunkt vom Bereich verwendet.

#todo[Berechnung vom Schwerpunkt?]

Liegt genau ein vorheriger Mittelpunkt in Bereich, wird wieder der Schwerpunkt als neuer Mittelpunkt verwendet, aber der Mittelpunkt gehört zum gleichen Segment, zu dem der Mittelpunkt aus der vorherigen Scheibe gehört.

Wenn mehrere Mittelpunkte im Bereich liegen, so werden die Mittelpunkte mit den zugehörigen Segmenten für die momentane Scheibe übernommen.


== Punkte zuordnen

Mit den Mittelpunkten wird das Voronoi-Diagramm berechnet, welches den Raum in Bereiche unterteilt, dass alle Punkte in einem Bereich für einen Mittelpunkt am nächsten an diesem Mittelpunkt liegen. Für jeden Punkt wird nun der zugehörige Bereich im Voronoi-Diagramm bestimmt und der Punkt zum Segment von dem Mittelpunkt vom Bereich zugeordnet.

#figure(caption: [Berechnete Mittelpunkte für die Punkte mit zugehörigen Bereichen und Voronoi-Diagramm.], box(clip: true, width: 100%, height: 30%, {
	rect(image("../images/segmente_punkte.svg", width: 500%), stroke: black, inset: 0pt)
}))

#todo[Bild veraltet mit Zentrum von Bereichen.]


== Ergebnisse

#todo[Ergebnisse Segmentierung]
