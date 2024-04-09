#import "setup.typ": *


= Segmentierung von Waldgebieten <seperierung_in_segmente>


== Ablauf

Für die Segmentierung werden alle Punkte in gleich breite parallele Scheiben entlang der Höhe unterteilt. Danach werden die Scheiben von Oben nach Unten einzeln verarbeitet, um die Segmente zu bestimmen. Dafür werden die Punkte in einer Scheibe zu zusammenhängenden Bereichen zusammengefasst. Mit den Bereichen werden die Koordinaten der Bäume bestimmt, welche in der momentanen Scheibe existieren. Die Punkte in der Scheibe werden dann dem nächsten Baum zugeordnet.


== Bereiche bestimmen <segmentierung_bereiche_chapter>

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

Für jede Scheibe werden konvexe zusammenhängende Bereiche bestimmt, dass die Punkte in unterschiedlichen Bereichen einen Mindestabstand voneinander entfernt sind. Dafür wird mit einer leeren Menge von Bereichen gestartet und jeder Punkt zu der Menge hinzugefügt. Wenn ein Punkt vollständig in einem Bereich enthalten ist, wird der Bereich nicht erweitert. Ist der Punkt außerhalb, aber näher als den Mindestabstand zu einem der Bereiche, so wird der Bereich erweitert. Ist der Punkt von allen bisherigen Bereichen weiter entfernt, so wird ein neuer Bereich angefangen.

Dadurch entstehen Bereiche wie in @segmentierung_bereiche. Bei einer Baumspitze entsteht ein kleiner Bereich. Wenn mehrere Bäume sich berühren, werden die Bäume zu einem größeren Bereich zusammengefasst.

// BR06-ALS
#figure(
	caption: [Beispiel für berechnete Segmente für zwei aufeinanderfolgende Scheiben.],
	grid(
		columns: 1 * 2,
		gutter: 1em,
		subfigure(rect(image("../images/test_5-areas.svg"), inset: 0pt), caption: [Höhere Scheibe]),
		subfigure(rect(image("../images/test_6-areas.svg"), inset: 0pt), caption: [Tiefere Scheibe]),
	),
) <segmentierung_bereiche>

Bei der Berechnung sind alle momentanen Bereiche in einer Liste gespeichert. Ein Bereich ist dabei eine Liste von Eckpunkten. Die Eckpunkte sind dabei sortiert, dass für einen Eckpunkt der nächste Punkt entlang der Umrandung vom Bereich der nächste Punkt in der Liste ist. Für den letzten Punkt ist der erste Punkt in der Liste der nächste Eckpunkt.

Um einen Punkt zu einem Bereich hinzuzufügen wird wie in @segmentierung_add_point für jede Kante der Abstand zum Punkt bestimmt und Kanten mit positivem Abstand werden ausgetauscht.

#figure(
	caption: [Berechnung vom Abstand vom Punkt $p$ zur Kante zwischen $a$ und $b$.],
	grid(
		columns: 2,
		subfigure(
			caption: [Abstand berechnen],
			cetz.canvas(length: 1cm, {
				import cetz.draw: *
				set-style(stroke: black)

				line((-2, 0), (5, 0), stroke: white)
				line((-2, -1), (5, -1), stroke: white)
				line((-2, -2), (3, 3), stroke: white)
				line((5, -2), (0, 3), stroke: white)

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
		), subfigure(
			caption: [Punkt hinzufügen],
			cetz.canvas(length: 1cm, {
				import cetz.draw: *
				set-style(stroke: black)

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
		),
	),
) <segmentierung_add_point>

Um die Distanz von einem Punkt zu einem Bereich zu berechnen, wird der größte Abstand nach Außen vom Punkt zu allen Kanten berechnet. Für jede Kante mit den Eckpunkten $a = (a_x, a_y)$ und $b = (b_x, b_y)$ wird zuerst der Vektor $d = (d_x, d_y) = b - a$ berechnet. Der normalisierte Vektor $o =1 / (norm(d)) dot (d_y, -d_x)$ ist orthogonal zu $d$ und zeigt aus dem Bereich hinaus, solange $a$ im Uhrzeigersinn vor $b$ auf der Umrandung liegt. Für den Punkt $p$ kann nun der Abstand zur Kante mit dem Skalarprodukt $o dot (p - a)$ berechnet werden. Wenn der Punkte auf der Innenseite der Kante liegt, ist der Abstand negativ.

Um einen Punkt zu einem Bereich hinzuzufügen, werden alle Kanten entfernt, bei denen der Punkt außerhalb liegt, und zwei neue Kanten zum Punkt werden hinzugefügt. Dafür werden die Eckpunkte entfernt, bei denen der neue Punkt außerhalb der beiden angrenzenden Kanten liegt. An der Stelle, wo die Punkte entfernt wurden, wird stattdessen der neue Eckpunkt eingefügt.

// #figure(
// 	caption: [Hinzufügen vom Punkt $p$ zum Bereich. Die Kanten in Rot werden entfernt und die Kanten in Grün werden hinzugefügt.],

// ) <segmentierung_replace>

#let area_figure(centers) = {
	import cetz.draw: *
	set-style(stroke: black)

	let points = (
		(0.0, 0.0),
		(1.0, 0.0),
		(1.5, 0.6),
		(1.2, 0.8),
		(0.2, 0.8),
		(-0.1, 0.7),
		(-0.5, 0.5),
		(-0.5, 0.3),
		(-0.4, 0.1),
	)
	let center = (0.0, 0.0)
	let total_area = 0.0
	for i in range(1, points.len() - 1) {
		let a = points.at(0)
		let b = points.at(i)
		let c = points.at(i + 1)

		let c = ((a.at(0) + b.at(0) + c.at(0)) / 3.0, (a.at(1) + b.at(1) + c.at(1)) / 3.0)
		let area = (b.at(0) * c.at(1) - b.at(1) * c.at(0)) / 2.0
		if centers {
			circle(c, fill: gray, stroke: none, radius: 0.1cm)
		}

		total_area += area;
		center = (center.at(0) + c.at(0) * area, center.at(1) + c.at(1) * area)
	}
	let center = (center.at(0) / total_area, center.at(1) / total_area)

	for i in range(0, points.len() - 1) {
		line(points.at(i), points.at(i + 1))
	}
	line(points.last(), points.at(0))

	for i in range(2, points.len() - 1) {
		line(points.at(0), points.at(i), stroke: gray)
	}

	for p in points {
		circle(p, fill: black, stroke: none, radius: 0.1cm)
	}
	if centers {
		circle(center, fill: green, stroke: none, radius: 0.1cm)

		let fake_center = (0.0, 0.0)
		for point in points {
			fake_center = (fake_center.at(0) + point.at(0), fake_center.at(1) + point.at(1))
		}
		fake_center = (fake_center.at(0) / points.len(), fake_center.at(1) / points.len())
		circle(fake_center, fill: red, stroke: none, radius: 0.1cm)
	}
}


== Koordinaten bestimmen

Für die Bäume der momentanen Scheibe werden die Koordinaten gesucht. Die Menge der Koordinaten startet mit der leeren Menge für die höchste Scheibe. Bei jeder Scheibe wird die Menge der Koordinaten mit den gefundenen Bereichen aktualisiert. Dafür wird für alle Bereiche in der momentanen Scheibe die Fläche und der Schwerpunkt wie in @segmentierung_schwerpunkt berechnet.

#figure(
	caption: [Fläche und Schwerpunkt für einen konvexen Bereich.],
	grid(
		columns: 1 *2,
		gutter: 1em,
		subfigure(
			cetz.canvas(length: 3.0cm, area_figure(false)),
			caption: [Bereich unterteilen],
		),
		subfigure(
			cetz.canvas(length: 3.0cm, area_figure(true)),
			caption: [Fläche und Schwerpunkt berechnen],
		),
	),
) <segmentierung_schwerpunkt>

Weil die Bereiche konvex sind, können diese trivial in Dreiecke unterteilt werden. Dafür wird ein beliebiger Punkt ausgewählt und für jede Kante, die nicht zum Punkt gehört, wird ein Dreieck gebildet. Die Fläche vom Bereich ist die Summe von den Flächen von den Dreiecken. Für den Schwerpunkt wird für jedes Dreieck der Schwerpunkt berechnet und diese mit der Fläche vom zugehörigen Dreieck gewichtet.

Weil die konvexe Hülle von allen Punkten in einem Bereich gebildet wird, können Bereiche sich Überscheiden, obwohl die Punkte der Bereiche voneinander entfernt sind. Bei dem Hinzuzufügen von neuen Punkten werden die Bereiche sequentiell iteriert, wodurch bei überschneidenden Bereichen das erste präferiert wird. Dadurch wächst der erste Bereich und der andere Bereich bleibt klein. Um den anderen Bereich zu entfernen, werden Bereiche entfernt, deren Zentren in einem anderen Bereich liegen oder deren Fläche kleiner als ein Schwellwert ist.

Danach werden die Koordinaten aus den vorherigen Scheiben mit den Schwerpunkten von der momentanen Scheibe aktualisiert. Für jede Koordinate wird der nächste Schwerpunkt näher als eine maximale Distanz bestimmt. Wenn ein naher Schwerpunkt gefunden wurde, wird die Koordinate mit der Position vom Schwerpunkte aktualisiert. Wenn kein naher Schwerpunkt existiert, so bleibt die Position gleich.

Für alle Schwerpunkte, welche nicht nah an einen der vorherigen Koordinaten liegen, wird ein neues Segment angefangen. Dafür wird der Schwerpunkt zur Liste der Koordinaten hinzugefügt.


== Punkte zuordnen

Mit den Koordinaten wird das Voronoi-Diagramm berechnet, welches den Raum in Bereiche unterteilt, dass alle Punkte in einem Bereich für eine Koordinate am nächsten an dieser Koordinate liegen. Für jeden Punkt wird nun der zugehörige Bereich im Voronoi-Diagramm bestimmt und der Punkt zum zugehörigen Segment zugeordnet. Ein Beispiel für eine Unterteilung ist in @segmentierung_voronoi zu sehen.

#figure(
	caption: [Berechnete Koordinaten für die Punkte mit zugehörigen Bereichen und Voronoi-Diagramm.],
	grid(
		columns: 1 * 2,
		gutter: 1em,
		subfigure(rect(image("../images/test_5-moved.svg"), inset: 0pt), caption: [Höhere Scheibe]),
		subfigure(rect(image("../images/test_6-moved.svg"), inset: 0pt), caption: [Tiefere Scheibe]),
	),
) <segmentierung_voronoi>

Der Ablauf wird für alle Scheiben durchgeführt, wodurch alle Punkte zu Segmenten zugeordnet werden. Ein Beispiel für eine Segmentierung ist in @segment_example gegeben. Die unterschiedlichen Segmente sind durch unterschiedliche Einfärbung der zugehörigen Punkte markiert.

#figure(
	caption: [Segmentierung von einem Waldgebiet.],
	image("../images/auto-crop/segments-br05-als.png", width: 80%),
) <segment_example>
