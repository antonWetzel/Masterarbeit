#import "setup.typ": *

#part([Visualisierung])


= Technik

- Rust
- WebGPU (wgpu)
- native Window (website?)
- LAS/LAZ


= Punkt

- Instancing
- quad rect
- Ausdehnung mit Normale
- Discard mit Distanz für Kreis (Kreisfläche)

#todo[Vergleich Quad oder Dreieck als Basis]


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

Für die gesamte Punktewolke wird ein Octree mit den Punkten erstellt. Der zugehörige Würfel vom Root-Knoten wird so gewählt, dass alle Punkte im Würfel liegen. Rekursiv wird der Würfel in acht Unterwürfel geteilt, solange in einem Würfel noch zu viele Punkte liegen. Bei dem Octree gehört jeder Punkt zu genau einem Leaf-Knoten.

Für jeden Branch-Knoten wird eine Punktwolke berechnet, welche als Vereinfachung der Punkte der zugehörigen Kinderknoten verwendet werden kann. Dafür wird de Algorithmus aus @berechnung_detailstufen verwendet.

Beim anzeigen wird vom Root-Knoten aus zuerst geprüft, ob der momentane Knoten von der Kamera aus sichtbar ist. Für die Knoten wird mit den Algorithmen aus @auswahl_detailstufen entschieden, ob die zugehörige vereinfachte Punktwolke gerendert oder der gleiche Algorithmus wird für die Kinderknoten wiederholt wird.


== Berechnung der Detailstufen <berechnung_detailstufen>

+ Grid
	- Größe abhängig von Leafgröße, wird gröber für größere Blätter
+ Kombination von Punkten
	- Größe als Fläche addieren
	- Normale Durchschnitt
	- Position durchschnitt
	- Eigenschaften?


== Auswahl der Detailstufen? <auswahl_detailstufen>


=== Abstand zur Kamera

- kostenbudget
- Anpassung der Genauigkeit
	- Verringerung des Aufwands
- Iteratives anpasssen an das Budget?


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


= Bedienung/Interface

#todo([Bedienung/Interface])

#todo([Referenzen])

#pagebreak()

#bibliography("bibliographie.bib")
