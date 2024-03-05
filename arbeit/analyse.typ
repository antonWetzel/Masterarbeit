#import "setup.typ": *


== Analyse von Segmenten


=== Eigenschaften <berechnung_eigenschaften>

Die Baumeigenschaften werden für jedes Segment einzeln berechnet. Dabei sind alle Punkte im Segment als Liste der Länge $n$ verfügbar. Für den Punkt $i in NN_0^(n-1)$ ist nur die globale Position $p_i = (p_(i x), p_(i y), p_(i z))$ gegeben.


==== Nachbarschaft

Um relevante Eigenschaften für einen Punkt zu bestimmen, werden die umliegenden Punkte benötigt. Dafür wird für alle Punkte ein *KD-Baum* erstellt. Mit diesem können effizient für einen Punkt die $k$-nächsten Punkte bestimmt werden.


==== Punkthöhe

Für jeden Punkt wird die relative Höhe im Segment bestimmt. Mit den Positionen wird die Mindesthöhe $h_min$ und Maximalhöhe $h_max$ bestimmt.

$ h_min = min_(i in NN_0^(n-1))p_(i y) #h(40pt) h_max = max_(i in NN_0^(n-1))p_(i y) $

Die relative Höhe $h_i$ wird mit $h_i = (p_(i y) - h_min) / (h_max - h_min)$ berechnet. Diese liegt dadurch immer im Bereich $[0; 1]$. Ein Beispiel ist in @analyse_height zu sehen.

#let example(content) = align(center, box(width: 70%, side-caption(
	amount: (1fr, 5fr),
	content,
)))

#example[#figure(
	caption: [Punktwolke basierend auf der relativen Höhe der Punkte eingefärbt.],
	image("../images/auto-crop/height.png"),
) <analyse_height>]


==== Krümmung <krümmung>

Die Krümmung der Oberfläche wird für jeden Punkt geschätzt. Dafür werden die Positionen der Punkte in der Nachbarschaft betrachtet. Zuerst wird der geometrische Schwerpunkt bestimmt, dass die Positionen der Punkte um diesen verschoben werden können. Ohne die Verschiebung würde die globale Position der Punkte das Ergebnis verfälschen. Mit den Positionen der Punkte kann die Kovarianzmatrix bestimmt werden.

Die normierten Eigenvektoren der Kovarianzmatrix bilden eine Orthonormalbasis und die Eigenwerte geben die Ausdehnung der Punkte entlang des zugehörigen Basisvektors an. Der kleinste Eigenwert gehört zu Dimension mit der geringsten Ausdehnung. Je kleiner der Eigenwert, desto näher liegen die Punkte in der Nachbarschaft an der Ebene, aufgespannt durch die anderen beiden Eigenvektoren. Ein Beispiel für die Eigenvektoren in 2D ist in @analyse_eigenvektoren gegeben.

#let numbers = (
	(-0.2365, -0.7597),
	(0.5705, 0.0867),
	(-0.0476, 0.6232),
	(0.0683, 0.0178),
	(-0.3706, 0.5467),
	(0.3455, -0.5056),
	(0.2504, -0.2920),
	(-0.3370, 0.2531),
	(-0.3892, -0.1629),
	(0.0706, -0.4136),
	(-0.2474, 0.3263),
	(-0.6299, 0.7042),
	(-0.6604, -0.6542),
	(0.4309, 0.4845),
	(-0.2063, 0.9690),
	(-0.1857, -0.8976),
	(-0.3240, -0.6993),
	(0.2966, 0.7842),
	(-0.4146, 0.5181),
	(0.3337, 0.4373),
	(0.1344, -0.8613),
	(-0.8789, 0.4179),
	(-0.7789, -0.4808),
	(0.2710, 0.7512),
	(-0.7899, -0.5918),
	(-0.3302, 0.6643),
	(-0.6266, 0.5993),
	(0.2749, 0.7502),
	(-0.0716, 0.0242),
	(-0.4604, 0.0333),
	(-0.0576, 0.5913),
	(-0.4449, 0.3906),
	(0.8919, 0.2610),
	(-0.0264, 0.0841),
	(0.4190, -0.7367),
	(-0.1474, -0.3379),
	(0.5468, 0.1351),
	(-0.7162, 0.0972),
	(-0.4032, 0.8296),
	(-0.7783, -0.2086),
	(-0.9851, 0.1004),
	(0.0353, -0.3981),
	(0.3548, 0.1741),
	(0.5707, -0.3953),
	(-0.0605, -0.4656),
	(0.7439, 0.1365),
	(-0.3275, 0.3069),
	(-0.4963, -0.3546),
	(-0.2255, 0.9107),
	(0.3843, 0.8612),
)

#side-caption(amount: (1fr, 1.5fr))[#figure(
	caption: [Eigenvektoren $v_0$ und $v_1$ der Kovarianzmatrix für die Punkte.\
	Die Länge der Vektoren ist anhängig vom zugehörigen Eigenwert.],
	cetz.canvas(length: 2cm, {
		import cetz.draw: *;

		line((0, 0), (2, 0), mark: (end: ">", fill: black))
		line((0, 0), (0, 2), mark: (end: ">", fill: black))
		content((2, 0), anchor: "west", padding: 0.1, $x$)
		content((0, 2), anchor: "east", padding: 0.1, $y$)

		let a_0 = (0.8 * 0.8, 0.5 * 0.8)
		let a_1 = (-0.125, 0.2)

		for (x, y) in numbers {
			let c_x = 1.0 + x * a_0.at(0) + y * a_1.at(0)
			let c_y = 1.0 + x * a_0.at(1) + y * a_1.at(1)
			circle((c_x, c_y), radius: 0.03, fill: black, stroke: none)
		}

		let s = 1.5
		let e_0 = (1 + a_0.at(0) * s, 1 + a_0.at(1) * s)
		let e_1 = (1 + a_1.at(0) * s, 1 + a_1.at(1) * s)
		line((1, 1), e_0, mark: (end: ">", fill: black))
		line((1, 1), e_1, mark: (end: ">", fill: black))

		content(e_0, anchor: "north", padding: 0.1, $v_0$)
		content(e_1, anchor: "south", padding: 0.1, $v_1$)
	}),
) <analyse_eigenvektoren>]

Wenn die Eigenwerte $lambda_i$ mit $i in NN_0^2$ absteigend nach größer sortiert sind, dann kann die Krümmung $c$ mit $c = (3 lambda_2) / (lambda_0 + lambda_1 + lambda_2)$ berechnet werden. $c$ liegt dabei im abgeschlossenen Bereich $[0; 1]$, weil $lambda_i >= 0$ ist. In @analyse_curve ist ein Beispiel gegeben.

#example[#figure(
	caption: [
		Punktwolke basierend auf der Krümmung einfärbt.\
		Der Farbverlauf geht von Gelb für wenig bis Rot für maximale Krümmung.
	],
	image("../images/auto-crop/curve_all.png"),
) <analyse_curve>]


==== Ausdehnung

Der Baum wird entlang der Horizontalen in gleich hohe Scheiben unterteilt. Die Breite der Scheiben ist dabei einstellbar. Die Ausdehnung wird für jede Scheibe berechnet. Zuerst wird der geometrische Schwerpunkt der Positionen berechnet, womit die durchschnittliche Standardabweichung entlang der Horizontalen bestimmt wird.

Die größte Varianz von allen Scheiben wird verwendet, um die Varianzen auf den Bereich $[0; 1]$ zu normieren. Für jeden Punkt wird die Varianz der zugehörigen Scheibe zugeordnet.

Die Ausdehnung eignet sich zur Unterscheidung von Stamm und Krone. Beim Stamm sind die Punkte näher einander, während bei der Krone die Punkte weiter verteilt sind.

#example[#figure(
	caption: [
		Punktwolke basierend auf der Ausdehnung einfärbt.\
		Der Farbverlauf geht von Gelb für geringe bis Rot für größte Ausdehnung.
	],
	image("../images/auto-crop/var_all.png"),
) <analyse_var>]


=== Eigenschaften für die Visualisierung <eigenschaften_visualisierung>

Die Visualisierung werden die Position, Orientierung und Größe von einem Punkte benötigt. Die Position ist in den Eingabedaten gegeben und die anderen Eigenschaften werden mit der lokalen Umgebung vom Punkt berechnet.

Für die Orientierung wird die Normale bestimmt, welche orthogonal zur geschätzten zugehörigen Oberfläche vom Punkt ist. Dafür werden die Eigenvektoren aus @krümmung verwendet. Der Eigenvektor, welcher zum kleinsten Eigenwert gehört, ist dabei orthogonal zur geschätzten Ebene mit der größten Ausdehnung. Für die Punktgröße wird der durchschnittliche Abstand zu den umliegenden Punkten bestimmt. Dadurch werden die Punkte in Bereichen mit hoher Punktdichte kleiner. In @analyse_render ist ein Beispiel gegeben.

#align(center, box(width: 70%, side-caption(
	amount: (1fr, 2fr),
	[#figure(
		caption: [
			Ausschnitt von einer Punktwolke.\
			Die Punkte beim Stamm sind kleiner als die freien Punkte und die Orientierung ändert sich beim Übergang vom Stamm zum Boden.
		],
		rect(image("../images/auto-crop/properties.png"), inset: 0.5pt),
	) <analyse_render>],
)))

// === Baumart

// #todo([Segmente + Eigenschaften + ? $->$ Klassifizierung?])
// - out of scope?
// - neural?
