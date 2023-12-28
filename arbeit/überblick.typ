#import "setup.typ": *


= Überblick

// == Scanner

// / Arial: ...
// / Terrestrial: ...


== Ablauf

Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird die Arbeit für eine Phase so weit wie möglich parallelisiert.

#todo[Referenzen zu späteren Abschnitten]


=== Separierung in Segmente

Für jeden Punkte wird bestimmt, zu welchem Segment er gehört. Dafür werden die Punkte in Voxel unterteilt, die Voxel in unterschiedliche Segmente unterteilt und für jeden Punkte das Segment von zugehörigen Voxel zugeordnet. Der vollständige Ablauf ist in @seperierung_in_segmente gegeben.


=== Segmente verarbeiten

Für jedes Segment werden die benötigten Eigenschaften für die Visualisierung berechnet. Dabei werden Eigenschaften spezifisch für jeden Punkt und Eigenschaften für das gesamte Segment bestimmt. In @berechnung_eigenschaften und @eigenschaften_visualisierung sind die Schritte ausgeführt.

Die Triangulierung wird für die Segmente einzeln durchgeführt. Der Algorithmus ist in @triangulierung gegeben.

Die fertigen Segmente werden einzeln abgespeichert, dass diese separat angezeigt werden können. Zusätzlich wird ein Octree mit allen Segmenten kombiniert erstellt.


=== Berechnung vom Octree

Für alle Branch-Knoten im Octree wird mit den Kinderknoten eine vereinfachte Punktwolke als Detailstufe für das Anzeigen berechnet. Die Baumstruktur und alle Knoten mit den zugehörigen Punkten werden abgespeichert.

#todo([Mehr Überblick])

#include "stand-der-technik.typ"
