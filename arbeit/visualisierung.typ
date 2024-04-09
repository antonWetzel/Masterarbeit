#import "setup.typ": *


= Visualisierung


== Punkte

Grafikpipelines haben mehrere primitive Formen, welche gerendert werden können. Die verfügbaren primitiven Formen sind meistens Punkte, Linien und Dreiecke, wobei Dreiecke immer verfügbar sind. Für das Anzeigen von komplizierter Modelle werden mehreren primitiven Formen zusammengesetzt.

Der primitive Punkt hat dabei keine Größe, sondern wird mit genau einem Pixel dargestellt. Um einen Punkt mit einer Größe anzeigen, werden Dreiecke als primitive Form verwendet. Bei einem Dreieck kann beliebige Eckpunkte haben und die Grafikpipeline färbt alle Pixel ein, welche zwischen den Eckpunkten liegen.

Um einen Kreis zu rendern, kann ein beliebiges Polygon gerendert werden, solange der gewünschte Kreis vollständig enthalten ist. Die Pixel, welche außerhalb vom Kreis liegen, werden beim Rendern verworfen, wodurch nur der Kreis übrig bleibt. Je mehr Ecken das Polygon hat, desto kleiner ist der Bereich vom Polygon, der nicht zum Kreis gehört. Jede Ecke und der benötigte Bereich erhöhen den benötigten Arbeitsaufwand.


=== Mögliche Polygone

Zuerst wird ein Kreis mit Position $(0, 0)$ und Radius $1$ benötigt. Mithilfe der Position vom Punkt und der Kamera wird der Kreis transformiert, dass die korrekten Pixel eingefärbt werden. In @visualisierung_polygon ist die Konstruktion für mögliche Polygone gegeben.

#figure(caption: [Seitenlänge für Polygone, welche den Einheitskreis enthalten.], grid(
	columns: 2,
	subfigure(
		caption: [Dreieck],
		cetz.canvas(length: 1.8cm, {
			import cetz.draw: *
			set-style(stroke: black)

			circle((0, 0), radius: 1, fill: silver)
			line((-1.73, -1), (-0.86, 0.5), (0, 0), close: true)
			line((-1.73, -1), (0, -1), (0, 0), close: true)
			line((0, -1), (1.73, -1), (0, 2), close: true)

			arc((-1.73, -1), start: 0deg, stop: 30deg, anchor: "origin", radius: 0.6)
			content((-1.45, -0.9), [$30°$], anchor: "west")

			arc((0, -1), start: 90deg, stop: 180deg, anchor: "origin", radius: 0.3)
			circle((-0.15, -0.85), radius: 0.01, fill: black)

			arc((0, 0), start: 210deg, stop: 270deg, anchor: "origin", radius: 0.5)
			content((-0.2, -0.2), [$60°$], anchor: "north")

			content((0, -1), $w = 2 dot tan(60°) approx 3,46$, anchor: "north", padding: 0.1)
			line((0, 0), (0, 2), (-0.86, 0.5))
			content((0, 0), $h = 1 + 1 / cos(60°) = 3$, angle: 90deg, anchor: "north", padding: 0.1)
			circle((0, 0), radius: 0.05, fill: black, stroke: none)
		}),
	), subfigure(
		caption: [Quadrat],
		cetz.canvas(length: 1.8cm, {
			import cetz.draw: *
			set-style(stroke: black)

			line((-1, -1), (-1, 1), (1, 1), (1, -1), close: true)
			circle((0, 0), radius: 1, fill: silver)
			circle((0, 0), radius: 0.05, fill: black, stroke: none)
			line((-1, -1), (1, 1))
			line((-1, 0), (0, 0), (0, -1))
			content((-0.5, 0.0), $1$, anchor: "south", padding: 0.1)
			content((0.0, -0.5), $1$, anchor: "west", padding: 0.1)
			content((0, -1), $a = 2$, anchor: "north", padding: 0.1)
		}),
	),
)) <visualisierung_polygon>

Das kleinste passende Dreieck ist ein gleichseitiges Dreieck. Ein mögliches Dreieck hat die Eckpunkte $(-tan(60°), -1)$, $(tan(60°), -1)$ und $(0, 2)$. Für das Dreieck werden drei Ecken und eine Fläche von $(w dot h) / 2 = (tan(60°) dot 2 dot 3) / 2 = tan(60°) dot 3 approx #number(5.2)$ benötigt.

Das kleinste mögliche Viereck ist das Quadrat mit Seitenlänge $2$. Um diesen anzuzeigen, wird das Quadrat entlang der Diagonalen in zwei Dreiecke unterteilt. Für die beiden Dreiecke werden sechs Ecken und eine Fläche von $a^2 =2^2 = 4$ benötigt.

In @visualiserung_vergleich_polygon ist ein Vergleich für eine Punktwolke gerendert mit unterschiedlichen Polygonen. Für Polygone mit mehr Ecken, wird der benötigte Bereich kleiner, es werden aber auch mehr Ecken benötigt.

#let boxed(p, caption: []) = subfigure(box(image(p), stroke: 1pt, clip: true), caption: caption)

#figure(
	caption: [Eine Punktwolke mit einem Polygonen oder Kreis für jeden Punkt.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		boxed("../images/crop/point_triangle.png", caption: [Dreiecke]),
		boxed("../images/crop/point_quad.png", caption: [Quadrate]),
		boxed("../images/crop/point_circle.png", caption: [Kreise]),
	),
) <visualiserung_vergleich_polygon>


=== Anzeigen im dreidimensionalen Raum

Für jeden Punkt wird mit der Position $p$, Normalen $n$ und Größe $s$ und den Koordinaten $(x_i, y_i)$ vom Eckpunkt $i$ wird die zugehörige Position im dreidimensionalen Raum bestimmt. Wie in @dreieck_kreuzprodukt werden zuerst zwei Vektoren bestimmt, welche paarweise zueinander und zur Normalen orthogonal sind. Mit den Vektoren wird dann die dreidimensionale Position vom Eckpunkt berechnet.

#figure(caption: [Transformation der Eckpunkte mit der Normalen.], grid(
	columns: 2,
	subfigure(
		caption: [$a$ und $b$ berechnen],
		cetz.canvas(length: 2cm, {
			import cetz.draw: *
			set-style(stroke: black)

			let test((x, y, z), name: "", paint: gray) = {
				let l = x * x + y * y + z * z
				let l = calc.sqrt(l) / 2
				let x = x / l
				let y = y / l
				let z = z / l

				line((x, 0, 0), (x, 0, z), (0, 0, z), stroke: (paint: paint, dash: "dashed"))
				line((x, 0, z), (x, y, z), stroke: (paint: paint, dash: "dashed"))
				line((0, 0, 0), (x + z / 2, y + z / 2), stroke: paint, mark: (end: ">", fill: paint), name: name)
			}

			test((-56, -182, 70), name: "b", paint: red)
			content("b.end", [$b$], anchor: "east", padding: 0.1)

			test((-28, 14, 14), name: "a", paint: green)
			content("a.end", [$a$], anchor: "east", padding: 0.1)

			test((3, 1, 5), name: "n", paint: black)
			content("n.end", [$n$], anchor: "west", padding: 0.1)

			line((-2, 0, 0), (2, 0, 0), stroke: gray + 2pt, mark: (end: ">", fill: gray), name: "x")
			line((0, -2, 0), (0, 2, 0), stroke: gray + 2pt, mark: (end: ">", fill: gray), name: "y")
			line((-1, -1), (1, 1, 0), stroke: gray + 2pt, mark: (end: ">", fill: gray), name: "z")
			content("x.end", [$x$], anchor: "north", padding: 0.1)
			content("y.end", [$y$], anchor: "west", padding: 0.1)
			content("z.end", [$z$], anchor: "west", padding: 0.1)

			test((1, 5, -3), name: "n_m", paint: blue)
			content("n_m.end", [$(n_y, n_z, -n_x)$], anchor: "south", padding: 0.1)
		}),
	), subfigure(
		caption: [Eckpunkt berechnen],
		cetz.canvas(length: 2cm, {
			import cetz.draw: *
			set-style(stroke: black)

			line((0, 0, 0), (0, 1, 0), mark: (end: ">", fill: black), name: "n")
			line((0, 0, 0), (2, 0, 0), mark: (end: ">", fill: black), name: "a")
			line((0, 0), (1, 1), mark: (end: ">", fill: black), name: "b")

			content("n.end", [$n$], padding: 0.1, anchor: "east")
			content("a.end", [$a$], padding: 0.1, anchor: "north")
			content("b.end", [$b$], padding: 0.1, anchor: "west")

			line((0, 0, 0), (0, 0, 1.5), stroke: green + 2pt)
			line((0, 0, 0), (1.5, 0, 0), stroke: red + 2pt)
			line((0, 0, 1.5), (1.5 + 1.5 / 2, 1.5 / 2), (1.5, 0, 0), stroke: (dash: "dashed"))

			content((1.5 + 1.5 / 2, 1.5 / 2), [$p_i$], padding: 0.1, anchor: "west")

			content((1.5 / 2, 0), [$x_i dot s$], anchor: "north", padding: 0.1)
			content((0.4, 0.4), [$y_i dot s$], anchor: "west", padding: 0.1)

			circle((0, 0), fill: black, radius: 0.0)
			circle((1.5 + 1.5 / 2, 1.5 / 2), fill: black, radius: 0.02)

			content((0, 0), [$p$], anchor: "east", padding: 0.1)
		}),
	)
)) <dreieck_kreuzprodukt>

Für den ersten Vektor $a$ wird mit der Normalen $n = (n_x, n_y, n_z)$ das Kreuzprodukt $a = (n_x, n_y, n_z) times (n_y, n_z, -n_x)$ bestimmt. Weil $|n| > 0$ ist, sind $(n_y, n_z, -n_x)$ und $n$ unterschiedlich. $a$ muss noch für die weiteren Berechnungen normalisiert werden. Für den zweiten Vektor $b$ wird das Kreuzprodukt $b = n times a$ bestimmt. Weil das Kreuzprodukt zweier Vektoren orthogonal zu beiden Vektoren ist, sind $n$, $a$ und $b$ paarweise orthogonal. Ein Beispiel ist in @dreieck_kreuzprodukt gegeben.

Die Vektoren $a$ und $b$ spannen dadurch eine Ebene auf, welche orthogonal zu $n$ ist. Für den Eckpunkt vom Dreieck wird die Position $p_i = p + a * x_i * s + b * y_i * s$ berechnet.


== Detailstufen

Je nach Scanner und Größe des abgetasteten Gebietes kann die Punktwolke unterschiedlich viele Punkte beinhalten. Durch Hardwarelimitierungen ist es nicht immer möglich, alle Punkte gleichzeitig anzuzeigen, während eine interaktive Wiedergabe gewährleistet ist.

Besonders für weit von der Kamera entfernte Punkte ist es nicht notwendig, alle Punkte genau anzuzeigen. Deshalb wird für weit entfernte Punkte eine vereinfachte Version berechnet und anstelle der originalen Punkte verwendet. Diese besteht aus weniger Punkten und benötigt dadurch weniger Ressourcen.

Für die gesamte Punktwolke wird ein Octree mit den Punkten erstellt. Am Anfang besteht der Octree aus einem Leaf-Knoten und die Punkte zum Octree hinzugefügt. Dafür wird der Leaf-Knoten bestimmt, der zur Position vom Punkt gehört. Enthält der Leaf-Knoten weniger Punkte als die festgelegte Maximalanzahl, so wird der Punkt zum Knoten hinzugefügt. Wenn der Leaf-Knoten bereits voll ist, so wird dieser unterteilt. Der Leaf-Knoten wird in acht Kinderknoten unterteilt und die Punkte vom Leaf-Knoten werden auf die Kinderknoten verteilt, wodurch der Leaf-Knoten zum Branch-Knoten wird. Für die Unterteilung wird der Knoten entlang der x-, y- und z-Achse in der Mitte geteilt.

Alle Punkte gehören nach der Unterteilung zu einem Leaf-Knoten im Octree. Für jeden Branch-Knoten wird dann eine Punktwolke berechnet, welche als Vereinfachung der Punkte der zugehörigen Kinderknoten verwendet werden kann. In @visualiserung_lods sind die unterschiedlichen Stufen vom Octree mit zugehörigen Detailstufen visualisiert.

#figure(
	caption: [Unterschiedliche Detailstufen. Jeder Würfel enthält bis zu $32768$ Punkte. In der höchsten Stufe werden alle Punkte im Datensatz angezeigt.],
	box(width: 90%, grid(
		columns: (3),
		gutter: 1em,
		subfigure(image("../images/crop/lod_0.png"), caption: [Stufe 0]),
		subfigure(image("../images/crop/lod_1.png"), caption: [Stufe 1]),
		subfigure(image("../images/crop/lod_2.png"), caption: [Stufe 2]),
		subfigure(image("../images/crop/lod_3.png"), caption: [Stufe 3]),
		subfigure(image("../images/crop/lod_4.png"), caption: [Stufe 4]),
		subfigure(image("../images/crop/lod_5.png"), caption: [Stufe 5]),
		subfigure(image("../images/crop/lod_6.png"), caption: [Stufe 6]),
		subfigure(image("../images/crop/lod_7.png"), caption: [Stufe 7]),
		subfigure(image("../images/crop/lod_8.png"), caption: [Stufe 8]),
	)),
) <visualiserung_lods>


=== Berechnung der Detailstufen

Die Detailstufen werden wie bei "Fast Out-of-Core Octree Generation for Massive Point Clouds" @potree_lod von den untersten Branch-Knoten bis zum Root-Knoten berechnet. Dabei wird mit den Detailstufen der Kinderknoten die Detailstufe für den momentanen Knoten berechnet.

Dadurch haben zwar Berechnungen der gröberen Detailstufen für Knoten näher an der Wurzel nur Zugriff auf bereits vereinfachte Daten, aber die Anzahl der Punkte, mit denen die Detailstufe berechnet wird, ist viel kleiner. Solange die Detailstufen eine gute Vereinfachung der ursprünglichen Punkte sind, kann so der Berechnungsaufwand stark verringert werden.

Für die Berechnung einer Detailstufe wird der Voxel, welcher zu dem Knoten gehört, in eine feste Anzahl von gleich großen Teilvoxeln unterteilt. Für jeden Teilvoxel werden zuerst alle Punkt aus den Kinderknoten bestimmt, welche im Teilvoxel liegen. Liegt kein Punkt im Teilvoxel, so wird dieser übersprungen. Aus den Punkten im Teilvoxel wird ein repräsentativer Punkt bestimmt. Dafür werden Position, Normale und Größe gemittelt und die Eigenschaften von einem der Punkte übernommen. Die Detailstufe besteht aus allen repräsentativen Punkten für die Teilvoxel, welche nicht leer waren.

Bei der nächst gröberen Detailstufe ist der Voxel vom Branch-Knoten doppelt so groß. Durch die feste Anzahl der Teilvoxel verdoppelt sich auch die Größe der Teilvoxel, wodurch die Punkte weiter vereinfacht werden.


== Eye-Dome Lighting

Um die Punktwolke anzuzeigen, werden die Punkte aus dem dreidimensionalen Raum auf den zweidimensionalen Monitor projiziert. Dabei gehen die Tiefeninformationen verloren. Mit der Rendertechnik Eye-Dome Lighting werden die Kanten von Punkten hervorgehoben, bei denen die Tiefe sich stark ändert.

Beim Rendern von 3D-Szenen wird für jedes Pixel die momentane Tiefe vom Polygon an dieser Stelle gespeichert. Das wird benötigt, dass bei überlappenden Polygonen das nähere Polygon an der Kamera angezeigt wird. Nachdem die Szene gerendert ist, wird mit den Tiefeninformationen für jedes Pixel der Unterschied zu den umliegenden Pixeln bestimmt. Ein Beispiel für die Tiefeninformationen ist in @eye_dome_depth gegeben.

#figure(
	caption: [Tiefeninformationen nach dem Rendern der Szene. Je heller eine Position ist, desto weiter ist das Polygon zugehörig zur Koordinate von der Kamera entfernt.],
	box(image("../images/eye_dome_depth_edited.png", width: 80%), stroke: 1pt),
) <eye_dome_depth>

Der Effekt entsteht dadurch, dass für jedes Pixel der maximale Unterschied in der Tiefe zu den umliegenden Pixeln bestimmt wird. Je größer der Unterschied, desto mehr wird das zugehörige Pixel verdunkelt. Eine Veranschaulichung ist in @eye_dome_example gegeben.

#let boxed(p, caption: []) = subfigure(box(image(p), fill: rgb(35%, 49%, 58%), stroke: 1pt), caption: caption)

#figure(
	caption: [Waldgebiet mit und ohne Eye-Dome Lighting. Die Punkte sind zusätzlich in Weiß angezeigt, um den Effekt hervorzuheben.],
	grid(
		columns: 2 * 1,
		gutter: 1em,
		boxed("../images/eye_dome_without.png", caption: [Ohne Eye-Dome Lighting]),
		boxed("../images/eye_dome_with.png", caption: [Mit Eye-Dome Lighting]),
		boxed("../images/eye_dome_white_without.png", caption: [Einfarbig ohne Eye-Dome Lighting]),
		boxed("../images/eye_dome_white_with.png", caption: [Einfarbig mit Eye-Dome Lighting]),
	),
) <eye_dome_example>
