//https://home.uni-leipzig.de/~gsgas/fileadmin/Recommendations/Expose_Recommendations.pdf
//https://www.uni-bremen.de/fileadmin/user_upload/fachbereiche/fb7/gscm/Dokumente/Structure_of_an_Expose.pdf
#show: (document) => {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	show heading.where(level: 1): it => { v(10pt); align(center, it); v(10pt); }
	show heading.where(level: 2): it => { v(5pt); it; v(5pt); }
	document
}

= Exposé

== Problem

Informationsgewinnung über Bäume aus Messdaten von Wäldern.

=== Eingabe

- 3D Punktwolken (präferiert)
	- nur Positionen
- Bilder

=== Zwischenformate

- `custom`
- `.ply`
- `.obj`


=== Ergebnisse

- Visualisierung
	- Custom
		- Farbe?
		- Eye Dome Lighting?
	- Godot
	- Unreal
- Arbeit
	- Ziel
	- Analyse momentaner Stand (Software und Forschung)
	- eigene Software
	- eigene Forschung
- Statistiken
	- Pro Baum
		- Höhe
		- Durchmesser
		- relevante Punkte (Graph)
			- Start
			- Gabelungen
			- Spitzen
	- Wald
		- in Bäume unterteilen? (schon gemacht in Datensatz)


== Stand der Technik

- Software
	- ...
- Forschung
	- ...

== Referenzen

- https://dl.acm.org/doi/10.1109/TVCG.2015.2513409
- https://nph.onlinelibrary.wiley.com/doi/full/10.1111/nph.15517
- https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.13121
- https://ieeexplore.ieee.org/document/8462802
- https://dl.acm.org/doi/10.1145/3478513.3480525
- https://dl.acm.org/doi/10.1145/3478513.3480486
\
- https://www.3dforest.eu/

== Anderes

- Deutsch oder Englisch
- Typst
- Kommunikation
	- E-mail
	- Discord
	- ...
- Besprechungen
	- Webex
	- Person
