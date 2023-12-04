#import "setup.typ": *

#part([Meshing])

#todo([Meshing])

#todo[Anpassen für Segmente]

#todo[Umsetzen in Rust]

#todo[Mehr Bilder]


= Triangulierung


== Ziel

Eine Triangulierung ermöglicht eine Rekonstruktion der ursprünglichen gescannten Oberfläche, um diese weiterzuverarbeiten oder anzuzeigen. Die meisten Programme und Hardware sind auf das Anzeigen von Dreiecken spezialisiert, und können diese effizienter als Punkte darstellen.


== Vorverarbeitung

Damit das Blatt mit den Punkten trianguliert werden kann, müssen die Punkte zu einer Oberfläche gehören. Das ist bei Scans von dreidimensionalen Objekten in der Regel der Fall.

// Probleme können bei der Kombination von Scans entstehen. Weil die Scans nicht zeitgleich aufgenommen werden, können zwischen den Scans Unterschiede in der gescannten Umgebung entstehen. Zum Beispiel sind bei Wind die Blätter von Bäumen wahrscheinlich unterschiedlich zwischen zwei Scans.

Bei Regionen, wo mehrere Scans überlappen, können Punkte entlang der Oberfläche sehr nah aneinander liegen. Durch Ungenauigkeiten beim Messen oder der Transformation in das globale Koordinatensystem sind aber Unterschiede orthogonal zur Oberfläche möglich. Für die Triangulierung dieser Punkte würde ein Dreieck orthogonal zur eigentlichen Oberfläche benötigt werden.

// Um eine eindeutige Triangulierung zu ermöglichen wird vor der Triangulierung Rauschen entfernt, dass die Punkte entlang einer Oberfläche liegen. Dafür können die Filter aus @rauschfilter benutzt werden.

Bei Bereichen, bei denen die Oberfläche zwischen Scans unterschiedlich ist, werden beide Oberfläche trianguliert und beim Übergang ist keine eindeutige Triangulierung möglich.


== Datenstrukturen


=== Punktstatus

Für jeden Punkt wird gespeichert, ob dieser bereits zu einem Dreieck gehört. Dabei ist der Standardwert inaktiv für alle Punkte und während der Triangulierung wird der Wert auf aktiv gesetzt.


=== Aktive Kante

Eine aktive Kante bildet den Übergang zwischen den bereits Triangulierten Bereich und den Rest des Blattes. Eine aktive Kante beinhaltet die beiden Indices der Eckpunkte, zwischen denen die Kante ist und den Index eines inneren Punktes, um die Richtung zum noch nicht Triangulierten Bereich zu bestimmen.


=== Äußere Kanten

Die äußeren Kanten sind eine Warteschlange, welche die aktiven Kanten enthält. Während der Triangulierung werden die Kanten abgearbeitet, bis die Warteschlange leer ist.


=== Dreieckszähler

Für die berechneten Kanten werden in einer Hashtabelle die zugehörige Anzahl von anliegenden Dreiecken gespeichert. Wenn die Kante noch keinen Eintrag in der Tabelle hat, wird für die Anzahl der Standardwert null verwendet.


== Gesuchte Triangulierung

Als Triangulierung wird eine Delaunay-Triangulierung gesucht, diese vermeidet spitzwinklige Dreiecke. Für eine Delaunay-Triangulierung werden Dreiecke gesucht, in deren Umkreis kein anderer Punkt liegt. Wegen der 3-Dimensionalität wird die Kugel verwendet, welche den Umkreis vom Dreieck als Großkreis hat.

Weil die Bedingung unabhängig davon ist, welche der Kanten von dem gesuchten Dreieck die aktive Kante ist, wird die gleiche Triangulierung unabhängig von der Auswahl der aktiven Kante gefunden.


== Ablauf


=== Anfang

Als Anfang wird ein beliebiger Punkt im Blatt als erster Punkt ausgewählt. Von diesem Punkt wird ein Dreieck gesucht, welches den Anfang des triangulierten Bereiches bildet.

Als zweiter Punkt wird der räumlich nächste Punkt zum ersten Punkt ausgewählt. Dieser gehört immer zur Delaunay-Triangulierung, weil alle anderen Punkte weiter entfernt sind und somit dieser Punkt im Umkreis von den zwei weiter entfernten Punkten liegen müsste.

Als dritter Punkt wird der Punkt ausgewählt, dass der Winkel mit dem dritten Punkt als Winkelscheitel mit den Winkelschenkeln zu den beiden ersten Punkten maximiert wird. Dieser Punkt hat den kleinsten Umkreis und somit gehört das Dreieck mit den drei Punkten zur Triangulierung. Dafür werden alle Punkte iteriert, die in der Nachbarschaft vom ersten und zweiten Punkt sind.

Für alle drei Punkte wird der Punktstatus aktiv gesetzt und die drei Kanten vom Dreieck bilden die äußeren Kanten. Für die Kanten wird der zugehörige Dreieckszähler um eins erhöht.


=== Triangulierten Bereich erweitern

Solange die äußeren Kanten nicht leer sind, kann der triangulierte Bereich erweitert werden. Dafür wird zuerst eine beliebige aktive Kante ausgewählt und aus den äußeren Kanten entfernt.

Wenn zu dieser Kante bereits zwei oder mehr Dreiecken gehört, wird diese entfernt, ohne ein weiteres Dreieck zu suchen. Sonst wird wieder der beste dritte Punkt gesucht, der den Winkel zu den beiden bekannten Punkten maximiert. In @triangulierung_erweiterung ist der Ablauf grafisch dargestellt.

Als zusätzliche Bedingung kommt hinzu, dass der dritte Punkt auf der anderen Seite zum inneren Punkt der aktiven Kante liegen muss. Wenn kein dritter Punkt gefunden wird, wird kein weiteres Dreieck zur Triangulierung hinzugefügt.

Für alle drei Punkte wird der Punktstatus aktiv gesetzt und die zwei neuen Kanten werden zu den äußeren Kanten hinzugefügt. Für alle drei Kanten vom Dreieck wird der zugehörige Zähler um eins erhöht.

#figure(
	caption: [Erweiterung um zwei Dreiecke. Für die ausgewählte aktive Kante in Rot wird das Dreieck in Grau gefunden und zum bereits Triangulierten Bereich in Grün hinzugefügt. Die neuen aktiven Kanten sind gepunktet eingezeichnet.],
	todo[Bild],
) <triangulierung_erweiterung>


=== Komplettes Blatt triangulieren

Ein Blatt kann mehrere nicht-zusammenhängende Bereiche enthalten. Deshalb werden alle Punkte betrachtet und von jedem eine Triangulierung gestartet, wenn der Punktstatus noch nicht aktiv ist.


== Limitierung

Weil die Triangulierung für jedes Blatt einzeln durchgeführt wird, kann zwischen den Punkten unterschiedlicher Blätter nicht trianguliert werden. Dadurch entsteht bei der Zusammenführung aller Triangulierung zwischen den Blättern sichtbare Lücken.

Durch die Limitierung auf die Nachbarschaft, bei der Suche des dritten Punktes für eine Kante, entstehen bei einer starken Veränderung der Punktdichte Lücken. Die Nachbarschaft von einem Punkt nah der Veränderung der Punktdichte beinhaltet nur die Punkte aus der Region mit der größeren Dichte. Dadurch findet die Suche nicht den optimalen dritten Punkt vom gewünschten Dreieck aus der Region mit der niedrigeren Dichte.


== Ergebnisse

// Die Ergebnisse der Triangulierung sind in @triangulierung_pumpe zu sehen. Bereiche, bei denen die Punkte auf einer zwei-mannigfaltigen Oberfläche liegen, können vollständig Trianguliert werden. Beim Rand der abgetasteten Oberfläche entstehen durch einzelne weiter entfernte Punkte Artefakte.

#todo[Bild]
