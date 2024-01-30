#import "setup.typ": *


== Visualisierung


=== Punkte

Grafikpipelines können Punkte, Linien oder Dreiecke rendern. Ein Punkt wird dabei mit genau einem Pixel angezeigt, dadurch können Datenpunkte unterschiedlich weit von der Kamera entfernt nicht unterschiedlich groß angezeigt werden. Um einen Datenpunkt anzuzeigen, wird deshalb ein ausgefüllter Kreis verwendet.

Um einen Kreis zu rendern, kann ein beliebiges Polygon gerendert werden, solange der Einheitskreis mit Zentrum $(0, 0)$ vollständig enthalten ist. Die Bereiche, welche außerhalb vom Kreis liegen, werden beim Rendern verworfen, wodurch nur der Kreis übrig bleibt. Je mehr Ecken das Polygon hat, desto kleiner ist der Bereich vom Polygon, der nicht zum Kreis gehört. Jede Ecke und der benötigte Bereich erhöhen den benötigten Arbeitsaufwand.


==== Mögliche Polygone

Das kleinste passende Dreieck ist ein gleichseitiges Dreieck. In @dreieck_größe ist die Konstruktor für die Seitenlänge gegeben. Ein mögliches Dreieck hat die Eckpunkte $(-tan(60°), -1)$, $(tan(60°), -1)$ und $(0, 2)$. Für das Dreieck werden dadurch drei Ecken und eine Fläche von $(w dot h) / 2 = (tan(60°) dot 2 dot 3) / 2 = tan(60°) dot 3 approx 5.2$ benötigt.

#figure(
	caption: [Seitenlänge für das kleinste gleichseitige Dreieck, welches den Einheitskreis enthält.],
	cetz.canvas(length: 2.0cm, {
		import cetz.draw: *

		let triangle() = {
			line((-1.73, -1), (0, -1), (0, 0), close: true)

			arc((-1.73, -1), start: 0deg, stop: 30deg, anchor: "origin", radius: 0.6)
			content((-1.45, -0.9), [$30°$], anchor: "west")

			arc((0, -1), start: 90deg, stop: 180deg, anchor: "origin", radius: 0.3)
			circle((-0.15, -0.85), radius: 0.01, fill: black)

			arc((0, 0), start: 210deg, stop: 270deg, anchor: "origin", radius: 0.5)
			content((-0.2, -0.2), [$60°$], anchor: "north")

			content((0, -0.5), [$1$], anchor: "west", padding: 0.05)
		}

		circle((0, 0), radius: 1)
		line((-1.73, -1), (-0.86, 0.5), (0, 0), close: true)
		triangle()

		content((-1.73 / 2, -1), [$x$], anchor: "north", padding: 0.1)
		content(((-1.73, -1), 0.9, (0, 0)), angle: 30deg, [$y$], anchor: "south", padding: 0.1)
		line((0, 0), (0, 2), (-0.86, 0.5))
		content(((0, 0), 1.2, (0, 2)), [$y$], anchor: "west", padding: 0.1)
		circle((0, 0), radius: 0.05, fill: black, stroke: none)

		set-origin((3, 0))

		triangle()

		content(((-1.73, -0.98), 1.0, (0, 0.02)), angle: 30deg, [$y = 1 / cos(60°) = 2$], anchor: "south", padding: 0.1)
		circle((0, 0), radius: 0.05, fill: black, stroke: none)

		content((-1.73 / 2, -1), [$x = tan(60°) approx 1,73$], anchor: "north", padding: 0.1)

	}),
) <dreieck_größe>

Das kleinste mögliche Viereck ist das Quadrat mit Seitenlänge $2$. In @vis_viereck_polygon ist die Konstruktion gegeben. Um diesen anzuzeigen, werden zwei Dreiecke benötigt. Für die beiden Dreiecke werden dadurch sechs Ecken und eine Fläche von $a^2 =2^2 = 4$ benötigt.

#figure(
	caption: [Seitenlänge für das kleinste Quadrat, welches den Einheitskreis enthält.],
	cetz.canvas(length: 2.0cm, {
		import cetz.draw: *

		line((-1, -1), (-1, 1), (1, 1), (1, -1), close: true)
		circle((0, 0), radius: 0.05, fill: black, stroke: none)
		circle((0, 0), radius: 1)
		line((-1, -1), (1, 1))
		line((-1, 0), (0, 0), (0, -1))
		content((-0.5, 0.0), $1$, anchor: "south", padding: 0.1)
		content((0.0, -0.5), $1$, anchor: "west", padding: 0.1)

	}),
) <vis_viereck_polygon>

Für Polygone mit mehr Ecken, wird der benötigte Bereich kleiner, es werden aber auch mehr Ecken benötigt.

#let boxed(p, caption: []) = subfigure(box(image(p), stroke: 1pt, clip: true), caption: caption)

#figure(
	caption: [Unterschiedliche Polygone und Kreise für das Anzeigen der Punkte.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		boxed("../images/point_triangle-crop.png", caption: [Dreiecke]),
		boxed("../images/point_quad-crop.png", caption: [Quadrate]),
		boxed("../images/point_circle-crop.png", caption: [Kreise]),
	),
)

// Ein Dreieck kann mit nur einem Dreieck dargestellt werden, für ein Quadrat werden zwei Dreiecke benötigt. benötigt. Für das Quadrat werden sechs Ecken und eine Fläche von $w * h = 2 * 2 = 4$ benötigt. In @dreieck_oder_quadrat ist ein grafischer Vergleich.

// #figure(
// 	caption: [Quadrat und Dreieck, welche den gleichen Kreis enthalten.],
// 	cetz.canvas({
// 		import cetz.draw: *

// 		line((-1, -1), (-1, 1), (1, 1), (1, -1), close: true, fill: red)
// 		circle((0, 0), radius: 1, fill: white)

// 		set-origin((5, 0))

// 		line((-1.73, -1), (1.73, -1), (0, 2), close: true, fill: red)
// 		circle((0, 0), radius: 1, fill: white)
// 	}),
// ) <dreieck_oder_quadrat>

// Durch die hohe Anzahl und kleine Fläche der Punkte, kann die Punktwolke mit dem Dreieck als Basis schneller angezeigt werden.


==== Anzeigen im dreidimensionalen Raum

Für jeden Punkt wird mit der Position $p$, Normalen $n$ und Größe $s$ die Position der Eckpunkte der Dreiecke im dreidimensionalen Raum bestimmt. Dafür werden zwei Vektoren bestimmt, welche paarweise zueinander und zur Normalen orthogonal sind.

Für den ersten Vektor $a$ wird mit der Normalen $n = (n_x, n_y, n_z)$ das Kreuzprodukt $a = (n_x, n_y, n_z) times (n_y, n_z, -n_x)$ bestimmt. Weil $|n| > 0$ ist, sind $(n_y, n_z, -n_x)$ und $n$ unterschiedlich. $a$ muss noch für die weiteren Berechnungen normalisiert werden. Für den zweiten Vektor $b$ wird das Kreuzprodukt $b = n times a$ bestimmt. Weil das Kreuzprodukt zweier Vektoren orthogonal zu beiden Vektoren ist, sind $n$, $a$ und $b$ paarweise orthogonal. Ein Beispiel ist in @dreieck_kreuzprodukt gegeben.

#figure(
	caption: [Beispiel für die Berechnung von $a$ und $b$ paarweise orthogonal zu $n$.],
	cetz.canvas(length: 2cm, {
		import cetz.draw: *

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
) <dreieck_kreuzprodukt>

Die Vektoren $a$ und $b$ spannen eine Ebene auf, welche orthogonal zu $n$ ist. Für den Eckpunkt $i$ vom Dreieck, mit den Koordinaten $(x_i, y_i)$, wird die Position $p_i = p + a * x_i * s + b * y_i * s$ berechnet werden. In @dreieck_eckpunkt ist die Berechnung dargestellt.

#figure(
	caption: [Berechnung von einem Eckpunkt.],
	cetz.canvas(length: 2cm, {
		import cetz.draw: *

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

		content((1.5 / 2, 0), [$x_i*s$], anchor: "north", padding: 0.1)
		content((0.4, 0.4), [$y_i*s$], anchor: "west", padding: 0.1)

		circle((0, 0), fill: black, radius: 0.0)
		circle((1.5 + 1.5 / 2, 1.5 / 2), fill: black, radius: 0.02)

		content((0, 0), [$p$], anchor: "east", padding: 0.1)
	}),
) <dreieck_eckpunkt>


=== Detailstufen

Je nach Scannertechnologie und Größe des abgetasteten Gebietes kann die Punktwolke unterschiedlich viele Punkte beinhalten. Durch Hardwarelimitierungen ist es nicht immer möglich, alle Punkte gleichzeitig anzuzeigen, während eine interaktive Wiedergabe gewährleistet ist.

Besonders für weit entfernte Punkt ist es nicht notwendig, alle Punkte genau wiederzugeben. Deshalb wird für weit entfernte Punkte eine vereinfachte Version angezeigt. Diese besteht aus weniger Punkten und benötigt dadurch weniger Ressourcen, bietet aber eine gute Approximation der ursprünglichen Daten.

#figure(
	caption: [Unterschiedliche Stuffen der Unterteilung. Jeder Würfel entählt bis zu $32768$ Punkte. In der letzen höchsten Stuffe werden alle Punkte im Datensatz angezeigt.],
	grid(
		columns: (3),
		gutter: 1em,
		subfigure(image("../images/lod_0-crop.png"), caption: [Stuffe 0]),
		subfigure(image("../images/lod_1-crop.png"), caption: [Stuffe 1]),
		subfigure(image("../images/lod_2-crop.png"), caption: [Stuffe 2]),
		subfigure(image("../images/lod_3-crop.png"), caption: [Stuffe 3]),
		subfigure(image("../images/lod_4-crop.png"), caption: [Stuffe 4]),
		subfigure(image("../images/lod_5-crop.png"), caption: [Stuffe 5]),
		subfigure(image("../images/lod_6-crop.png"), caption: [Stuffe 6]),
		subfigure(image("../images/lod_7-crop.png"), caption: [Stuffe 7]),
		subfigure(image("../images/lod_8-crop.png"), caption: [Stuffe 8]),
	),
)

Für die gesamte Punktewolke wird ein Octree mit den Punkten erstellt. Der zugehörige Voxel vom Root-Knoten wird so gewählt, dass alle Punkte im Voxel liegen. Rekursiv wird der Voxel in acht gleich große Voxel geteilt, solange in einem Voxel noch zu viele Punkte liegen. Nach der Unterteilung gehört jeder Punkt im Datensatz zu genau einem Leaf-Knoten.

Für jeden Branch-Knoten wird eine Punktwolke berechnet, welche als Vereinfachung der Punkte der zugehörigen Kinderknoten verwendet werden kann.


==== Berechnung der Detailstufen

#todo[Kopiert vom Fachpraktikum]

Die Detailstufen werden wie bei "Fast Out-of-Core Octree Generation for Massive Point Clouds" @potree_lod von den Blättern des Baumes bis zur Wurzel berechnet. Dabei wird als Eingabe für einen Knoten die Detailstufen der direkten Kinder verwendet. Als Anfang werden alle originalen Punkte in einem Blatt als Eingabe benutzt.

Dadurch haben zwar Berechnungen der gröberen Detailstufen für Knoten näher an der Wurzel nur Zugriff auf bereits vereinfachte Daten, dafür müssen aber auch viel weniger Punkte bei der Berechnung betrachtet werden. Solange die Detailstufen eine gute Vereinfachung der ursprünglichen Punkte sind, kann so der Berechnungsaufwand stark verringert werden.

Der Voxel, welcher zu dem Knoten gehört, wird in eine feste Anzahl von gleich großen Teilvoxel unterteilt. Für jeden Teilvoxel werden alle Punkte kombiniert, die im Teilvoxel liegen. Aus den Punkten im Teilvoxel wird ein repräsentativer Punkt bestimmt. Weil die Anzahl der Teilvoxel unabhängig von der Größe vom Voxel ist, sind die Teilvoxel für gröbere Detailstufen größer und mehr Punkte werden kombiniert.


=== Eye-Dome-Lighting

Um die Punktwolke anzuzeigen, werden die Punkte aus dem dreidimensionalen Raum auf den zweidimensionalen Monitor projiziert. Dabei gehen die Tiefeninformationen verloren. Mit der Rendertechnik *Eye-Dome-Lighting* werden die Kanten von Punkten hervorgehoben, bei denen die Tiefe sich stark ändert.

Beim Rendern von 3D-Scenen wird für jedes Pixel die momentane Tiefe vom Polygon an dieser Stelle gespeichert. Das wird benötigt, dass bei überlappenden Polygonen das nähere Polygon an der Kamera angezeigt wird. Nachdem die Szene gerendert ist, wird mit den Tiefeninformationen für jedes Pixel der Tiefenunterschied zu den umliegenden Pixeln bestimmt. Das Tiefenbild für die Veranschaulichung ist in @eye_dome_depth gegeben.

Je größer der Unterschied ist, desto stärker wird der Pixel im Ergebnisbild eingefärbt. Dadurch werden Kanten hervorgehoben, je nachdem wie groß der Tiefenunterschied ist.

#figure(
	caption: [Tiefenbild nach dem Rendern der Szene. Je heller eine Position ist, desto weiter ist das Polygon zugehörig zur Koordinate von der Kamera entfernt.],
	box(image("../images/eye_dome_depth_edited.png", width: 80%), stroke: 1pt),
) <eye_dome_depth>

Der Effekt entsteht dadurch, dass für jedes Pixel der maximale Tiefenunterschied zu den umliegenden Pixeln bestimmt wird. Je größer der Unterschied, desto mehr wird das zugehörige Pixel verdunkelt. Ein Veranschaulichung ist in @eye_dome_example gegeben.

#let boxed(p, caption: []) = subfigure(box(image(p), fill: rgb(35%, 49%, 58%), stroke: 1pt), caption: caption)

#figure(
	caption: [Waldstück mit und ohne Eye-Dome-Lighting. Die Punkte sind zusätzlich in Weiß angezeigt, um den Effekt hervorzuheben.],
	grid(
		columns: 2 * 1,
		gutter: 1em,
		boxed("../images/eye_dome_without.png", caption: [ohne Eye-Dome-Lighting]),
		boxed("../images/eye_dome_with.png", caption: [mit Eye-Dome-Lighting]),
		boxed("../images/eye_dome_white_without.png", caption: [einfarbig ohne Eye-Dome-Lighting]),
		boxed("../images/eye_dome_white_with.png", caption: [einfarbig mit Eye-Dome-Lighting]),
	),
) <eye_dome_example>
