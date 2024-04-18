#import "setup.typ": *


= Triangulierung <triangulierung>


== Ziel

Das Ziel der Triangulierung ist eine Approximation der ursprünglichen Oberfläche von den gescannten Bäumen, welche weiterverarbeitet oder angezeigt werden kann. Die meisten Programme und Hardware sind auf das Anzeigen von Dreiecken spezialisiert und können diese effizienter als Punkte darstellen. Die Triangulierung wird dafür mit den Punkten von einem Bereich berechnet.


== Ball-Pivoting Algorithmus

Beim Ball-Pivoting Algorithmus werden die Dreiecke der Oberfläche bestimmt, welche von einer Kugel mit Radius $alpha$ ($alpha$-Kugel) erreicht werden können. Dabei berührt die Kugel die drei Eckpunkte vom Dreieck und alle anderen Punkte sind außerhalb der Kugel @ball_pivot.

In @ball_pivoting_überblick ist ein Beispiel in 2D gegeben. Dabei werden die Kanten zwischen zwei Punkten gesucht, dass der zugehörige Kreis keine weiteren Punkte enthält. Für die äußeren Punkte in Schwarz wird eine Oberfläche gefunden. Für den inneren Punkt in Rot kann kein Nachbar gefunden werden, weil alle zugehörigen Kreise weitere Punkte enthalten würden.

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
	set-style(stroke: black)

	let d_x = (b.at(0) - a.at(0)) / 2.0
	let d_y = (b.at(1) - a.at(1)) / 2.0
	let d_l = calc.sqrt(d_x * d_x + d_y * d_y)
	let l = calc.sqrt(radius * radius - d_l * d_l)
	let c_x = a.at(0) + d_x - d_y / d_l * l
	let c_y = a.at(1) + d_y + d_x / d_l * l
	circle((c_x, c_y), radius: radius, stroke: color)
}

#figure(
	caption: [
		Ball-Pivoting Algorithmus in 2D.
	],
	cetz.canvas(length: 1.7cm, {
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
) <ball_pivoting_überblick>

Die gefundenen Dreiecke bilden eine äußere Hülle um die Punkte. Je kleiner $alpha$ ist, desto genauer ist die Hülle um die Punkte und Details werden besser wiedergegeben. Dafür werden mehr Dreiecke benötigt und größere Lücken in den Punkten sind auch in der Hülle vorhanden.


=== $alpha$-Kugel für ein Dreieck

Für ein Dreieck $(p_1, p_2, p_3)$ wird die Position der zugehörigen $alpha$-Kugel benötigt. Dafür wird zuerst das Zentrum $c$ vom Umkreis vom Dreieck bestimmt. Von diesem sind alle Eckpunkte gleich weit entfernt. Ist der Abstand $d_c$ vom Zentrum zu den Ecken größer als $alpha$, so gibt es keine zugehörige $alpha$-Kugel. Für Abstände kleiner gleich $alpha$ ist das Zentrum der Kugel $d = sqrt(alpha^2 - d_c^2)$ vom Zentrum vom Umkreis entfernt. Der Vektor $o = (p_2 - p_1) times (p_3 - p_1)$ ist orthogonal zum Dreieck, womit die Position vom Zentrum der $alpha$-Kugel mit $c + d dot o / (norm(o))$ berechnet werden kann.

Durch die Berechnung von $o$ ist die Reihenfolge der Punkte relevant. Vertauschen von zwei Punkten berechnet die $alpha$-Kugel auf der anderen Seite des Dreiecks.


== Ablauf


=== KD-Baum berechnen

Zuerst wird ein KD-Baum für die Punkte im Segment berechnet. Der KD-Baum ermöglicht die effiziente Bestimmung von den nächsten Punkten für eine beliebige Position. Dabei werden nur die Punkte bestimmt, welche näher als ein Maximalabstand von der Position entfernt sind. Die Konstruktion und Verwendung vom KD-Baum wird in @kd_baum erklärt.

Mit dem KD-Baum kann auch überprüft werden, ob in einer $alpha$-Kugel keine weiteren Punkte liegen. Dafür wird der erste Punkt gesucht, der in der Kugel liegt. Wenn kein Punkt gefunden wird, ist die Kugel leer.


=== Startdreieck bestimmen

Als Anfang wird ein Dreieck mit zugehöriger $alpha$-Kugel benötigt, dass keine weiteren Punkte innerhalb der Kugel liegen. Dafür werden alle Punkte iteriert.

Für den momentanen Punkt werden die umliegenden Punkte mit einem Abstand von $2 alpha$ oder weniger bestimmt. Für weiter entfernte Punkte gibt es keine $alpha$-Kugel, welche beide Punkte berühren würde.

Mit dem momentanen Punkt und alle möglichen Kombination von zwei Punkten aus den umliegenden Punkten wird ein Dreieck gebildet. Für das Dreieck wird probiert die zwei möglichen $alpha$-Kugeln zu bestimmen, welche zum Dreieck gehören.

Wenn ein Dreieck mit zugehöriger $alpha$-Kugel gefunden wurde, welche keine weiteren Punkte enthält, kann dieses Dreieck als Startdreieck verwendet werden. Das Dreieck wird zur Triangulierung hinzugefügt und die drei zugehörigen Kanten bilden die momentanen äußeren Kanten, von denen aus die Triangulierung berechnet wird.


=== Triangulierten Bereich erweitern

Solange es noch eine äußere Kante $(p_1, p_2)$ gibt, kann die Triangulierung erweitert werden. Für die Kante ist bereits ein Dreieck und die zugehörige $alpha$-Kugel mit Zentrum $c$ bekannt. Die Kante dient als Pivot, um welches die $alpha$-Kugel gerollt wird. Der erste Punkt $p$, welcher von der Kugel berührt wird, bildet mit $p_1$ und $p_2$ ein neues Dreieck.

In @ball_pivoting_erweiterung ist ein Beispiel für eine Erweiterung in 2D gegeben. Im zweidimensionalen werden Kanten gesucht und Punkte werden als Pivot verwendet. Die vorherige Kante und der momentane Pivot-Punkt sind in Schwarz. Der $alpha$-Kreis rollt entlang der markierten Richtung und berührt zuerst den grünen Punkt. Die weiteren Kandidaten sind in Rot und liegen weiter entlang der Rotation.

#figure(
	caption: [
		Erweiterung der gefundenen Oberfläche in 2D.

	],
	cetz.canvas(length: 1.7cm, {
		import cetz.draw: *
		set-style(stroke: black)

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

		arc(b, start: -17deg, delta: -190deg, anchor: "origin", radius: 0.3, name: "arc", mark: (end: ">", fill: black))

		let m-x = b.at(0) - 0.295
		let m-y = b.at(1) + 0.05
	}),
) <ball_pivoting_erweiterung>


==== Mögliche Kandidaten bestimmen

Um den ersten Punkt $p$ zu finden, werden zuerst alle möglichen Punkte bestimmt, welche von der Kugel bei der kompletten Rotation berührt werden können. Dafür wird der Mittelpunkt $m p$ der Kante und der Abstand $d$ berechnet.

$ m p = (p_1 + p_2) / 2 #h(40pt) d = norm(p_1-m p) = norm(p_2-m p) $

Der Abstand zwischen dem Zentrum der Kugel und den Endpunkten von der Kante ist immer $alpha$, dadurch ist der Abstand vom Zentrum zum Mittelpunkt der Kante $d_C = sqrt(alpha^2 - d^2)$. In @triangulierung_abstand_kugel ist die Konstruktion veranschaulicht.

#figure(
	caption: [Abstand vom Zentrum der $alpha$-Kugel zum Mittelpunkt der Kante.],
	cetz.canvas(length: 0.5cm, {
		import cetz.draw: *
		set-style(stroke: black)

		arc((4, 3), start: 10deg, delta: -200deg, anchor: "origin", radius: 5, stroke: gray)

		circle((0, 0), radius: 0.1, fill: black)
		content((0, 0), $p_1$, anchor: "north", padding: 0.15)

		circle((4, 0), radius: 0.1, fill: black)
		content((4, 0), $m p$, anchor: "north", padding: 0.15)

		circle((8, 0), radius: 0.1, fill: black)
		content((8, 0), $p_2$, anchor: "north", padding: 0.15)

		line((4, 0), (4, 3))
		line((0, 0), (4, 3), (8, 0))
		line((0, 0), (8, 0))

		circle((4, 3), radius: 0.1, fill: black)
		content((4, 3), $c$, anchor: "south", padding: 0.15)

		content(((0, 0), 2.5, (4, 3)), angle: 30deg, [$alpha$], anchor: "south", padding: 0.15)
		content(((4, 3), 2.5, (8, 0)), angle: -30deg, [$alpha$], anchor: "south", padding: 0.15)
		content(((4, 0), 1.5, (4, 3)), [$d_c$], anchor: "west", padding: 0.15)
		content(((0, 0), 2.0, (4, 0)), [$d$], anchor: "north", padding: 0.15)

		arc((4, 0), start: 90deg, stop: 180deg, anchor: "origin", radius: 1)
		circle((3.5, 0.5), radius: 0.05, fill: black)
	}),
) <triangulierung_abstand_kugel>

Die möglichen Punkte sind vom Zentrum der Kugel $c$ maximal $alpha$ entfernt und $c$ ist vom Mittelpunkt $m p$ genau $d_c$ weit entfernt. Deshalb werden mit dem KD-Baum die Punkte in der Kugel mit Zentrum $m p$ und Radius $alpha + d_c$ als mögliche Kandidaten bestimmt.


==== Besten Kandidaten bestimmen

Für jeden Kandidaten $p$ wird berechnet, wie weit die Kugel um die Kante gerollt werden muss, bis die Kugel den Kandidaten berührt. Dafür wird zuerst das Zentrum $c_p$ der $alpha$-Kugel bestimmt, welche $p_1$, $p_2$ und $p$ berührt. Das Zentrum wird dabei wie in @triangulierung_kugel_seite berechnet, dass die Kugel auf der korrekten Seite vom potenziellen Dreieck liegt. $p$ kann so liegen, dass es keine zugehörige $alpha$-Kugel gibt, in diesem Fall wird $p$ nicht weiter betrachtet. Für die restlichen Kandidaten wird der Winkel $phi$ berechnet, wie weit um die Kante die Kugel gerollt wurde.

#figure(
	caption: [Berechnung von Zentrum der $alpha$-Kugel und zugehöriger Winkel für einen Kandidaten.],
	cetz.canvas(length: 1.2cm, {
		import cetz.draw: *
		set-style(stroke: black)

		line((0, 0, 0), (0, 0, 2), (-2.4, 0, 1), close: true, name: "wow")
		line((0, 0, 0), (0, 0, 2), (2.4, -1.2, 1), close: true)

		line((-1, 0, 1), (-1, 2, 1), name: "c", stroke: gray)
		line((1, -0.5, 1), (1.7, 1.3, 1), name: "cp", stroke: gray)

		circle((-1.9, 0.5), radius: 0.03, fill: black)
		content((0, 0, 0), $p_1$, anchor: "north", padding: 0.15)
		circle((0, 0, 0), radius: 0.03, fill: black)
		content((1, 1), $p_2$, anchor: "south", padding: 0.15)
		circle((1, 1), radius: 0.03, fill: black)
		content((2.9, -0.7), $p$, anchor: "west", padding: 0.15)
		circle((2.9, -0.7), radius: 0.03, fill: black)

		content((-0.5, 2.5), $c$, anchor: "south", padding: 0.15)
		circle((-0.5, 2.5), radius: 0.03, fill: black)
		content((2.2, 1.8), $c_p$, anchor: "south", padding: 0.15)
		circle((2.2, 1.8), radius: 0.03, fill: black)

		arc((-1, 0, 1), start: 0deg, delta: 90deg, anchor: "origin", radius: 0.3, stroke: gray)
		arc((1, -0.5, 1), start: 70deg, delta: 90deg, anchor: "origin", radius: 0.3, stroke: gray)

		content((0.5, 0.5), $m p$, anchor: "west", padding: 0.15)
		circle((0.5, 0.5), radius: 0.03, fill: black)

		line((-0.5, 2.5), (0.5, 0.5), (2.2, 1.8))

		arc((0.5, 0.5), start: 37.5deg, delta: 79deg, anchor: "origin", radius: 1.2, stroke: gray, mark: (start: ">", fill: gray))
		content((0.6, 1.3), $phi$, anchor: "south", padding: 0.15)

	}),
) <triangulierung_kugel_seite>

Mit $m p$, $c$ und $c_p$ wird der Winkel $phi$ bestimmt. Dafür werden die normalisierten Vektoren $a$ und $b$ berechnet.

$ a = (c - m p) / norm(c - m p) #h(40pt) b = (c_p - m p) / norm(c_p - m p) $

Der Kosinus von $phi$ ist dabei das Skalarprodukt $s =a dot b$. Zusätzlich wird mit dem Kreuzprodukt $k =a times b$ die Richtung $r$ bestimmt, um die Winkel mit gleichen Kosinus zu unterscheiden.

$ k = a times b #h(40pt) r = k dot (p_2 - p_1) #h(40pt) phi = cases(
		arccos(s) & "falls" & r >= 0,
		tau - arccos(s) & "falls" & r < 0,
	) $

Von allen Kandidaten wird der Punkt $p_3$ ausgewählt, für den $phi$ am kleinsten ist. Wenn $p_1 = p_3$ oder $p_2 = p_3$, dann gibt es keinen dritten Punkt um die Triangulierung zu erweitern und kein weiteres Dreieck wird für die Kante hinzugefügt.

Es muss nicht kontrolliert werden, ob ein Punkt in der $alpha$-Kugel von $(p_1, p_2, p_3)$ liegt, weil diese immer leer ist. Würde ein weiterer Punkt in der Kugel liegen, so würde der zugehörige Winkel $phi$ von diesem Punkt kleiner sein, weil der Punkt beim Rollen um die Kante früher von der Kugel berührt wird. Weil $p_3$ aber zum kleinsten Winkel gehört, ist die zugehörige $alpha$-Kugel immer leer. Dies gilt aber nur, wenn die Kugel vor dem Rollen bereits leer war.


==== Triangulierung erweitern

Das neu gefundene Dreieck mit den Eckpunkten $(p_1, p_2, p_3)$ wird zur Triangulierung hinzugefügt. Die Kante ($p_1, p_2$) wird von den äußeren Kanten entfernt, dafür werden die neuen Kanten $(p_1, p_3)$ und $(p_3, p_2)$ hinzugefügt. Wenn eine der neuen Kante in den äußeren Kanten bereits vorhanden ist, wird diese nicht hinzugefügt, sondern von den äußeren Kanten entfernt, weil das zugehörige zweite Dreieck auf der anderen Seite der Kante bereits gefunden wurde. Eine Veranschaulichung ist in @triangulierung_erweiterung gegeben.

#figure(
	caption: [Erweiterung der Triangulierung in 3D.],
	box(width: 90%, grid(
		columns: 2,
		column-gutter: 2em,
		row-gutter: 1em,
		subfigure(image("../images/pivot_0.png", width: 70%), caption: [Kante mit zugehörigem Dreieck, #box[$alpha$-Kugel] und Ring mit Radius $d_c$]), subfigure(image("../images/pivot_1.png", width: 70%), caption: [Kugel mit Radius $alpha + d_c$, welche alle Kandidaten enthält]),
		subfigure(image("../images/pivot_2.png", width: 70%), caption: [Erster Punkt, welcher entlang der Rotation die Kugel berührt]),                 subfigure(image("../images/pivot_3.png", width: 70%), caption: [Triangulierung, mit dem neuen Dreieck hinzugefügt]),
	)),
) <triangulierung_erweiterung>


=== Komplettes Segment triangulieren

Solange es noch äußere Kanten gibt, kann von diesen aus die Triangulierung erweitert werden. Dabei muss beachtet werden, dass durch Ungenauigkeiten bei der Berechnung eine Kante mehrfach gefunden werden kann. Um eine erneute Triangulierung von bereits triangulierten Bereichen zu verhindern, werden alle inneren Kanten gespeichert und neue Kanten nur zu den äußeren Kanten hinzugefügt, wenn diese noch nicht in den inneren Kanten vorhanden sind.

Wenn es keine weiteren äußeren Kanten gibt, muss ein neues Startdreieck gefunden werden. Dabei werden nur die Punkte in Betracht gezogen, welche zu noch keinem Dreieck gehören. Wenn kein Startdreieck gefunden werden kann, ist das Segment vollständig trianguliert.


== Vorauswahl

Vor der Triangulierung wird mit einem Mindestabstand die Menge der Punkte berechnet, welche betrachtet werden. Dafür wird eine Teilmenge der Punkte bestimmt, dass die Punkte paarweise mindestens den Mindestabstand voneinander entfernt sind.

Für die Berechnung wird ein Greedy-Algorithmus verwendet. Am Anfang werden alle Punkte zur Teilmenge hinzugefügt und danach werden die Punkte in der Teilmenge iteriert. Für jeden Punkt wird mit dem KD-Baum die Punkte in der Nachbarschaft bestimmt, welche näher als den Mindestabstand zum momentanen Punkt liegen. Die nahen Punkte werden aus der Teilmenge entfernt und der nächste Punkt in der Teilmenge wird betrachtet.


== Auswahl von $alpha$

In @triangulierung_alpha wurde die Triangulation für die gleiche Punktwolke mit unterschiedlichen Werten für $alpha$ berechnet. Im oberen Bild sind die Dreiecke ausgefüllt und im unteren Bild umrandet. Mit einem größerem $alpha$ wird das Ergebnis immer weiter vereinfacht. Bei einem kleinen Wert für $alpha$ entstehen Lücken in der Triangulierung, wenn die Punkte weiter als $2 alpha$ voneinander entfernt sind.

#let lines_and_mesh(prec) = {
	stack(
		dir: ttb,
		image("../images/crop/triangulation_mesh_" + prec + ".png"),
		image("../images/crop/triangulation_lines_" + prec + ".png"),
	)
}

#figure(
	caption: [Triangulation für unterschiedliche $alpha$.],
	box(width: 80%, grid(
		columns: 1 * 5,
		subfigure(
			caption: [$0.2$ m],
			lines_and_mesh("0.2"),
		),
		subfigure(
			caption: [$0.5$ m],
			lines_and_mesh("0.5"),
		),
		subfigure(
			caption: [$1.0$ m],
			lines_and_mesh("1.0"),
		),
		subfigure(
			caption: [$2.0$ m],
			lines_and_mesh("2.0"),
		),
		subfigure(
			caption: [$5.0$ m],
			lines_and_mesh("5.0"),
		),
	)),
) <triangulierung_alpha>

Der Bereich für die Suche vom nächsten Kandidaten für die Erweiterung von der Triangulierung ist abhängig von $alpha$. Dadurch steigt der Berechnungsaufwand mit größerem $alpha$, weil mehr Dreiecke und jeweils mehr Kandidaten berechnet werden müssen.

Im Idealfall wird $alpha$ so klein gewählt, dass keine gewünschten Details verloren gehen und so groß, dass keine Lücken in der Triangulierung entstehen.
