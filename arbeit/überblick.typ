#import "setup.typ": *

#part([Überblick])


= Punktwolke

- Menge von Punkten
- mindestens Position


= Testdaten

Der benutze Datensatz @data beinhaltet $12$ Hektar Waldfläche in Deutschland, Baden-Württemberg. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen, Drohnen und vom Boden aus durchgeführt wurden. Dabei entstehen 3D-Punktwolken, welche im komprimiert LAS Dateiformat gegeben sind.

Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für $6$ Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen. Mit den bereits bestimmten Eigenschaften können automatisch berechnete Ergebnisse validiert werden.


= Ablauf

+ Diskretisieren
	- in 5cm große Voxel unterteilen
	- kann vollständig im Hauptspeicher sein
+ Segmente bestimmen
	- Top Down
	- Quadtree
	- nearest mit ...m max distance
+ Segmentieren (nochmal)
	- je nach Voxel zum Segment ordnen
+ Segmente analysieren
	- Beimeigenschaften
	- Punktgreigenschaften
+ Segmente abspeichern
+ gemeinsamer Octree erstellen
	- LOD für Visualisierung

#todo([Mehr Überblick])
