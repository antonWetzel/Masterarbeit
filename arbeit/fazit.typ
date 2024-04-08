= Fazit

Die Software ermöglicht den Übergang von den Punktdaten ohne weitere Informationen zu einer interaktiven Visualisierung vom Waldgebiet. Dadurch ist ein Überblick über das gescannte Waldgebiet und einzelne Bäume möglich. Trotzdem gibt es noch Fehler bei der Methodik und Implementierung, welche ausgebessert werden können.

Die Segmentierung unterteilt die Punkte in einzelne Bäume. Wenn die Kronen der Bäume klar getrennte Spitzen haben, werden diese problemlos unterteilt. Dadurch werden manche Waldgebiete gut segmentiert, aber je näher die Kronen der Bäume zueinander sind, desto wahrscheinlicher werden mehrere Bäume zu einem Segment zusammengefasst. Vor der Segmentierung muss der Mindestabstand zwischen Segmenten und die Breite der Scheiben festgelegt werden. Die Parameter müssen passend für den Datensatz gewählt werden, was eine Anpassungsmöglichkeit, aber auch eine Fehlerquelle ist.

Bei der Analyse von einem Baum werden Daten für jeden Punkt im Baum und für den gesamten Baum berechnet. Für die einzelnen Punkte werden Punktgröße, Normale für die Visualisierung und die lokale Krümmung problemlos berechnet. Die Berechnung vom Durchmesser funktioniert für die meisten Bereiche vom Baum, wird aber durch Punkte, welche nicht zum Baum gehören stark beeinflusst.

Die charakteristischen Eigenschaften vom Baum können mit den genaueren TLS-Daten abgeschätzt werden, haben aber noch systematische Fehler, welche das Ergebnis verfälschen. Mit den ALS- und ULS-Daten werden größere Gebiete abgedeckt, dafür sind die berechneten Eigenschaften ungenauer. Besonders die Berechnung vom Durchmesser vom Stamm ist nur mit den TLS-Daten möglich.

Die Triangulierung berechnet ein Mesh für die Segmente, welches von der Visualisierung angezeigt werden kann. Die Visualisierung kann die berechneten Daten ohne Probleme visualisieren. Durch die Detailstufen können auch größere Datenmengen interaktiv angezeigt werden.


== Ausblick

Momentan werden die ermittelten Daten nur für die Visualisierung verwendet. In der `project.json` sind die charakteristischen Eigenschaften für die Segmente gespeichert, aber auch Daten für die Visualisierung. Durch eine Trennung wird eine automatische Weiterverarbeitung der berechneten Eigenschaften erleichtert.

Vor der Visualisierung müssen die Daten importiert werden. Je größer die Datenmenge, desto länger dauert der Import und während des Imports können die Daten noch nicht inspiziert werden. Die Möglichkeit die Zwischenergebnisse vom Importprozess anzuzeigen würde das Anpassen von Importparametern erleichtern und die Zeit verringert, ab der die ersten Ergebnisse sichtbar sind.

Der Importer unterstützt momentan nur Dateien im LASzip-Format, wodurch Daten in anderen Formaten nicht verwendet werden können oder zuerst konvertiert werden müssen. Durch andere Importformate kann die Verwendung erweitert werden.

Die Visualisierung kann Punktwolken auch aus anderen Quellen als Waldgebiete anzeigen, ist aber stark an diesen Verwendungszweck angepasst. Durch einen zusätzlicher Importer, welcher für beliebige Datensätze geeignet ist kann die Visualisierung vielseitiger benutzt werden.
