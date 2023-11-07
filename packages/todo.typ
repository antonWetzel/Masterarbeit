#let todo(body, prefix: [Todo]) = {
	set text(size: 0pt)
	figure(kind: "todo", supplement: "", outlined: true, caption: body)[
		#pad(0.5cm, block(
			fill: orange,
			inset: 5pt,
			radius: 3pt,
			stroke: black,
			width: 90%,
			text(fill: black, size: 11pt, prefix + [: ] + body),
		))
	]
}

#let todo-outline = () => locate(loc => {
	let x = query(figure.where(kind: "todo"), loc)
	if x != () {
		outline(title: [TODOs], target: figure.where(kind: "todo"))
		pagebreak()
	}
})
