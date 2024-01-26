#import "setup.typ": *


== Visualisierung


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

Für die gesamte Punktewolke wird ein Octree mit den Punkten erstellt. Der zugehörige Voxel vom Root-Knoten wird so gewählt, dass alle Punkte im Voxel liegen. Rekursiv wird der Voxel in acht gleichgroße Voxel geteilt, solange in einem Voxel noch zu viele Punkte liegen. Nach der Unterteilung gehört jeder Punkt im Datensatz zu genau einem Leaf-Knoten.

Für jeden Branch-Knoten wird eine Punktwolke berechnet, welche als Vereinfachung der Punkte der zugehörigen Kinderknoten verwendet werden kann.


==== Berechnung der Detailstufen

#todo[Kopiert vom Fachpraktikum]

Die Detailstufen werden wie bei "Fast Out-of-Core Octree Generation for Massive Point Clouds" @potree_lod von den Blättern des Baumes bis zur Wurzel berechnet. Dabei wird als Eingabe für einen Knoten die Detailstufen der direkten Kinder verwendet. Als Anfang werden alle originalen Punkte in einem Blatt als Eingabe benutzt.

Dadurch haben zwar Berechnungen der gröberen Detailstufen für Knoten näher an der Wurzel nur Zugriff auf bereits vereinfachte Daten, dafür müssen aber auch viel weniger Punkte bei der Berechnung betrachtet werden. Solange die Detailstufen eine gute Vereinfachung der ursprünglichen Punkte sind, kann so der Berechnungsaufwand stark verringert werden.

Der Voxel, welcher zu dem Knoten gehört, wird in eine feste Anzahl von gleichgroßen Teilvoxel unterteilt. Für jeden Teilvoxel werden alle Punkte kombiniert, die im Teilvoxel liegen. Aus den Punkten im Teilvoxel wird ein repräsentativer Punkt bestimmt. Weil die Anzahl der Teilvoxel unabhängig von der Größe vom Voxel ist, sind die Teilvoxel für gröbere Detailstufen größer und mehr Punkte werden kombinert.


=== Eye-Dome-Lighting

Um die Punktwolke anzuzeigen, werden die Punkte aus dem dreidimensionalen Raum auf den zweidimensionalen Monitor projiziert. Dabei gehen die Tiefeninformationen verloren. Mit der Rendertechnik *Eye-Dome-Lighting* werden die Kanten von Punkten hervorgehoben, bei denen die Tiefe sich stark ändert. Ein Veranschaulichung ist in @eye_dome_example gegeben.

#let boxed(p, caption: []) = subfigure(box(image(p), fill: rgb(35%, 49%, 58%), stroke: 1pt), caption: caption)

#figure(
	caption: [Waldstück mit und ohne Eye-Dome-Lighting. Die Punkte sind zusätzlich in Weiß angezeigt, um den Effekt hervorzuheben.],
	grid(
		columns: 2 * 1,
		gutter: 1em,
		boxed("../images/eye_dome_without.png", caption: [Ohne Eye-Dome-Lighting]),
		boxed("../images/eye_dome_with.png", caption: [Mit Eye-Dome-Lighting]),
		boxed("../images/eye_dome_white_without.png", caption: [Einfarbig ohne Eye-Dome-Lighting]),
		boxed("../images/eye_dome_white_with.png", caption: [Einfarbig mit Eye-Dome-Lighting]),
	),
) <eye_dome_example>

Der Effekt entsteht dadurch, dass für jedes Pixel der maximale Tiefenunterschied zu den umliegendenen Pixels bestimmt wird. Je größer der Unterschied, desto mehr wird das zugehörige Pixel verdunktelt.
