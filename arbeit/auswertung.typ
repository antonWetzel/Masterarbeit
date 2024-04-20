#import "setup.typ": *


= Auswertung <auswertung>


== Testdaten

Der benutze Datensatz#footnote[Terrestrial, UAV-borne, and airborne laser scanning point clouds of central European forest plots, Germany, with extracted individual trees and manual forest inventory measurements] beinhaltet zwölf Hektar Waldfläche in Deutschland, Baden-Württemberg @data. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen (ALS#footnote([aircraft laser scan])), Drohnen (ULS#footnote([uncrewed aerial vehicle laser scan])) und vom Boden (TLS#footnote([terrestrial laser scan])) aus durchgeführt wurden. Die 3D-Punktwolken sind im komprimierten LASzip Dateiformat gegeben.

Für die meisten Waldgebiete existieren ALS-, ULS- und TLS-Daten. Dabei enthalten die ALS-Daten die wenigsten und die TLS-Daten die meisten Punkte. Bei den ALS- und ULS-Daten sind die Punkte gleichmäßig über das gescannte Gebiet verteilt. Bei den TLS-Daten wird von einem festen Punkt aus gescannt, wodurch die Punktdichte nach außen immer weiter abnimmt.

Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für sechs Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen. Mit den bereits bestimmten Eigenschaften können automatisch berechnete Ergebnisse validiert werden.


== Importgeschwindigkeit

In @auswertung_import_geschwindigkeit sind die Importgeschwindigkeiten gegeben. Die Eigenschaften vom verwendeten System sind in @systemeigenschaften und die genauen Messwerte in @messwerte gelistet. Für jedes Waldgebiet wurde jeweils ein zufälliger Datensatz von den ALS-, ULS- und TLS-Daten verwendet.

#figure(
	caption: [Geschwindigkeit vom Import in Punkte pro Sekunde.],
	image("../data/punkte_pro_sekunde.svg"),
) <auswertung_import_geschwindigkeit>

Bei den ALS-Daten wird für die meisten Datensätze eine Importgeschwindigkeit von #number(500000) Punkte pro Sekunde erreicht. Durch die kleinen Datenmengen schwankt aber die Importgeschwindigkeit stark. Für die ULS-Daten liegt die Importgeschwindigkeit bei #number(400000) und für die TLS-Daten bei #number(250000).

In @auswertung_import_phasen sind die absoluten und relativen Dauern für die einzelnen Phasen vom Import aufgeschlüsselt. Am längsten wird für die Analyse der Segmente benötigt, weil für jeden Punkt die benötigten Eigenschaften berechnet werden.

#figure(
	caption: [Dauer für die einzelnen Importphasen pro Punkt.],
	grid(
		gutter: 1em,
		subfigure(image("../data/mikrosekunde_phase_pro_punkt.svg"), caption: [Absolut]),
		subfigure(image("../data/phasen_percent.svg"), caption: [Relativ]),
	) ,
) <auswertung_import_phasen>

Bei den TLS-Daten enthalten durch die ungleiche Punktdichte manche Segmente überproportional viele Punkte, wodurch die Analyse von diesen Segmenten pro Punkt länger dauert.

Wie in @auswertung_ka_flat zu sehen, ist bei den `ALS-KAxx`-Daten der Boden sehr eben, wodurch die Baumkronen ähnliche Höhen haben. Dadurch haben viele Punkte die gleiche Höhe und die Segmentierung dauert länger.

#figure(
	caption: [Seitenansicht für die Punktwolke `ALS-KA10`.],
	image("../images/auto-crop/ka10-side.png"),
) <auswertung_ka_flat>


== Segmentierung von Waldgebieten

Beispiele für die Segmentierung sind in @segmentierung_ergebnis gegeben. Die meisten Bäume werden korrekt erkannt und zu unterschiedlichen Segmenten zugeordnet. Je weiter die Spitzen der Bäume voneinander getrennt sind, desto besser können die Bäume voneinander unterschieden werden. Für Bäume, bei denen die Baumkronen keine klare Trennung haben, werden die Bäume fehlerhaft zu einem Segment zusammengefasst.

#figure(
	caption: [Segmentierung von unterschiedlichen Punktwolken.],
	grid(
		gutter: 1em,
		grid(
			columns: (1.3fr, 1fr),
			subfigure(caption: [ALS], image("../images/auto-crop/segments-ka11-als.png")), subfigure(caption: [ULS], image("../images/auto-crop/segmentation_uls.png")),
		),
		subfigure(caption: [TLS], image("../images/auto-crop/segmentation_tls.png")),
	),
) <segmentierung_ergebnis>

Punkte, welche zu keinem Baum gehören, werden trotzdem zu den Segmenten zugeordnet. Dadurch entstehen Segmente wie in @auswertung_segmentierung_keine_bäume. Die Punkte in den freien Flächen werden zu eigenen Segmenten zusammengefasst, welche zu keinem Baum gehören. Wenn die Punkte in der Nähe von einem Baum liegen, werden diese als Boden zu dem Baum hinzugefügt.

#figure(
	caption: [Segmente bei Gebieten ohne Bäume.],
	rect(image("../images/auto-crop/segmentation_no_trees.png", width: 90%), inset: 0.5pt),
) <auswertung_segmentierung_keine_bäume>

Kleine Bereiche werden vor der Zuordnung entfernt. Dadurch wird vermieden, dass ein Baum in mehrere Segmente unterteilt wird. Wenn die Spitze von einem Baum gerade so in einer Scheibe liegt, so ist der zugehörige Bereich klein und wird gefiltert. Dadurch wird kein neues Segment für den Baum erstellt und die Punkte werden dem falschen nächsten Baum zugeordnet. Der Effekt ist in @auswertung_segmentierung_spitze zu sehen. Die Spitzen von den umliegenden Bäumen wurden dem nächsten größeren Baum zugeordnet.

#figure(
	caption: [Segmentierungsfehler bei Baumspitzen.],
	grid(
		columns: 1 * 2,
		gutter: 1em,
		subfigure(rect(image("../images/segmentation_top_error_full.png"), inset: 0.5pt), caption: [Alle Segmente]),
		subfigure(rect(image("../images/segmentation_top_error.png"), inset: 0.5pt), caption: [Segment einzeln]),
	),
) <auswertung_segmentierung_spitze>

#pagebreak(weak: true)


== Triangulierung

Ein Beispiel für die Triangulation ist in @auswertung_triangulierung gegeben. Mit dem Ball-Pivoting Algorithmus wird eine äußere Hülle für die Punkte bestimmt, wodurch der Algorithmus auch für eine Baumkrone mit Blättern geeignet ist.

#figure(
	caption: [Beispiel für eine Triangulierung von einem Baum mit #box($alpha = #number(1, unit: [m])$).],
	grid(
		columns: 1 * 3,
		gutter: 1em,
		subfigure(caption: [Punkte], image("../images/crop/triangulation_big_points.png")),
		subfigure(caption: [Dreiecke umrandet], image("../images/crop/triangulation_big_lines.png")),
		subfigure(caption: [Dreiecke ausgefüllt], image("../images/crop/triangulation_big_mesh.png")),
	),
) <auswertung_triangulierung>

Beim Baumstamm liegen alle Punkte auf der Oberfläche, wodurch diese ohne Probleme trianguliert werden können. Bei der Krone sind die Punkte im Raum verteilt, wodurch diese nicht auf einer eindeutigen Oberfläche liegen.

Mit einem ausreichend großen Wert für $alpha$ wird eine passende äußere Hülle berechnet. Bei Bereichen ohne Punkte wird für kleine $alpha$ keine passende Oberfläche gefunden, wodurch das berechnete Dreiecksnetz fehlerhaft ist.


== Visualisierung

Die gleiche Punktwolke ist in @auswertung_vis_example jeweils mit und ohne Detailstufen und Eye-Dome-Lighting gegeben. Die Detailstufen sind nicht von den originalen Punkten optisch zu unterscheiden und das Eye-Dome-Lighting ermöglicht eine bessere Wahrnehmung der verlorenen Tiefeninformationen.

//KA09-OFF-ULS
#figure(
	caption: [Visualisierung von einem Datensatz mit #number(59967504) Punkten.],
	grid(
		columns: 1 * 2,
		gutter: 2em,
		subfigure(image("../images/auto-crop/perf_full_no.png"), caption: [originalen Punkte]),
		subfigure(image("../images/auto-crop/perf_lod_no.png"), caption: [Detailstufen]),
		subfigure(image("../images/auto-crop/perf_full_eye.png"), caption: [originalen Punkte #linebreak() Eye-Dome-Lighting]),
		subfigure(image("../images/auto-crop/perf_lod_eye.png"), caption: [Detailstufen #linebreak() Eye-Dome-Lighting]),
	),
) <auswertung_vis_example>

Wie in @auswertung_vis_time zu sehen, ist die Renderzeit durch die Detailstufen ein Bruchteil im Vergleich zur Dauer für die originalen Punkte. Das Eye-Dome-Lighting hat unabhängig von der Anzahl der sichtbaren Punkte keinen relevanten Effekt auf die Renderzeit.

#figure(
	caption: [Renderzeit für einen Datensatz mit #number(59967504) Punkten.],
	image("../data/renderzeit.svg"),
) <auswertung_vis_time>

Der Speicherbedarf für die Detailstufen ist in @auswertung_vis_lod_memory gelistet. Für diese wird im Durchschnitt zusätzlich die Hälfte vom Speicherbedarf von den originalen Punkten benötigt.

#figure(
	caption: [Speicherbedarf für die Punkte vom Datensatz und der Detailstufen.],
	image("../data/ratio_source_lod_points.svg"),
) <auswertung_vis_lod_memory>


== Analyse von Bäumen


=== Punkteigenschaften

In @auswertung_curve ist ein Segment basierend auf der Krümmung eingefärbt. Die Punkte mit der größten Krümmung gehören zu den Blättern, was eine Filterung ermöglicht. Die Punkte beim Stamm und teilweise in der Krone haben eine geringere Krümmung.

#figure(
	caption: [Punktwolke basierend auf der Krümmung eingefärbt.],
	box(width: 75%, grid(
		columns: 1 * 3,
		gutter: 5em,
		subfigure(image("../images/crop/prop_curve_all.png"), caption: [Alle Punkte]),
		subfigure(image("../images/crop/prop_curve_low.png"), caption: [Geringe Krümmung]),
		subfigure(image("../images/crop/prop_curve_high.png"), caption: [Hohe Krümmung]),
	)),
) <auswertung_curve>

Die Krümmung wurde für jeden Punkt mit den $31$ nächsten Punkten bestimmt, wodurch für dichtere Bereiche in der Punktwolke nur ein sehr kleines Gebiet betrachtet wird. Um den Einflussradius zu erhöhen, können mehr Punkte für die Nachbarschaft verwendet werden, dadurch steigt aber auch der Berechnungsaufwand. Eine andere Option ist es, für jeden Punkt die durchschnittliche Krümmung der umliegenden Punkte zu verwenden. Der Durchschnitt kann mit der bereits vorhandenen Nachbarschaft einfach berechnet werden.

Der gleiche Baum ist in @auswertung_var basierend auf der horizontalen Ausdehnung eingefärbt. Punkte zugehörig zu einer geringen horizontalen Ausdehnung gehören immer zum Stamm oder der Spitze der Krone, wodurch der Übergang vom Stamm zur Baumkrone gefunden werden kann.

#figure(
	caption: [Punktwolke basierend auf der Ausdehnung eingefärbt.],
	box(width: 75%, grid(
		columns: 1 * 3,
		gutter: 5em,
		subfigure(image("../images/crop/prop_var_all.png"), caption: [Alle Punkte]),
		subfigure(image("../images/crop/prop_var_trunk.png"), caption: [Geringe Ausdehnung]),
		subfigure(image("../images/crop/prop_var_crown.png"), caption: [Hohe Ausdehnung]),
	)),
) <auswertung_var>


=== Baumeigenschaften

Für die Auswertung von der Berechnung der Baumeigenschaften werden die berechneten Werte mit den direkt am Baum gemessenen Werten verglichen.

Für die Berechnung wurden die einzelnen bereits segmentierten Bäume aus dem Datensatz verwenden. Die Positionen der Bäume wurde mit einer Kombination von den ALS-, ULS- und TLS-Daten und einer manuellen Unterteilung der Punkte berechnet. Danach wurden alle Punktwolken der Waldgebiete mit den Baumpositionen unterteilt, wodurch besonders für die ALS- und ULS-Daten für manche Bäume nur wenig Punkte bekannt sind @pang. Eine Visualisierung vom Unterschied ist in @auswertung_vergleich_scanner und @auswertung_vergleich2_scanner gegeben.

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

Die Datenpunkte sind in @analyse_baumeigenschaften zu sehen. Entlang der x-Achse sind die gemessenen Werte und entlang der y-Achse sind die berechneten Werte. Im Idealfall sind beide Werte gleich, wodurch ein Datenpunkt auf der Diagonalen entsteht. Wenn ein Punkt oberhalb der Diagonalen ist, wurde ein zu großer Wert berechnet und ist der Punkt unterhalb, ist der berechnete Wert zu klein.

#figure(
	caption: [Vergleich zwischen den Messwerten und Approximation von den Baumeigenschaften.],
	grid(
		columns: 1 * 2,
		column-gutter: 1em,
		row-gutter: 3em,
		subfigure(image("../data/data_tree_height.svg", height: 195pt), caption: [Gesamthöhe vom Baum]),
		subfigure(image("../data/data_trunk_diameter.svg", height: 195pt), caption: [Stammdurchmesser bei #number(130, unit: [cm])]),
		subfigure(image("../data/data_crown_start.svg", height: 195pt), caption: [Anfangshöhe der Baumkrone]),
		subfigure(image("../data/data_crown_diameter.svg", height: 195pt), caption: [Durchmesser der Baumkrone]),
	),
) <analyse_baumeigenschaften>

Für die Gesamthöhe vom Baum liegen weniger Messwerte vor, wodurch weniger Vergleiche mit der Approximation möglich sind. Die Approximation für die Baumhöhe ist mit den ALS-, ULS- und TLS-Daten möglich, weil die Gesamthöhe gesucht wird, welche unabhängig von der Punktdichte berechnet werden kann.

Die Berechnung vom Stammdurchmesser funktioniert für die TLS-Daten am besten. Der Stamm wird als Kreis approximiert, wodurch die berechneten Werte kleiner als die gemessenen Werte sind. Bei den ULS-Daten ist eine Korrelation zu sehen, aber die Ergebnisse weichen stark von den gemessenen Werten ab. Mit den ALS-Daten kann der Stammdurchmesser nicht berechnet werden. Bei vielen Punktwolken waren zu wenig Datenpunkte im verwendeten Bereich für die Berechnung, wodurch der Standardwert von $50$ cm verwendet wurde.

Auch die Berechnung von der Anfangshöhe der Baumkrone funktioniert mit den TLS-Daten am besten. Mit den ALS- und den ULS-Daten ist eine Approximation möglich, wobei die Ergebnisse bei den ALS Daten weiter von den gemessenen Werten abweichen.

Für die Berechnung vom Durchmesser der Baumkrone sind die ALS-, ULS- und TLS-Daten geeignet. Durch die Approximation der Baumform als Kreis ist der berechnete Wert kleiner als der gemessene Wert. Bei den gemessenen Werten würde der Durchschnitt zwischen der größten Ausdehnung und zugehörigen orthogonalen Ausdehnung bestimmt, wodurch die Baumform als Ellipse approximiert wird. Der Radius vom Kreis mit gleichem Umfang wie die Ellipse ist kleiner, wodurch der systematische Fehler entsteht.
