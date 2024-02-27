#import "setup.typ": *


= Auswertung <auswertung>

#todo[Ergebnisse]

#todo[Ausschreiben]


== Testdaten

Der benutze Datensatz @data beinhaltet $12$ Hektar Waldfläche in Deutschland, Baden-Württemberg. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen (ALS#footnote([aircraft laser scan])), Drohnen (ULS#footnote([uncrewed aerial vehicle laser scan])) und vom Boden (TLS#footnote([terrestrial laser scan])) aus durchgeführt wurden. Dabei entstehen 3D-Punktwolken, welche im komprimiert LAS Dateiformat gegeben sind.

Für die meisten Waldstücke existiert ein ALS, ULS und TLS. Dabei enthält der ALS die wenigsten und der TLS die meisten Punkte. Bei ALS und ULS sind die Punkte gleichmäßig über das gescannte Gebiet verteilt. Bei TLS wird von einem zentralen Punkt aus gescannt, wodurch die Punktedichte nach außen immer weiter abnimmt.

// Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für $6$ Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen. Mit den bereits bestimmten Eigenschaften können automatisch berechnete Ergebnisse validiert werden.


== Importgeschwindigkeit

Für den Import sind in @messwerte die Messdaten für unterschiedliche Datensätze gegeben. Die Eigenschaften vom verwendeten System zum Messen sind in @systemeigenschaften gelistet. Dabei wurden nur die ALS und ULS verwendet. Durch die hohe Punktanzahl und die ungleichmäßige Verteilung bei den TLS sind diese nicht gut für die Analyse geeignet.

In @auswertung_import_geschwindigkeit ist der Durchsatz beim Import angegeben. Dabei wird eine Importgeschwindigkeit von circa $400 space.thin 000$ Punkte pro Sekunde für die Datensätze erreicht.

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
	image("../images/segments-br06-als-crop.png"),
) <segmentierung_ergebnis>

Punkte, welche zu keinem Baum gehören, werden trotzdem zu den Segmenten zugeordnet. Bei frei stehenden Flächen entstehen separate Segmente und unter Bäumen werden die Punkte zum Baum zugeordnet.

Kleine Bereiche werden vor der Zuordnung entfernt. Dadurch wird vermieden, dass ein Baum in mehrere Segmente unterteilt wird. Wenn die Spitze von einem Baum gerade so in einer Scheibe liegt, so ist der zugehörige Bereich klein und wird gefiltert. Dadurch wird kein neues Segment für den Baum erstellt und die Punkte werden dem nächsten Baum zugeordnet. Der Effekt ist in @auswertung_segmentierung_spitze zu sehen.

#figure(
	caption: [Segmentierungsfehler bei Baumspitzen.],
	grid(
		columns: 1 * 2,
		gutter: 1em,
		subfigure(rect(image("../images/segmentation_top_error_full.png"), inset: 0.5pt), caption: [Alle Segmente]),
		subfigure(rect(image("../images/segmentation_top_error.png"), inset: 0.5pt), caption: [Segment einzeln]),
	),
) <auswertung_segmentierung_spitze>


== Analyse von Segmenten

#todo[Berechnung Ergebnisse]


== Triangulierung

Ein Beispiel für die Triangulation ist in @auswertung_triangulierung gegeben. Mit dem Ball-Pivoting-Algorithmus wird eine äußere Hülle für die Punkte bestimmt, wodurch der Algorithmus auch für eine Baumkrone mit Blättern geeignet ist. Beim Baumstamm liegen alle Punkte auf der Oberfläche, welche trianguliert werden kann. Bei der Krone sind die Punkte im Raum verteilt, wodurch diese nicht auf einer eindeutigen Oberfläche liegen.

#figure(
	caption: [Beispiel für eine Triangulierung von einem Baum mit $alpha = 1m$.],
	stack(
		dir: ltr,
		spacing: 1em,
		subfigure(caption: [Punkte], width: 30%, box(
			clip: true,
			image("../images/triangulation_big_points-crop.png"),
		)),
		subfigure(caption: [Dreiecke umrandet], width: 30%, box(
			clip: true,
			image("../images/triangulation_big_lines-crop.png"),
		)),
		subfigure(caption: [Dreiecke ausgefüllt], width: 30%, box(
			clip: true,
			image("../images/triangulation_big_mesh-crop.png"),
		)),
	),
) <auswertung_triangulierung>


== Visualisierung

In @auswertung_vis_time ist die benötigte Renderzeit für die Beispiele aus @auswertung_vis_example gegeben.

#figure(
	caption: [Renderzeit in Sekunden für einen Datensatz mit #number(59967504) Punkten.],
	image("../data/renderzeit.svg"),
) <auswertung_vis_time>

//KA09-OFF-ULS
#figure(
	caption: [Visualisierung von einem Datensatz mit #number(59967504) Punkten.],
	grid(
		columns: 1 * 2,
		subfigure(image("../images/perf_lod_no-crop.png"), caption: [Detailstufen]),
		subfigure(image("../images/perf_lod_eye-crop.png"), caption: [Detailstufen + Eye-Dome-Lighting]),
		subfigure(image("../images/perf_full_no-crop.png"), caption: [Alle Punkte]),
		subfigure(image("../images/perf_full_eye-crop.png"), caption: [Alle Punkte + Eye-Dome-Lighting]),
	),
) <auswertung_vis_example>

Die Detailstufen ermöglichen eine Visualisierung vom kompletten Datensatz in Echtzeit ohne einen sichtbaren Detailverlust. Der zusätzliche Speicherbedarf für die Detailstufen ist in @auswertung_vis_lod_memory gelistet. Für die Detailstufen wird zusätzlich die Hälfte vom Speicherbedarf für die Punkte benötigt.

Das Eye-Dome-Lighting ermöglicht eine bessere Wahrnehmung der verlorenen Tiefeninformationen. Der Berechnungsaufwand ist dabei unabhängig von der Anzahl der sichtbaren Punkte, wodurch der Effekt auch bei einer großen Anzahl von Punkten die Renderzeit nicht beeinflusst.

#figure(
	caption: [Speicherbedarf für die Punkte und Detailstufen.],
	image("../data/ratio_source_lod_points.svg"),
) <auswertung_vis_lod_memory>


== Fazit

- Segmentierung Benutzbar, aber hat Fehler.
- interaktive Visualisierung möglich
	- gute Visualisierung der Punkte
-
- ...

#todo[Fazit]


== Diskussion


== Ausblick
