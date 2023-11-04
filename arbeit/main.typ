#import "setup.typ": *

#show: setup

#align(center, {
	text(size: 3em, [*Masterarbeit*])
})

#outline(indent: auto)

#pagebreak()

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


= ...

#part([Berechnung])


= Ablauf

Als Bild

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

- ?


= Segmentierung von einem Baum

- ?


= Baumeigenschaften


== Krümmung

+ Hauptkomponentenanalyse
	- $lambda_i$ mit $i in NN_0^2$ und $lambda_i > lambda_j$ wenn $i > j$
+ $c (3 lambda_2) / (lambda_0 + lambda_1 + lambda_2)$
	- $c in [0, 1]$


== Punkthöhe

+ $h = (p_y - y_min) / (y_max - y_min)$
	- $h in [0, 1]$


== Varianz in Scheibe

+ 5 cm Scheiben
+ geometrischen Schwerpunkt berechnen
+ Varianz $v$ berechnen
+ $x = v_i / v_max$
	- $x in [0, 1]$


== ...


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

- ?

#part([Meshing])

- ?

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


== Lookup Table


= Subpunktwolken (Bäume)


== Selektion (Raycast)


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
+ Beim rendern für entferne Punkte nur Lod Stufe verwenden
	+ je näher so genauere LOD Stufe


== Kostenbudget?

- Anpassung der Genauigkeit
	- Verringerung des Aufwands


= Kamera/Projektion


== Kontroller


=== Orbital


=== First person


== Projektion


=== Perspektive

- FOV


=== Orthogonal?


= Bedienung/Interface

- ?
