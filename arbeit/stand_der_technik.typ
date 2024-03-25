#import "setup.typ": *


= Stand der Technik <stand_der_technik>

== Datenaufnahme
Punktwolken können mit unterschiedlichen Lidar Scanverfahren aufgenommen werden. Aufnahmen vom Boden oder aus der Luft bieten dabei verschiedene Vor- und Nachteile @scantech. Bei einem Scan von Boden aus, kann nur eine kleinere Fläche abgetastet werden, dafür mit erhöhter Genauigkeit, um einzelne Bäume genau zu analysieren @terrestriallidar. Aus der Luft können größere Flächen erfasst werden, wodurch Waldstücke aufgenommen werden können, aber die Datenmenge pro Baum ist geringer @forestscan.

Ein häufiges Format für Lidar-Daten ist das LAS Dateiformat @las. Bei diesem werden die Messpunkte mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können unterschiedliche Daten bei unterschiedlichen Punktwolken bekannt sein, aber die Position der Punkte ist immer gegeben. Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format @laz gespeichert. Die Kompression ist Verlustfrei und ermöglicht eine Kompressionsrate zwischen $5$ und $15$ je nach Eingabedaten.

_LAStools_ @lastools ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte. Durch den allgemeinen Fokus ist die Software nicht für die Verarbeitung von Waldteilen ausgelegt, wodurch Funktionalitäten wie Berechnungen von Baumeigenschaften mit zugehöriger Visualisierung nicht gegeben sind.

== Analyse
Nach der Datenerfassung können relevante Informationen aus den Punkten bestimmt werden, dazu gehört eine Segmentierung in einzelne Bäume @treeseg und die Berechnung von Baumhöhe oder Kronenhöhe @forestscan.

In der Arbeit von #cite(<simple_tree>, form: "prose") beschäftigt sich mit der Berechnung vom Holzvolumnen von einem Baum. Dafür werden passend orientierte Zylinder für die Punkte berechnet, mit denen das totale Volumen berechnet wird. Für die Bestimmung von passenden Zylindern können auch neuronale Ansätze verwendet werden @neural_decomp.

Eine Alternative zur Analyse von Bäumen mit Punktwolken ist die Verwendung von mehreren Fotografien als Datenquelle @from_images. Für die Fotos werden die Tiefeninformationen geschätzt, womit eine dreidimensionale Rekonstruktion ermöglicht wird. Das Verfahren ist nur für die Rekonstruktion von einzelnen Bäumen geeignet, dafür sind Farbinformationen vorhanden, womit realistische Modelle erstellt werden können.