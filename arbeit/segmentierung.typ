#import "setup.typ": *


= Segmentierung in Bäume <seperierung_in_segmente>


== Ablauf

Die Punkte werden in gleichbreite parallele Scheiben entlang der Höhe unterteilt. Danach werden die Scheiben von Oben nach Unten einzeln verarbeitet, um die Segmente zu bestimmen. Dafür werden die Punkte in einer Scheibe zu Bereichen zusammengefasst. Für die Bereiche die zugehörigen Koordinaten vom Mittelpunkte bestimmt und jeder Punkte wird zur nächsten Koordinate zugeordnet.


== Bereiche bestimmen

Für jede Scheibe werden konvexe zusammenhängende Bereiche bestimmt, dass die Punkte in unterschiedlichen Bereichen einen Mindestabstand voneinander entfernt sind. Dafür wird mit einer leeren Menge von Bereichen gestartet und jeder Punkt zu der Menge hinzugefügt. Wenn ein Punkt in einem Bereich ist, ändert der Punkt nicht den Bereich. Ist der Punkt näher als den Mindestabstand zu einem der Bereiche, so wird der Bereich erweitert. Ist der Punkt von allen bisherigen Bereichen entfernt, so wird ein neuer Bereich angefangen.

#todo[Bild]

Die Bereiche sind als Liste gespeichert, wobei für jeden Bereich die Eckpunkte als Liste gegeben sind. Die Eckpunkte sind dabei sortiert, dass für einen Eckpunkt der nächste Punkt entlang der Umrandung der nächste Punkt in der Liste ist. Für den letzten Punkt ist der erste Punkt in der Liste der nächste Punkt.

Um die Distanz von einem Punkt zu einem Bereich zu berechnen, wird der größte Abstand von Punkt zu allen Kanten berechnet. Für jede Kante mit den Eckpunkten $a = (a_x, a_y)$ und $b = (b_x, b_y)$ wird zuerst der Vektor $d = (d_x, d_y) = b - a$ berechnet. Der normalisierte Vektor $o = (d_y, -d_x) / (|d|)$ ist orthogonal zu $d$ und zeigt aus dem Bereich hinaus, solange $a$ im Uhrzeigersinn vor $b$ auf der Umrandung liegt. Für den Punkt $p$ kann nun der Abstand zur Kante mit dem Skalarprodukt $o dot (p - a)$ berechnet werden.

#todo[Bild]

Um einen Punkt zu einem Bereich hinzuzufügen, werden alle Kanten entfernt, bei denen der Punkt auf der Seite außerhalb liegt, entfernt und zwei neue Kanten zum Punkt werden hinzugefügt. Dafür werden die beiden Eckpunkte gesucht, bei denen eine zugehörige Kante entfernt wird und die andere nicht. Um die Kanten zwischen den Punkten zu entfernt, werden alle Punkte zwischen den beiden Punkte entfernt und stattdessen der neue Punkt eingefügt, um die beiden neuen Kanten zu ergänzen.

#todo[Bild]

Nachdem alle Punkte zu den Bereichen hinzugefügt würden, können Bereiche so gewachsen sein, dass Bereiche sich überlappen. Um diese zu verbinden wird wiederholt überlappende Bereiche gesucht und alle Punkte von einem Bereich zum anderen hinzugefügt. Um zu überprüfen, ob Bereiche sich überlappen, wird für einen der Bereiche alle Kanten überprüft, ob der andere Bereich vollständig außerhalb der Kante liegt. Wenn alle Punkte vom anderen Bereich außerhalb der Kante liegen, trennt die Kante die Bereiche. Wenn keine trennende Kante existiert, so überlappen sich die Bereiche.

#todo[Bild überschneiden gewachsene Bereiche]

#todo[Bild getrennte Bereiche gerade]


== Koordinaten bestimmen

Mit den Bereichen und den Koordinaten aus der vorherigen Scheibe werden die Koordinaten für die momentane Scheibe berechnet. Für die erste Scheibe wird die leere Menge als vorherigen Koordinaten verwendet. Für jeden Bereich werden die Koordinaten aus der vorherigen Scheibe gesucht, die im Bereich liegen.

Wenn keine Koordinate in dem Bereich liegt, so fängt der Bereich ein neues Segment an. Als Koordinate wird die durchschnittliche Position der Eckpunkte verwendet.

Liegt genau eine Position in Bereich, wird wieder die durchschnittliche Position als Koordinate verwendet, aber die Koordinate gehört zum gleichen Segment, zu dem die Koordinate aus der vorherigen Scheibe gehört.

Wenn mehrere Koordinaten im Bereich liegen, so werden die mehreren Koordinaten mit den zugehörigen Segmenten für die momentane Scheibe übernommen.


== Punkte zuordnen

Mit den Koordinaten wird das Voronoi-Diagramm berechnet, welches den Raum in Bereiche unterteilt, dass alle Punkte in einem Bereich für eine Koordinate am nächsten an dieser Koordinate liegen. Für jeden Punkt wird nun der zugehörige Bereich im Voronoi-Diagramm bestimmt und der Punkt zum Segment von der Koordinate vom Bereich zugeordnet.

#todo[Bild]
