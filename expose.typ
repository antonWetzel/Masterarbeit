//https://home.uni-leipzig.de/~gsgas/fileadmin/Recommendations/Expose_Recommendations.pdf
//https://www.uni-bremen.de/fileadmin/user_upload/fachbereiche/fb7/gscm/Dokumente/Structure_of_an_Expose.pdf
#show: (document) => {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	show heading.where(level: 1): it => { v(10pt); align(center, it); v(10pt); }
	show heading.where(level: 2): it => { v(5pt); it; v(5pt); }
	document
}


= Exposé

#pad(x: 1.5cm, align(center)[
	*Berechnung von Eigenschaften aus 3D-Punktwoken von Wäldern und Visualiserung der 3D-Daten mit Hilfe der Eigenschaften*
])

== Motivation

Zuerst werden für jeden Baum die Eigenschaften berechnet. Dafür werden die 3D-Daten eingelesen, die Berechnung für jeden Baum durchgeführt und die Ergebnisse zusammen mit den 3D Daten abgespeichert.

Die Eigenschaften und 3D Daten können dadurch gemeinsam für die Visualisierung verwendet werden. Dies ermöglicht eine interaktive Visualisierung mit spezialisierter Software, welche eine Analyse der Daten vereinfacht.

=== Eingabedaten

Die Daten sind mit Laserscans aufgenommen, wobei der Scan von Flugzeugen, Dronen und vom Boden aus durchgeführt wird. Teilgebiete sind mehrfach aufgenommen, einmal ohne und einmal mit Blättern. Die Datensätze sind bereits in einzelne Bäume unterteilt. Zusätzlich wurden für Teilgebiete zusätzlich die Baumart, Höhe, Durchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen.

=== Eigenschaften

Ein Datensatz muss zuerst in einzelne Bäume unterteilt werden, um diese einzeln weiter zu verarbeiten.

Eigenschaften für den gesamten Baum können aus den Punkten berechnet werden. Dazu gehören die Höhe des Baumes und der Krone, Durchmesser von Stamm und der Krone und das Baumvolumen. Die berechneteten Eigenschaften können mit den erfasten Messwerten verglichen werden, um die Korrektheit zu berwerten.

Mit einer Segmentierung des Baumes in Stamm, Äste und Blätter kann der Baum weiter unterteilt werden. Die Segmente bilden die Kanten von einem Graph, wobei Gebelungen und Endpunkte die Knoten bilden. Bei den Ästen kann die Stufe zugeordnet werden, wie viele Teilungen sie vom Stamm entfernt sind.

=== Visualisierung

Für die Visualisierung ist nur die Position der einzelnen Punkte bekannt. Weil die Messdaten keine Farbinformationen enthalten müssen andere Eigenschaften verwendet werden. Um die Punkte zu unterschieden kann die Höhe der einzelen Punkte mit einem Farbverlauf verwendet werden. Die vorherige Berechnung von weiteren Eigenschaften ermöglichen komplexere Möglichkeiten, dazu gehört die unterschiedliche Einfärbung von unterschiedlichen Bäumen oder von unterschiedlichen Segmenten

Um auch größere Datensätze zu Visualisieren, werden beim Berechnen der Eigenschaften auch gröbere Detailstufen berechnet, welche für weit entfernte Bäume verwendet werden könne.

Für eine bessere Visualisierung der Tiefeninformation kann `Eye Dome Lighting` verwendet werden, welches Ränder der 3D-Modelle hervorhebt.

=== Generierung von 3D-Modellen

Für die Visualisierung können die Punkte Trianguliert werden, wodurch ein 3D-Modell mit einer Oberfläche entsteht. Für die Farbinformationen können die Methoden aus der Visualisierung oder generierte Texturen verwendet werden.

Dabei muss der Stamm und Äste unterschiedlich zu den Blättern gehändelt werden, weil die Punkte zugehörig zu den Blättern keine Oberfläche bilden.

Für die Validierung der 3D-Modelle können syntetisch generierte Baummodelle verwendet werden. Aus diesen wird eine Punktwolke generiert, aus der das Modell berechnet wird. Das berechnete Modell kann mit dem syntetischen Verglichen werden.

== Weitere Verabeitung

Die Eigenschaften in Kombination mit der Klassifikation der Bäume in den Messdaten ermöglicht eine Metrik für die Baumart. Dadurch können syntetisch generierte Baummodelle validiert werden.

Für die gleichen Regionen können unterschiedliche Datensätze von unterschiedlichen Messmethoden verglichen werden. Dadurch können Vor- und Nachteile der Methoden ausgearbeitet werden.

Die Ergebnisse können auch mit bildbasierenden Verfahren verglichen werden, wodurch Vor- und Nachteile zu strukturel unterschiedlichen Methoden ausgearbeitete werden können.


== Stand der Technik

- Software
	- ...
- Forschung
	- ...

== Überblick

- Überblick
- Eigenschaften der Messdaten
- Ziele Berechnung Eigenschaften
- Ziele Visualisierung
- Stand der Technik
- Erreichte Ergebnisse Berechnung Eigenschaften
- Erreichte Ergebnisse Visualisierung
- Weitere Möglichkeiten
- Weitere Benutzng der Ergebnisse
- Resümee
- Bibliographie

== Bibliographie

...
