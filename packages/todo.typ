#let todo(body, prefix: [To-do]) = {
	set text(size: 0pt)
	figure(kind: "todo", supplement: "", outlined: true, caption: body)[
		#pad(0.5cm, block(
			fill: orange,
			inset: 5pt,
			radius: 3pt,
			stroke: black,
			width: 90%,
			text(size: 11pt, prefix + [: ] + body),
		))
	]
}

#let todo-inline(body, prefix: [To-do]) = {
	set text(size: 0pt)
	box({
		set text(size: 0pt)
		figure(kind: "todo", supplement: "", outlined: true, caption: body, rect(
			fill: orange,
			height: auto,
			inset: 1pt,
			radius: 1pt,
			stroke: black,
			text(size: 11pt, prefix + [: ] + body),
		))
	})
}

#let todo-outline = () => locate(loc => {
	let x = query(figure.where(kind: "todo"), loc)
	if x != () {
		outline(title: [To-dos], target: figure.where(kind: "todo"))
		pagebreak()
	}
})
