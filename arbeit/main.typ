#import "setup.typ": *
#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *

#show: setup

#todo-outline()

#align(center, {
	text(size: 3em, [*Masterarbeit*])
	todo([Deckblatt])
	pagebreak()
})

#outline(indent: auto)

#pagebreak()


= Glossar

#todo([Glossar])

/ Octree: ...
/ Leaf: ...
/ Branch: ...
/ Root: ...

#todo(prefix: [Note], [Englische Begriffe für die Datenstrukturen])

/ Punktwolke: ...
/ Punkt: ...
/ Normale: ...
/ Arial: ...
/ Terrestrial: ...
/ ...: ...

#todo([Akronyme])

#part([Überblick])


= Punktwolke

- Menge von Punkten
- mindestens Position


= Daten

- Waldstücke
- Deutschland
- terrestrial und arial
- zusätzlich manuelle Datenbestimmung
- nur Position bekannt

#todo([Mehr Überblick])


= Stand der Technik

#todo([Stand der Technik])

#part([Berechnung])


= Ablauf

#todo([Ablauf als Bild])

+ Eingabedateien
	- Dateien laden
+ Punktmenge
	- Segmentierung in Bäume, Boden...
+ Liste von Bäumen
	- Analyse der Bäume
+ Liste von analysierten Bäumen
	- Generierung von Octree
+ Octree + LOD für Visualisierung

getrennte Phasen (Phase ist in sich parallelisiert)
+ Laden der Dateien
+ Segmentierung
+ Analyse + Generierung


= Separierung in Bäume

#todo([Separierung in Bäume])


= Baumeigenschaften


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


=== Detailstufe

+ Grid
	- Größe abhängig von Leafgröße, wird gröber für größere Blätter
+ Kombination von Punkten
	- Größe als Fläche addieren
	- Normale Durchschnitt
	- Position durchschnitt
	- Eigenschaften?


= Baumart

#todo([Segmente + Eigenschaften + ? $->$ Klassifizierung?])
- out of scope?
- neural?

#part([Meshing])

#todo([Meshing])

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


= Dynamische Eigenschaft

- eigenschaften als $32$ bit unsigned integer
- look up table für farbe basierend auf eigenschaftwert


= Subpunktwolken (Bäume)

- Punkte in einem Leaf gehören zum gleichen Segment
- Raycast durch den Octree zum ersten Leaf
- Segment vom leaf auswählen
	- nur nodes anzeigen, die zum Segment gehören
	- infos für segment anzeigen

#stack(
	dir: ltr,
	image("../images/segment_1.png", height: 30%),
	image("../images/segment_2.png", height: 30%),
)

#todo(prefix: [Note], [Oben/Unten Teilung in 2 Segmente für Debug])


== Selektion (Raycast)

- von root bis leaf
- bestimme intersection mit knoten
- leaf mit geringstem anstand als ergebnis
	- To-do?: besserer Algorithmus (ist schlecht aber gut genug)


= Eye Dome

+ Post processing
+ depth image
+ anliegender Pixel mit maximalem Abstand
	+ $(-1, 0), (0, -1), (1, 0), (0, 1)$
+ Parameter $m$
+ $x = "maximaler abstand" / m$
+ auf $[0, 1]$ beschränken
+ Parameter $"color"$?
+ Pixel mit $"color"$ und $x$ als $alpha$ überlagern


= LOD Octree

+ (Octree begriffe in English)
+ Octree mit maximaler Blattgröße $1 << 15$? (32k)
+ Blätter mit mehr Punkten werden in 8 Kinderknoten geteilt
	- Punkte auf Kinder verteilen
+ non Leaf Knoten wird LOD aus Kindern berechnet
	+ Punkte kombinieren
	+ Für Eigenschaften wert von einem Punkt übernehmen
+ rekursiv von Kindern bis zum Root
+ beim rendern für entferne Punkte nur Lod Stufe verwenden
	+ je näher so genauere LOD Stufe


== Kostenbudget?

- Anpassung der Genauigkeit
	- Verringerung des Aufwands
- Iteratives anpasssen an das Budget?


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
