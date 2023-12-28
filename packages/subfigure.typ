#let subfigure_counter = counter("subfigures")
#let subfigure_current_figure = counter("subfigure_current_figure")

#let subfigure = (
	content,
	width: 100%,
	height: auto,
	alt: none,
	fit: "cover",
	numbering: "(a)",
	caption: none,
) => locate(loc => {
	let current_figure = counter(figure).at(loc)
	if (current_figure != subfigure_current_figure.at(loc)) {
		subfigure_current_figure.update(current_figure)
		subfigure_counter.update(0)
	}
	box(width: width, align(center, {
		content
		if caption != none {
			subfigure_counter.step()
			v(10pt, weak: true)
			subfigure_counter.display(numbering) + [ ] + caption
		}
	}))
})
