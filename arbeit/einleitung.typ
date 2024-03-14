#import "setup.typ": *


= Einleitung <einleitung>


== Motivation

Größere Gebiete wie Teile von Wäldern können mit 3D-Scanners abgetastet werden. Der Scanner ist dabei an einem Flugzeug oder einer Drohne befestigt, womit der gewünschte Bereich abgeflogen wird. Dabei entsteht eine Punktewolke, bei der für jeden Punkt die Position bekannt ist.

Aus den Punkten sind relevante Informationen aber nicht direkt ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealistisch, weshalb automatisierte Methoden benötigt werden.

Die automatisierte Unterteilung in einzelne Bäume und die Berechnung der charakteristischen Eigenschaften der Bäume bildet dabei eine Grundlage für die Auswertung vom gesamten Waldstück. Durch die interaktive Visualisierung der berechneten Daten können diese intuitiv inspiziert werden.


== Themenbeschreibung

Das Ziel dieser Arbeit ist eine Erforschung des Ablaufs von einem Scan von einem Waldstücke bis zur Analyse der Daten mit zugehöriger interaktiven Visualisierung der Ergebnisse. Ein Beispiel für eine Visualisierung ist in @einleitung_beispiel gegeben.

#figure(caption: [Waldstück mit Einfärbung der Punkte nach Höhe.], image("../images/auto-crop/br06-uls.png")) <einleitung_beispiel>

Als Eingabe wird der Datensatz vom Waldstücke benötigt. Dabei wird davon ausgegangen, dass ein Datensatz eine ungeordnete Menge von Punkten enthält, für die nur die Position im dreidimensionalen Raum bekannt ist. Je nach Scanner können die Punkte im Datensatz entsprechend der räumlichen Verteilung geordnet sein oder weitere Eigenschaften wie die Farbe der Punkte enthalten. Die weiteren Daten werden nicht bei der Analyse betrachtet, wodurch die Auswertung auch für Datensätze ohne die weiteren Daten funktioniert.

Für die Analyse der Daten muss die Menge der Punkte zuerst in einzelne Bäume segmentiert werden, dass Punkte vom gleichem Baum zum gleichem Segment gehören. Danach können die einzelnen Bäume ausgewertet werden. Durch die Beschränkung auf Waldstücke kann die Segmentierung und die folgende Auswertung auf Bäume spezialisiert werden.

Bei der Auswertung werden die charakteristischen Eigenschaften für die Bäume, aber auch für jeden Punkt bestimmt. Für Bäume werden Eigenschaften bestimmt, welche den ganzen Baum beschreiben. Für Punkte werden die Eigenschaften für die lokale Umgebung mit den umliegenden Punkten bestimmt.

Die Visualisierung präsentiert die berechneten Ergebnisse. Dabei werden die Eigenschaften visuell zu den zugehörigen Bäumen oder Punkten zugeordnet und können interaktive inspiziert werden.


== Struktur der Arbeit

In @einleitung wird das Theme vorgestellt und @stand_der_technik enthält den zugehörigen Stand der Technik.

Die Methodik wird in @methodik erklärt. Dazu gehört die Segmentierung in einzelnen Bäume, Analyse und Triangulierung dieser und die technischen Grundlagen für die Visualisierung der Ergebnisse.

Die Methoden dienen als Grundlage für die Implementierung in @implementierung. Das Softwareprojekt mit der technischen Umsetzung der Algorithmen wird vorgestellt. Dafür wird die Bedienung vom Softwareprojekt, der Ablauf vom Import, das Anzeigen aller Punkte und von einzelnen Segmenten erklärt.

Die Auswertung wird in @auswertung durchgeführt. Dafür werden die benutzten Datensätze vorgestellt. Mit den Datensätzen und der Implementierung werden dann die Analyse und Visualisierung bewertet.
