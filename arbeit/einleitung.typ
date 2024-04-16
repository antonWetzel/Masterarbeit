#import "setup.typ": *


= Einleitung <einleitung>


== Motivation

Größere Gebiete wie Teile von Wäldern können mit 3D-Scanners abgetastet werden. Dabei wird entweder vom Boden aus ein Waldgebiet abgetastet oder der Scanner ist an einem Flugzeug oder einer Drohne befestigt, womit der gewünschte Bereich abgeflogen wird. Dabei entsteht eine Punktwolke, bei der für jeden Punkt mindestens die dreidimensionale Position bekannt ist.

Aus den Punkten sind relevante Informationen aber nicht direkt ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealistisch, weshalb automatisierte Methoden benötigt werden.

Vor der Analyse müssen die Punktwolken zuerst in die einzelnen Bäume unterteilt werden. Danach können für jeden Baum die gewünschten Eigenschaften berechnet werden. Dazu gehört die Höhe vom Stamm, der Krone und dem gesamten Baum und der Durchmesser vom Stamm bei Brusthöhe und der Baumkrone.

Eine Visualisierung der Punktwolke und der berechneten Daten ermöglicht einen Überblick über das gescannte Waldgebiet. Ein Beispiel für so eine Visualisierung ist in @einleitung_beispiel gegeben. Es sind die Punkte vom Datensatz zu sehen, welche basierend auf der relativen Höhe im Baum eingefärbt sind. Dadurch ist der Boden in Gelb und zu den Baumspitzen hin ändert sich die Farbe der Punkte zu Rot.

#figure(caption: [Waldgebiet mit den Punkten basierend auf der relativen Höhe im Baum eingefärbt.], image("../images/auto-crop/br06-uls.png", width: 90%)) <einleitung_beispiel>


== Themenbeschreibung

Das Ziel dieser Arbeit ist eine Erforschung des Ablaufs von einem Scan von einem Waldgebiet bis zur Analyse der Daten mit zugehöriger interaktiven Visualisierung der Ergebnisse.

Als Eingabe wird der Datensatz vom Waldgebiet benötigt. Dabei wird davon ausgegangen, dass ein Datensatz eine ungeordnete Menge von Punkten enthält, für die nur die Position im dreidimensionalen Raum bekannt ist. Je nach Scanner können die Punkte im Datensatz entsprechend der räumlichen Verteilung geordnet sein oder weitere Eigenschaften wie die Farbe der abgetasteten Oberfläche enthalten. Weil nur die Position bei der Analyse betrachtet wird, kann die Auswertung auch für Datensätze durchgeführt werden, welche keine weiteren Informationen enthalten.

Für die Analyse der Daten muss die Menge der Punkte zuerst in einzelne Bäume unterteilt werden. Dafür wird für jeden Baum ein Segment bestimmt, welches alle zugehörigen Punkte enthält. Danach können die einzelnen Bäume ausgewertet werden. Durch die Beschränkung auf Waldgebiete kann die Segmentierung und die folgende Auswertung auf Bäume spezialisiert werden.

Bei der Auswertung werden charakteristische Eigenschaften für die Bäume, aber auch für die einzelnen Punkte im Baum bestimmt. Für Bäume werden Eigenschaften bestimmt, welche den ganzen Baum beschreiben. Für Punkte werden die Eigenschaften für die lokale Umgebung berechnet.

Die Visualisierung präsentiert die berechneten Ergebnisse. Für die Bäume und die Punkte werden die Daten mit den berechneten Eigenschaften dargestellt und können interaktiv inspiziert werden. Dabei werden die Punkte vom gesamten Datensatz, einzelne Segmente mit den Punkten oder eine triangulierte Oberfläche angezeigt.


== Struktur der Arbeit

#let section(index, name) = {
	v(0.2em)
	strong([Abschnitt #numbering("1.1", index): #name])
}

#section(1, [Einleitung])

In der Einleitung wird die Motivation für die Arbeit erklärt, das Thema definiert und die Struktur der Arbeit vorgestellt.

#section(2, [Stand der Technik])

Der Stand der Technik beschäftigt sich mit wissenschaftlichen und technischen Arbeiten zugehörigen zum Thema. Dazu gehört die Aufnahme und Verarbeitung von Punktdaten und die Analyse von Bäumen mit den Daten.

#section(3, [Segmentierung von Waldgebieten])

Die Segmentierung erklärt den verwendeten Algorithmus für die Unterteilung von einer Punktwolke von einem Waldgebiet in mehrere Punktwolken für jeweils einen Baum. Von den Baumspitzen aus wird die Position der Bäume berechnet und die Punkte werden dem nächsten Baum zugeordnet.

#section(4, [Visualisierung])

Im Abschnitt Visualisierung wird die Methodik erklärt, um die Punktwolken oder einzelne Segmente mit allen gegebenen und berechneten Daten in Echtzeit zu rendern. Dafür wird das Anzeigen von einzelnen Punkten, Detailstufen und die Visualisierung von den Tiefeninformationen erklärt.

#section(5, [Triangulierung])

Bei der Triangulierung wird für die Punktwolke von einem Baum ein geeignetes Dreiecksnetz für die Oberfläche vom Baum gesucht. Mit dem Dreiecksnetz und den Punkten kann für den Baum ein dreidimensionales Mesh erstellt werden.

#section(6, [Analyse von Bäumen])

Bei der Analyse werden mit der Punktwolke von einem Baum die charakteristischen Eigenschaften für den Baum und einzelne Punkte berechnet. Für den Baum wird der Durchmesser vom Stamm und der Krone abgeschätzt und die Höhe vom Stamm, der Krone und dem gesamten Baum bestimmt. Für die einzelnen Punkte wird die relative Höhe im Baum, die lokale Krümmung und die benötigten Eigenschaften für die Visualisierung berechnet.

#section(7, [Implementierung])

Das Softwareprojekt mit der technischen Umsetzung der Algorithmen wird in der Implementierung vorgestellt. Dafür wird die Bedienung und die Struktur vom Programm erklärt. Für den Import wird der Ablauf und das verwendete Dateiformat vorgestellt und für die Visualisierung werden die verwendeten Algorithmen für das Anzeigen von Punkten, Segmenten und Detailstufen ausgeführt.

#section(8, [Auswertung])

Bei der Auswertung werden die in der Arbeit vorgestellten Methoden analysiert. Dafür werden die benutzten Datensätze vorgestellt, mit denen der Ablauf bis zur Visualisierung getestet wurde. Für die charakteristischen Eigenschaften der Bäume werden die berechneten Werte mit den gemessenen Werten im Datensatz verglichen.

#section(9, [Fazit])

Im Fazit werden die Ergebnisse der Auswertung eingeordnet und mögliche Verbesserungen angesprochen und weitere Verarbeitungsschritte der berechneten Daten vorgestellt.

#section(10, [Appendix])

Im Appendix werden benutzte Begriffe und Datenstrukturen erklärt und die verwendeten Systemeigenschaften und Messdaten für die Auswertung gelistet.
