#import "../packages/todo.typ": *
#import "../packages/placeholder.typ": *
#import "../packages/subfigure.typ": *
#import "../packages/cetz/src/lib.typ" as cetz

#let setup(document) = {
	set text(lang: "de", font: "Noto Sans", region: "DE", size: 11pt, weight: 400, fallback: false)
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
				set align(left)
				set par(hanging-indent: 0.5cm, justify: true)
				pad(left: 0.5cm, right: 1cm, it.caption)
				v(1em)
			})
		}))
		v(1em)
	}

	show outline.entry.where(): it => {
		h((it.level - 2) * 2em) + link(it.element.location(), it.body)
	}

	show outline.entry.where(level: 1): it => {
		v(2em, weak: true)
		link(it.element.location(), strong(it.body))
	}

	document
}

#let side-caption(amount: 1.0, content) = {
	show figure: it => box({
		v(1em)
		grid(
			columns: (1fr, amount * 1fr),
			align(center + horizon)[#it.body],
			align(center + horizon, {
				set align(left)
				set par(hanging-indent: 0.5cm, justify: true)
				pad(left: 0.5cm, right: 1cm)[#it.supplement #it.counter.display(it.numbering): #it.caption]
				v(1em)
			}),
		)
		v(1em)
	})
	content
}
