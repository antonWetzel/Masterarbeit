#import "setup.typ": *


= Analyse von Segmenten

Die charakteristischen Eigenschaften werden für jedes Segment einzeln berechnet. Ein Beispiel für die Ergebnisse sind in @analyse_eigenschaften zu sehen. Für jeden Punkt im Baum wird zuerst die relative Höhe, lokale Krümmung und zugehörige horizontale Ausdehnung bestimmt. Mit diesen Daten wird das eine Klassifikation vom Segment in Boden, Stamm und Krone durchgeführt.

Mit der Klassifikation wird die Baum-, Stamm- und Kronenhöhe abgeschätzt. Zusätzlich kann mit der Bodenhöhe und den Punkten der Umfang vom Stamm bei $130$ cm Höhe bestimmt werden. Mit den Punkten zugehörig zur Krone wird die zugehörige Projektionsfläche und Volumen berechnet.

#figure(caption: [Segment basierend auf den berechneten Eigenschaften eingefärbt.], grid(
	columns: 4,
	column-gutter: 1em,
	subfigure(image("../images/auto-crop/height.png"), caption: [Höhe]), subfigure(image("../images/auto-crop/curve_all.png"), caption: [Krümmung]), subfigure(image("../images/auto-crop/var_all.png"), caption: [Ausdehnung]), subfigure(placeholder("classifcation"), caption: [Klassifikation]),
)) <analyse_eigenschaften>


== Eingabedaten

Die Punkte im Segment sind als Liste der Länge $n$ verfügbar. Für den Punkt $i in NN_0^(n-1)$ ist nur die globale Position $p_i = (p_(i x), p_(i y), p_(i z))$ gegeben. Die Punkte sind dabei ungeordnet, wodurch aufeinanderfolgende Punkte in der Liste weit voneinander entfernte Positionen haben können.

Um einen Punkt $i$ zu analysieren, wird die zugehörige Nachbarschaft $N_i$ benötigt. Die Nachbarschaft enthält dabei die nächsten Punkte nach Abstand sortiert. Dafür wird für alle Punkte ein KD-Baum erstellt. Mit diesem können effizient für eine Position $p_i$ und ein beliebiges $k in NN$ die $k$-nächsten Punkte bestimmt werden. Die Konstruktion und Verwendung vom KD-Baum wird in @kd_baum erklärt. In der Nachbarschaft ist dann $N_0$ der ursprüngliche Punkt $i$, $N_1$ der nächste Punkt und $N_(k-1)$ der $k-1$ nächste Punkt.


== Punkteigenschaften


=== Punkthöhe

Für jeden Punkt wird die relative Höhe im Segment bestimmt. Dafür wird zuerst mit allen Positionen die Mindesthöhe $h_min$ und Maximalhöhe $h_max$ bestimmt.

$ h_min = min_(i in NN_0^(n-1))p_(i y) #h(40pt) h_max = max_(i in NN_0^(n-1))p_(i y) $

Mit der Mindest- und Maximalhöhe kann für den Punkt $i$ die relative Höhe $h_i$ bestimmt werden.

$ h_i = (p_(i y) - h_min) / (h_max - h_min) $

Die relative Höhe liegt immer im Bereich $[0; 1]$ und wird größer, je höher der Punkt liegt.


=== Krümmung <krümmung>

Die Krümmung der ursprünglichen abgetasteten Oberfläche wird für jeden Punkt geschätzt. Dafür wird für den Punkte $i$ die Verteilung der Positionen der Punkte in der Nachbarschaft $N_i$ betrachtet. Zuerst wird für die Nachbarschaft der geometrische Schwerpunkt $s_i$ bestimmt.

$ s_i = 1 / k * sum_(j in N_i) p_j $

Mit dem Schwerpunkte kann die Kovarianzmatrix $C_i$ bestimmt werden.

// prettypst: disable
#{
	set math.mat(column-gap: 0.5cm)
	$ C_i = 1 / k * sum_(j in N_i) mat(
		(p_(j x) - s_(i x))^2, (p_(j x) - s_(i x)) * (p_(j y) - s_(i y)), (p_(j x) - s_(i x)) * (p_(j z) - s_(i z));
		(p_(j y) - s_(i y)) * (p_(j x) - s_(i x)), (p_(j y) - s_(i y))^2, (p_(j y) - s_(i y)) * (p_(j z) - s_(i z));
		(p_(j z) - s_(i z)) * (p_(j x) - s_(i x)), (p_(j z) - s_(i z)) * (p_(j y) - s_(i y)), (p_(j z) - s_(i z))^2;
	) $
}
// prettypst: enable

Ohne die Verschiebung um $s_i$ würde die globale Position der Punkte die Kovarianzmatrix beeinflussen. Von der Kovarianzmatrix werden die Eigenwerte und zugehörige Eigenvektoren bestimmt.

Die normierten Eigenvektoren $v_(i 0)$, $v_(i 1)$ und $v_(i 2)$ bilden eine Orthonormalbasis und der zugehörige Eigenwert $lambda_(i alpha)$ für $v_(i alpha)$ ist die Ausdehnung der Punkte entlang des Basisvektors. Der kleinste Eigenwert gehört zu Dimension mit der geringsten Ausdehnung. Je kleiner der kleinste Eigenwert, desto näher liegen die Punkte in der Nachbarschaft an der Ebene, aufgespannt durch die anderen beiden Eigenvektoren. Ein Beispiel für die Eigenvektoren in 2D ist in @analyse_eigenvektoren gegeben.

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

#figure(
	caption: [Eigenvektoren $v_0$ und $v_1$ der Kovarianzmatrix für eine Punktmenge.\
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
) <analyse_eigenvektoren>

Mit den Eigenwerten $lambda_(i alpha)$ absteigend nach größer sortiert wird die Krümmung $c_i$ berechnet.

$ c_i = (3 lambda_(i 2)) / (lambda_(i 0) + lambda_(i 1) + lambda_(i 2)) $

$c_i$ liegt dabei im abgeschlossenen Bereich $[0; 1]$, weil $0 <= lambda_(i 0) <= lambda_(i 1) <= lambda_(i 2)$ ist.


=== Eigenschaften für die Visualisierung <eigenschaften_visualisierung>

Für die Visualisierung werden die Position, Orientierung und Größe von einem Punkte benötigt. Die Position ist in den Eingabedaten gegeben und die anderen Eigenschaften werden mit der lokalen Umgebung vom Punkt berechnet.

Für die Orientierung wird die Normale bestimmt, welche orthogonal zur geschätzten zugehörigen Oberfläche vom Punkt ist. Dafür werden die Eigenvektoren aus @krümmung verwendet. Der Eigenvektor, welcher zum kleinsten Eigenwert gehört, ist dabei orthogonal zur geschätzten Ebene mit der größten Ausdehnung. Für die Punktgröße wird der durchschnittliche Abstand zu den umliegenden Punkten bestimmt. Dadurch werden die Punkte in Bereichen mit hoher Punktdichte kleiner. In @analyse_render ist ein Beispiel gegeben.

#figure(
	caption: [
		Ausschnitt von einer Punktwolke.\
		Die Punkte beim Stamm sind kleiner als die umliegenden Punkte und die Orientierung ändert sich beim Übergang vom Stamm zum Boden.
	],
	rect(image("../images/auto-crop/properties.png", height: 30%), inset: 0.5pt),
) <analyse_render>


== Baumeigenschaften

#todo[was]

Die einstellbaren Parameter sind in @analyse_klassifkation_parameter gelistet.

#figure(
	caption: [Parameter für die Klassifikation.],
	table(
		columns: (auto, 1fr),
		align: (x, y) => if y == 0 { center } else { (center, left).at(x) },
		[*Name*], [*Funktion*],
		$w$,      [Breite von einer Scheibe],
		$h_g$,    [Maximale Suchhöhe für den Boden],
		$s_g$,    [Skalierungsfaktor für die Mindestfläche vom Boden zur kleinsten Scheibe],
		$h_t$,    [Höhe für die Berechnung vom Stammdurchmesser],
		$r_t$,    [Bereich für die Berechnung vom Stammdurchmesser],
		$d_c$,    [Differenz zwischen den Stammdurchmesser und dem Mindestdurchmesser der Krone],
	),
) <analyse_klassifkation_parameter>


=== Unterteilung in Scheiben

Zuerst werden die Punkte gleich breite Scheiben unterteilt. Dafür wird mit der Breite $w$ der Scheiben, $h_min$ und $h_max$ die Anzahl der benötigten Scheiben $c$ und den Index der Scheibe $s_i$ für den Punkt $i$ berechnet.

$ c = floor((h_max - h_min) / w) + 1 #h(40pt) s_i = floor((p_(i y) - h_min) / w) $

Für jede Scheibe wird der horizontale konvexe Bereich bestimmt, der alle Punkte in der Scheibe beinhaltet. Dafür werden die Methoden wie bei der Segmentierung in @segmentierung_bereiche_chapter verwendet. Mit den Bereichen wird die Fläche bestimmt, welche von den Punkten in der Scheibe belegt wird. In @analyse_klassifkation_slices ist ein Beispiel gegeben.

#figure(
	caption: [Baum in Scheiben unterteilt mit der zugehörigen Fläche für jede Scheibe.],
	image("../images/klassifkation_slices.svg"),
) <analyse_klassifkation_slices>


=== Bodenhöhe

Mit den Flächen wird zuerst die kleinste Fläche $a_min$ und die größte Fläche $a_max$ bestimmt.

Danach wird die Bodenhöhe $g$ gesucht. Dafür werden die Suchhöhe $h_g$ und der Skalierungsfaktor $s_g$ verwendet. Von unten wird die erste Scheibe gesucht, welche eine größere Fläche als $s_g dot a_min$ hat. Ist die Scheibe höher als $h_g$, wird die Höhe der untersten Scheibe als Boden verwendet. Ist die Scheibe niedriger als $h_g$, wird die nächste Scheibe gesucht, dessen Fläche kleiner als $s_g dot a_min$ und die Höhe von dieser Scheibe wird als $g$ verwendet.


=== Stammdurchmesser

Mit der berechneten Bodenhöhe $g$, der Messhöhe $h_t$ und dem Bereich $r_t$ wird der Stammdurchmesser $d_t$ bestimmt. Zuerst werden alle Punkte mit einer Höhe im Bereich $[g + h_t - r_t / 2, g + h_t + r_t / 2)$ gesucht. Mit dem Ransac-Algorithmus wird der Kreis gesucht, welcher am nächsten an allen Punkten liegt.

#todo[Ransac]

Der Durchmesser vom Kreis wird als der geschätzte Stammdurchmesser verwendet.


=== Baumhöhe

Mit dem Stammdurchmesser $d_t$ und der Mindestdifferenz $d_c$ wird die Höhe vom Anfang der Krone bestimmt. Dafür wird die Mindestfläche für die erste Scheibe der Krone $a_m$ bestimmt.

$ a_m = pi dot ((d_t + d_c) / 2)^2 $

Danach wird die erste Scheibe höher als der Boden gesucht, dessen Fläche größer als $a_m$ ist. Der Stamm geht vom Boden bis zu dieser Scheibe und die Krone von dieser Scheibe bis zur höchsten Scheibe.


=== Durchmesser von der Baumkrone

Für den Durchmesser von der Baumkrone wird für alle Scheiben in der Krone die Scheibe mit der größten Fläche $a_c$ gesucht. Mit der Fläche wird der zugehörige Durchmesser $d_c$ geschätzt.

$ d_c = 2 dot sqrt(a_c / pi) $
