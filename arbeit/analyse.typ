#import "setup.typ": *


== Analyse von Segmenten


=== Eigenschaften <berechnung_eigenschaften>

Die Baumeigenschaften werden für jedes Segment einzeln berechnet. Dabei sind alle Punkte im Segment verfügbar.


==== Nachbarschaft

Um relevante Eigenschaften für einen Punkt zu bestimmen, werden die umliegenden Punkte benötigt. Dafür wird für alle Punkte ein *KD-Baum* erstellt. Mit diesem können effizient für einen Punkt die $k$-nächsten Punkte bestimmt werden.


==== Krümmung <krümmung>

Die Krümmung der Oberfläche wird für jeden Punkt geschätzt. Dafür werden die Positionen der Punkte in der Nachbarschaft betrachtet. Zuerst wird der geometrische Schwerpunkt bestimmt, dass die Positionen der Punkte um diesen verschoben werden können. Ohne die Verschiebung würde die globale Position der Punkte das Ergebnis verfälschen. Mit den Positionen der Punkte kann die Kovarianzmatrix bestimmt werden.

Die Eigenvektoren der Kovarianzmatrix bilden eine Orthonormalbasis und die Eigenwerte geben die Ausdehnung entlang des zugehörigen Basisvektors an. Der kleinste Eigenwert gehört zu Dimension mit der geringsten Ausdehnung. Je kleiner der Eigenwert, desto näher liegen die Punkte in der Nachbarschaft an der Ebene, aufgespannt durch die Eigenvektoren zugehörig zu den größeren Eigenwerten.

Wenn die Eigenwerte $lambda_i$ mit $i in NN_0^2$ absteigend nach größer sortiert sind, dann kann die Krümmung $c$ mit $c = (3 lambda_2) / (lambda_0 + lambda_1 + lambda_2)$ berechnet werden. $c$ liegt dabei im abgeschlossenen Bereich $[0; 1]$.

#figure(
	caption: [Punktwolke mit Krümmung markiert.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(box(image("../images/curve_all-crop.png"), stroke: 1pt + gray), caption: [Alle Punkte]),
		subfigure(box(image("../images/curve_low-crop.png"), stroke: 1pt + gray), caption: [Geringe Varianz]),
		subfigure(box(image("../images/curve_high-crop.png"), stroke: 1pt + gray), caption: [Hohe Varianz]),
	),
)


==== Punkthöhe

Für jeden Punkt wird die relative Höhe im Segment bestimmt. Dafür wird die Mindesthöhe $y_min$ und die Maximalhöhe $y_max$ im Segment benötigt. Die relative Höhe $h$ für den Punkt mit der Höhe $p_y$ kann mit $h = (p_y - y_min) / (y_max - y_min)$ berechnet werden. Die relative Höhe liegt dabei im Bereich $[0; 1]$.

#align(center, box(width: 80%, side-caption(
	amount: (2fr, 3fr),
	figure(
		caption: [Punktwolke mit Höhe markiert.],
		box(image("../images/height-crop.png"), stroke: 1pt + gray),
	),
)))


==== Ausdehnung

Der Baum wird entlang der Horizontalen in gleich hohe Scheiben unterteilt. Die Breite der Scheiben ist dabei einstellbar. Die Ausdehnung wird für jede Scheibe berechnet. Zuerst wird der geometrische Schwerpunkt der Positionen berechnet, womit die durchschnittliche Standardabweichung entlang der Horizontalen bestimmt wird.

Die größte Varianz von allen Scheiben wird verwendet, um die Varianzen auf den Bereich $[0; 1]$ zu normieren. Für jeden Punkt wird die Varianz der zugehörigen Scheibe zugeordnet.

#figure(
	caption: [Punktwolke mit Varianz markiert.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(box(image("../images/var_all-crop.png"), stroke: 1pt + gray), caption: [Alle Punkte]),
		subfigure(box(image("../images/var_trunk-crop.png"), stroke: 1pt + gray), caption: [Geringe Ausdehnung]),
		subfigure(box(image("../images/var_crown-crop.png"), stroke: 1pt + gray), caption: [Hohe Ausdehnung]),
	),
)

Die Ausdehnung eignet sich zur Unterscheidung von Stamm und Krone. Beim Stamm sind die Punkte näher einander, während bei der Krone die Punkte weiter verteilt sind.

#todo([Mehr Baumeigenschaften])


=== Segmentierung von einem Baum

#link("https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.13144")

#todo([Baumeigenschaften + ? $->$ Segmente])


=== Eigenschaften für die Visualisierung <eigenschaften_visualisierung>

Die Visualisierung werden die Position, Orientierung und Größe von einem Punkte benötigt. Die Position ist in den Eingabedaten gegeben und die anderen Eigenschaften werden mit der lokalen Umgebung vom Punkt berechnet.

Für die Orientierung wird die Normale bestimmt, welche orthogonal zur geschätzten zugehörigen Oberfläche vom Punkt ist. Dafür werden die Eigenvektoren aus @krümmung verwendet. Der Eigenvektor, welcher zum kleinsten Eigenwert gehört, ist dabei orthogonal zur geschätzten Ebene mit der größten Ausdehnung.

Für die Punktgröße wird der durchschnittliche Abstand zu den umliegenden Punkten bestimmt. Dadurch werden die Punkte in Bereichen mit hoher Punktdichte kleiner.


=== Baumart

#todo([Segmente + Eigenschaften + ? $->$ Klassifizierung?])
- out of scope?
- neural?
