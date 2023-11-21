#import "setup.typ": *;

#part([Berechnung])

#todo([Voxel statt Würfel verwenden?])


= Ablauf

#todo([Ablauf als Bild])

+ Diskretisieren
	- in 5cm große Würfel unterteilen
	- kann vollständig im Hauptspeicher sein
+ Segmente bestimmen
	- Top Down
	- Quadtree
	- nearest mit ...m max distance
+ Segmentieren (nochmal)
	- je nach Würfel zum Segment ordnen
+ Segmente analysieren
	- Beimeigenschaften
	- Punktgreigenschaften
+ Segmente abspeichern
+ gemeinsamer Octree erstellen
	- LOD für Visualisierung


= Separierung in Bäume


== Diskretisieren

+ Punkte laden
+ Position diskretisieren (5cm) und zugehöriger Würfel berechnen
+ alle Würfel, welche Punkte enthalten abspeichern


== Segmente bestimmen

+ Boden Bestimmen
	- tiefster Würfel in ...m #sym.times ...m
+ von oben nach unten in Scheiben segmentieren
	- für jeden Würfel den nächsten bereits Segmentieren Würfel mit Maximaldistanc ...m bestimmen
	- wenn kein Würfel gefunden, neues Segment anfangen
	- wenn Würfel gefunden gleiches Segment verwdenden


== Segmentieren

+ Punkt nochmal laden
+ Berechnen zu welchen Würfel der Punkt gehört
+ Segment vom Würfel zum Punkt zuordnen
+ Punkte im gleichem Segment zusammenfassten zu einer Punktwolke


= Baumeigenschaften

Alle Punkte in einem Segment (Baum) sind verfügbar


== Krümmung

+ Hauptkomponentenanalyse
	- $lambda_i$ mit $i in NN_0^2$ und $lambda_i > lambda_j$ wenn $i > j$
+ $c (3 lambda_2) / (lambda_0 + lambda_1 + lambda_2)$
	- $c in [0, 1]$

#stack(
	dir: ltr,
	image("../images/curve.png", height: 30%),
	image("../images/curve_filter.png", height: 30%),
)

#todo([Background Option für weißen Hintergrund für Bilder])


== Punkthöhe

+ $h = (p_y - y_min) / (y_max - y_min)$
	- $h in [0, 1]$


== Varianz in Scheibe

+ 5 cm Scheiben
+ geometrischen Schwerpunkt berechnen
+ Varianz $v$ berechnen
+ $x = v_i / v_max$
	- $x in [0, 1]$

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

+ Hauptkomponentenanalyse
+ Eigenvektor für $lambda_2$


== Punktgröße

+ Durchschnittliche Abstand zu umliegenden Punkten
+ Ausgleichsfaktor?


= Baumart

#todo([Segmente + Eigenschaften + ? $->$ Klassifizierung?])
- out of scope?
- neural?
