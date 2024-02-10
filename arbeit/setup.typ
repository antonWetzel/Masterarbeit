#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *
#import "../packages/subfigure.typ": *
#import "@preview/cetz:0.2.0" as cetz
#import "@preview/tablex:0.0.8": tablex, colspanx, rowspanx

#let setup(document) = {
	let font = "Noto Serif"
	let font = "Noto Sans"

	set text(lang: "de", font: font, region: "DE", size: 11pt, weight: 400, fallback: false)
	show math.equation: set text(font: "Noto Sans Math", weight: 600, fallback: false)
	set par(justify: true)

	set heading(numbering: (..nums) => {
		let nums = nums.pos()
		if nums.len() <= 1 {
			numbering("I.", ..nums)
		} else {
			numbering("1.", ..nums.slice(1))
		}
	})

	show ref: it => {
		let el = it.element
		if el == none {
			return it
		}
		if el.func() != heading {
			return it
		}
		let body = el.supplement + [ ] + numbering("I-1.1", ..counter(el.func()).at(el.location()))
		link(el.location(), body)
	}

	show raw: it => text(size: 1.2em, it)

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
		pad(top: 0.7cm, it, bottom: 0.1cm)
	}
	show heading.where(level: 2): it => {
		pad(top: 0.5cm, it, bottom: 0.1cm)
	}
	show heading.where(level: 3): it => pad(top: 0.3cm, it, bottom: 0.1cm)

	show link: it => text(fill: blue, it)

	show outline.entry: it => {
		if it.level == 1 {
			v(2em, weak: true) + strong(it)

		} else {
			h((it.level - 2) * 2em, weak: false) + it
		}
	}

	document
}

#let side-caption(amount: (1fr, 1fr), content) = {
	show figure: it => box({
		v(1em)
		grid(
			columns: amount,
			align(center + horizon)[#it.body],
			align(center + horizon, {
				set align(left)
				set par(hanging-indent: 0.5cm, justify: true)
				pad(left: 0.5cm, right: 1cm, it.caption)
				v(1em)
			}),
		)
		v(1em)
	})
	content
}

#let link-footnote(_link, _body) = {
	link(_link, _body)
	footnote(raw(_link))
}
