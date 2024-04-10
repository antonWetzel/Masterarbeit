#import "setup.typ": *


= Einleitung <einleitung>


== Motivation

Größere Gebiete wie Teile von Wäldern können mit 3D-Scanners abgetastet werden. Dabei wird vom Boden aus ein Waldgebiet abgetastet oder der Scanner ist an einem Flugzeug oder einer Drohne befestigt, womit der gewünschte Bereich abgeflogen wird. Dabei entsteht eine Punktwolke, bei der für jeden Punkt die Position bekannt ist.

Aus den Punkten sind relevante Informationen aber nicht direkt ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealistisch, weshalb automatisierte Methoden benötigt werden.

Vor der Analyse müssen die Punktwolken zuerst in die einzelnen Bäume unterteilt werden. Danach kann für jeden Baum die gewünschten Eigenschaften berechnet werden. Dazu gehört die Höhe vom Stamm, der Krone und dem gesamten Baum und der Durchmesser vom Stamm und der Baumkrone.

Eine Visualisierung der Punktwolke und der berechneten Daten ermöglicht ein Überblick über das gescannte Waldgebiet. Ein Beispiel für so eine Visualisierung ist in @einleitung_beispiel gegeben. Es sind die Punkte vom Datensatz zu sehen, welche basierend auf der relativen Höhe im Baum eingefärbt sind. Dadurch ist der Boden in Gelb und zu den Baumspitzen hin ändert sich die Farbe zu Rot.

#figure(caption: [Waldgebiet mit den Punkten nach der Höhe eingefärbt.], image("../images/auto-crop/br06-uls.png", width: 90%)) <einleitung_beispiel>


== Themenbeschreibung

Das Ziel dieser Arbeit ist eine Erforschung des Ablaufs von einem Scan von einem Waldgebiet bis zur Analyse der Daten mit zugehöriger interaktiven Visualisierung der Ergebnisse.

Als Eingabe wird der Datensatz vom Waldgebiet benötigt. Dabei wird davon ausgegangen, dass ein Datensatz eine ungeordnete Menge von Punkten enthält, für die nur die Position im dreidimensionalen Raum bekannt ist. Je nach Scanner können die Punkte im Datensatz entsprechend der räumlichen Verteilung geordnet sein oder weitere Eigenschaften wie die Farbe der Punkte enthalten. Die weiteren Daten werden nicht bei der Analyse betrachtet, wodurch die Auswertung auch für Datensätze ohne die weiteren Daten funktioniert.

Für die Analyse der Daten muss die Menge der Punkte zuerst in einzelne Bäume segmentiert werden, dass Punkte vom gleichem Baum zum gleichem Segment gehören. Danach können die einzelnen Bäume ausgewertet werden. Durch die Beschränkung auf Waldgebiete kann die Segmentierung und die folgende Auswertung auf Bäume spezialisiert werden.

Bei der Auswertung werden charakteristische Eigenschaften für die Bäume, aber auch für die einzelnen Punkte im Baum bestimmt. Für Bäume werden Eigenschaften bestimmt, welche den ganzen Baum beschreiben. Für Punkte werden die Eigenschaften für die lokale Umgebung mit den umliegenden Punkten bestimmt.

Die Visualisierung präsentiert die berechneten Ergebnisse. Dabei werden die Eigenschaften visuell zu den zugehörigen Bäumen oder Punkten zugeordnet und können interaktiv inspiziert werden. Dabei können die Punkte vom gesamte Datensatz oder einzelne Segmente mit den Punkten oder der triangulierten Oberfläche angezeigt werden.


== Struktur der Arbeit

#let section(index, name) = {
	v(1em)
	strong([Abschnitt #numbering("1.1", index): #name])
}

#section(1, [Einleitung])

In der Einleitung wird die Motivation für die Arbeit erklärt, das Thema definiert und die Struktur der Arbeit vorgestellt.

#section(2, [Stand der Technik])

Der Stand der Technik beschäftigt sich mit wissenschaftlichen und technischen Arbeiten zugehörigen zum Thema. Dazu gehört die Aufnahme und Verarbeitung von Punktdaten und die Analyse von Bäumen mit den Daten.

#section(3, [Segmentierung von Waldgebieten])

Die Segmentierung erklärt den verwendeten Algorithmus für die Unterteilung von einer Punktwolke von einem Waldgebiet in mehrere Punktwolken für jeweils einen Baum. Die Punktwolke kann dabei ungeordnet sein und für die einzelnen Punkte wird nur die Position vorausgesetzt.

#section(4, [Visualisierung])

Im Abschnitt Visualisierung werden die Algorithmen erklärt, um die Punktwolken oder einzelnen Segmente mit allen gegebenen und berechneten Daten in Echtzeit zu rendern. Dafür wird das Anzeigen von einzelnen Punkten, Detailstufen und die Visualisierung von den Tiefeninformationen erklärt.

#section(5, [Triangulierung])

Bei der Triangulierung wird für die Punktwolke von einem Baum ein geeignetes Dreiecksnetz für die Oberfläche vom Baum gesucht. Mit dem Dreiecksnetz und den Punkten kann für den Baum ein dreidimensionales Mesh erstellt werden.

#section(6, [Analyse von Segmenten])

Bei der Analyse wird mit der Punktwolke von einem Baum die charakteristischen Eigenschaften für den Baum und einzelne Punkte abgeschätzt. Für den Baum wird der Durchmesser vom Stamm und der Krone und die Höhe vom gesamten Stamm, der Krone und dem gesamten Baum berechnet. Für die einzelnen Punkte wird die relative Höhe im Baum, die lokale Krümmung und die benötigten Eigenschaften für die Visualisierung bestimmt.

#section(7, [Implementierung])

Das Softwareprojekt mit der technischen Umsetzung der Algorithmen wird in der Implementierung vorgestellt. Dafür wird die Bedienung und die Struktur vom Softwareprojekt erklärt. Für den Import wird der Ablauf und das verwendete Dateiformat vorgestellt und für die Visualisierung werden die verwendeten Algorithmen für das Anzeigen von Punkten, Segmenten und Detailstufen ausgeführt.

#section(8, [Auswertung])

Bei der Auswertung werden die in der Arbeit vorgestellten Methoden analysiert. Dafür werden die benutzten Datensätze vorgestellt, mit denen der Ablauf bis zur Visualisierung getestet wurde.

#section(9, [Fazit])

Im Fazit werden die Ergebnisse der Auswertung bewertet und mögliche Verbesserungen und Verarbeitungsschritte werden vorgestellt.

#section(10, [Appendix])

Im Appendix werden benutzte Begriffe und Datenstukturen erklärt und die verwendeten Systemeigenschaften und Messdaten für die Auswertung gelistet.
