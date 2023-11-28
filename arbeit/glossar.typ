#import "setup.typ": *


= Glossar

#todo([Glossar])


== Punktwolken

/ Koordinatensystem: ist eine Menge von Achsen, mit den eine Position genau beschrieben werden kann. Im Normalfall werden kartesische Koordinaten verwendet, welche so orientiert sind, dass die x-Achse nach rechts, die y-Achse nach oben und die z-Achse nach hinten zeigt.
/ Punkt: ist eine dreidimensionale Position, welcher zusätzlichen Informationen zugeordnet werden können.
/ Punktwolke: ist eine Menge von Punkten. Für alle Punkte sind die gleichen zusätzlichen Informationen vorhanden.
/ Normale: ist ein normalisierter dreidimensionaler Vektor, welcher die Orientierung einer Oberfläche von einem Objekt angibt. Der Vektor ist dabei orthogonal zur Oberfläche, kann aber in das Objekt oder aus dem Objekt gerichtet sein.


== Datenstrukturen

/ Voxel: ist ein Würfel im dreidimensionalen Raum. Die Position und Größe vom Voxel kann explicit abgespeichert oder relative zu den umliegenden Voxeln bestimmt werden.
/ Tree: ist eine Datenstruktur bestehend aus Knoten, welche wiederum Kinderknoten haben können. Die Knoten selber können weitere Informationen enthalten.
/ Octree: ist ein Tree, bei dem ein Knoten acht Kinderknoten haben kann. Mit einem Octree kann ein Voxel aufgeteilt werden. Jeder Knoten gehört zu einem Voxel, welcher gleichmäßig mit den Kinderknoten weiter unterteilt wird. Eine Veranschaulichung ist in @octree gegeben.
/ Quadtree: ist ein Tree, bei dem ein Knoten vier Kinderknoten haben kann. Statt eines Voxels bei einem Octree, kann ein Quadtree ein zweidimensionales Quadrat unterteilen. Eine Veranschaulichung ist in @quadtree gegeben.
/ Leaf-Knoten: ist ein Knoten, welcher keine weiteren Kinderknoten hat. Für Punktwolken gehört jeder Punkt zu genau einem Leaf-Knoten.
/ Branch-Knoten: ist ein Knoten, welcher weitere Kinderknoten hat.
/ Root-Knoten: ist der erste Knoten im Tree, alle anderen Knoten sind direkte oder indirekte Kinderknoten vom Root-Knoten.

#figure(
	caption: [Unterschiedliche Stufen von einem Octree.],
	cetz.canvas({
		import cetz.draw: *
		let frontal((ax, ay, az), size, fill: black, stroke: black) = {
			line((ax + size, ay, az), (ax + size, ay + size, az), stroke: stroke)
			line((ax, ay + size, az), (ax + size, ay + size, az), stroke: stroke)
			line((ax + size, ay + size, az + size), (ax + size, ay + size, az), stroke: stroke)
		}
		let background((ax, ay, az), size, fill: black, stroke: black) = {
			line(
				(ax, ay, az),
				(ax + size, ay, az),
				(ax + size, ay, az + size),
				(ax + size, ay + size, az + size),
				(ax, ay + size, az + size),
				(ax, ay + size, az),
				close: true,
				fill: fill,
				stroke: stroke,
			)
		}
		let cube((ax, ay, az), size, fill: black, stroke: black) = {
			background((ax, ay, az), size, fill: fill, stroke: stroke)
			frontal((ax, ay, az), size, fill: fill, stroke: stroke)
		}

		cube((0, 0, 0), 2, fill: blue)

		set-origin((5, 0))
		background((0, 0, 0), 2, fill: none, stroke: gray)
		cube((0, 0, 1), 1, fill: blue)
		cube((0, 0, 0), 1, fill: blue)
		cube((0, 1, 1), 1, fill: blue)
		cube((1, 1, 1), 1, fill: blue)
		frontal((0, 0, 0), 2, fill: none, stroke: gray)

		set-origin((5, 0))
		background((0, 0, 0), 2, fill: none, stroke: gray)
		cube((0, 0, 1.5), 0.5, fill: blue)
		cube((0, 0.5, 1.5), 0.5, fill: blue)
		cube((0, 1.0, 1.5), 0.5, fill: blue)
		cube((0.5, 1.0, 1.5), 0.5, fill: blue)
		cube((1.0, 1.0, 1.5), 0.5, fill: blue)
		cube((1.5, 1.0, 1.5), 0.5, fill: blue)
		cube((1.5, 1.0, 1.0), 0.5, fill: blue)
		cube((0, 0, 1.0), 0.5, fill: blue)
		cube((0, 0, 0.5), 0.5, fill: blue)
		cube((0.5, 0, 0.5), 0.5, fill: blue)
		cube((0, 0, 0), 0.5, fill: blue)
		frontal((0, 0, 0), 2, fill: none, stroke: gray)
	}),
) <octree>

#figure(
	caption: [Unterschiedliche Stufen von einem Quadtree.],
	cetz.canvas({
		import cetz.draw: *

		rect((0, 0), (2, 2), fill: blue)

		set-origin((5, 0))
		rect((0, 0), (2, 2), stroke: gray)
		rect((0, 0), (1, 1), fill: blue)
		rect((0, 1), (1, 2), fill: blue)
		rect((1, 1), (2, 2), fill: blue)

		set-origin((5, 0))
		rect((0, 0), (2, 2), stroke: gray)
		rect((0, 0), (1, 1), stroke: gray)
		rect((0, 1), (1, 2), stroke: gray)
		rect((1, 1), (2, 2), stroke: gray)
		rect((0.0, 0.0), (0.5, 0.5), fill: blue)
		rect((0.0, 0.5), (0.5, 1.0), fill: blue)
		rect((0.0, 1.0), (0.5, 1.5), fill: blue)
		rect((0.5, 1.0), (1.0, 1.5), fill: blue)
		rect((0.0, 1.5), (0.5, 2.0), fill: blue)
		rect((0.5, 1.5), (1.0, 2.0), fill: blue)
		rect((1.0, 1.5), (1.5, 2.0), fill: blue)
	}),
) <quadtree>


== Akronyme

#todo([Akronyme])
