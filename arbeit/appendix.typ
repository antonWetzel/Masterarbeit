#import "setup.typ": *


= Appendix


== KD-Baum

Für eine Menge von Punkten kann ein KD-Baum bestimmt werden. Mit diesem kann effizient bestimmt werden, welche Punkte innerhalb einer Kugel mit beliebiger Position und Radius liegen. Ein Beispiel für einen KD-Baum ist in @appendix_kd_baum gegeben.

#side-caption(amount: 1)[#figure(
	caption: [
		KD-Baum für Punkte in 2D. Für jede Unterteilung ist die Trenngerade gepunkteter gezeichnet. Weil der rote Kreis vollständig auf einer Seite der ersten Unterteilung ist, müssen die Punkte auf der anderen Seite nicht betrachtet werden.
	],
	cetz.canvas(length: 2cm, {
		import "triangulierung.typ": positions
		import cetz.draw: *

		for pos in positions {
			circle(pos, radius: 0.1, fill: black)
		}
		circle((1.7, 0), radius: 0.1, fill: black)

		let x0 = positions.at(3).at(0)
		line((x0, 1.5), (x0, -1), stroke: black + 2pt)
		let y1 = positions.at(0).at(1)
		line((-0.5, y1), (x0, y1), stroke: (dash: "densely-dotted", thickness: 2pt))
		let x2 = positions.at(1).at(0)
		line((x2, 1.5), (x2, y1), stroke: (dash: "dotted", thickness: 2pt))
		let y3 = positions.at(2).at(1)
		line((x2, y3), (x0, y3), stroke: (dash: "loosely-dotted", thickness: 2pt))
		let x2 = positions.at(9).at(0)
		line((x2, y1), (x2, -1), stroke: (dash: "dotted", thickness: 2pt))
		let y3 = positions.at(8).at(1)
		line((x2, y3), (x0, y3), stroke: (dash: "loosely-dotted", thickness: 2pt))

		let y1 = 0
		line((x0, y1), (2.5, y1), stroke: (dash: "densely-dotted", thickness: 2pt))
		let x2 = positions.at(4).at(0)
		line((x2, 1.5), (x2, y1), stroke: (dash: "dotted", thickness: 2pt))
		let y3 = positions.at(5).at(1)
		line((x2, y3), (2.5, y3), stroke: (dash: "loosely-dotted", thickness: 2pt))
		let x2 = positions.at(7).at(0)
		line((x2, y1), (x2, -1), stroke: (dash: "dotted", thickness: 2pt))
		let y3 = positions.at(6).at(1)
		line((x2, y3), (2.5, y3), stroke: (dash: "loosely-dotted", thickness: 2pt))

		circle((0.8, 0.1), radius: 0.4, stroke: red)
	}),
) <appendix_kd_baum>]


=== Konstruktion

Für die Konstruktion von einem KD-Baum werden nur die Positionen der Punkte benötigt.

Zuerst wird für die Punkte entlang der ersten Dimension der Median bestimmt. Dabei wird der _Quickselect_-Algorithmus @quickselect verwendet. Der Median hat als Index die halbe Anzahl der Punkte. Ist die Anzahl der Punkte ungerade, so kann der Index auf- oder abgerundet werden, solange bei der Suche die gleiche Strategie verwendet wird. Wie beim _Quicksort_-Algorithmus wird ein beliebiges Pivot-Element ausgewählt, mit diesem die Positionen entlang der Dimension unterteilt werden. Die Positionen werden einmal iteriert und kleinere Positionen vor dem Pivot und größere Positionen nach dem Pivot verschoben. Der Pivot ist am Index, wo es in der sortierten List wäre. Um den Median zu finden, wird nur der Teil von den Punkten betrachtet, welcher den zugehörigen Index beinhaltet. Die Unterteilung wird so lange wiederholt, bis der Median bekannt ist.

Durch den _Quickselect_-Algorithmus sind die Positionen nach der Bestimmung vom Median in kleine und größere Positionen unterteilt. Die Ebene durch den Punkt teilt dabei den Raum und alle Punkte mit kleinerem Index liegen auf der anderen Seite als die Punkte mit größerem Index. Die beiden Hälften werden in der gleichen Weise unterteilt. Dabei wird die nächste, beziehungsweise für die letzte Dimension wieder die erste Dimension verwendet.

Der zugehörige Binärbaum muss nicht gespeichert werden, da diese implizit entsteht. Für jede Unterteilung wird die Position vom Median gespeichert, dass diese für die Suchanfragen benötigt werden.


=== Suche mit festem Radius

Bei dieser Suchanfrage werden alle Punkte gesucht, welche in einer Kugel mit bekanntem Zentrum und Radius liegen. Von der Root-Knoten aus wird der Baum dabei durchsucht. Bei jeder Unterteilung wird dabei überprüft, wie die Kugel zur teilenden Ebene liegt. Ist die Kugel vollständig auf einer Seite, so muss nur der zugehörige Teilbaum weiter durchsucht werden. Liegen Teile der Kugel auf beiden Seiten, so müssen beide Teilbaum weiter durchsucht werden.

Dabei wird bei jeder Unterteilung überprüft, ob die zugehörige Position in der Kugel liegt und gegebenenfalls zum Ergebnis hinzugefügt.

Mit der gleichen Methode kann effizient bestimmt werden, ob eine Kugel leer ist. Dafür wird beim ersten gefundenen Punkt in der Kugel die Suche abgebrochen.


=== Suche mit fester Anzahl

Bei dieser Suchanfrage wird für eine feste Anzahl $k$ die $k$-nächsten Punkte für ein bestimmtes Zentrum gesucht. Dafür werden die momentan $k$-nächsten Punkte gespeichert und nach Entfernung sortiert. Die Entfernung zum $k$-ten Punkt wird als Maximaldistanz verwendet. Solange noch nicht $k$ Punkte gefunden sind, kann $oo$ oder ein beliebiger Wert als Maximalabstand verwendet werden.

Es wird wieder von der Wurzel aus der Baum durchsucht. Bei jeder Unterteilung wird zuerst in der Hälfte vom Baum weiter gesucht, die das Zentrum enthält. Dabei werden die Punkte zu den besten Punkten hinzugefügt, die näher am Zentrum als die Maximaldistanz liegen. Sobald $k$ Punkte gefunden sind, wird dadurch die Maximaldistanz kleiner, weil der Punkte mit der alten Maximaldistanz nicht mehr zu den $k$-nächsten Punkten gehört.

Nachdem ein Teilbaum vollständig durchsucht ist, wird überprüft, ob Punkte aus dem anderen Teilbaum näher am Zentrum liegen können. Dafür wird der Abstand vom Zentrum zur Ebene bestimmt. Ist der Abstand größer als die Maximaldistanz, so kann kein Punkt näher am Zentrum liegen und der Teilbaum muss nicht weiter betrachtet werden.


=== Schnelle Suche

Sobald ein Teilbaum nur noch wenige Punkte beinhaltet, ist es langsamer zu überprüfen, welche Punkte näher sein können, als alle Punkte zu betrachten. Deshalb wird für Teilbäume mit weniger als $32$ Punkte die Punkte linear iteriert, wodurch Rekursion vermieden wird.


== Baum (Datenstruktur)

Ein Baum ermöglichen räumlich dünnbesetzte Daten effizient zu speichern. Dafür wird der Raum unterteilt, und nur für Bereiche mit Daten weitere Knoten gespeichert.


=== Konstruktion

Zuerst wird die räumliche Ausdehnung der Daten bestimmt. Dieser Bereich wird dem Root-Knoten zugeordnet. Solange noch zu viele Datenwerte im Bereich von einem Knoten liegen, wird dieser weiter unterteilt. Dafür wird der zugehörige Bereich entlang aller Dimensionen halbiert und jeder Teilbereich einem Kinderknoten zugeordnet. Bei einem Quadtree in 2D entstehen dadurch vier Kinderknoten und bei einem Octree in 3D acht Kinderknoten. Der Daten gehören nicht mehr zum unterteilten Knoten, sondern zu den Kinderknoten. Der unterteilte Knoten speichert stattdessen die Kinderknoten.

In @quadtree und @octree sind Beispiele in 2D und 3D gegeben.

#figure(
	caption: [Unterschiedliche Stufen von einem Quadtree.],
	cetz.canvas({
		import cetz.draw: *

		rect((0, 0), (2, 2), fill: blue)

		set-origin((5, 0))
		rect((0, 0), (2, 2), stroke: gray)
		rect((0, 0), (1, 1), fill: blue)
		rect((0, 1), (1, 2), fill: blue)
		rect((1, 1), (2, 2), fill: blue)

		set-origin((5, 0))
		rect((0, 0), (2, 2), stroke: gray)
		rect((0, 0), (1, 1), stroke: gray)
		rect((0, 1), (1, 2), stroke: gray)
		rect((1, 1), (2, 2), stroke: gray)
		rect((0.0, 0.0), (0.5, 0.5), fill: blue)
		rect((0.0, 0.5), (0.5, 1.0), fill: blue)
		rect((0.0, 1.0), (0.5, 1.5), fill: blue)
		rect((0.5, 1.0), (1.0, 1.5), fill: blue)
		rect((0.0, 1.5), (0.5, 2.0), fill: blue)
		rect((0.5, 1.5), (1.0, 2.0), fill: blue)
		rect((1.0, 1.5), (1.5, 2.0), fill: blue)
	}),
) <quadtree>

#figure(
	caption: [Unterschiedliche Stufen von einem Octree.],
	cetz.canvas({
		import cetz.draw: *
		let frontal((ax, ay, az), size, fill: black, stroke: black) = {
			line((ax + size, ay, az), (ax + size, ay + size, az), stroke: stroke)
			line((ax, ay + size, az), (ax + size, ay + size, az), stroke: stroke)
			line((ax + size, ay + size, az + size), (ax + size, ay + size, az), stroke: stroke)
		}
		let background((ax, ay, az), size, fill: black, stroke: black) = {
			line(
				(ax, ay, az),
				(ax + size, ay, az),
				(ax + size, ay, az + size),
				(ax + size, ay + size, az + size),
				(ax, ay + size, az + size),
				(ax, ay + size, az),
				close: true,
				fill: fill,
				stroke: stroke,
			)
		}
		let cube((ax, ay, az), size, fill: black, stroke: black) = {
			background((ax, ay, az), size, fill: fill, stroke: stroke)
			frontal((ax, ay, az), size, fill: fill, stroke: stroke)
		}

		cube((0, 0, 0), 2, fill: blue)

		set-origin((5, 0))
		background((0, 0, 0), 2, fill: auto, stroke: gray)
		cube((0, 0, 1), 1, fill: blue)
		cube((0, 0, 0), 1, fill: blue)
		cube((0, 1, 1), 1, fill: blue)
		cube((1, 1, 1), 1, fill: blue)
		frontal((0, 0, 0), 2, fill: auto, stroke: gray)

		set-origin((5, 0))
		background((0, 0, 0), 2, fill: auto, stroke: gray)
		cube((0, 0, 1.5), 0.5, fill: blue)
		cube((0, 0.5, 1.5), 0.5, fill: blue)
		cube((0, 1.0, 1.5), 0.5, fill: blue)
		cube((0.5, 1.0, 1.5), 0.5, fill: blue)
		cube((1.0, 1.0, 1.5), 0.5, fill: blue)
		cube((1.5, 1.0, 1.5), 0.5, fill: blue)
		cube((1.5, 1.0, 1.0), 0.5, fill: blue)
		cube((0, 0, 1.0), 0.5, fill: blue)
		cube((0, 0, 0.5), 0.5, fill: blue)
		cube((0.5, 0, 0.5), 0.5, fill: blue)
		cube((0, 0, 0), 0.5, fill: blue)
		frontal((0, 0, 0), 2, fill: auto, stroke: gray)
	}),
) <octree>


=== Suchanfrage

Bei einer Suchanfrage wird vom Root-Knoten aus der Leaf-Knoten gesucht, welche die gesuchte Position enthält. Dafür wird so lange der momentane Knoten ein Branch-Knoten ist berechnet, welcher der Kinderknoten die Position enthält und von diesem aus weiter gesucht.


== Messwerte vom Import <messwerte>

#let data = csv("../data/werte.tsv", delimiter: "\t")
#figure(
	table(
		align: (x, y) => if y == 0 { center } else { (left, left, right, right, right).at(x) },
		columns: 5,
		[#box(width: 2.2cm)[*Datensatz*]], [*Datei*], [*Daten#linebreak()Punkte*], [*Segment#linebreak()Punkte*], [*Detailstufen#linebreak()Punkte*],
		..data.slice(1).flatten(),
	),
	caption: [Messwerte (1).],
) <messwerte_1>

#let data = csv("../data/werte_2.tsv", delimiter: "\t")
#figure(
	table(
		align: (x, y) => if y == 0 { center } else { (left, right, right, right, right, right).at(x) },
		columns: 6,
		[#box(width: 2.2cm)[*Datensatz*]], [*Segmente*], [*Punkte#linebreak()Laden*], [*Segmentierung*], [*Berechnungen*], [*Detailstufen*],
		..data.slice(1).flatten(),
	),
	caption: [Messwerte (2).],
) <messwerte_2>
