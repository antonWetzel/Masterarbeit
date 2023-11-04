#let PART_LEVEL = 10;

#let PART_COUNTER = counter("parts")

#let part(name, numbering: "I.") = {
	heading(level: PART_LEVEL, numbering: none, {
		PART_COUNTER.step()
		PART_COUNTER.display(numbering) + [ ] + name
		counter(heading).update(0)
	})
}

#let setup(document) = {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	set heading(numbering: "1.")
	show heading.where(level: PART_LEVEL): it => text(size: 20pt, it)

	show outline.entry.where(level: PART_LEVEL): it => {
		v(1.5em, weak: true)
		link(it.element.location(), strong(it.body))
	}

	show outline: it => { it; PART_COUNTER.update(0); }

	show raw: it => text(size: 1.2em, it)
	document
}
