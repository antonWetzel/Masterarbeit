#import "setup.typ": *


= Triangulierung <triangulierung>


== Ziel

Eine Triangulierung ermöglicht eine Rekonstruktion der ursprünglichen Oberfläche vom eingescannten Bereich, welche weiterverarbeitet oder anzuzeigen werden kann. Die meisten Programme und Hardware sind auf das Anzeigen von Dreiecken spezialisiert, und können diese effizienter als Punkte darstellen. Die Triangulierung wird dabei für die Segmente getrennt bestimmt.


== Ball-Pivoting-Algorithmus


=== Überblick

Beim Ball-Pivoting-Algorithmus werden die Dreiecke der Oberfläche bestimmt, welche von einer Kugel mit Radius $alpha$ ($alpha$-Kugel) erreicht werden können. Dabei berührt die Kugel die drei Eckpunkte vom Dreieck und kein weiterer Punkt aus der Punktwolke liegt in der Kugel.

In @ball_pivoting_überblick ist ein Beispiel in 2D gegeben. Dabei werden die Linien gesucht, dass der zugehörige Kreis keine weiteren Punkte enthält.

#let positions = (
	(0, 0),
	(0.6, 0.2),
	(1, 0.1),
	(1.5, 0.3),
	(1.7, 1.0),
	(2, 0.2),
	(2, -0.3),
	(1.8, -0.6),
	(1.3, -0.4),
	(0.6, -0.2),
)

#let radius = 0.5

#let draw_circle(a, b, color: gray) = {
	import cetz.draw: *
	let d_x = (b.at(0) - a.at(0)) / 2.0
	let d_y = (b.at(1) - a.at(1)) / 2.0
	let d_l = calc.sqrt(d_x * d_x + d_y * d_y)
	let l = calc.sqrt(radius * radius - d_l * d_l)
	let c_x = a.at(0) + d_x - d_y / d_l * l
	let c_y = a.at(1) + d_y + d_x / d_l * l
	circle((c_x, c_y), radius: radius, stroke: color)
}

#side-caption(amount: 1)[#figure(
	caption: [
		Ball-Pivoting-Algorithmus in 2D. Für die äußeren Punkte in Schwarz wird eine Oberfläche gefunden. Für den inneren Punkt in Rot kann kein Nachbar gefunden werden, weil alle zugehörigen Kreise weitere Punkte enthalten würden.
	],
	cetz.canvas(length: 2cm, {
		import cetz.draw: *

		for i in range(1, positions.len()) {
			draw_circle(positions.at(i - 1), positions.at(i))
		}
		draw_circle(positions.last(), positions.at(0))

		for pos in positions {
			circle(pos, radius: 0.1, fill: black)
		}
		circle((1.7, 0), radius: 0.1, fill: red)

		for i in range(1, positions.len()) {
			line(positions.at(i - 1), positions.at(i))
		}
		line(positions.last(), positions.at(0))

	}),
) <ball_pivoting_überblick>]

Die gefundenen Dreiecke bilden eine Hülle, welche alle Punkte beinhaltet. Je kleiner $alpha$ ist, desto genauer ist die Hülle um die Punkte und Details werden besser wiedergegeben. Dafür werden mehr Dreiecke benötigt und Lücken im Datensatz sind auch in der Hülle vorhanden.


=== $alpha$-Kugel für ein Dreieck

Für ein Dreieck $(p_1, p_2, P-3)$ wird die Position der zugehörigen $alpha$-Kugel benötigt. Dafür wird ... #todo[Kugel für Dreieck]

Dabei ist die Reihenfolge der Punkte relevant. Vertauschen von zwei Punkten berechnet die $alpha$-Kugel auf der anderen Seite des Dreiecks.


=== Ablauf


=== Startdreieck bestimmen

Als Anfang wird ein Dreieck mit zugehöriger $alpha$-Kugel benötigt, dass keine weiteren Punkte innerhalb der Kugel liegen. Dafür werden alle Punkte iteriert.

Für den momentanen Punkt werden die umliegenden Punkte mit einem Abstand von $2 alpha$ oder weniger bestimmt. Für weiter entfernte Punkte gibt es keine $alpha$-Kugel, welche beide Punkte berühren würde.

Mit dem momentanen Punkt und alle möglichen Kombination von zwei Punkten aus den umliegenden Punkten wird ein Dreieck gebildet. Für das Dreieck werden nun die zwei möglichen $alpha$-Kugeln bestimmt, welche zum Dreieck gehören.

Wenn ein Dreieck mit zugehöriger $alpha$-Kugel gefunden wurde, welche keine weiteren Punkte enthält, kann dieses Dreieck als Startdreieck verwendet werden. Das Dreieck wird zur Triangulierung hinzugefügt und die drei zugehörigen Kanten bilden die momentanen äußeren Kanten, von denen aus die Triangulierung berechnet wird.


=== Triangulierten Bereich erweitern

Solange es noch eine äußere Kante $(p_1, p_2)$ gibt, kann die Triangulierung erweitert werden. Für die Kante ist bereits ein Dreieck und die zugehörige $alpha$-Kugel mit Zentrum $c$ bekannt. Die Kante dient nun als Pivot, um welches die $alpha$-Kugel gerollt wird. Der erste Punkt $p$, welcher von der Kugel berührt wird, bildet mit $p_1$ und $p_2$ ein neues Dreieck.

In @ball_pivoting_erweiterung ist ein Beispiel für die Erweiterung in 2D gegeben. Es werden Kanten als Oberfläche gesucht und Punkte werden als Pivot-Element verwendet.

#side-caption(amount: 1.5)[#figure(
	caption: [
		Erweiterung der gefundenen Oberfläche in 2D. Die vorherige Kante und der momentane Pivot-Punkt sind in Schwarz. Der $alpha$-Kreis rollt entlang der markierten Richtung. In Grün ist der erste Punkt und zugehörigen Kreis, welche berührt werden. Die weiteren Punkte in Rot sind Kandidaten, liegen aber weiter in der Rotation, weshalb die grüne Kante zur Oberfläche hinzugefügt wird.

	],
	cetz.canvas(length: 2cm, {
		import cetz.draw: *

		let a = positions.at(8);
		let b = positions.at(9);
		draw_circle(a, b, color: black)

		// for pos in positions {
		// 	circle(pos, radius: 0.1, fill: black)
		// }
		circle(b, stroke: gray, radius: radius + 0.5);

		draw_circle(b, positions.at(0), color: green)

		line(a, b, stroke: 2pt)
		line(b, positions.at(0), stroke: green + 2pt)
		line(b, positions.at(1), stroke: red + 2pt)
		line(b, positions.at(2), stroke: red + 2pt)

		circle((1.7, 0), radius: 0.1, fill: gray, stroke: none)
		circle(positions.at(0), radius: 0.1, fill: green, stroke: none)
		circle(positions.at(1), radius: 0.1, fill: red, stroke: none)
		circle(positions.at(2), radius: 0.1, fill: red, stroke: none)
		circle(positions.at(3), radius: 0.1, fill: gray, stroke: none)
		circle(positions.at(4), radius: 0.1, fill: gray, stroke: none)
		circle(positions.at(5), radius: 0.1, fill: gray, stroke: none)
		circle(positions.at(6), radius: 0.1, fill: gray, stroke: none)
		circle(positions.at(7), radius: 0.1, fill: gray, stroke: none)
		circle(positions.at(8), radius: 0.1, fill: red, stroke: none)
		circle(positions.at(9), radius: 0.1, fill: black)

		arc(b, start: -17deg, delta: -180deg, anchor: "origin", radius: 0.3, name: "arc")

		let m-x = b.at(0) - 0.295
		let m-y = b.at(1) + 0.05
		mark((m-x, m-y), (m-x + 0.06, m-y + 0.2), symbol: ">", fill: black, stroke: none)

	}),
) <ball_pivoting_erweiterung>]


==== Kandidaten bestimmen

Um den ersten Punkt $p$ zu finden, werden zuerst alle möglichen Punkte bestimmt, welche von der Kugel bei der kompletten Rotation berührt werden können. Dafür wird der Mittelpunkt $m p = (p_1 + p_2) / 2$ der Kante und der Abstand $d = |p_(1, 2)-m p|$ berechnet. Der Abstand zwischen dem Zentrum der Kugel und den Endpunkten von der Kante ist immer $alpha$, dadurch ist der Abstand vom Zentrum zum Mittelpunkt $x = sqrt(alpha^2 - d^2)$. In @triangulierung_abstand_kugel ist die Berechnung veranschaulicht.

#figure(
	caption: [Berechnung des Abstands der $alpha$-Kugel vom Mittelpunkt der Kante],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *
		arc((4, 3), start: 10deg, delta: -200deg, anchor: "origin", radius: 5, stroke: gray)

		circle((0, 0), radius: 0.1, fill: black)
		content((0, 0), $p_1$, anchor: "top", padding: 0.15)

		circle((4, 0), radius: 0.1, fill: black)
		content((4, 0), $m p$, anchor: "top", padding: 0.15)

		circle((8, 0), radius: 0.1, fill: black)
		content((8, 0), $p_2$, anchor: "top", padding: 0.15)

		line((4, 0), (4, 3))
		line((0, 0), (4, 3), (8, 0))
		line((0, 0), (8, 0))

		circle((4, 3), radius: 0.1, fill: black)
		content((4, 3), $c$, anchor: "bottom", padding: 0.15)

		content(((0, 0), 0.5, (4, 3)), angle: -30deg, [$alpha$], anchor: "bottom", padding: 0.15)
		content(((4, 3), 0.5, (8, 0)), angle: 30deg, [$alpha$], anchor: "bottom", padding: 0.15)
		content(((4, 0), 0.5, (4, 3)), [$x$], anchor: "left", padding: 0.15)
		content(((0, 0), 0.5, (4, 0)), [$d$], anchor: "top", padding: 0.15)

		arc((4, 0), start: 90deg, stop: 180deg, anchor: "origin", radius: 1)
		circle((3.5, 0.5), radius: 0.05, fill: black)
	}),
) <triangulierung_abstand_kugel>

Die möglichen Punkte sind vom Zentrum der Kugel $c$ maximal $alpha$ entfernt und $c$ ist vom Mittelpunkt $m p$ $x$ entfernt. Deshalb werden die Punkte in der Kugel mit Zentrum $m p$ und Radius $alpha + x$ bestimmt.


==== Besten Kandidaten bestimmen

Für jeden Kandidaten $p$ wird berechnet, wie weit die Kugel um die Kante gerollt werden muss, bis die Kugel den Kandidaten berührt. Dafür wird zuerst das Zentrum $c_p$ der $alpha$-Kugel bestimmt, welche $p_1$, $p_2$ und $p$ berührt. Die Kugel wird dabei wie in @triangulierung_kugel_seite bestimmt, dass die Kugel auf der korrekten Seite vom potenziellen Dreieck liegt. $p$ kann so liegen, dass es keine zugehörige $alpha$-Kugel gibt, in diesem Fall wird $p$ nicht weiter betrachtet. Für jeden Kandidaten wird der Winkel $phi$ berechnet, wie weit um die Kante die Kugel gerollt wurde.

#figure(
	caption: [Berechnung von Zentrum der $alpha$-Kugel und zugehöriger Winkel für einen Kandidatenpunkt],
	cetz.canvas(length: 2cm, {
		import cetz.draw: *

		line((0, 0, 0), (0, 0, 2), (-2.4, 0, 1), close: true, name: "wow")
		line((0, 0, 0), (0, 0, 2), (2.4, -1.2, 1), close: true)

		line((-1, 0, 1), (-1, 2, 1), name: "c", stroke: gray)
		line((1, -0.5, 1), (1.7, 1.3, 1), name: "cp", stroke: gray)

		circle((-1.9, 0.5), radius: 0.03, fill: black)
		content((0, 0, 0), $p_1$, anchor: "top", padding: 0.15)
		circle((0, 0, 0), radius: 0.03, fill: black)
		content((1, 1), $p_2$, anchor: "bottom", padding: 0.15)
		circle((1, 1), radius: 0.03, fill: black)
		content((2.9, -0.7), $p$, anchor: "left", padding: 0.15)
		circle((2.9, -0.7), radius: 0.03, fill: black)

		content((-0.5, 2.5), $c$, anchor: "bottom", padding: 0.15)
		circle((-0.5, 2.5), radius: 0.03, fill: black)
		content((2.2, 1.8), $c_p$, anchor: "bottom", padding: 0.15)
		circle((2.2, 1.8), radius: 0.03, fill: black)

		arc((-1, 0, 1), start: 0deg, delta: 90deg, anchor: "origin", radius: 0.3, stroke: gray)
		arc((1, -0.5, 1), start: 70deg, delta: 90deg, anchor: "origin", radius: 0.3, stroke: gray)

		content((0.5, 0.5), $m p$, anchor: "left", padding: 0.15)
		circle((0.5, 0.5), radius: 0.03, fill: black)

		line((-0.5, 2.5), (0.5, 0.5), (2.2, 1.8))

		arc((0.5, 0.5), start: 37.5deg, delta: 79deg, anchor: "origin", radius: 1.2, stroke: gray)
		content((0.6, 1.3), $phi$, anchor: "bottom", padding: 0.15)

	}),
) <triangulierung_kugel_seite>

Mit $m p$, $c$ und $c_p$ wird der Winkel $phi$ bestimmt. Dafür werden die Vektoren $a = c - m p$ und $b = c_p - m p$ bestimmt und normalisiert. Der Kosinus von $phi$ ist dabei das Skalarprodukt $s =a dot b$. Zusätzlich wird das Kreuzprodukt $k =a times b$ bestimmt, womit $ phi = cases(
		arccos(s) & "falls" & k >= 0,
		tau - arccos(s) & "falls" & k < 0,
	) $ berechnet wird. Von allen Kandidaten wird der Punkt $p_3$ ausgewählt, für den $phi$ am kleinsten ist.

Es muss nicht kontrolliert werden, ob ein Punkt in der $alpha$-Kugel von $(p_1, p_2, p_3)$ liegt, weil diese immer leer ist. Würde ein weiterer Punkt in der Kugel liegen, so würde der zugehörige Winkel $phi$ von diesem Punkt kleiner sein, weil der Punkt beim Rollen um die Kante früher von der Kugel berührt wird. Weil $p_3$ aber zum kleinsten Winkel gehört, kann das nicht sein. Dies gilt aber nur, wenn die Kugel zum Start bereits leer ist.


==== Triangulierung erweitern

Das neu gefundene Dreieck mit den Eckpunkten $(p_1, p_2, p_3)$ wird zur Triangulierung hinzugefügt. Die Kante ($p_1, p_2$) wird von den äußeren Kanten entfernt, dafür werden die Kanten zwischen $(p_1, p_3)$ und $(p_3, p_2)$ hinzugefügt. Wenn eine neue Kante in den äußeren Kanten bereits vorhanden ist, wird diese nicht hinzugefügt, sondern entfernt, weil das zugehörige zweite Dreieck bereits gefunden wurde. Ein Veranschaulichung ist in @triangulierung_erweiterung gegeben.

#figure(
	caption: [Erweiterung der Triangulierung in 3D.],
	box(width: 80%, grid(
		columns: 2,
		column-gutter: 5em,
		row-gutter: 1em,
		subfigure(image("../images/pivot_0.png"), caption: [Kante mit zugehörigem Dreieck, Kugel und Ring mit Radius $x$]), subfigure(image("../images/pivot_1.png"), caption: [Kugel mit Radius $alpha + x$, welche alle Kanditaten enthält]),
		subfigure(image("../images/pivot_2.png"), caption: [Erster Punkt, welcher entlang der Rotation die Kugel berührt]), subfigure(image("../images/pivot_3.png"), caption: [Triangulierung, mit dem neuen Dreieck hinzugefügt]),
	)),
) <triangulierung_erweiterung>


=== Komplettes Segment triangulieren

Solange es noch äußere Kanten gibt, kann von diesen aus die Triangulierung erweitert werden. Dabei muss beachtet werden, dass durch Ungenauigkeiten bei der Berechnung und malformierten Daten eine Kante mehrfach gefunden werden kann. Um eine erneute Triangulierung von bereits triangulierten Bereichen zu verhindern, werden alle inneren Kanten gespeichert und neue Kanten nur zu den äußeren Kanten hinzugefügt, wenn diese noch nicht in den inneren Kanten vorhanden sind. Bei der Erweiterung wird die ausgewählte äußere Kante zu den inneren Kanten hinzugefügt.

Wenn es keine weiteren äußeren Kanten gibt, muss ein neues Startdreieck gefunden werden. Dabei werden nur die Punkte in betracht gezogen, welche zu noch keinem Dreieck gehören. Wenn kein Startdreieck gefunden werden kann, ist das Segment vollständig trianguliert.


=== Vorauswahl

Vor der Triangulierung wird mit dem Mindestabstand $d$ die Anzahl der Punkte und deformierte Dreiecke verringert. Dafür wird ein Subset der Punkte bestimmt, dass die Punkte paarweise mindestens den Mindestabstand voneinander entfernt sind.

Für die Berechnung wird ein Greedy-Algorithmus verwendet. Am Anfang werden alle Punkte zum Set hinzugefügt und danach werden alle Punkte im Set iteriert. Für jeden Punkt werden mit dem KD-Baum die Punkte in der Nachbarschaft bestimmt, welche näher als der Mindestabstand zum momentanen Punkt liegen. Die Punkte werden aus dem Set entfernt und der nächste Punkt, der noch im Set ist, wird betrachtet.


=== Auswahl von $alpha$

- Groß genug für keine Lücken
- Klein genug für gute Laufzeit

#todo[Auswahl $alpha$]


== Ergebnisse

#todo[Ergebnisse]

#todo[Vergleich $alpha$]

#figure(
	caption: [Beispiel für eine Triangulierung von einem Baum.],
	stack(
		dir: ltr,
		spacing: 1em,
		subfigure(caption: [Punkte], width: 30%, box(
			clip: true,
			image("../images/triangulation_input.png", width: 400%),
		)),
		subfigure(caption: [Dreiecke umrandet], width: 30%, box(
			clip: true,
			image("../images/triangulation_outline.png", width: 400%),
		)),
		subfigure(caption: [Dreiecke ausgefüllt], width: 30%, box(
			clip: true,
			image("../images/triangulation_filled.png", width: 400%),
		)),
	),
)
