#import "setup.typ": *


= Auswertung <auswertung>


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

In @auswertung_import_phasen ist die Dauer für die einzelnen Phasen vom Import aufgeschlüsselt. Bei jeder Phase wird jeder Punkt betrachtet, aber am längsten wird für die Segmentierung und Berechnungen von Informationen benötigt, weil diese mehr Aufwand pro Punkt benötigen.

#figure(
	caption: [Dauer für die einzelnen Importphasen in $mu s$ pro Punkt.],
	image("../data/mikrosekunde_phase_pro_punkt.svg"),
) <auswertung_import_phasen>


== Segmentierung von Waldstücken

Ein Beispiel für eine Segmentierung ist in @segmentierung_ergebnis gegeben. Die meisten Bäume werden korrekt erkannt und zu unterschiedlichen Segmenten zugeordnet. Je weiter die Spitzen der Bäume voneinander getrennt sind, desto besser können die Bäume voneinander getrennt werden.

#figure(
	caption: [Segmentierung von einer Punktwolke.],
	image("../images/auto-crop/segments-br06-als.png"),
) <segmentierung_ergebnis>

Punkte, welche zu keinem Baum gehören, werden trotzdem zu den Segmenten zugeordnet. Bei Bereichen ohne Bäume entstehen dadurch Segmente wie in @auswertung_segmentierung_keine_bäume. Die Punkte in freien Flächen werden zu eigenen Segmenten zusammengefasst. Wenn die Punkte in der Nähe von einem Baum liegen, werden diese zu dem Baum hinzugefügt.

#figure(
	caption: [Segmente bei Gebieten ohne Bäume.],
	rect(image("../images/auto-crop/segmentation_no_trees.png"), inset: 0.5pt),
) <auswertung_segmentierung_keine_bäume>

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


== Triangulierung

Ein Beispiel für die Triangulation ist in @auswertung_triangulierung gegeben. Mit dem Ball-Pivoting Algorithmus wird eine äußere Hülle für die Punkte bestimmt, wodurch der Algorithmus auch für eine Baumkrone mit Blättern geeignet ist. Beim Baumstamm liegen alle Punkte auf der Oberfläche, wodurch diese problemlos trianguliert werden können. Bei der Krone sind die Punkte im Raum verteilt, wodurch diese nicht auf einer eindeutigen Oberfläche liegen.

#figure(
	caption: [Beispiel für eine Triangulierung von einem Baum mit $alpha = 1m$.],
	stack(
		dir: ltr,
		spacing: 1em,
		subfigure(caption: [Punkte], width: 30%, box(
			clip: true,
			image("../images/crop/triangulation_big_points.png"),
		)),
		subfigure(caption: [Dreiecke umrandet], width: 30%, box(
			clip: true,
			image("../images/crop/triangulation_big_lines.png"),
		)),
		subfigure(caption: [Dreiecke ausgefüllt], width: 30%, box(
			clip: true,
			image("../images/crop/triangulation_big_mesh.png"),
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
		subfigure(image("../images/auto-crop/perf_lod_no.png"), caption: [Detailstufen]),
		subfigure(image("../images/auto-crop/perf_lod_eye.png"), caption: [Detailstufen + Eye-Dome Lighting]),
		subfigure(image("../images/auto-crop/perf_full_no.png"), caption: [Alle Punkte]),
		subfigure(image("../images/auto-crop/perf_full_eye.png"), caption: [Alle Punkte + Eye-Dome Lighting]),
	),
) <auswertung_vis_example>

Die Detailstufen ermöglichen eine Visualisierung vom kompletten Datensatz in Echtzeit ohne einen sichtbaren Detailverlust. Der zusätzliche Speicherbedarf für die Detailstufen ist in @auswertung_vis_lod_memory gelistet. Für die Detailstufen wird zusätzlich die Hälfte vom Speicherbedarf für die Punkte benötigt.

Das Eye-Dome Lighting ermöglicht eine bessere Wahrnehmung der verlorenen Tiefeninformationen. Der Berechnungsaufwand ist dabei unabhängig von der Anzahl der sichtbaren Punkte, wodurch der Effekt auch bei einer großen Anzahl von Punkten die Renderzeit nicht beeinflusst.

#figure(
	caption: [Speicherbedarf für die Punkte und Detailstufen.],
	image("../data/ratio_source_lod_points.svg"),
) <auswertung_vis_lod_memory>


== Analyse von Bäumen


=== Punkteigenschaften

In @auswertung_curve und @auswertung_var ist ein Segment basierend auf den berechneten Eigenschaften eingefärbt gegeben und zusätzlich mit den größten und kleinste Werte gefiltert.

Die Punkte mit der größten Krümmung gehören zu den Blättern, was eine teilweise Filterung ermöglicht. Die Punkte beim Stamm haben eine geringere Krümmung, aber auch Punkte, die zu den Blättern gehören, können eine geringe Krümmung haben.

Punkte zugehörig zu einer geringen horizontalen Ausdehnung gehören immer zum Stamm oder der Spitze der Krone, wodurch der Stamm identifiziert werden kann.

#figure(
	caption: [Punktwolke basierend auf der Krümmung eingefärbt.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(box(image("../images/crop/curve_all.png"), stroke: 1pt + gray), caption: [Alle Punkte]),
		subfigure(box(image("../images/crop/curve_low.png"), stroke: 1pt + gray), caption: [Geringe Krümmung]),
		subfigure(box(image("../images/crop/curve_high.png"), stroke: 1pt + gray), caption: [Hohe Krümmung]),
	),
) <auswertung_curve>

#figure(
	caption: [Punktwolke basierend auf der Ausdehnung eingefärbt.],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(box(image("../images/crop/var_all.png"), stroke: 1pt + gray), caption: [Alle Punkte]),
		subfigure(box(image("../images/crop/var_trunk.png"), stroke: 1pt + gray), caption: [Geringe Ausdehnung]),
		subfigure(box(image("../images/crop/var_crown.png"), stroke: 1pt + gray), caption: [Hohe Ausdehnung]),
	),
) <auswertung_var>


=== Baumeigenschaften

#todo[Auswertung Baumeigenschafte]


== Fazit

Die Software ermöglicht den Übergang von den Punktdaten ohne weitere Informationen zu einer interaktiven Visualisierung vom Waldstück. Dadurch kann sich ein Überblick über das gescannte Waldstücke gemacht werden, wodurch das gewünschte Ziel erreicht ist. Trotzdem gibt es noch Fehler bei der Methodik und Implementierung, welche ausgebessert werden können.

Die Segmentierung unterteilt die Punkte in einzelne Bäume. Wenn die Kronen der Bäume klar getrennte Spitzen haben, werden diese problemlos unterteilt. Dadurch werden manche Waldstücke gut segmentiert, aber je näher die Kronen der Bäume zueinander sind, desto wahrscheinlicher werden mehrere Bäume zu einem Segment zusammengefasst. Vor der Segmentierung muss der Mindestabstand zwischen Segmenten und die Breite der Scheiben festgelegt werden. Die Parameter müssen passend für den Datensatz gewählt werden, was eine Anpassungsmöglichkeit, aber auch eine Fehlerquelle ermöglicht.

Bei der Analyse von einem Baum werden Daten für jeden Punkt im Baum und für den gesamten Baum berechnet. Für die einzelnen Punkte werden Punktgröße, Normale für die Visualisierung und die lokale Krümmung problemlos berechnet. Die Berechnung der Ausdehnung ist funktioniert für die meisten Bereiche vom Baum. Punkte vom Waldboden werden zu den Bäumen zugeordnet, wodurch die Ausdehnung am Boden höher als die Ausdehnung vom eigentlichen Stamm ist.

Die Triangulierung berechnet ein Mesh für die Segmente. Dabei wird eine äußere Hülle bestimmt, was für Bäume geeignet ist.

Die Visualisierung kann die berechneten Daten ohne Probleme visualisieren. Durch die Detailstufen können auch größere Datenmengen interaktiv angezeigt werden.


== Ausblick

Momentan werden die ermittelten Daten nur für die Visualisierung verwendet. Um die Daten als Basis für weitere Analysen zu verwenden, müssen diese in einem festgelegten Format gespeichert werden.

Vor der Visualisierung müssen die Daten importiert werden. Je größer die Datenmenge, desto länger dauert der Import und während des Imports können die Daten noch nicht inspiziert werden. Die Möglichkeit die Zwischenergebnisse vom Importprozess anzuzeigen würde das Anpassen von Importparametern erleichtern.
