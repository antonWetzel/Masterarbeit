#import "setup.typ": *

#part([Visualisierung])


= Technik

- Rust
- WebGPU (wgpu)
- native Window (website?)
- LAS/LAZ


= Punkt


== Dreieck

Als Basis für einen Punkt wird ein Dreieck gerendert. Das Dreieck hat die Eckpunkte $(-1.73, -1)$, $(1.73, -1)$ und $0, 2$, wodurch der Kreis mit Radius $1$ und Zentrum $(0, 0)$ vollständig im Dreieck liegt.

#todo[Warum die Ecken, schöner aufschreiben]

Für jeden Punkt wird mit der Position $p$, Normalen $n$ und Größe $s$ die Position der Eckpunkte vom Dreieck im dreidimensionalen Raum bestimmt. Dafür werden zwei Vektoren bestimmt, welche paarweise zueinander und zur Normalen orthogonal sind.

Für den erste Vektor $a$ wird mit der Normalen $n = (n_x, n_y, n_z)$ das Kreuzprodukt $a = (n_x, n_y, n_z) times (n_y, n_z, -n_x)$ bestimmt. Weil $|n| > 0$ ist, sind $(n_y, n_z, -n_x)$ und $n$ nicht gleich. $a$ muss noch für die weiteren Berechnungen normalisiert werden.

Für den zweiten Vektor $b$ wird das Kreuzprodukt $b = n times a$ bestimmt. Weil das Kreuzprodukt zweier Vektoren orthogonal zu beiden Vektoren ist, sind $n$, $a$ und $b$ paarweise orthogonal.

#todo[Bild Vektoren und Kreuzprodukt]

Die Vektoren $a$ und $b$ spannen eine Ebene auf, welche orthogonal zu $n$ ist. Für den Eckpunkt $i$ vom Dreieck mit den Koordinaten $(x, y)$, wird die Position $p_i = p + a * x * s + b * y * s$ berechnet werden.


== Vergleich zu Quad

#todo[Vergleich Quad oder Dreieck als Basis]

- triangle als Basis
	- weniger Verticies (3 zu 6)
	- mehr Fragment (4.0 zu 5.19615242270663)
	- schneller als Quad


== Instancing

Weil für alle Punkte das gleiche Dreieck als Basis verwendet wird, muss dieses nur einmal zur Grafikkarte übertragen werden. Mit *Instancing* wird das gleiche Dreieck für alle Punkte verwendet, während nur die Daten spezifisch für einen Punkt sich ändern.


== Kreis

Die Grafikpipeline bestimmt alle Pixel, welche im transformierten Dreieck liegen. Für jeden Pixel kann entschieden werden, ob dieser im Ergebnis gespeichert wird. Dafür wird bei den Eckpunkten die untransformierten Koordinaten abgespeichert, dass diese später verfügbar sind. Für jeden Pixel wird von der Pipeline die interpolierten Koordinaten berechnet. Nur wenn der Betrag der interpolierten Koordinaten kleiner $1$ ist, wird der Pixel im Ergebnis abgespeichert.

#stack(
	dir: ltr,
	image("../images/point-triangle.png", width: 50%),
	image("../images/point-circle.png", width: 50%),
)

#todo[Bilder Crop]


= Dynamische Eigenschaft

- eigenschaften als $32$ bit unsigned integer
- look up table für farbe basierend auf eigenschaftwert


= Subpunktwolken (Bäume)

#stack(
	dir: ltr,
	image("../images/segment_1.png", height: 30%),
	image("../images/segment_2.png", height: 30%),
)

#todo(prefix: [Note], [Oben/Unten Teilung in 2 Segmente für Debug])


== Selektion (Raycast)

- von root bis leaf
- bestimme intersection mit knoten
- wenn leaf mit intersection gefunden
	- lade Segmente, welche im Leaf liegen
	- bestimme Abstand Ray-Punkt
	- wenn kleiner als Radius hit
	- Segment mit Punkt mit geringstem Abstand Ergebnis


== Anzeige

- segmente seperate abgespeichert
	- keine LOD Stufen, nur Originalpunkte
	- maxbuffersize?


= Eye-Dome-Lighting

Um die Punktwolke auf Anzuzeigen, werden die Punkte aus dem dreidimensionalen Raum auf den zweidimensionalen Monitor projiziert. Dabei gehen die Tiefeninformationen verloren. Mit der Rendertechnik *Eye-Dome-Lighting* werden die Kanten von Punkten hervorgehoben, bei denen die Tiefe sich stark ändert.

#todo[Vergleichsbild]

Beim Rendern von 3D-Scenen wird für jeden Pixel die momentane Tiefe vom Polygon an dieser Stelle gespeichert. Das wird benötigt, dass bei überlappenden Polygonen das nähere Polygon an der Kamera angezeigt wird. Nachdem die Scene gerendert ist, wird mit den Tiefeninformationen für jeden Pixel der Tiefenunterschied zu den umliegenden Pixeln bestimmt.

#todo[Farb- und Tiefenbild]

Je größer der Unterschied ist, desto stärker wird der Pixel im Ergebnisbild eingefärbt. Dadurch werden Kanten hervorgehoben, je nachdem wie groß der Tiefenunterschied ist. Für den Effekt kann die Stärke und die Farbe angepasst werden.

#todo[Stark und Schwache Effekt Bild]


= Detailstufen

Je nach Scannertechnologie und Größe des abgetasteten Gebietes kann die Punktwolke unterschiedlich viele Punkte beinhalten. Durch Hardwarelimitierungen ist es nicht immer möglich alle Punkte gleichzeitig anzuzeigen, während eine interaktive Wiedergabe gewährleistet ist.

Besonders für weit entfernte Punkt ist es nicht notwendig, alle Punkte genau wiederzugeben. Deshalb wird für weit entfernte Punkte eine vereinfachte Version angezeigt. Diese besteht aus weniger Punkten und benötigt dadurch weniger Ressourcen, bietet aber eine gute Approximation der ursprünglichen Daten.

#todo[Vergleich alle Punkt und vereinfachte Versionen]

Für die gesamte Punktewolke wird ein Octree mit den Punkten erstellt. Der zugehörige Voxel vom Root-Knoten wird so gewählt, dass alle Punkte im Voxel liegen. Rekursiv wird der Voxel in acht gleichgroße Voxel geteilt, solange in einem Voxel noch zu viele Punkte liegen. Bei dem Octree gehört jeder Punkt zu genau einem Leaf-Knoten.

Für jeden Branch-Knoten wird eine Punktwolke berechnet, welche als Vereinfachung der Punkte der zugehörigen Kinderknoten verwendet werden kann. Dafür wird de Algorithmus aus @berechnung_detailstufen verwendet.

Beim anzeigen wird vom Root-Knoten aus zuerst geprüft, ob der momentane Knoten von der Kamera aus sichtbar ist. Für die Knoten wird mit den Algorithmen aus @auswahl_detailstufen entschieden, ob die zugehörige vereinfachte Punktwolke gerendert oder der gleiche Algorithmus wird für die Kinderknoten wiederholt wird.


== Berechnung der Detailstufen <berechnung_detailstufen>

#todo[Kopiert vom Fachpraktikum]

Die Detailstufen werden wie bei "Fast Out-of-Core Octree Generation for Massive Point Clouds" @potree_lod von den Blättern des Baumes bis zur Wurzel berechnet. Dabei wird als Eingabe für einen Knoten die Detailstufen der direkten Kinder verwendet. Als Anfang werden alle originalen Punkte in einem Blatt als Eingabe benutzt.

Dadurch haben zwar Berechnungen der gröberen Detailstufen für Knoten näher an der Wurzel nur Zugriff auf bereits vereinfachte Daten, dafür müssen aber auch viel weniger Punkte bei der Berechnung betrachtet werden. Solange die Detailstufen eine gute Vereinfachung der ursprünglichen Punkte sind, kann so der Berechnungsaufwand stark verringert werden.

Der Voxel, welcher zu dem Knoten gehört, wird in gleich große Zellen unterteilt. Für jede Zelle mit Punkten wird ein repräsentativer Punkt bestimmt. Dafür wird für die Zelle die Kombination aller Eingabepunkte, welche in der Zelle liegen berechnet. Die Anzahl der Zellen ist dabei unabhängig von der Größe des ursprünglichen Voxels, wodurch bei gröberen Detailstufen durch den größeren Voxel auch die Zellen größer werden und mehr Punkte zusammengefasst werden.


== Auswahl der Detailstufen? <auswahl_detailstufen>


=== Abstand zur Kamera

- Schwellwert
- Abstand zur kleinsten Kugel, die den Voxel inkludiert
- Abstand mit Größe des Voxels dividieren
- Wenn Abstand größer als Schwellwert
	- Knoten rendern
- sonst
	- Kinderknoten überprüfen


=== Auto

- wie Abstand zur Kamera
- messen wie lang rendern dauert
- Dauer kleiner als Mindestdauer
	- Schwellwert erhöhen
- Dauer kleiner als Maximaldauer
	- Schwellwert verringern


=== Gleichmäßig

- gleich für alle Knoten
- auswahl der Stufe


= Kamera/Projektion


== Kontroller

- bewegt Kamera
- kann gewechselt werden, ohne die Kameraposition zu ändern


=== Orbital

- rotieren um einem Punkt im Raum
- Kamera fokussiert zum Punkt
- Entfernung der Kamera zum Punkt variabel
- Punkt entlang der horizontalen Ebene bewegbar
- To-do: Oben-Unten Bewegung


=== First person

- rotieren um die Kamera Position
- Bewegung zur momentanen Blickrichtung
- Bewegungsgeschwindigkeit variabel
- To-do: Oben-Unten Bewegung


== Projektion


=== Perspektive

- Projektion mit Field of View Kegel


=== Orthogonal?

#todo([Orthogonal?])


=== Side-by-Side 3D?


= Bedienung/Interface

#todo([Bedienung/Interface])

#todo([Referenzen])
