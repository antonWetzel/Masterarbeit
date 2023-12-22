#import "setup.typ": *

#part([Berechnung])


= Separierung in Bäume


== Diskretisieren

Die Eingabedaten können beliebig viele Punkte beinhalten, wodurch es wegen Hardwarelimitierungen nicht möglich ist alle Punkte gleichzeitig zu laden. Um eine schnellere Verarbeitung zu ermöglichen, wird zuerst eine vereinfachte Version der ursprünglichen Punktewolke bestimmt.

Dafür wird die gesamte Punktwolke in gröbere Voxel unterteilt und Punkte im gleichem Voxel werden zusammengefasst. Die Größe von den Voxeln ist dabei als Makroparameter einstellbar (WIP). Als Standartwert wird $5"cm"$ verwendet.

Für jeden Voxel wird gespeichert, wie viele Punkte zum Voxel gehören.


== Segmente bestimmen


=== Bodenhöhe bestimmen

(Momentan programmiert nur niedrigster Punkt)

Für die Berechnung der Bodenhöhe wird Quadrate entlang der Horizontalen betrachtet. (WIP) Zuerst werden alle Voxel zusammengefasst, welche unabhängig von der Höhe zum gleichen Quadrat gehört.

Weil die zugehörige, zugehörig, zugehöre Punktanzahl von jedem Voxel gespeichert ist, kann die Gesamtanzahl der Punkte von einem Quadrat bestimmt werden. Das gewünschte Quantil wird als Makroparameter festgelegt und es wird die Bodenhöhe zu gewählt, dass der Anteil der Punkte unter der Bodenhöhe dem Quantil entspricht. Als Standartwert wird $2%$ verwendet.


=== Bäume bestimmen

(Noch im Wandel)

Für die Bestimmung der Bäume werden alle Voxel, die über dem Boden liegen in horizontale Scheiben unterteilt. Alle Punkte unter der Bodenhöhe werden nicht weiter segmentiert.

Von der höchsten Scheibe aus werden die Voxel zu Segmenten zugeordnet. Dafür wird jeder Voxel in der Scheibe betrachtet. Für den momentanen Voxel wird der nächste Voxel in einer höheren Scheibe gesucht, wobei es eine Maximaldistanz gibt. Wird ein naher Voxel gefunden, so wird dem momentanen Voxel das gleiche Segment wie dem gefundenen Voxel zugeordnet. Wenn kein naher Voxel gefunden wird, so ist der momentane Voxel der Anfang von einem neuen Segment.


== In Segmente unterteilen

Nachdem alle Voxel zu einem Segment gehören werden alle originalen Punkte nochmal geladen. Dabei wird für jeden Punkt der zugehörige Voxel bestimmt und dem Punkt das Segment vom Voxel zugeordnet.

Die Punkte werden nach Segment getrennt abgespeichert, um weiter zu verarbeitet zu werden.


= Eigenschaften

Die Baumeigenschaften werden für jedes Segment einzeln berechnet. Dabei sind alle Punkte im Segment verfügbar.


== Nachbarschaft

Um relevante Eigenschaften für einen Punkt zu bestimmen, werden die umliegenden Punkte benötigt. Dafür wird für alle Punkte ein *KD-Baum* erstellt. Mit diesem können effizient für ein Punkt die $k$-nächsten Punkte bestimmt werden.


== Krümmung <krümmung>

Die Krümmung der Oberfläche wird für jeden Punkt geschätzt. Dafür werden die Positionen der Punkte in der Nachbarschaft betrachtet. Zuerst wird der geometrische Schwerpunkt bestimmt, dass die Positionen der Punkte um diesen verschoben werden können. Ohne die Verschiebung würde die globale Position der Punkte das Ergebnis verfälschen. Mit den Positionen der Punkte kann die Kovarianzmatrix bestimmt werden.

Die Eigenvektoren der Kovarianzmatrix bilden eine Orthonormalbasis und die Eigenwerte geben die Ausdehnung entlang des zugehörigen Basisvektors an. Der kleinste Eigenwert gehört zu Dimension mit der geringsten Ausdehnung. Je kleiner der Eigenwert, desto näher liegen die Punkt in der Nachbarschaft Ebene aufgespannt durch die Eigenvektoren zugehörig zu den größeren Eigenwerten.

Wenn die Eigenwerte $lambda_i$ mit $i in NN_0^2$ absteigend nach größer sortiert sind, dann kann die Krümmung $c$ mit $c = (3 lambda_2) / (lambda_0 + lambda_1 + lambda_2)$ berechnet werden. $c$ liegt dabei im abgeschlossenen Bereich $[0; 1]$.

#stack(
	dir: ltr,
	image("../images/curve.png", height: 30%),
	image("../images/curve_filter.png", height: 30%),
)

#todo([Aktuelle Bilder])


== Punkthöhe

Für jeden Punkt wird die relative Höhe im Segment bestimmt. Dafür wird die Mindesthöhe $y_min$ und die Maximalhöhe $y_max$ im Segment benötigt. Die Höhe $h$ für den Punkt mit der der Höhe $p_y$ kann mit $h = (p_y - y_min) / (y_max - y_min)$ berechnet werden. Die relative Höhe liegt dabei im Bereich $[0; 1]$.


== Ausdehnung

Der Baum wird entlang der Horizontalen in gleichhohe Scheiben unterteilt. Die Höhe der Scheiben ist dabei einstellbar. Für jede werden alle Punkte in der Scheibe betrachtet. Zuerst wird der geometrische Schwerpunkt der Positionen berechnet, womit die durchschnittliche Standartabweichung entlang der Horizontalen bestimmt wird.

Die größte Varianz von allen Scheiben wird verwendet, um die Varianzen auf den Bereich $[0; 1]$ zu normieren. Für jeden Punkt wird die Varianz der zugehörigen Scheibe zugeordnet.

#stack(
	dir: ltr,
	image("../images/var.png", height: 30%),
	image("../images/var_filter.png", height: 30%),
)

#todo([Mehr Baumeigenschaften])


= Segmentierung von einem Baum

#todo([Baumeigenschaften + ? $->$ Segmente])


= Eigenschaften für Visualisierung


== Normale

Mit den Eigenvektoren aus @krümmung wird die Normale für die Umgebung bestimmt. Der Eigenvektor, welcher zum kleinsten Eigenwert gehört, ist orthogonal zur Ebene mit der größten Ausdehnung.


== Punktgröße

Für die Punktgröße wird der durchschnittliche Abstand zu den umliegenden Punkten bestimmt.


= Baumart

#todo([Segmente + Eigenschaften + ? $->$ Klassifizierung?])
- out of scope?
- neural?
