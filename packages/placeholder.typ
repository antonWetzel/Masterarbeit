#import "todo.typ": *

#let placeholder = (
	location,
	width: 100%,
	height: auto,
	alt: none,
	fit: "cover",
) => {
	let fill = orange.lighten(30%)
	let location = align(center + horizon, todo(location))
	if height == auto {
		layout(size => {
			box(width: size.width * width, height: size.width * width * 9 / 16, fill: fill, stroke: black, radius: 5pt, location)
		})
	} else {
		box(width: width, height: height, fill: fill, stroke: black, radius: 5pt, location)
	}
}
