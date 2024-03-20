#import "setup.typ": *


= Einleitung <einleitung>


== Motivation

Größere Gebiete wie Teile von Wäldern können mit 3D-Scanners abgetastet werden. Der Scanner ist dabei an einem Flugzeug oder einer Drohne befestigt, womit der gewünschte Bereich abgeflogen wird. Dabei entsteht eine Punktwolke, bei der für jeden Punkt die Position bekannt ist.

Aus den Punkten sind relevante Informationen aber nicht direkt ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealistisch, weshalb automatisierte Methoden benötigt werden.

Die automatisierte Unterteilung in einzelne Bäume und die Berechnung der charakteristischen Eigenschaften der Bäume bildet dabei eine Grundlage für die Auswertung vom gesamten Waldstück. Durch die interaktive Visualisierung der berechneten Daten können diese intuitiv inspiziert werden.


== Themenbeschreibung

Das Ziel dieser Arbeit ist eine Erforschung des Ablaufs von einem Scan von einem Waldstücke bis zur Analyse der Daten mit zugehöriger interaktiven Visualisierung der Ergebnisse.

Ein Beispiel für so eine Visualisierung ist in @einleitung_beispiel gegeben. Es sind die Punkte vom Datensatz zu sehen, welche basierend auf der relativen Höhe im Baum eingefärbt sind. Dadurch ist der Boden in Gelb und zu den Baumspitzen hin ändert sich die Farbe zu Rot.

#figure(caption: [Waldstück mit Einfärbung der Punkte nach Höhe.], image("../images/auto-crop/br06-uls.png", width: 90%)) <einleitung_beispiel>

Als Eingabe wird der Datensatz vom Waldstücke benötigt. Dabei wird davon ausgegangen, dass ein Datensatz eine ungeordnete Menge von Punkten enthält, für die nur die Position im dreidimensionalen Raum bekannt ist. Je nach Scanner können die Punkte im Datensatz entsprechend der räumlichen Verteilung geordnet sein oder weitere Eigenschaften wie die Farbe der Punkte enthalten. Die weiteren Daten werden nicht bei der Analyse betrachtet, wodurch die Auswertung auch für Datensätze ohne die weiteren Daten funktioniert.

Für die Analyse der Daten muss die Menge der Punkte zuerst in einzelne Bäume segmentiert werden, dass Punkte vom gleichem Baum zum gleichem Segment gehören. Danach können die einzelnen Bäume ausgewertet werden. Durch die Beschränkung auf Waldstücke kann die Segmentierung und die folgende Auswertung auf Bäume spezialisiert werden.

Bei der Auswertung werden charakteristische Eigenschaften für die Bäume, aber auch für die einzelnen Punkte im Baum bestimmt. Für Bäume werden Eigenschaften bestimmt, welche den ganzen Baum beschreiben. Für Punkte werden die Eigenschaften für die lokale Umgebung mit den umliegenden Punkten bestimmt.

Die Visualisierung präsentiert die berechneten Ergebnisse. Dabei werden die Eigenschaften visuell zu den zugehörigen Bäumen oder Punkten zugeordnet und können interaktive inspiziert werden. Dabei können die Punkte vom gesamte Datensatz oder einzelne Segmente mit den Punkten oder als Triangulierung angezeigt werden.


== Struktur der Arbeit

#let section(index, name) = {
	set heading(numbering: none)

	heading(numbering: none, level: 3, [Abschnitt #numbering("I", index): #name])
}

#section(1, [Einleitung])

In der Einleitung wird das Theme und Struktur der Arbeit vorgestellt.

#section(2, [Stand der Technik])

Der Stand der Technik beschäftigt sich mit zugehörigen wissenschaftlichen und technischen Arbeiten. #todo-inline[Update mit Stand der Technik]

#section(3, [Methodik])

Im Abschnitt Methodik werden die benutzen Algorithmen vorgestellt und erforscht. Dazu gehört die Segmentierung in einzelnen Bäume, Analyse und Triangulierung dieser und die technischen Grundlagen für die Visualisierung der Ergebnisse.

#section(4, [Implementierung])

Die Methodik ist die Grundlage für die Implementierung. Das Softwareprojekt mit der technischen Umsetzung der Algorithmen wird vorgestellt. Dafür wird die Bedienung vom Softwareprojekt, der Ablauf vom Import, das Anzeigen aller Punkte und von einzelnen Segmenten erklärt.

#section(5, [Auswertung])

Schlussendlich werden die Algorithmen aus der Methodik mithilfe der Implementierung ausgewertet. Dafür werden die benutzten Datensätze vorgestellt, mit denen der Ablauf bis zur Visualisierung getestet wird. Die Auswertung enthält die gemessenen Werte und die daraus folgende Bewertung der Arbeit.
