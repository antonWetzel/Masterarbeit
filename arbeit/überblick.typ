#import "setup.typ": *

#part([Überblick])

// == Scanner

// / Arial: ...
// / Terrestrial: ...


= Ablauf

Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird die Arbeit für eine Phase so weit wie möglich parallelisiert.

#todo[Referenzen zu späteren Abschnitten]


== Diskretisierung

Die Eingabedaten können beliebig viele Punkte enthalten. Für die weiteren Phasen wird deshalb eine vereinfachte Version berechnet, bei der alle Punkte in diskrete Voxel unterteilt werden. Die vereinfachte Version kann vollständig im Hauptspeicher geladen sein.


== Segmente bestimmen

Für jeden gefüllten Voxel wird bestimmt, zu welchem Segment er gehört. Dafür werden die gefüllten Voxel nach der Höhe geordnet. Von Oben nach Unten werden die Voxel zu einem Segment zugeordnet. Dafür werden Voxel dem gleichen Segment zugeordnet, zu dem nach Voxel gehören.


== Segmente unterteilen

Für jeden Punkt wird der zugehörige Voxel bestimmt und das Segment vom Voxel dem Punkt zugeordnet. Die Punkte werden in Segmente unterteilt gespeichert.


== Analyse und Speichern

Für jedes Segment werden die benötigten Eigenschaften für die Visualisierung berechnet. Dabei werden Eigenschaften spezifisch für jeden Punkt und Eigenschaften für das Gesamte Segment bestimmt.

Die fertigen Segmente werden einzeln abgespeichert, dass diese separat angezeigt werden können. Zusätzlich wird ein Octree mit allen Segmenten kombiniert erstellt.


== Speichern vom Octree

Für alle Branch-Knoten im Octree wird mit den Kinderknoten eine vereinfachte Punktwolke als Detailstufe für das Anzeigen berechnet. Die Baumstruktur und alle Knoten mit den zugehörigen Punkten werden abgespeichert.

#todo([Mehr Überblick])

#include "stand-der-technik.typ"
