#import "setup.typ": *


= Berechnung


== Separierung in Segmente <seperierung_in_segmente>

#todo[Bilder]

Die Punkte werden in gleichbreite parallele Scheiben entlang der Höhe unterteilt. Danach werden die Scheiben von Oben nach Unten einzeln verarbeitet, um die Segmente zu bestimmen.

Dabei wird eine zweidimensionale Karte mitgeführt, welche zu jeder Position das zugehörige Segment speichert. Dafür wird der Bereich in gleichgroße Quadrate unterteilt und im jedem Quadrat wird das zugehörige Segment abgespeichert, wenn dass Quadrat zu einem Segment gehört.

Am Anfang ist die Karte leer. Weil noch keine Segmente existieren, starten die ersten betrachteten Punkte neue Segmente, welche in der Karte eingetragen werden. Weil die Spitze von den Bäumen über mehrere Quadrate gespannt sein kann, werden alle Quadrate in einem Bereich zum Segment zugeordnet.

#todo[Merge Algorithmus statt Bereich]

Es ist auch möglich das der Punkt in einem Quadrat liegt, was bereits zu einem Segment gehört. In diesem Fall wird kein neues Segment angefangen, sondern der Punkte zum existierenden Segment hinzugefügt.

Weil die Ausdehnung von Bäumen sich entlang der Höhe verändert, wird die Karte zwischen den horizontalen Scheiben aktualisiert. Dabei werden die leeren Quadrate um ein Quadrat mit einem zugehörigen Segment auch zu diesem Segment zugeordnet. Dadurch erhöht sich der Bereich, der zu einem Baum gehört. Gleichzeitig wird für Quadrate das zugehörige Segment entfernt, wenn kein Punkt in letzten verarbeiteten Scheiben in dem Bereich gelegen hat.

#figure(
	caption: [Todo.],
	cetz.canvas({
		import cetz.draw: *

		rect((1.0, 4.0), (6.0, 5.0), stroke: none, fill: rgb(100%, 20%, 20%))
		rect((0.0, 3.0), (7.0, 4.0), stroke: none, fill: rgb(100%, 40%, 40%))
		rect((0.0, 2.0), (8.0, 3.0), stroke: none, fill: rgb(100%, 60%, 60%))
		circle((3.3, 4.5), radius: 0.2, stroke: none, fill: black)

		rect((4.0, 2.0), (5.0, 3.0), stroke: none, fill: rgb(100%, 20%, 20%))
		rect((3.0, 1.0), (6.0, 2.0), stroke: none, fill: rgb(100%, 40%, 40%))
		rect((2.0, 0.0), (7.0, 1.0), stroke: none, fill: rgb(100%, 60%, 60%))
		circle((4.6, 2.3), radius: 0.2, stroke: none, fill: black)

		grid(
			(0, 0),
			(8, 6),
			stroke: gray
		)
	}),
) <segmentierung_komplett>

#figure(
	caption: [Todo.],
	box(image("../images/segments.png"), stroke: 1pt + gray),
)


== Eigenschaften <berechnung_eigenschaften>

Die Baumeigenschaften werden für jedes Segment einzeln berechnet. Dabei sind alle Punkte im Segment verfügbar.


=== Nachbarschaft

Um relevante Eigenschaften für einen Punkt zu bestimmen, werden die umliegenden Punkte benötigt. Dafür wird für alle Punkte ein *KD-Baum* erstellt. Mit diesem können effizient für ein Punkt die $k$-nächsten Punkte bestimmt werden.


=== Krümmung <krümmung>

Die Krümmung der Oberfläche wird für jeden Punkt geschätzt. Dafür werden die Positionen der Punkte in der Nachbarschaft betrachtet. Zuerst wird der geometrische Schwerpunkt bestimmt, dass die Positionen der Punkte um diesen verschoben werden können. Ohne die Verschiebung würde die globale Position der Punkte das Ergebnis verfälschen. Mit den Positionen der Punkte kann die Kovarianzmatrix bestimmt werden.

Die Eigenvektoren der Kovarianzmatrix bilden eine Orthonormalbasis und die Eigenwerte geben die Ausdehnung entlang des zugehörigen Basisvektors an. Der kleinste Eigenwert gehört zu Dimension mit der geringsten Ausdehnung. Je kleiner der Eigenwert, desto näher liegen die Punkt in der Nachbarschaft Ebene aufgespannt durch die Eigenvektoren zugehörig zu den größeren Eigenwerten.

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


=== Punkthöhe

Für jeden Punkt wird die relative Höhe im Segment bestimmt. Dafür wird die Mindesthöhe $y_min$ und die Maximalhöhe $y_max$ im Segment benötigt. Die Höhe $h$ für den Punkt mit der der Höhe $p_y$ kann mit $h = (p_y - y_min) / (y_max - y_min)$ berechnet werden. Die relative Höhe liegt dabei im Bereich $[0; 1]$.

#align(center, box(width: 80%, side-caption(
	amount: 1.5,
	figure(
		caption: [Punktwolke mit Höhe markiert.],
		box(image("../images/height-crop.png"), stroke: 1pt + gray),
	),
)))


=== Ausdehnung

Der Baum wird entlang der Horizontalen in gleichhohe Scheiben unterteilt. Die Breite der Scheiben ist dabei einstellbar. Die Ausdehnung wird für jede Scheibe berechnet. Zuerst wird der geometrische Schwerpunkt der Positionen berechnet, womit die durchschnittliche Standartabweichung entlang der Horizontalen bestimmt wird.

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

Die Ausdehnung eignet sich zur Unterscheidung von Stamm und Krone. Beim Stamm sind die Punkte

#todo([Mehr Baumeigenschaften])


== Segmentierung von einem Baum

#link("https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.13144")

#todo([Baumeigenschaften + ? $->$ Segmente])


== Eigenschaften für Visualisierung <eigenschaften_visualisierung>


=== Normale

Mit den Eigenvektoren aus @krümmung wird die Normale für die Umgebung bestimmt. Der Eigenvektor, welcher zum kleinsten Eigenwert gehört, ist orthogonal zur Ebene mit der größten Ausdehnung.


=== Punktgröße

Für die Punktgröße wird der durchschnittliche Abstand zu den umliegenden Punkten bestimmt.


== Baumart

#todo([Segmente + Eigenschaften + ? $->$ Klassifizierung?])
- out of scope?
- neural?
