#import "setup.typ": *


= Appendix


== Glossar

/ Koordinatensystem: ist eine Menge von Achsen, mit den eine Position genau beschrieben werden kann. Für kartesische Koordinaten ist die x-Achse nach rechts, die y-Achse nach oben und die z-Achse nach hinten orientiert.
/ Punkt: ist die Kombination von einer dreidimensionalen Position und zusätzlichen Informationen.
/ Punktwolke: ist eine Menge von Punkten. Für alle Punkte sind die gleichen zusätzlichen Informationen vorhanden.
/ Normale: ist ein normalisierter dreidimensionaler Vektor, welcher die Orientierung einer Oberfläche von einem Objekt angibt. Der Vektor ist dabei orthogonal zur Oberfläche, kann aber in das Objekt oder aus dem Objekt gerichtet sein.

/ Voxel: ist ein Würfel im dreidimensionalen Raum. Die Position und Größe vom Voxel kann explizit abgespeichert oder relativ zu den umliegenden Voxeln bestimmt werden.
/ Tree: ist eine Datenstruktur, bestehend aus Knoten, welche wiederum Kinderknoten haben können. Die Knoten selber können weitere Informationen enthalten. Die Knoten sind eindeutig sortiert, wodurch ein Knoten niemals Kinderknoten oder indirekter Kinderknoten von sich selbst ist.
/ Octree: ist eine Tree, bei dem ein Knoten acht Kinderknoten haben kann. Mit einem Octree kann ein Voxel aufgeteilt werden. Jeder Knoten gehört dabei zu einem Voxel, welcher gleichmäßig mit den Kinderknoten weiter unterteilt wird.
/ Leaf-Knoten: ist ein Knoten, welcher keine weiteren Kinderknoten hat. Für Punktwolken gehört jeder Punkt zu genau einem Leaf-Knoten.
/ Branch-Knoten: ist ein Knoten, welcher weitere Kinderknoten hat.
/ Root-Knoten: ist der erste Knoten im Tree, alle anderen Knoten sind direkte oder indirekte Kinderknoten vom Root-Knoten.
/ KD-Baum: ist eine Datenstruktur, um im $k$-dimensionalen Raum für eine Position die nächsten Punkte zu bestimmen.
/ Greedy-Algorithmus: ist eine Kategorie von Algorithmen, bei denen das Ergebnis schrittweise berechnet wird. Bei jedem Schritt wird mit den momentanen Informationen die beste Entscheidung getroffen, wodurch das Ergebnis schnell, aber meist nicht global optimal berechnet wird.

#pagebreak(weak: true)


== KD-Baum <kd_baum>

Für eine Menge von Punkten kann ein KD-Baum berechnet werden. Mit diesem kann effizient bestimmt werden, welche Punkte innerhalb einer Kugel mit beliebiger Position und Radius liegen. Ein Beispiel für einen KD-Baum ist in @appendix_kd_baum gegeben. Für jede Unterteilung ist die Trenngerade mit weniger Punkten gezeichnet. Weil der rote Kreis vollständig links der ersten Unterteilung ist, müssen die Punkte rechts nicht betrachtet werden.

#figure(
	caption: [
		KD-Baum für Punkte in 2D.
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
) <appendix_kd_baum>


=== Konstruktion

Für die Konstruktion von einem KD-Baum werden nur die Positionen der Punkte benötigt.

Zuerst wird für die Punkte entlang der ersten Dimension der Median bestimmt. Dabei wird der _Quickselect_-Algorithmus @quickselect verwendet. Der Median hat als Index die halbe Anzahl der Punkte. Ist die Anzahl der Punkte ungerade, so kann der Index auf- oder abgerundet werden, solange bei der Suche die gleiche Strategie verwendet wird. Wie beim _Quicksort_-Algorithmus wird ein beliebiges Pivot-Element ausgewählt, mit diesem die Positionen entlang der Dimension unterteilt werden. Die Positionen werden einmal iteriert und kleinere Positionen vor dem Pivot und größere Positionen nach dem Pivot verschoben. Der Pivot ist am Index, wo es in der sortierten Liste wäre. Um den Median zu finden, wird nur der Teil von den Punkten weiter betrachtet, welcher den Median beinhaltet. Die Unterteilung wird so lange wiederholt, bis der Bereich nur noch einem Punkt enthält und der Median bekannt ist.

Durch den _Quickselect_-Algorithmus sind die Positionen nach der Bestimmung vom Median in kleine und größere Positionen unterteilt. Die Ebene durch den Punkt teilt dabei den Raum und alle Punkte mit kleinerem Index liegen auf der anderen Seite als die Punkte mit größerem Index. Die beiden Hälften werden in der gleichen Weise unterteilt. Dabei wird die nächste, beziehungsweise für die letzte Dimension wieder die erste Dimension verwendet.

Der zugehörige Binärbaum muss nicht gespeichert werden, da dieser implizit entsteht. Für jede Unterteilung wird die Position vom Median gespeichert, weil diese für die Suchanfragen benötigt werden.


=== Suche mit festem Radius

Bei dieser Suchanfrage werden alle Punkte gesucht, welche in einer Kugel mit bekanntem Zentrum und Radius liegen. Von dem Root-Knoten aus wird der Baum dabei durchsucht. Bei jeder Unterteilung wird dabei überprüft, wie die Kugel zur teilenden Ebene liegt. Ist die Kugel vollständig auf einer Seite, so muss nur der zugehörige Teilbaum weiter durchsucht werden. Liegen Teile der Kugel auf beiden Seiten, so müssen beide Teilbäume weiter durchsucht werden.

Dabei wird bei jeder Unterteilung überprüft, ob der zugehörige Punkt in der Kugel liegt und wird gegebenenfalls zum Ergebnis hinzugefügt.

Mit der gleichen Methode kann effizient bestimmt werden, ob eine Kugel leer ist. Dafür wird beim ersten gefundenen Punkt in der Kugel die Suche abgebrochen.


=== Suche mit fester Anzahl

Bei dieser Suchanfrage wird für eine feste Anzahl $k$ die $k$-nächsten Punkte für ein bestimmtes Zentrum gesucht. Dafür werden die momentan $k$-nächsten Punkte gespeichert und nach Entfernung sortiert. Die Entfernung zum $k$-ten Punkt wird als Maximaldistanz verwendet. Solange noch nicht $k$ Punkte gefunden sind, kann unendlich oder ein beliebiger Wert als Maximalabstand verwendet werden.

Es wird wieder vom Root-Knoten aus der Baum durchsucht. Bei jeder Unterteilung wird zuerst in der Hälfte vom Baum weiter gesucht, die das Zentrum enthält. Dabei werden die Punkte zu den besten Punkten hinzugefügt, die näher am Zentrum als die Maximaldistanz liegen. Sobald $k$ Punkte gefunden sind, wird dadurch die Maximaldistanz kleiner, weil der Punkte mit der alten Maximaldistanz nicht mehr zu den $k$-nächsten Punkten gehört.

Nachdem ein Teilbaum vollständig durchsucht ist, wird überprüft, ob Punkte aus dem anderen Teilbaum näher am Zentrum liegen können. Dafür wird der Abstand vom Zentrum zur Ebene bestimmt. Ist der Abstand größer als die momentane Maximaldistanz, so kann kein Punkt näher am Zentrum liegen und der Teilbaum muss nicht weiter betrachtet werden.


=== Verbesserte Suche für kleine Teilbäume

Sobald ein Teilbaum nur noch wenige Punkte beinhaltet, ist es langsamer zu überprüfen, welche Punkte näher sein können, als alle Punkte zu betrachten. Deshalb wird für Teilbäume mit weniger als #number(32) Punkte die Punkte linear iteriert, wodurch Rekursion vermieden wird.

#pagebreak(weak: true)


== Baum (Datenstruktur)

Ein Baum ermöglichen räumlich dünnbesetzte Daten effizient zu speichern. Dafür wird der Raum unterteilt, und nur für Bereiche mit Daten weitere Knoten gespeichert.


=== Konstruktion

Zuerst wird die räumliche Ausdehnung der Daten bestimmt. Dieser Bereich wird dem Root-Knoten zugeordnet. Solange noch zu viele Datenwerte im Bereich von einem Knoten liegen, wird dieser weiter unterteilt. Dafür wird der zugehörige Bereich entlang aller Dimensionen halbiert und jeder Teilbereich einem Kinderknoten zugeordnet. Bei einem Quadtree in 2D entstehen dadurch vier Kinderknoten und bei einem Octree in 3D acht Kinderknoten. Die Daten vom Knoten werden auf die Kinderknoten aufgeteilt. Der unterteilte Knoten speichert stattdessen die Kinderknoten.

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

Bei einer Suchanfrage wird vom Root-Knoten aus der Leaf-Knoten gesucht, welcher die gesuchte Position enthält. Am Anfang wird der Root-Knoten als momentaner Knoten verwendet. Solange der momentane Knoten ein Branch-Knoten ist, wird der Kinderknoten gesucht, welcher die Position enthält und als neuer momentaner Knoten verwendet. Wenn der momentane Knoten ein Leaf-Knoten ist, wurde der gesuchte Leaf-Knoten gefunden.


== Systemeigenschaften <systemeigenschaften>

#figure(
	caption: [Überblick über die Systemeigenschaften],
	table(
		columns: (1fr, 2fr),
		align: (left, right),
		[Betriebssystem], [Windows 11],
		[Prozessor],      [Intel(R) Core(TM) i7-9700KF CPU \@ 3.60 GHz],
		[Grafikkarte],    [NVIDIA GeForce GTX 1660 SUPER],
		[RAM],            [2 x G.Skill F4-3200C16-8GIS],
		[Festplatte],     [SanDisk SSD PLUS 2000GB],
	),
)

#figure(
	caption: [Prozessoreigenschaften],
	table(
		columns: (1fr, 2fr),
		align: (left, right),
		[Physische Kerne],         $8$,
		[Logische Kerne],          $8$,
		[Maximale Taktrate],       [#number(4.6) GHz],
		[Cachegröße (L1, L2, L3)], [$512 "KiB"$, $2 "MiB"$, $12 "MiB"$],
	),
)

#figure(
	caption: [Grafikkarteneigenschaften],
	table(
		columns: (1fr, 2fr),
		align: (left, right),
		[Basistaktung],          $1530 "Mhz"$,
		[Boost-Taktung],         $1785 "Mhz"$,
		[Speicherkonfiguration], $6 "GB GDDR6"$,
		[Speicherschnittstelle], $192 "Bit"$,
	),
)

#figure(
	caption: [RAM-Eigenschaften],
	table(
		columns: (1fr, 2fr),
		align: (left, right),
		[Größe],    $2 times 8 "GiB"$,
		[Taktrate], $2133 "MHz"$,
	),
)

#figure(
	caption: [Sequenzielle Lese- und Schreibgeschwindigkeit der Festplatte mit $4 "KiB"$ Blöcken für unterschiedliche Dateigrößen.],
	table(
		columns: (1fr, 1fr, 1fr, 1fr),
		align: (left, right, right, right),
		[*Aktion*],  [*1 GiB*],      [*5 GiB*],      [*10 GiB*],
		[Lesen],     $776 "MiB/s"$,  $384 "MiB/s"$,  $218 "MiB/s"$,
		[Schreiben], $1739 "MiB/s"$, $1929 "MiB/s"$, $270 "MiB/s"$,
	),
)


== Messwerte vom Import <messwerte>

#[
	#set text(size: 0.8em)
	#set par(justify: false)
	#let data = csv("../data/werte.tsv", delimiter: "\t")
	#figure(
		table(
			align: (x, y) => if y == 0 { center } else { (left, left, right, right, right).at(x) },
			columns: (1fr, 2.5fr, 1fr, 1fr, 1.2fr),
			[#box(width: 2.2cm)[*Datensatz*]], [*Datei*], [*Daten*#linebreak() (Punkte)], [*Segmente* (Punkte)], [#box[*Detailstufen*]#linebreak() (Punkte)],
			..data.flatten(),
		),
		caption: [Messwerte (Verwendete Datei und Punktanzahl).],
	) <messwerte_1>

	#let data = csv("../data/werte_2.tsv", delimiter: "\t")
	#figure(
		table(
			align: (x, y) => if y == 0 { center } else { (left, right, right, right, right, right).at(x) },
			columns: (1fr, 1fr, 1fr, 1.5fr, 1fr, 1fr),
			[#box(width: 2.2cm)[*Datensatz*]], [*Segmente* (Anzahl)], [*Laden* (Sekunden)], [*Segmentierung* (Sekunden)], [*Analyse* (Sekunden)], [*Detailstufen* (Sekunden)],
			..data.flatten(),
		),
		caption: [Messwerte (Anzahl Segmente und Importgeschwindigkeit).],
	) <messwerte_2>
]
