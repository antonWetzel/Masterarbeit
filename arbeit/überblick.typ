#import "setup.typ": *


= Überblick


== Motivation

Größere Gebiete wie Teile von Wäldern können als 3D-Punktwolken gescannt werden, aber relevante Informationen sind nicht direkt aus den Daten ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealisitsch, weshalb automatisierte Methoden benötigt werden.

Die automatisierte Unterteilung in einzelne Bäume und die Berechnung der charakteristischen Eigenschaften der Bäume bildet dabei eine Grundlage für die Auswertung vom gesamten Waldstück. In dieser Arbeit wird mit den Daten eine interaktive Visualisierung ermöglicht, welche eine manuelle Auswertung ermöglicht.


== Ablauf

Die Daten müssen zuerst importiert werden, wobei die benötigten Projektdaten berechnet werden. Das Projekt kann dann von der Visualisierung geöffnet werden, um die Daten zu inspizieren.

Der Import wird in mehreren getrennten Phasen durchgeführt. Dabei wird der Berechnungsaufwand für eine Phase so weit wie möglich parallelisiert. Die berechneten Daten und ihre Abhängigkeiten sind in @überblick_datenfluss zu sehen.

#figure(
	caption: [Datenfluss für den Import.],
	cetz.canvas(length: 1cm, {
		import cetz.draw: *

		set-style(mark: (end: ">", fill: black))
		rect((0, 2), (3, 3), name: "daten")
		content("daten", [Punktdaten])

		rect((5, 4), (8, 5), name: "seg0");
		content("seg0", [Segment 1])
		line("daten.east", "seg0.west")

		rect((5, 2), (8, 3), name: "seg1");
		content("seg1", [Segment 2])
		line("daten.east", "seg1.west")

		rect((5, 0), (8, 1), name: "seg2");
		content("seg2", [Segment ...])
		line("daten.east", "seg2.west")

		rect((10, 3), (14, 4), name: "octree")
		content("octree", [Octree])
		line("seg0.east", "octree.west")
		line("seg1.east", "octree.west")
		line("seg2.east", "octree.west")

		rect((10, 1), (14, 2), name: "projekt")
		content("projekt", [Projekt])
		line("seg0.east", "projekt.west")
		line("seg1.east", "projekt.west")
		line("seg2.east", "projekt.west")
		line("octree.south", "projekt.north")
	}),
) <überblick_datenfluss>


=== Separierung in Segmente

Für jeden Punkt wird bestimmt, zu welchem Segment er gehört. Die Segmente werden dabei so berechnet, dass jeder Baum sein eigenes Segment bekommt. Dafür werden die Punkte in horizontale Scheiben unterteilt und von Oben nach Untern werden die Punkte von den Scheiben zu den Segmenten zugeordnet. Der vollständige Ablauf ist in @seperierung_in_segmente gegeben.


=== Segmente verarbeiten

Für jedes Segment werden die benötigten Eigenschaften für die Visualisierung berechnet. Dabei werden Eigenschaften spezifisch für jeden Punkt und Eigenschaften für das gesamte Segment bestimmt. In @berechnung_eigenschaften und @eigenschaften_visualisierung sind die Schritte ausgeführt.

Die fertigen Segmente werden einzeln abgespeichert, dass diese separat angezeigt werden können. Zusätzlich wird ein Octree mit allen Segmenten kombiniert erstellt.


=== Berechnung vom Octree

Für alle Branch-Knoten im Octree wird mit den Kinderknoten eine vereinfachte Punktwolke als Detailstufe für das Anzeigen berechnet. Die Baumstruktur und alle Knoten mit den zugehörigen Punkten werden abgespeichert. Der Ablauf ist in @berechnung_detailstufen erklärt.


== Stand der Technik

Punktwolken können mit unterschiedlichen Lidar Scanverfahren aufgenommen werden. Aufnahmen vom Boden oder aus der Luft bieten dabei verschiedene Vor- und Nachteile @scantech. Bei einem Scan von Boden aus, kann nur eine kleinere Fläche abgetastet werden, dafür mit erhöhter Genauigkeit, um einzelne Bäume genau zu analysieren @terrestriallidar. Aus der Luft können größere Flächen erfasst werden, wodurch Waldstücke aufgenommen werden können, aber die Datenmenge pro Baum ist geringer @forestscan.

Nach der Datenerfassung können relevante Informationen aus den Punkten bestimmt werden, dazu gehört eine Segmentierung in einzelne Bäume @treeseg und die Berechnung von Baumhöhe oder Kronenhöhe @forestscan.

Ein häufiges Format für Lidar-Daten ist das LAS Dateiformat @las. Bei diesem werden die Messpunkte mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können unterschiedliche Daten bei unterschiedlichen Punktwolken bekannt sein, aber die Position der Punkte ist immer gegeben. Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format @laz gespeichert. Die Kompression ist Verlustfrei und ermöglicht eine Kompressionsrate zwischen $5$ und $15$ je nach Eingabedaten.

_LASTools_ @lastools ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte. Durch den allgemeinen Fokus ist die Software nicht für die Verarbeitung von Waldteilen ausgelegt, wodurch Funktionalitäten wie Berechnungen von Baumeigenschaften mit zugehöriger Visualisierung nicht gegeben sind.
