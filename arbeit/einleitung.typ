#import "setup.typ": *


= Einleitung


== Motivation

Größere Gebiete wie Teile von Wäldern können als 3D-Punktwolken gescannt werden, aber relevante Informationen sind nicht direkt aus den Daten ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealistisch, weshalb automatisierte Methoden benötigt werden.

Die automatisierte Unterteilung in einzelne Bäume und die Berechnung der charakteristischen Eigenschaften der Bäume bildet dabei eine Grundlage für die Auswertung vom gesamten Waldstück. Mit den berechneteten Daten kann eine interaktive Visualisierung ermöglicht werden, welche eine manuelle Auswertung erleichtert.


== Themenbeschreibung

Das Ziel dieser Arbeit ist eine Erforschung des Ablaufs von einem Scan von einem Waldstücke bis zur Analyse der Daten mit zugehöriger interaktiven Visualisierung der Ergebnisse. Ein Beispiel für eine Visualisierung ist in @einleitung_beispiel gegeben.

#figure(
    caption: [Waldstück mit Einfärbung der Punkte nach Höhe.],
    image("../images/br06-uls-crop.png")
) <einleitung_beispiel>

Als Eingabe wird der Datensatz vom Waldstücke benötigt. Dabei wird davon ausgegangen, dass ein Datensatz eine ungeordnete Menge von Punkten enthält, für die nur die Position im dreidimensionalen Raum bekannt ist. Je nach Scantechnologie können die Punkte im Datensatz entsprechend der räumlichen Verteilung geordnet sein oder weitere Eigenschaften wie die Farbe der Punkte enthalten. Die weiteren Daten werden nicht bei der Analyse betrachet, damit die Auswertung für alle Datensatze geeignet ist.

Für die Analyse der Daten muss die Menge der Punkte in einzelne Bäume segmentiert werden, dass Punkte vom gleichem Baum zum gleichem Segment gehören. Danach können die einzelnen Bäume ausgewertet werden. Durch die Beschränkung auf Waldstücke kann die Segmentierung und die folgende Auswertung auf Bäume spezialisiert werden.

Bei der Auswertung werden die charakteristischen Eigenschaften für die Bäume, aber auch für jeden Punkt bestimmt. Für Bäume werden Eigenschaften bestimmt, welche den ganzen Baum beschreiben. Für Punkte werden die Eigenschaften für die lokale Umgebung mit den umliegenden Punkten bestimmt.

Die Visualisierung präsentiert die berechneten Ergebnisse. Dabei werden die Eigenschaften visuell zu den zugehörigen Bäumen oder Punkten zugeordnet und können interaktive inspiziert werden.


== Struktur der Arbeit

Die Methodik für die Analyse der Daten wird in @methodik erklärt. Dazu gehört die Segmentierung in einzelnen Bäume, Analyse und Triangulierung dieser und die technischen Grundlagen für die Visualisierung der Ergebnisse.

Die Methoden dienen als Grundlage für die Implementierung in @implementierung.
Das Softwareprojekt mit den technische Umsetzung der Algorithmen wird vorgestellt. Dazu gehört die Benutzung von Softwareprojekt, der Ablauf vom Import, das Anzeigen der Segmente und einzelner Punkte.

Die Auswertung der Methoden wird in @auswertung durchgeführt. Dafür werden die benutzten Datensätze vorgestellt. Mit den Datensätzen und der Implementierung werden dann die Analyse und Visualisierung bewertet.