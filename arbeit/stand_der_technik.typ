#import "setup.typ": *


= Stand der Technik <stand_der_technik>


== Punktdaten

Die Erfassung von Punktwolken kann durch verschiedene Lidar-Scanverfahren erfolgen. Aufnahmen vom Boden oder aus der Luft bieten dabei verschiedene Vor- und Nachteile @scantech. Bei einem Scan vom Boden aus wird eine kleinere Fläche mit hoher Genauigkeit abgetastet, wodurch einzelne Bäume genau analysiert werden können @terrestriallidar. Aus der Luft können größere Flächen mit gleichbleibender Genauigkeit erfasst werden, wodurch größere Waldgebiete aufgenommen werden können. Dafür ist die Punktanzahl pro Baum geringer @forestscan, was eine Analyse der einzelnen Bäume erschwert.

Alternativ zu Lidar kann auch DAP#footnote[digital aerial photogrammetry] als Datenquelle verwendet werden @dap_als_comp. Dabei wird von einer Drohne oder einem Flugzeug mehrere Bilder vom Waldgebiet gemacht, mit denen die Höheninformationen bestimmt werden. Im Vergleich zu Lidar ist die Datengewinnung günstiger, dafür enthalten die DAP-Daten nur Informationen über die Baumkronen, weil nur diese von der Drohne oder dem Flugzeug sichtbar sind @dap.

Lidar-Daten können im LAS Dateiformat abgespeichert werden @las. Bei diesem werden die Messpunkte als Liste mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können die erfassten Daten bei unterschiedlichen Punktwolken variieren, aber die dreidimensionale Position der Punkte ist immer gegeben. Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format gespeichert @laz. Die Kompression ist verlustfrei und ermöglicht eine Kompressionsrate zwischen #number(5) und #number(15) je nach Eingabedaten.

LAStools ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien @lastools. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte. Durch den allgemeinen Fokus ist die Software nicht für die Verarbeitung von Wäldern ausgelegt, wodurch Funktionalitäten wie Berechnungen von Baumeigenschaften mit zugehöriger Visualisierung nicht gegeben sind.


== Analyse

Die Punktwolke kann für die Analyse vom abgetasteten Gebiet verwendet werden. Für agrarisch verwendete Nutzflächen kann der momentane Stand von den Pflanzen bestimmt werden und das weitere Vorgehen kann daran angepasst werden @lidar_agri.

Mit der Punktwolke von einem Baum können charakteristische Informationen abgeschätzt werden. Aus der Verteilung der Punkte kann die Höhe vom Stamm, der Krone und dem ganzen Baum berechnet werden @forestscan. Eine weiterer relevanter Messwert ist der Durchmesser vom Stamm bei #number(1.3, unit: [m]) @pang. Aus den Messwerten können Eigenschaften wie das Alter vom Baum oder die aufgenommene Menge von Kohlenstoffdioxid, welche schwer zu messen sind, abgeschätzt werden.

Mit Punktwolken kann auch die Baumspezies bestimmt werden. Dafür kann die Verteilung der Punkte zugehörig zur Baumkrone benutzt werden @tree_ident. Zusätzlich zu den Punktwolken können hyperspektralen Bildern vom Gebiet als eine weitere Datenquelle dienen, wodurch die Klassifikation verbessert werden kann @tree_ident_spectral @tree_ident_spectral_2. Mit hochauflösenden Daten kann ein Profil für die Rinde bestimmt werden, welches für die Einordnung verwendet wird @tree_bark.

Für Waldgebiete wird die Punktwolke automatisch oder manuell in Segmente unterteilt @treeseg @pang, welche wie die einzelnen Bäume weiter analysiert werden können. Aus den kombinierten Daten von den einzelnen Bäumen kann eine Forstinventur berechnet werden @forest_inventory. Wenn zeitlich versetze Datensätze vom gleichem Waldgebiet existieren, kann daraus auch die Entwicklung von den Bäumen abgeschätzt werden @forest_inventory_change.


== Rekonstruktion

Aus den Punktwolken können die ursprünglich abgetasteten Objekte rekonstruiert werden. Dazu gehören Objekte wie Gebäude und Straßen, aber auch Bäume @urban_recon.

Für die Rekonstruktion von Bäumen kann vom Boden aus zuerst der Stamm, dann Äste und final die Blätter bestimmt werden @synthetic_trees. Für die Berechnung der Baumstruktur können auch neuronale Ansätze verwendet werden @neural_decomp. Mit einer Rekonstruktion vom Baum kann das Holzvolumen geschätzt werden @simple_tree. Der Stamm und die Äste werden mit Zylindern approximiert, aus denen dann das totale Holzvolumen berechnet werden kann.

Für die Analyse von einzelnen Bäumen können mehrere Fotografien als alternative Datenquelle verwendet werden @from_images. Für die Fotos werden die Tiefeninformationen geschätzt, womit eine dreidimensionale Rekonstruktion ermöglicht wird. Das Verfahren ist nur für die Rekonstruktion von einzelnen Bäumen geeignet, dafür sind Farbinformationen vorhanden, womit realistische Modelle erstellt werden können.
