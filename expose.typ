#let boxed(content) = rect(inset: 0pt, stroke: black + 3pt, content)

//https://home.uni-leipzig.de/~gsgas/fileadmin/Recommendations/Expose_Recommendations.pdf
//https://www.uni-bremen.de/fileadmin/user_upload/fachbereiche/fb7/gscm/Dokumente/Structure_of_an_Expose.pdf
#show: (document) => {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	show heading: it => { v(5pt); it; v(5pt); }

	// set page(columns: 2)
	show raw: it => text(size: 1.2em, it)

	set enum(numbering: "I.1.")
	document
}

#page(columns: 1, align(center, {

	set text(size: 1.25em)
	text(size: 1.25em, [= Exposé])

	{
		set align(left)
		set par(hanging-indent: 1cm)
		align(left, pad(x: 2.5cm)[
			*Arbeitstitel: Berechnung charakteristischen Eigenschaften von botanischen Bäumen mithilfe von 3D-Punktwolken.*
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
		[*Professor:*],    [*Prof. Dr.-Ing. Patrick Mäder*],
		[E-Mail:],         link("mailto:patrick.maeder@tu-ilmenau.de", [patrick.maeder\@tu-ilmenau.de]),
		[],                [],
		[Fachgebiet:],     [Data-intensive Systems and Visualization Group],
		[],                [],
		[Datum:],          datetime.today().display("[day].[month].[year]"),
	)
	v(2fr)
	image(width: 70%, "images/logo_tui.svg")
}))


= Motivation

Größere Gebiete wie Teile von Wäldern können als 3D-Punktwolken gescannt werden, aber der Zustand vom Waldstück ist nicht direkt aus den Daten ersichtlich. Mit einer automatisierten Analyse der Daten könnte das Waldstück digitalisiert werden, wodurch Informationen wie Artenbestand oder Gesundheit abgeschätzt werden können.

Diese Arbeit erkundet die Möglichkeiten einer automatisierten Auswertung von 3D-Punktwolken von Wäldern. Dazu gehört eine Analyse, welche charakteristischen Eigenschaften aus den Daten ermittelt werden können und wie diese geeignet Visualisiert werden können.

Durch die Kombination von Analyse und Visualisierung können die gefundenen Eigenschaften interaktive aufgearbeitete werden, was hoffentlich die Analyse von Waldstücken vereinfacht. Dabei kann die Visualisierung auf die genauen Anforderungen spezialisiert werden, um die Ergebnisse ideal zu präsentieren.

#figure(
	caption: [Visualisierung von einem Waldstück | Datensatz @data, Datei `ALS-on_SP02_2019-07-05_140m.laz`],
	boxed(image(width: 100%, "images/overview.png")),
)


= Stand der Technik

Punktwolken können mit unterschiedlichen Lidar Scanverfahren aufgenommen werden. Aufnahmen vom Boden oder aus der Luft bieten dabei verschiedene Vor- und Nachteile @scantech. Bei einem Scan von Boden aus kann nur eine kleinere Fläche abgetastet werden, dafür mit erhöhter Genauigkeit, um einzelne Bäume genau zu analysieren @terrestriallidar. Aus der Luft können größere Flächen erfasst werden, wodurch Waldstücke aufgenommen werden können, aber die Datenmenge pro Baum ist geringer @forestscan.

Nach der Datenerfassung können relevante Informationen aus den Punkten bestimmt werden, dazu gehört eine Segmentierung in einzelne Bäume @treeseg, Bestimmung von Baumhöhe oder Kronenhöhe @forestscan.

Ein häufiges Format für Lidar-Daten ist das LAS Dateiformat @las. Bei diesem werden die Messpunkte mit den bekannten Punkteigenschaften gespeichert. Je nach Messtechnologie können unterschiedliche Daten bei unterschiedlichen Punktwolken bekannt sein, aber die Position der Punkte ist immer gegeben. Aufgrund der großen Datenmengen werden LAS Dateien häufig im komprimierten LASzip Format @laz gespeichert. Die Kompression ist Verlustfrei und ermöglicht eine Kompressionsrate zwischen $5$ und $15$ je nach Eingabedaten.

_LASTools_ @lastools ist eine Sammlung von Software für die allgemeine Verarbeitung von LAS Dateien. Dazu gehört die Umwandlung in andere Dateiformate, Analyse der Daten und Visualisierung der Punkte. Durch den allgemeinen Fokus ist die Software nicht für die Verarbeitung von Waldteilen ausgelegt, wodurch Funktionalitäten wie Berechnungen von Baumeigenschaften mit zugehöriger Visualisierung nicht gegeben sind.


= Ziel

Das Ziel ist die Entwicklung von einem Softwareprojekt für die spezialisierte Auswertung und Visualisierung von 3D-Punktwolken von Wäldern. Als Eingabe soll nur die Punktwolken ohne weiteren Informationen ausreichen. Durch die Kombination von Auswertung und Visualisierung kann über eine allgemeine Visualisierung von LAS Dateien hinausgegangen werden.

Im Folgenden ist eine Auflistung der momentanen Ziele. Während der Entwicklung können die Ziele an neue Erkenntnisse und Anforderungen angepasst werden.

#box(height: 22.5em, columns(2)[
	+ Datensatz in Bäume unterteilen
		- Boden oder andere Obekte filtern
	+ Bestimmung von Eigenschaften
		- Baum- und Kronenhöhe
		- Stamm- und Kronendurchmesser
	+ Segmentierung von einem Baum
		- Struktur als Graph
		- Baum unterteilen in
			- Stamm
			- Äste
			- Blätter
	+ 3D-Modelle
		- Punkte filtern und Triangulieren
		- Farben aus der Visualisierung oder von generierten Texturen
		- Vergleich zu synthetischen Modellen
	+ Visualisierung
		- ein oder mehrere Bäume
		- Färbung von Punkten
			- Farbverlauf mit Punkthöhe
			- je nach Baum
			- je nach Segment
		- Punktgröße und -normale
		- Detailstufen
		- Eye-Dome Lighting @eyedome
	+ weitere Verarbeitung
		- Klassifikator für Baumarten
		- Validierung der 3D-Modelle basierend auf synthetischen Bäumen
		- Vergleich der unterschiedlichen Messmethoden
		- Vergleich zu Verfahren basierend auf Bilddaten
])

Die berechneten Eigenschaften werden für die Visualisierung verwendet, aber können auch für weitere Projekte als Grundlage dienen. Dazu gehört das Trainieren von neuronalen Netzwerken für die Klassifikation von Bäumen oder die Analyse von Ökosystemen.


= Geplante Umsetzung

Für die technische Umsetzung wird die Programmiersprache Rust und die Grafikkartenschnittstelle WebGPU verwendet. Rust ist eine performante Programmiersprache mit einfacher Integration für WebGPU. WebGPU bildet eine Abstraktionsebene über der nativen Grafikkartenschnittstelle, dadurch ist die Implementierung unabhängig von den Systemeigenschaften.


== Testdaten

Der benutze Datensatz @data beinhaltet $12$ Hektar Waldfläche in Deutschland, Baden-Württemberg. Die Daten sind mit Laserscans aufgenommen, wobei die Scans von Flugzeugen, Drohnen und vom Boden aus durchgeführt wurde. Dabei entstehen 3D-Punktwolken, welche im komprimiert LAS Dateiformat gegeben sind.

Der Datensatz ist bereits in einzelne Bäume unterteilt. Zusätzlich wurden für $6$ Hektar die Baumart, Höhe, Stammdurchmesser auf Brusthöhe und Anfangshöhe und Durchmesser der Krone gemessen. Mit den bereits bestimmten Eigenschaften können automatisch berechnete Ergebnisse validiert werden.

#bibliography("expose.bib")
