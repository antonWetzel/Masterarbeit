#import "setup.typ": *

#set heading(numbering: none)


= Glossar

/ Koordinatensystem: ist eine Menge von Achsen, mit den eine Position genau beschrieben werden kann. Im Normalfall werden kartesische Koordinaten verwendet, welche so orientiert sind, dass die x-Achse nach rechts, die y-Achse nach oben und die z-Achse nach hinten zeigt.
/ Punkt: ist eine dreidimensionale Position, welcher zusätzlichen Informationen zugeordnet werden können.
/ Punktwolke: ist eine Menge von Punkten. Für alle Punkte sind die gleichen zusätzlichen Informationen vorhanden.
/ Normale: ist ein normalisierter dreidimensionaler Vektor, welcher die Orientierung einer Oberfläche von einem Objekt angibt. Der Vektor ist dabei orthogonal zur Oberfläche, kann aber in das Objekt oder aus dem Objekt gerichtet sein.

/ Voxel: ist ein Würfel im dreidimensionalen Raum. Die Position und Größe vom Voxel kann explizit abgespeichert oder relative zu den umliegenden Voxeln bestimmt werden.
/ Tree: ist eine Datenstruktur, bestehend aus Knoten, welche wiederum Kinderknoten haben können. Die Knoten selber können weitere Informationen enthalten.
/ Octree: ist eine Baumdatenstruktur, bei dem ein Knoten acht Kinderknoten haben kann. Mit einem Octree kann ein Voxel aufgeteilt werden. Jeder Knoten gehört zu einem Voxel, welcher gleichmäßig mit den Kinderknoten weiter unterteilt wird.
/ Quadtree: ist eine Baumdatenstruktur, bei dem ein Knoten vier Kinderknoten haben kann. Statt eines Voxels bei einem Octree, wird ein zweidimensionales Quadrat unterteilen.
/ Leaf-Knoten: ist ein Knoten, welcher keine weiteren Kinderknoten hat. Für Punktwolken gehört jeder Punkt zu genau einem Leaf-Knoten.
/ Branch-Knoten: ist ein Knoten, welcher weitere Kinderknoten hat.
/ Root-Knoten: ist der erste Knoten im Tree, alle anderen Knoten sind direkte oder indirekte Kinderknoten vom Root-Knoten.
/ KD-Baum: ist eine Datenstruktur, um im $k$-dimensionalen Raum für eine Position die nächsten Punkte zu bestimmen.
/ Greedy-Algorithmus: ist eine Kategorie von Algorithmen, bei denen das Ergebnis schrittweise berechnet wird. Bei jedem Schritt wird mit den momentanen Informationen die beste Entscheidung getroffen, wodurch das Ergebnis schnell, aber meist nicht global optimal berechnet wird.
