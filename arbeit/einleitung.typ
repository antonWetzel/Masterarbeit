#import "setup.typ": *


= Einleitung

#todo[Mit Bild(ern) auflockern.]


== Motivation

Größere Gebiete wie Teile von Wäldern können als 3D-Punktwolken gescannt werden, aber relevante Informationen sind nicht direkt aus den Daten ersichtlich. Eine manuelle Weiterverarbeitung ist durch die großen Datenmengen unrealisitsch, weshalb automatisierte Methoden benötigt werden.

Die automatisierte Unterteilung in einzelne Bäume und die Berechnung der charakteristischen Eigenschaften der Bäume bildet dabei eine Grundlage für die Auswertung vom gesamten Waldstück. In dieser Arbeit wird mit den Daten eine interaktive Visualisierung ermöglicht, welche eine manuelle Auswertung ermöglicht.


== Themenbeschreibung

Das Ziel dieser Arbeit ist eine Erforschung des Ablaufs von einem Scan von einem Waldstücke bis zur Analyse der Daten mit zugehöriger interaktiven Visualisierung der Ergebnisse. Als Eingabe wird der Datensatz vom Waldstücke benötigt. Dabei enthält ein Datensatz eine ungeordnete Menge von Punkten, für die nur die Position im dreidimensionalen Raum bekannt ist.

Für die Analyse der Daten muss die Menge der Punkte in einzelne Bäume segmentiert werden, dass Punkte vom gleichem Baum zum gleichem Segment gehören. Danach können die einzelnen Bäume ausgwertert werden. Durch die Beschränkung auf Waldstücke kann die Segmentierung und die folgende Auswertung auf Bäume spezialisiert werden.

Bei der Auswertung werden die charakteristischen Eigenschaften für die Bäume, aber auch für jeden Punkt bestimmt. Für Bäume werden Eigenschaften bestimmt, welche den ganzen Baum beschreiben. Für Punkte werden die Eigenschaften für die lokale Umgebung mit den umliegenden Punkten bestimmt.

Die Visualisierung präsentiert die berechneteten Ergenbisse. Dabei werden die Eigenschaften visuell zu den zugehörigen Bäumen oder Punkten zugeordnet und können interaktive inspiziert werden.


== Struktur der Arbeit

In @methodik wird die Methodik für die Analyse der Daten erklärt. Dazu gehört die Segmentierung in einzelen Bäume, Analyse und Triangulierung dieser und die technischen Grundlagen für die Visualisierung der Ergebnisse.

In @implementierung wird die Implementierung der Methoden ausgeführt. Dazu gehört die konkrete technische Umsetzung der Algorithmen und Messung der Ergebnisse.

Die Auswertung der Methodk wird in @auswertung durchgeführt. Dafür werden die benutzen Testdaten vorgestellt und die Ergebnisse der Implementierung analysisert.
