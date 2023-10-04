#let todo(it) = { text(fill: orange, it) }

//https://home.uni-leipzig.de/~gsgas/fileadmin/Recommendations/Expose_Recommendations.pdf
//https://www.uni-bremen.de/fileadmin/user_upload/fachbereiche/fb7/gscm/Dokumente/Structure_of_an_Expose.pdf
#show: (document) => {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	show heading: it => { v(5pt); it; v(5pt); }

	set page(columns: 2)
	show raw: it => text(size: (1.0em / 0.8), it)

	set enum(numbering: "I.1.")
	document
}

#page(columns: 1, align(center, {

	set text(size: 1.25em)
	text(size: 1.25em, [= Exposé])

	{
		set align(left)
		set par(hanging-indent: 1cm)
		align(left, pad(x: 1cm)[
			*Arbeitstitel: Berechnung von charakteristischen Eigenschaften von Bäumen mit 3D-Punktwolken von Wäldern und Visualisierung der 3D-Daten mithilfe der Eigenschaften.*
		])
	}
	v(1fr)
	table(
		columns: (0.7fr, 1fr),
		column-gutter: 0.2cm,
		align: (right, left),
		stroke: none,
		[*Name:*],         [*Anton Wetzel*],
		[E-Mail:],         link("mailto:anton.wetzel@tu-ilmenau.de", [anton.wetzel\@tu-ilmenau.de]),
		[Matrikelnummer:], [60451],
		[Studiengang:],    [Informatik Master],
		[],                [],
		[*Betreuer:*],     [*Tristan Nauber*],
		[E-Mail:],         link("mailto:tristan.nauber@tu-ilmenau.de", [tristan.nauber\@tu-ilmenau.de]),
		[],                [],
		[*Professor:*],    todo[*Professor*],
		[E-Mail:],         todo(link("...", [E-Mail])),
		[],                [],
		[Fachgebiet:],     [Data-intensive Systems and Visualization Group],
		[],                [],
		[Datum:],          datetime.today().display("[day].[month].[year]"),
	)
	v(2fr)
	image(width: 70%, "images/logo_tui.svg")
}))


= Motivation

Mit Lidar Technologie können größere Gebiete wie Teile von Wäldern als 3D-Punktwolken gescannt werden, aber eine Auswertung der Daten ist durch die massive Anzahl der Messpunkte erschwert.

Durch eine automatisierte Extraktion von charakteristischen Eigenschaften aus den 3D-Punktwolken ist eine angepasste Visualisierung der Daten möglich. Die Software soll dabei interaktiv die berechneten Eigenschaften geeignet präsentieren.


= Stand der Technik

Der Artikel _Adjudicating Perspectives on Forest Structure: How Do Airborne, Terrestrial, and Mobile Lidar-Derived Estimates Compare?_ @scantech beschäftigt sich mit unterschiedlichen Lidar Scanverfahren. Dabei werden Verfahren vom Boden oder aus der Luft verglichen, um Vor- und Nachteile zu ermitteln.

Ein häufiges Format für Lidar-Daten ist das LAS Dateiformat @las. Bei diesem werden die Messpunkte mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können unterschiedliche Daten bei unterschiedlichen Punktwolken bekannt sein, aber die Position der Punkte ist immer gegeben.

Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format @laz gespeichert. Die Kompression ist Verlustfrei und ermöglicht eine Kompressionsrate zwischen 5 und 15 je nach Eingabedaten.

_LASTools_ @lastools ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte.

Ein Überblick über Lidar Scans von Bäumen vom Boden aus wird in der Arbeit _Terrestrial LiDAR: a three-dimensional revolution in how we look at trees_ @terrestriallidar gegeben. Mehrere mögliche Informationen werden erklärt, welche aus den Daten ermittelt werden können.

In der Arbeit _Extracting individual trees from lidar point clouds using treeseg_ @treeseg wird ein Algorithmus ausgearbeitet, welcher eine automatisierte Segmentierung von Lidar-Daten von Wäldern in einzelne Bäume ermöglicht.

Die Arbeit _Forest Data Collection by UAV Lidar-Based 3D Mapping: Segmentation of Individual Tree Information from 3D Point Clouds_ @forestscan beschäftigt sich mit dem Erfassen von Daten, aber auch der Extraktion von relevanten Punkten der einzelnen Bäume.


= Eingabedaten

Der benutze Datensatz @data beinhaltet $12$ Hektar Waldfläche in Deutschland, Baden-Württemberg. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen, Drohnen und vom Boden aus durchgeführt wurde. Dabei entstehen 3D-Punktwolken, welche im komprimiert LAS Dateiformat @las @laz gegeben sind.

Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für $6$ Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen.


= Ziel

Das Ziel ist die Entwicklung von einem Softwareprojekt für die spezialisierte Auswertung und Visualisierung von 3D-Punktwolken von Wäldern. Als Eingabe soll nur die Punktwolken ohne weiteren Informationen ausreichen. Durch die Kombination von Auswertung und Visualisierung kann über eine allgemeine Visualisierung von LAS Dateien hinausgegangen werden.

Für die technische Umsetzung wird die Programmiersprache Rust und die Grafikkartenschnittstelle WebGPU verwendet.

Im Folgenden ist eine Auflistung der momentanen Ziele. Während der Entwicklung können die Ziele an neue Erkenntnisse und Anforderungen angepasst werden.

+ Datensatz in Bäume unterteilen
+ Bestimmung von Eigenschaften
	- Baum- und Kronenhöhe
	- Stamm- und Kronendurchmesser
+ Segmentierung als Graph
	- Stamm
	- Äste
	- Blätter
+ Visualisierung
	- ein oder mehrere Bäume
	- Färbung von Punkten
		- Farbverlauf mit Punkthöhe
		- je nach Baum
		- je nach Segment
	- Punktgröße und -normale
	- Detailstufen
	- Eye-Dome Lighting @eyedome
+ 3D-Modelle
	- Punkte filtern und Triangulieren
	- Farben aus der Visualisierung oder generierte Texturen
+ weitere Verarbeitung
	- Klassifikator für Baumarten
	- Validierung der 3D-Modelle basierend auf synthetischen Bäumen
	- Vergleich der unterschiedlichen Messmethoden
	- Vergleich zu Verfahren basierend auf Bilddaten

#bibliography("expose.bib")
