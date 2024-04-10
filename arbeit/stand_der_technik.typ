#import "setup.typ": *


= Stand der Technik <stand_der_technik>


== Punktdaten

Die Erfassung von Punktwolken kann durch verschiedene Lidar-Scanverfahren erfolgen. Aufnahmen vom Boden oder aus der Luft bieten dabei verschiedene Vor- und Nachteile @scantech. Bei einem Scan vom Boden aus wird eine kleinere Fläche mit hoher Genauigkeit abgetastet, wodurch einzelne Bäume genau analysiert werden können @terrestriallidar. Aus der Luft können größere Flächen mit gleichbleibender Genauigkeit erfasst werden, wodurch größere Waldgebiete aufgenommen werden können. Dafür ist die Punktanzahl pro Baum geringer @forestscan, was eine Analyse der einzelnen Bäume erschwert.

Ein häufiges Format für Lidar-Daten ist das LAS Dateiformat @las. Bei diesem werden die Messpunkte als Liste mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können die erfassten Daten bei unterschiedlichen Punktwolken variieren, aber die dreidimensionale Position der Punkte ist immer gegeben. Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format gespeichert @laz. Die Kompression ist verlustfrei und ermöglicht eine Kompressionsrate zwischen #number(5) und #number(15) je nach Eingabedaten.

LAStools ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien @lastools. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte. Durch den allgemeinen Fokus ist die Software nicht für die Verarbeitung von Wäldern ausgelegt, wodurch Funktionalitäten wie Berechnungen von Baumeigenschaften mit zugehöriger Visualisierung nicht gegeben sind.


== Analyse von Bäumen

Das abgetastete Gebiet für eine Punktwolke kann ein einzelner Baum oder ein Waldgebiet sein. Für Waldgebiete wird die Punktwolke automatisch oder manuell in Segmente unterteilt @treeseg @pang, welche wie die einzelnen Bäume weiter analysiert werden können.

Mit der Punktwolke von einem Baum können charakteristische Informationen abgeschätzt werden. Mit der Verteilung der Punkte kann die Höhe vom Stamm, der Krone und dem ganzen Baum abgeschätzt werden @forestscan. Eine weiterer relevanter Messwert ist der Durchmesser vom Stamm bei #number(1.3, unit: [m]) @pang. Aus den Messwerten können Eigenschaften wie das Alter vom Baum oder die aufgenommene Menge von Kohlenstoffdioxid, welche schwer zu messen sind, abgeschätzt werden.

Die Arbeit von #cite( <simple_tree>, form: "prose") beschäftigt sich mit der Berechnung vom Holzvolumen von einem Baum. Dafür wird für einen Baum der Stamm und die Äste mit Zylindern approximiert, aus denen dann das totale Baumvolumen berechnet werden kann. Für die Rekonstruktion der Baumstruktur können auch neuronale Ansätze verwendet werden @neural_decomp.

Mit den kombinierten Daten von den einzelnen Bäumen kann eine Forstinventur durchgeführt werden @forest_inventory. Wenn zeitlich versetze Datensätze vom gleichem Waldgebiet existieren, kann daraus auch die Entwicklung von den Bäumen abgeschätzt werden @forest_inventory_change.

Mit Punktwolken kann auch die Baumspezies bestimmt werden. Dafür kann die Verteilung der Punkte zugehörig zur Baumkrone benutzt werden @tree_ident. Zusätzlich zu den Punktwolken können hyperspektralen Bildern vom Gebiet als eine weitere Datenquelle dienen, wodurch die Klassifikation verbessert werden kann @tree_ident_spectral @tree_ident_spectral_2. Mit hochauflösenden Daten kann ein Profil für die Rinde bestimmt werden, welches für die Einordnung verwendet wird @tree_bark.

Eine Alternative zur Analyse von Bäumen mit Punktwolken ist die Verwendung von mehreren Fotografien als Datenquelle @from_images. Für die Fotos werden die Tiefeninformationen geschätzt, womit eine dreidimensionale Rekonstruktion ermöglicht wird. Das Verfahren ist nur für die Rekonstruktion von einzelnen Bäumen geeignet, dafür sind Farbinformationen vorhanden, womit realistische Modelle erstellt werden können.
