#let setup(document) = {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	set heading(numbering: "I.1.")

	show raw: it => text(size: 1.2em, it)
	document
}
