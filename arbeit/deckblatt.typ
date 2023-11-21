#import "setup.typ": *

#align(center, {
	set text(size: 1.25em)
	text(size: 3em, [*Masterarbeit*])
	v(0.5fr)
	{
		set align(left)
		set par(justify: true)
		align(center, pad(x: 2cm, [
			*Berechnung charakteristischen Eigenschaften von botanischen Bäumen mithilfe von 3D-Punktwolken.*
		]))
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
	image(width: 70%, "../images/logo_tui.svg")
	set page(numbering: "1")
})
