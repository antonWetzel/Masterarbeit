//https://home.uni-leipzig.de/~gsgas/fileadmin/Recommendations/Expose_Recommendations.pdf
//https://www.uni-bremen.de/fileadmin/user_upload/fachbereiche/fb7/gscm/Dokumente/Structure_of_an_Expose.pdf
#show: (document) => {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	show heading.where(level: 1): it => { v(10pt); it; v(10pt); }
	show heading.where(level: 2): it => { v(5pt); it; v(5pt); }

	show raw: it => text(size: (1.0em / 0.8), it)
	document
}


#align(center, {

	set text(size: 1.25em)
	heading(level: 1, [Exposé])

	pad(x: 2cm)[
		*Berechnung von charakteristischen Eigenschaften von Bäumen aus 3D-Punktwoken von Wäldern und Visualiserung der 3D-Daten mit Hilfe der Eigenschaften*
	]

	v(1cm)

	table(
		columns: (0.7fr, 1fr),
		column-gutter: 0.2cm,
		align: (right, left),
		stroke: none,
		[Name:], [Anton Wetzel],

		[Betreuer:], [Tristan Nauber],
		[Professor:], [...],
		[], [],
		[Fachgebiet:], [Data-intensive Systems and Visualization Group],
		[Studiengang:], [Informatik Master],

		[], [],
		[E-Mail:], [anton.wetzel\@tu-ilmenau.de],
		[Matrikelnummer:], [60451],
		[], [],
		[Datum:], datetime.today().display("[day].[month].[year]"),
	)

	v(1fr)
	image(width: 70%, "images/logo_tui.svg")
})

#pagebreak()

== Motivation

Mit Lidar Technologie können größere Gebiete wie Teile von Wäldern analysiert werden, aber eine Auswertung der Daten ist durch die massive Anzahl der Messpunkte erschwert. Das Ziel der Arbeit ist die automatisierte Extraktion von charakteristischen Eigenschaften aus den 3D Punktwolken und eine angepasste Visualisierung.

Die Eigenschaften und 3D Daten können dadurch gemeinsam für die Visualisierung verwendet werden. Dies ermöglicht eine interaktive Visualisierung mit spezialisierter Software, welche eine Analyse der Daten vereinfacht.

== Eingabedaten

Der Datensatz @data beinhaltet 12 Hektar Waldfläche in Baden-Württemberg, Deutschland. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen, Dronen und vom Boden aus durchgeführt wurde. Die Daten sind im kompremierten LAS Dateiformat @las @laz gegeben.

//Teilgebiete sind mehrfach aufgenommen, einmal ohne und einmal mit Blättern.
Die Datensätze sind bereits in einzelne Bäume unterteilt. Zusätzlich wurden für 6 Hektar zusätzlich die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen.

== Ziel

=== Bestimmung von Eigenschaften

Ein Datensatz muss zuerst in einzelne Bäume unterteilt werden, um diese einzeln weiter zu verarbeiten.

Eigenschaften für den gesamten Baum können mit den Punkten berechnet werden. Dazu gehören die Höhe des Baumes und der Krone, Durchmesser von Stamm und der Krone und das Baumvolumen. Die berechneteten Eigenschaften können mit den erfasten Messwerten vergleicht werden, um die Korrektheit zu bewerten.

Mit einer Segmentierung des Baumes in Stamm, Äste und Blätter kann der Baum weiter unterteilt werden. Mit den Segmente als Kanten und Gabelungen und Endpunkt als Knoten kann die Baumstruktur als Graph dargestellt werden. Bei den Ästen kann die Stufe zugeordnet werden, wie viele Teilungen sie vom Stamm entfernt sind.

=== Visualisierung

Das Ziel ist eine specialisierte Software für die Visualisierung. Für die technische Umsetzung wird die Programmiersprache Rust mit der Grafikkartenschnittstelle WebGPU verwendet.

Aus den Daten ist nur die Position der einzelnen Punkte bekannt. Um die Punkte farblich zu unterschieden kann die Höhe als Farbverlauf kodiert werden. Die vorherige Berechnung von weiteren Eigenschaften ermöglichen komplexere Möglichkeiten, dazu gehört die unterschiedliche Einfärbung von unterschiedlichen Bäumen oder von unterschiedlichen Segmenten.

Die Normale und Größe der einzelnen Punkt wird mit den umliegenden Punkten berechnet. Um auch größere Datensätze zu Visualisieren, werden beim Berechnen der Eigenschaften auch gröbere Detailstufen berechnet, welche für weit entfernte Bäume verwendet werden.

// Für eine bessere Visualisierung der Tiefeninformation kann `Eye Dome Lighting` verwendet werden, welches Ränder der 3D-Modelle hervorhebt.

=== Generierung von 3D-Modellen

Mit einer Triangulierung kann aus der Punktwolke ein 3D-Modell berechnet werden. Für die Farbinformationen können die Methoden aus der Visualisierung oder generierte Texturen verwendet werden.

Dabei muss der Stamm und die Äste unterschiedlich zu den Blättern gehändelt werden, weil die Punkte zugehörig zu den Blättern keine eindeutige Oberfläche bilden.


== Weitere Verabeitung

Die Eigenschaften und die zugehörige Art des Baumes können als Grundlage für einen Klassifikator dienen. Dadurch können syntetisch generierte Baummodelle  für eine gewünschte Art validiert werden.

Mit syntetischen Baummodellen können die berechneten 3D Modelle validiert werden. Aus den syntetichen Modell wird eine Punktwolke generiert, aus der das Modell berechnet wird. Das berechnete Modell kann mit dem syntetischen bewertet werden.

Für die gleichen Regionen können die Ergebnisse von unterschiedliche  Datensätzen von unterschiedlichen Messmethoden verglichen werden. Dadurch können Vor- und Nachteile der Methoden ausgearbeitet werden.

Die Ergebnisse können auch mit bildbasierenden Verfahren verglichen werden, wodurch Vor- und Nachteile zu den unterschiedlichen Messmethoden ausgearbeitete werden können.


== Stand der Technik

https://www.mdpi.com/journal/remotesensing/special_issues/3D_forest

Dateiformate für Lidar Daten LAS (kompremiert) @las @laz.

LAStools für die Visualisierung und weiterverarbeitung und Visualisierung von Las/Laz Dateien @lastools.

Treeseg für Segmentierung von Wältern in einzelne Bäume @treeseg.


/*
== Überblick

- Überblick
- Eigenschaften der Messdaten
- Ziele Berechnung Eigenschaften
- Ziele Visualisierung
- Stand der Technik
- Erreichte Ergebnisse Berechnung Eigenschaften
- Erreichte Ergebnisse Visualisierung
- Weitere Möglichkeiten
- Weitere Benutzng der Ergebnisse
- Resümee
- Bibliographie
*/

#bibliography("expose.bib")
