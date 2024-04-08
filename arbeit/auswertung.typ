#import "setup.typ": *


= Auswertung <auswertung>


== Testdaten

Der benutze Datensatz @data beinhaltet $12$ Hektar Waldfläche in Deutschland, Baden-Württemberg. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen (ALS#footnote([aircraft laser scan])), Drohnen (ULS#footnote([uncrewed aerial vehicle laser scan])) und vom Boden (TLS#footnote([terrestrial laser scan])) aus durchgeführt wurden. Dabei entstehen 3D-Punktwolken, welche im komprimiert LAS Dateiformat gegeben sind.

Für die meisten Waldgebiete existieren ALS-, ULS- und TLS-Daten. Dabei enthalten die ALS-Daten die wenigsten und die TLS-Daten die meisten Punkte. Bei den ALS- und ULS-Daten sind die Punkte gleichmäßig über das gescannte Gebiet verteilt. Bei den TLS-Daten wird von einem zentralen Punkt aus gescannt, wodurch die Punktedichte nach außen immer weiter abnimmt.

Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für $6$ Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen. Mit den bereits bestimmten Eigenschaften können automatisch berechnete Ergebnisse validiert werden.


== Importgeschwindigkeit

Für den Import sind in @auswertung_import_geschwindigkeit die Importgeschwindigkeiten in Punkte pro Sekunde gegeben. Die genauen Messwerte sind in @messwerte und die Eigenschaften vom verwendeten System sind in @systemeigenschaften gelistet. Für jedes Waldgebiet wurde jeweils ein zufälliger Datensatz von den ALS-, ULS- und TLS-Daten verwendet.

#figure(
	caption: [Geschwindigkeit vom Import in Punkte pro Sekunde.],
	image("../data/punkte_pro_sekunde.svg"),
) <auswertung_import_geschwindigkeit>

Bei den ALS-Daten wird für die meisten Datensätze eine Importgeschwindigkeit von #number(500000) erreicht. Durch die kleinen Datenmengen schwankt aber die Importgeschwindigkeit stark. Für die ULS-Daten wird eine Importgeschwindigkeit von #number(200000) und für die TLS-Daten von #number(400000) erreicht.

In @auswertung_import_phasen ist die Dauer für die einzelnen Phasen vom Import aufgeschlüsselt. Am längsten wird für die Analyse der Segmente benötigt, weil für jeden Punkt die benötigten Eigenschaften berechnet werden. Bei den `ALS-KAxx`-Daten ist der Boden sehr eben, wodurch die Baumkronen ähnliche Höhen haben. Dadurch haben viele Punkte die gleiche Höhe und die Segmentierung dauert länger.

#figure(
	caption: [Dauer für die einzelnen Importphasen in $mu s$ pro Punkt.],
	image("../data/mikrosekunde_phase_pro_punkt.svg"),
) <auswertung_import_phasen>


== Segmentierung von Waldgebieten

Ein Beispiel für eine Segmentierung ist in @segmentierung_ergebnis gegeben. Die meisten Bäume werden korrekt erkannt und zu unterschiedlichen Segmenten zugeordnet. Je weiter die Spitzen der Bäume voneinander getrennt sind, desto besser können die Bäume voneinander getrennt werden.

#figure(
	caption: [Segmentierung von einer Punktwolke.],
	image("../images/auto-crop/segments-ka11-als.png"),
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
	caption: [Speicherbedarf für die Punkte vom Datensatz und der Detailstufen.],
	image("../data/ratio_source_lod_points.svg"),
) <auswertung_vis_lod_memory>


== Analyse von Bäumen


=== Punkteigenschaften

In @auswertung_curve und @auswertung_var ist ein Segment basierend auf den berechneten Eigenschaften eingefärbt gegeben und zusätzlich mit den größten und kleinste Werte gefiltert.

Die Punkte mit der größten Krümmung gehören zu den Blättern, was eine teilweise Filterung ermöglicht. Die Punkte beim Stamm haben eine geringere Krümmung, aber auch Punkte, die zu den Blättern gehören, können eine geringe Krümmung haben.

Punkte zugehörig zu einer geringen horizontalen Ausdehnung gehören immer zum Stamm oder der Spitze der Krone, wodurch der Stamm identifiziert werden kann.

#figure(
	caption: [Punktwolke basierend auf der Krümmung eingefärbt.],
	box(width: 75%, grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(image("../images/crop/prop_curve_all.png"), caption: [Alle Punkte]),
		subfigure(image("../images/crop/prop_curve_low.png"), caption: [Geringe Krümmung]),
		subfigure(image("../images/crop/prop_curve_high.png"), caption: [Hohe Krümmung]),
	)),
) <auswertung_curve>

#figure(
	caption: [Punktwolke basierend auf der Ausdehnung eingefärbt.],
	box(width: 75%, grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(image("../images/crop/prop_var_all.png"), caption: [Alle Punkte]),
		subfigure(image("../images/crop/prop_var_trunk.png"), caption: [Geringe Ausdehnung]),
		subfigure(image("../images/crop/prop_var_crown.png"), caption: [Hohe Ausdehnung]),
	)),
) <auswertung_var>


=== Baumeigenschaften

In @analyse_baumeigenschaften werden die korrekten gemessenen Werte für die Baumeigenschaften mit den aus den Punktwolken algorithmisch berechneten Werten verglichen. Entlang der x-Achse sind die gemessenen Werte und entlang der y-Achse sind die berechneten Werte.

#figure(
	caption: [Vergleich zwischen den Messwerten und Approximation von den Eigenschaften für die Baumkrone.],
	grid(
		columns: 1 * 2,
		column-gutter: 1em,
		row-gutter: 3em,
		subfigure(image("../data/data_tree_height.svg", height: 200pt), caption: [Gesamthöhe vom Baum]),
		subfigure(image("../data/data_trunk_diameter.svg", height: 200pt), caption: [Stammdurchmesser bei #number(130, unit: [cm])]),
		subfigure(image("../data/data_crown_start.svg", height: 200pt), caption: [Anfangshöhe der Baumkrone]),
		subfigure(image("../data/data_crown_diameter.svg", height: 200pt), caption: [Durchmesser der Baumkrone]),
	),
) <analyse_baumeigenschaften>

Für den Vergleich wurden die einzelnen Bäume aus dem Datensatz verwenden. Die Positionen der Bäume wurde mit einer Kombination von den ALS-, ULS- und TLS-Daten und einer manuellen Unterteilung der Punkte berechnet. Danach wurden alle Punktwolken der Waldgebiete mit den Baumpositionen unterteilt, wodurch besonders für die ALS- und ULS-Daten für manche Bäume nur wenig Punkte bekannt sind @pang. Eine Visualisierung vom Unterschied ist in @auswertung_vergleich_scanner und @auswertung_vergleich2_scanner gegeben.

// BR01\single_trees\QuePet_BR01_P21T14
#figure(
	caption: [Vergleich zwischen den unterschiedlichen Daten für einen Baum mit wenig Punkten.],
	grid(
		columns: 1 * 4,
		gutter: 3em,
		subfigure(image("../images/crop/compare2_als.png"), caption: [ALS#linebreak()#number(1503) Punkte]),
		subfigure(image("../images/crop/compare2_uls_off.png"), caption: [ULS-off#linebreak()#number(7156) Punkte]),
		subfigure(image("../images/crop/compare2_uls_on.png"), caption: [ULS-on#linebreak()#number(6273) Punkte]),
		subfigure(rect(width: 100%, height: 37%, radius: 5pt, align(center + horizon)[Keine Daten]), caption: [TLS#linebreak() -- Punkte]),
	),
) <auswertung_vergleich_scanner>

// BR02\single_trees\FagSyl_BR02_02
#figure(
	caption: [Vergleich zwischen den unterschiedlichen Daten für einen Baum mit vielen Punkten.],
	grid(
		columns: 1 * 4,
		gutter: 2em,
		subfigure(image("../images/crop/compare_als.png"), caption: [ALS#linebreak()#number(6446) Punkte]),
		subfigure(image("../images/crop/compare_uls_off.png"), caption: [ULS-off#linebreak()#number(58201) Punkte]),
		subfigure(image("../images/crop/compare_uls_on.png"), caption: [ULS-on#linebreak()#number(74262) Punkte]),
		subfigure(image("../images/crop/compare_tls.png"), caption: [TLS#linebreak()#number(1687505) Punkte]),
	),
) <auswertung_vergleich2_scanner>

Für die Gesamthöhe vom Baum liegen weniger Messwerte vor, wodurch weniger Vergleiche für die Approximation möglich sind. Die Approximation für die Baumhöhe ist mit den ALS-, ULS- und TLS-Daten möglich.

Die Berechnung vom Stammdurchmesser funktioniert für die TLS-Daten am besten. Der Stamm wird als Kreis approximiert, wodurch die berechneten Werte kleiner als die gemessenen Werte sind. Bei den ULS Daten ist eine Korrelation zu sehen, aber die Ergebnisse weichen stark von den gemessenen Werten ab. Mit den ALS-Daten kann der Stammdurchmesser nicht berechnet werden. Bei vielen Punktwolken waren zu wenig Datenpunkte im verwendeten Bereich für die Berechnung, wodurch der Standardwert von $50$ cm verwendet wurde.

Auch die Berechnung von der Anfangshöhe der Baumkrone funktioniert mit den TLS-Daten am besten. Mit den ALS- und den ULS-Daten ist eine Approximation möglich, wodurch die Ergebnisse bei den ALS Daten weiter von den gemessenen Werten schwanken.

Bei der Berechnung vom Durchmesser der Baumkrone sind die ALS-, ULS- und TLS-Daten geeignet. Durch die Approximation der Baumform als Kreis ist der berechnete Wert kleiner als der gemessene Wert. Bei den gemessenen Werten würde der Durchschnitt zwischen der größten Ausdehnung und zugehörigen orthogonalen Ausdehnung bestimmt.
