#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *
#import "../packages/subfigure.typ": *
#import "@preview/cetz:0.2.0" as cetz
#import "@preview/tablex:0.0.8": tablex, colspanx, rowspanx
#import "@preview/wordometer:0.1.0": word-count, total-words

#let black = cmyk(0%, 0%, 0%, 100%)

#let setup(document, print: false) = {
	set text(font: "Noto Serif")
	// set text(font: "Noto Sans")

	let setup_print(document) = {
		set text(fill: black)
		set table(stroke: black)
		set rect(stroke: black)
		set line(stroke: black)
		show link: it => text(fill: black, it)
		document
	}

	let setup_digital(document) = {
		show link: it => text(fill: eastern, it)
		show ref: it => text(fill: eastern, it)
		document
	}
	let rule = if print {
		setup_print
	} else {
		setup_digital
	}

	show: rule

	set text(lang: "de", region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)
	set page(margin: 3cm)

	set heading(numbering: (..nums) => {
		let nums = nums.pos()
		if nums.len() >= 4 {
			return none
		}
		return numbering("1.1", ..nums)
	})

	show raw: it => text(size: 1.2em, it)

	show heading: it => block({
		if it.numbering != none and it.level < 4 {
			counter(heading).display()
			h(13pt)
		}
		it.body
	})

	show figure: it => {
		v(1em)
		align(center, box({
			align(center + horizon, it.body)
			align(center + horizon, {
				box({
					set align(left)
					set par(hanging-indent: 0.5cm, justify: true)
					pad(left: 0.5cm, right: 1cm, it.caption)
				})
			})
		}))
		v(1em)
	}

	show heading.where(level: 1): it => {
		pagebreak(weak: true)
		it
	}

	show heading.where(level: 2): it => pad(
		top: 0.1cm,
		bottom: 0.2cm,
		it,
	)

	show outline.entry: it => {
		let elem(it, off) = {
			v(1.1em, weak: true)
			h((it.level - 1 - off) * 2em, weak: false)
			if it.body.has("children") {
				it.body.children.at(0)
				h(10pt)
				for x in it.body.children.slice(2) {
					x
				}
			} else {
				it.body
			}
			box(width: 1fr, it.fill)
			it.page
		};

		if it.level == 1 {
			v(2.5em, weak: true)
			strong(elem(it, 0))
		} else {
			v(1.15em, weak: true)
			elem(it, 1)
		}
	}
	set bibliography(style: "chicago-author-date")

	document
}

#let link-footnote(_link, _body) = {
	link(_link, _body)
	footnote(raw(_link))
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
