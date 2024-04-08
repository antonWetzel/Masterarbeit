#let subfigure = (
	content,
	width: 100%,
	numbering: "(a)",
	caption: none,
) => {
	let last_figure = state("last_figure")
	let sub_figure = counter("sub_figure")
	let fig_counter = counter(figure)

	locate(loc => {
		let current = fig_counter.at(loc).at(0)
		if last_figure.at(loc) != current {
			sub_figure.update(0)
			last_figure.update(current)
		}
	})
	sub_figure.step()
	set par(justify: false)
	set align(bottom)
	box(width: width, align(center, {
		content
		if caption != none {
			v(10pt, weak: true)
			sub_figure.display(numbering) + [ ] + caption
		}
	}))
}
