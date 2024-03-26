#import "setup.typ": *


= Stand der Technik <stand_der_technik>

== Punktdaten

Punktwolken können mit unterschiedlichen Lidar Scanverfahren aufgenommen werden. Aufnahmen vom Boden oder aus der Luft bieten dabei verschiedene Vor- und Nachteile @scantech. Bei einem Scan von Boden aus, kann nur eine kleinere Fläche mit hoher abgetastet werden, wodurch einzelne Bäume genau analysiert werden können @terrestriallidar. Aus der Luft können größere Flächen mit konstanter Genauigkeit erfasst werden, wodurch Waldstücke aufgenommen werden können. Dafür ist die Punktanzahl pro Baum geringer @forestscan.

Ein häufiges Format für Lidar-Daten ist das LAS Dateiformat @las. Bei diesem werden die Messpunkte als Liste mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können unterschiedliche Daten bei unterschiedlichen Punktwolken bekannt sein, aber die Position der Punkte ist immer gegeben. Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format gespeichert @laz. Die Kompression ist verlustfrei und ermöglicht eine Kompressionsrate zwischen $5$ und $15$ je nach Eingabedaten.

_LAStools_ ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien @lastools. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte. Durch den allgemeinen Fokus ist die Software nicht für die Verarbeitung von Wäldern ausgelegt, wodurch Funktionalitäten wie Berechnungen von Baumeigenschaften mit zugehöriger Visualisierung nicht gegeben sind.

== Analyse von Bäumen

Die Punktwolken gehören zu einzelnen Bäumen oder Waldstücken. Für Waldstücke wird die Punktwolke automatisch oder manuell in Segmente unterteilt @treeseg @pang, welche wie die einzelnen Bäume weiter analysiert werden können.

Mit der Punktwolke von einem Baum können charakteristische Informationen abgeschätzt werden. Dazu gehört die Berechnung von Baum-, Stamm- und Kronenhöhe @forestscan oder der Durchmesser vom Stamm bei $1.3$ m Höhe und der Krone @pang.

In der Arbeit von #cite(<simple_tree>, form: "prose") beschäftigt sich mit der Berechnung vom Holzvolumnen von einem Baum. Dafür wird der Baum mit Zylindern rekonstuiert, aus denen das totale Volumen berechnet wird. Für die Rekonstruktion können auch neuronale Ansätze verwendet werden @neural_decomp.

Eine Alternative zur Analyse von Bäumen mit Punktwolken ist die Verwendung von mehreren Fotografien als Datenquelle @from_images. Für die Fotos werden die Tiefeninformationen geschätzt, womit eine dreidimensionale Rekonstruktion ermöglicht wird. Das Verfahren ist nur für die Rekonstruktion von einzelnen Bäumen geeignet, dafür sind Farbinformationen vorhanden, womit realistische Modelle erstellt werden können.