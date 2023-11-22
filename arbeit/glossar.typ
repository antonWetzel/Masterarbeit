#import "setup.typ": *


= Glossar

#todo([Glossar])


== Punktwolken

/ Koordinatensystem: ist eine Menge von Achsen, mit den eine Position genau beschrieben werden kann. Im Normalfall werden kartesische Koordinaten verwendet, welche so orientiert sind, dass die x-Achse nach rechts, die y-Achse nach oben und die z-Achse nach hinten zeigt.
/ Punkt: ist eine dreidimensionale Position, welcher zusätzlichen Informationen zugeordnet werden können.
/ Punktwolke: ist eine Menge von Punkten. Für alle Punkte sind die gleichen zusätzlichen Informationen vorhanden.
/ Normale: ist ein normalisierter dreidimensionaler Vektor, welcher die Orientierung einer Oberfläche von einem Objekt angibt. Der Vektor ist dabei orthogonal zur Oberfläche, kann aber in das Objekt oder heraus gerichtet sein.


== Scanner

/ Arial: ...
/ Terrestrial: ...
/ ...: ...


== Datenstrukturen

/ Tree: ist eine Datenstruktur bestehend aus Knoten, welche wiederum Kinderknoten haben können. Die Knoten selber können weitere Informationen enthalten.
/ Octree: ist ein Tree, bei dem ein Knoten acht Kinderknoten haben kann. Mit einem Octree kann ein dreidimensionaler Würfel aufgeteilt werden. Jeder Knoten gehört zu einem Würfel, welcher gleichmäßig mit den Kinderknoten weiter unterteilt wird. #todo([Bild?])
/ Quadtree: ist ein Tree, bei dem ein Knoten vier Kinderknoten haben kann. Statt eines dreidimensionalen Würfels bei einem Octree, kann ein Quadtree ein zweidimensionales Quadrat unterteilen. #todo([Bild?])
/ Leaf-Knoten: ist ein Knoten, welcher keine weiteren Kinderknoten hat. Für Puntkwolken gehört jeder Punkt zu genau einem Leaf.
/ Branch-Knoten: ist ein Knoten, welcher weitere Kinderknoten hat.
/ Root-Knoten: ist der erste Knoten im Tree, alle anderen Knoten sind direkte oder indirekte Kinderknoten vom Root.


== Akronyme

#todo([Akronyme])
