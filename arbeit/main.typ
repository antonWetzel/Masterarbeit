#import "setup.typ": *
#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *

#show: setup

#todo-outline()

#include "deckblatt.typ"

#outline(indent: auto)

#pagebreak()

#include "glossar.typ"
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

#todo([Mehr Überblick])

#include "stand-der-technik.typ"
#pagebreak()

#include "berechnung.typ"

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


== Detailstufe

+ Grid
	- Größe abhängig von Leafgröße, wird gröber für größere Blätter
+ Kombination von Punkten
	- Größe als Fläche addieren
	- Normale Durchschnitt
	- Position durchschnitt
	- Eigenschaften?


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

#pagebreak()

#bibliography("bibliographie.bib")
