#import "setup.typ": *


= Fazit


== Segmentierung

Die Segmentierung unterteilt die Punkte in einzelne Bäume. Wenn die Kronen der Bäume klar getrennte Spitzen haben, werden diese problemlos unterteilt. Dadurch werden manche Waldgebiete gut segmentiert, aber je näher die Kronen der Bäume zueinander sind, desto wahrscheinlicher werden mehrere Bäume zu einem Segment zusammengefasst. Vor der Segmentierung muss der Mindestabstand zwischen Segmenten und die Breite der Scheiben festgelegt werden. Die Parameter müssen passend für den Datensatz gewählt werden, was eine Anpassungsmöglichkeit, aber auch eine Fehlerquelle ist.

Die bereits existierende Segmentierung vom Datensatz unterteilt die Punktwolken besser für die einzelnen Bäume @pang. Dafür werden nicht nur einzelne Datensätze benötigt, sondern mehrere Datensätze werden automatisch und manuell kombiniert und in einzelne Bäume unterteilt.


== Analyse

Bei der Analyse von einem Baum werden Daten für jeden Punkt im Baum und für den gesamten Baum berechnet. Für die einzelnen Punkte werden Punktgröße, Normale für die Visualisierung und die lokale Krümmung problemlos berechnet. Die Berechnung von der Ausdehnung für eine bestimmte Höhe vom Baum funktioniert für die meisten Bereiche, wird aber durch Punkte, welche nicht zum Baum gehören stark beeinflusst. Dadurch ist die Ausdehnung stark von der Qualität der Segmentierung abhängig.

Die charakteristischen Eigenschaften vom Baum können mit den genaueren TLS-Daten abgeschätzt werden, haben aber noch systematische Fehler, welche das Ergebnis verfälschen. Mit den ALS- und ULS-Daten werden größere Gebiete abgedeckt, dafür sind die berechneten Eigenschaften ungenauer. Besonders die Berechnung vom Durchmesser vom Stamm ist nur mit den TLS-Daten möglich. Mit den ALS- und ULS-Daten können die Werte für die Baumhöhe und die Baumkrone abgeschätzt werden, weil diese Werte auch mit einer geringeren Punktdichte berechnet werden. Für Punktwolken aus der Luft mit geringer Dichte existieren besonders wenig Punkte im Bereich vom Baumstamm, wodurch keine Approximation vom Baumstamm möglich ist.


== Visualisierung

Die Software ermöglicht den Übergang von den Punktdaten ohne weitere Informationen zu einer interaktiven Visualisierung vom Waldgebiet. Dadurch ist ein Überblick über das gescannte Waldgebiet und einzelne Bäume möglich.

Die Triangulierung berechnet ein Mesh für die Segmente, welches von der Visualisierung angezeigt werden kann. Unterschiedlich zu anderer 3D-Render-Software, kann das Mesh mit den berechneten Punkteigenschaften für die Farbinformationen angezeigt werden.

Die Visualisierung ermöglicht eine interaktive Darstellung der Daten. Im Gegensatz zu LAStools @lastools werden Datenpunkte nicht mit einer festen Größe, sondern durch einen orientierten Kreis mit variablem Radius angezeigt. Dadurch entstehen keine Lücken zwischen den Datenpunkten, wenn diese eine geringere Dichte haben oder die Entfernung zur Kamera gering ist. Ein Vergleich ist in @fazit_lasview_compare gegeben. Beim `LASviewer` sind die Baumkronen weit von den Messpunkten schwer zu sehen, weil weniger Datenpunkte existieren.

#figure(
	caption: [Vergleich zwischen den Visualisierungen von `LASviewer` und `treee`.],
	grid(
		columns: 1 * 2,
		gutter: 1em,
		subfigure(rect(inset: -1pt, radius: 4pt, stroke: 5pt, image("../images/lasviewer_it.png")), caption: [`LASviewer`]),
		subfigure(rect(inset: -1pt, radius: 4pt, stroke: 5pt, image("../images/lasviewer_treee.png")), caption: [`treee`]),
	),
) <fazit_lasview_compare>

Für größere Datensätze zeigt LAStools nur eine vorher festgelegte Anzahl von zufällig ausgewählten Punkten. Je größer die Anzahl, desto länger wird für das Rendern der Punkte benötigt, wodurch für große Datensätze nicht alle Daten gerendert werden oder das Rendern länger dauert und die Navigation erschwert. Die Berechnung der Detailstufen benötigen einen Vorverarbeitungsschritt, dafür kann der komplette Datensatz interaktiv angezeigt werden ohne.


== Ausblick

Momentan werden die ermittelten Daten nur für die Visualisierung verwendet. In der `project.json` sind die charakteristischen Eigenschaften für die Segmente gespeichert, aber auch Daten für die Visualisierung. Durch eine Trennung wird eine automatische Weiterverarbeitung der berechneten Eigenschaften erleichtert.

Für jeden Baum wird abhängig von der Höhe die horizontale Ausdehnung bestimmt. Ein Beispiel für die Daten ist in @fazit_slices gegeben. Die Verteilung kann als Basis für die Baumform benutzt werden, womit zum Beispiel Schätzung für die zugehörige Spezies gemacht werden kann.

#figure(caption: [Horizontale Scheiben für einen Baum mit der zugehörigen Fläche für jede Scheibe.], grid(
	columns: 1 * 2,
	image("../images/auto-crop/prop_height.png", height: 30%),
	image("../images/klassifkation_slices.svg", height: 30%),
)) <fazit_slices>

Vor der Visualisierung müssen die Daten importiert werden. Je größer die Datenmenge, desto länger dauert der Import und während des Imports können die Daten noch nicht inspiziert werden. Die Möglichkeit die Zwischenergebnisse vom Importprozess anzuzeigen würde das Anpassen von Importparametern erleichtern und die Zeit verringert, ab der die ersten Ergebnisse sichtbar sind.

Der Importer unterstützt momentan nur Dateien im LASzip-Format, wodurch Daten in anderen Formaten nicht verwendet werden können oder zuerst konvertiert werden müssen. Durch andere Importformate kann die Verwendung erweitert werden.

Die Visualisierung kann Punktwolken auch aus anderen Quellen als Waldgebiete anzeigen, ist aber stark an diesen Verwendungszweck angepasst. Durch einen zusätzlicher Importer, welcher für beliebige Datensätze geeignet ist kann die Visualisierung vielseitiger benutzt werden.
