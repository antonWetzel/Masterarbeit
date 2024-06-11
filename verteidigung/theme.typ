#import "@preview/polylux:0.3.1": *

#let footer_state = state("footer")
#let section_state = state("section")

#let color-light = rgb("a5a5a5")
#let color-important = rgb("ff7900")
#let color-important-2 = rgb("003359")
#let color-contrast = rgb("007479")

#let distibution = (6fr, 14fr, 3fr)
#let distibution_no_title = (20fr, 3fr)

#let new-section(section) = {
	section_state.update(section)
}

#let setup(footer: none, doc) = {
	set page(width: 25.40cm, height: 14.29cm, margin: 0pt)
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 18pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set list(indent: 0.25cm)
	show raw: set text(size: 1.2em)

	footer_state.update(footer)

	doc
}
#let slide-title(title) = locate(loc => {
	stack(
		dir: ttb,
		text(size: 32pt, fill: color-important, strong(section_state.at(loc))),
		v(1em),
		text(size: 24pt, fill: color-important-2, strong(title)),
	)
})

#let slide-footer() = locate(loc => {
	set text(fill: gray, size: 10pt)
	let columns = (1cm, auto, 1cm, auto, 1fr, 6cm, 1cm)
	grid(
		rows: (auto, 1fr),
		columns: columns,
		align: horizon,
		gutter: 0pt,
		grid.cell(colspan: columns.len(), {
			let ratio = (logic.logical-slide.at(loc).first() - 0.5) / logic.logical-slide.at(locate( <final-slide-marker>)).first() * 100%
			if ratio >= 100% {
				line(length: 100%, stroke: 3pt + color-contrast)
			} else {
				set align(horizon)
				stack(
					dir: ltr,
					line(length: ratio - 0.075cm, stroke: 3pt + color-contrast),
					circle(radius: 0.15cm, stroke: color-contrast),
					line(length: 100% - ratio - 0.075cm, stroke: 1pt + color-contrast),
				)
			}
		}),
		[],
		logic.logical-slide.display(),
		[],
		footer_state.at(loc),
		[],
		image("assets/logo.png"),
		[],
	)
})

#let title-slide(title: none, subtitle: none) = {
	logic.polylux-slide(grid(
		rows: distibution,
		pad(left: 1cm, top: 1cm, bottom: 1cm, {
			text(size: 32pt, fill: color-important, strong(title))
			linebreak()
			text(size: 24pt, fill: color-important-2, strong(subtitle))
		}),
		image("assets/first.jpg"),
		slide-footer(),
	))
}

#let normal-slide(
	title: none,
	columns: auto,
	expand-content: false,
	..content,
) = {
	let positional = content.pos()
	let columns = if columns == auto {
		(1fr,) * positional.len()
	} else if columns.len() == positional.len() {
		columns
	} else {
		panic("missmatch co.umns and arguments")
	}
	let body = table(
		columns: columns,
		stroke: none,
		..content
	)
	let title = slide-title(title)
	let title = if expand-content {
		title
	} else {
		grid.cell(colspan: columns.len(), title)
	}
	let positional = if expand-content {
		let positional = positional.enumerate().map((arg) => if arg.at(0) == 0 {
			arg.at(1)
		} else {
			grid.cell(rowspan: 2, arg.at(1))
		})
		positional.push(positional.remove(0))
		positional
	} else {
		positional
	}

	let top = pad(1cm, bottom: 0.5cm, grid(
		rows: distibution.slice(0, 2),
		column-gutter: 0.5cm,
		// stroke: silver,
		columns: columns,
		title,
		..positional,
	))

	logic.polylux-slide({
		grid(
			rows: (distibution.at(0) + distibution.at(1), distibution.at(2)),
			top,
			slide-footer(),
		)
	})
}

#let final-slide(
	title: none,
	e-mail: none,
	website: none,
) = {
	let suffix = if website == none { none } else { [ | ] + website }

	logic.polylux-slide(grid(
		rows: distibution,
		pad(1cm, bottom: 0cm, stack(
			dir: ttb,
			text(size: 32pt, fill: color-important, strong(title)),
			v(0.5cm),
			text(size: 14pt, fill: color-important-2, e-mail + suffix),
			v(0.3cm),
			text(
				size: 6pt,
				fill: gray,
				[Bildnachweis: Folie 1: Chris Liebold, Folie #logic.logical-slide.display(): helibild],
			),
		)),
		[#image("assets/final.jpg") <final-slide-marker>],
		slide-footer(),
	))
}

#let focus-slide(background: black, foreground: white, size: 100pt, content) = {
	set align(center + horizon)
	logic.polylux-slide(
		rect(width: 110%, height: 110%, fill: background, text(size: size, fill: foreground, strong(content))),
	)
}

#let number = (number, unit: none) => {
	let number = str(float(number))
	let split = number.split(".")
	let res = []
	{
		let text = split.at(0)
		for i in range(text.len()) {
			res += text.at(i)
			let idx = text.len() - i - 1
			if idx != 0 and calc.rem(idx, 3) == 0 {
				res += sym.space.thin
			}
		}
	}
	if split.len() >= 2 {
		res += $,$
		let text = split.at(1)
		for i in range(text.len()) {
			res += text.at(i)
			if i != 0 and calc.rem(i, 3) == 0 {
				res += sym.space.thin
			}
		}
	}
	if unit != none {
		res += [ ] + unit
	}
	return box(res)
}
