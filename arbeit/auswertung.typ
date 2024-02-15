#import "setup.typ": *


= Auswertung <auswertung>

#todo[Ergebnisse]


== Testdaten

Der benutze Datensatz @data beinhaltet $12$ Hektar Waldfläche in Deutschland, Baden-Württemberg. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen, Drohnen und vom Boden aus durchgeführt wurden. Dabei entstehen 3D-Punktwolken, welche im komprimiert LAS Dateiformat gegeben sind.

Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für $6$ Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen. Mit den bereits bestimmten Eigenschaften können automatisch berechnete Ergebnisse validiert werden.

#todo[Was ALS, ULS und TLS Daten]

#todo[Kurze namen für Tabellen]

#todo[TLS Daten]


== Import

Für den Import sind in @messwerte die Messdaten für unterschiedliche Datensätze gegeben. In @auswertung_import_geschwindigkeit ist der Durchsatz beim Import angegeben. Dabei wird eine Importgeschwindigkeit von circa $400 space.thin 000$ Punkte pro Sekunde für die meisten Datensätze erreicht.

#figure(
	caption: [Geschwindigkeit vom Import in Punkte pro Sekunde.],
	image("../data/punkte_pro_sekunde.svg"),
) <auswertung_import_geschwindigkeit>

In @auswertung_import_phasen ist die Dauer für die einzelnen Phasen vom Import aufgeschlüsselt. // Die größte Schwankung bei der Dauer ist in der Segmentierungsphase. Diese dauert bei einer größeren Anzahl an Datenpunkten länger pro Punkt, weil der Arbeitsaufwand für mehr Punkte mehr als linear zunimmt.

#figure(
	caption: [Dauer für die einzelnen Importphasen in $mu s$ pro Punkt.],
	image("../data/mikrosekunde_phase_pro_punkt.svg"),
) <auswertung_import_phasen>


== Segmentierung in Bäume

Ein Beispiel für eine Segmentierung ist in @segmentierung_ergebnis gegeben. Die meisten Bäume werden korrekt erkannt und zu unterschiedlichen Segmenten zugeordnet. Je weiter die Spitzen der Bäume voneinander getrennt sind, desto besser können die Bäume voneinander getrennt werden.

#figure(
	caption: [Segmentierung von einer Punktwolke.],
	image("../images/segments-crop.png"),
) <segmentierung_ergebnis>

#todo[neues Bild]

Punkte, welche zu keinem Baum gehören, werden trotzdem zu den Segmenten zugeordnet. Bei frei stehenden Flächen entstehen separate Segmente und unter Bäumen werden die Punkte zum Baum zugeordnet.

#todo[Fehler wenn spitze gerade so in scheibe]


== Analyse von Segmenten

#todo[Berechnung Ergebnisse]


== Triangulierung

#todo[Triangulierung Ergebnisse]

#todo[Vergleich $alpha$]

#figure(
	caption: [Beispiel für eine Triangulierung von einem Baum.],
	stack(
		dir: ltr,
		spacing: 1em,
		subfigure(caption: [Punkte], width: 30%, box(
			clip: true,
			image("../images/triangulation_input.png", width: 400%),
		)),
		subfigure(caption: [Dreiecke umrandet], width: 30%, box(
			clip: true,
			image("../images/triangulation_outline.png", width: 400%),
		)),
		subfigure(caption: [Dreiecke ausgefüllt], width: 30%, box(
			clip: true,
			image("../images/triangulation_filled.png", width: 400%),
		)),
	),
)


== Visualisierung

#todo[Visualisierung Ergebnisse]


== Fazit

#todo[Fazit]


== Diskussion


== Ausblick
