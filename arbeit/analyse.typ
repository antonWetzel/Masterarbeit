#import "setup.typ": *


= Analyse von Bäumen

Die charakteristischen Eigenschaften werden für jeden Baum einzeln berechnet. Für jeden Punkt im Baum wird zuerst die relative Höhe, lokale Krümmung und zugehörige horizontale Ausdehnung bestimmt. Mit diesen Daten wird dann eine Unterteilung in Boden, Stamm und Krone durchgeführt. Ein Beispiel für die Ergebnisse sind in @analyse_eigenschaften zu sehen.

#figure(caption: [Segment basierend auf den berechneten Eigenschaften eingefärbt.], grid(
	columns: 1 * 4,
	column-gutter: 1em,
	subfigure(image("../images/crop/prop_height.png"), caption: [Höhe]),
	subfigure(image("../images/crop/prop_curve_all.png"), caption: [Krümmung]),
	subfigure(image("../images/crop/prop_var_all.png"), caption: [Ausdehnung]),
	subfigure(image("../images/crop/prop_classification.png"), caption: [Klassifikation]),
)) <analyse_eigenschaften>

Mit der Unterteilung wird für den Stamm und die Krone die Höhe und der Durchmesser abgeschätzt.


== Eingabedaten

Die Punkte sind als Liste der Länge $n$ gegeben. Für den Punkt $i in NN_0^(n-1)$ ist nur die globale Position $p_i = (p_(i x), p_(i y), p_(i z))$ bekannt. Die Punkte sind dabei ungeordnet, wodurch aufeinanderfolgende Punkte in der Liste weit voneinander entfernte Positionen haben können.


== Punkteigenschaften

Um einen Punkt $i$ zu analysieren, wird die zugehörige Nachbarschaft $N_i$ benötigt. Die Nachbarschaft enthält dabei die nächsten Punkte nach Abstand sortiert. Dafür wird mit den Punkten ein KD-Baum erstellt. Mit diesem können effizient für eine Position $p_i$ und ein beliebiges $k in NN$ die $k$-nächsten Punkte bestimmt werden. Die Konstruktion und Verwendung vom KD-Baum wird in @kd_baum erklärt. In der Nachbarschaft ist dann $N_0$ der ursprüngliche Punkt $i$, $N_1$ der nächste Punkt und $N_(k-1)$ der $k-1$ nächste Punkt.


=== Relative Höhe

Für jeden Punkt wird die relative Höhe im Segment bestimmt. Dafür wird zuerst mit allen Positionen die Mindesthöhe $h_min$ und Maximalhöhe $h_max$ bestimmt.

$ h_min = min_(i in NN_0^(n-1))p_(i y) #h(40pt) h_max = max_(i in NN_0^(n-1))p_(i y) $

Mit der Mindest- und Maximalhöhe kann für den Punkt $i$ die relative Höhe $h_i$ bestimmt werden.

$ h_i = (p_(i y) - h_min) / (h_max - h_min) $

Die relative Höhe liegt immer im Bereich $[0; 1]$ und wird größer, je höher der Punkt liegt.


=== Krümmung <krümmung>

Die Krümmung der ursprünglichen abgetasteten Oberfläche wird für jeden Punkt geschätzt. Dafür wird für den Punkt $i$ die Verteilung der Positionen der Punkte in der Nachbarschaft $N_i$ betrachtet. Zuerst wird für die Nachbarschaft der geometrische Schwerpunkt $s_i$ bestimmt.

$ s_i = 1 / k dot sum_(j in N_i) p_j $

Mit dem Schwerpunkte kann die Kovarianzmatrix $C_i$ bestimmt werden.

// prettypst: disable
#{
	set math.mat(column-gap: 0.5cm)
	$ C_i = 1 / k dot sum_(j in N_i) mat(
		(p_(j x) - s_(i x))^2, (p_(j x) - s_(i x)) dot (p_(j y) - s_(i y)), (p_(j x) - s_(i x)) dot (p_(j z) - s_(i z));
		(p_(j y) - s_(i y)) dot (p_(j x) - s_(i x)), (p_(j y) - s_(i y))^2, (p_(j y) - s_(i y)) dot (p_(j z) - s_(i z));
		(p_(j z) - s_(i z)) dot (p_(j x) - s_(i x)), (p_(j z) - s_(i z)) dot (p_(j y) - s_(i y)), (p_(j z) - s_(i z))^2;
	) $
}
// prettypst: enable

Ohne die Verschiebung um $s_i$ würde die globale Position der Punkte die Kovarianzmatrix beeinflussen. Von der Kovarianzmatrix werden die Eigenwerte und zugehörige Eigenvektoren bestimmt.

Die normierten Eigenvektoren $v_(i alpha)$ mit $alpha in {0, 1, 2}$ bilden eine Orthonormalbasis und der zugehörige Eigenwert $lambda_(i alpha)$ für $v_(i alpha)$ ist die Ausdehnung der Punkte entlang des Basisvektors. Der kleinste Eigenwert gehört zu Dimension mit der geringsten Ausdehnung. Je kleiner der kleinste Eigenwert, desto näher liegen die Punkte in der Nachbarschaft an der Ebene, aufgespannt durch die anderen beiden Eigenvektoren. Ein Beispiel für zweidimensionale Eigenvektoren ist in @analyse_eigenvektoren gegeben.

#let numbers = (
	(0.4855, -0.6487),
	(0.3659, -0.2336),
	(-0.2306, 0.4376),
	(0.6910, -0.3798),
	(0.1949, -0.8047),
	(-0.0356, 0.8813),
	(-0.1612, 0.6089),
	(-0.5485, -0.2536),
	(0.0358, -0.5869),
	(0.4356, 0.4279),
	(0.7246, 0.2678),
	(-0.5915, -0.7436),
	(0.5475, -0.7034),
	(-0.0222, 0.1034),
	(-0.4046, 0.2089),
	(0.3141, -0.8417),
	(0.7025, -0.1088),
	(-0.3285, 0.8300),
	(-0.0354, -0.0361),
	(0.4030, -0.0194),
	(0.4539, -0.0164),
	(0.4572, -0.7717),
	(-0.2935, 0.3223),
	(0.9009, -0.1449),
	(0.7847, 0.1091),
	(0.6713, -0.1648),
	(0.3486, 0.6795),
	(-0.1179, -0.4614),
	(-0.3916, -0.7057),
	(-0.3888, 0.1888),
	(-0.0683, 0.2466),
	(-0.5469, -0.3778),
	(-0.6345, 0.1398),
	(0.0890, -0.3881),
	(0.8525, -0.4541),
	(-0.5835, -0.0581),
	(-0.8216, 0.2838),
	(-0.0144, 0.0659),
	(0.2945, -0.7860),
	(-0.7919, -0.3148),
	(-0.5017, 0.6025),
	(-0.9352, 0.1064),
	(0.5355, 0.0521),
	(0.3187, 0.4207),
	(0.2212, 0.2391),
	(-0.5832, 0.4985),
	(-0.3192, -0.7679),
	(-0.2470, 0.0340),
	(0.9310, 0.3424),
	(-0.2747, 0.1090),
)

#let test(sec_scale) = cetz.canvas(length: 2cm, {
	import cetz.draw: *;

	set-style(stroke: black)

	line((0, 0), (2, 0), mark: (end: ">", fill: black))
	line((0, 0), (0, 2), mark: (end: ">", fill: black))
	content((2, 0), anchor: "west", padding: 0.1, $x$)
	content((0, 2), anchor: "east", padding: 0.1, $y$)

	let a_0 = (0.8, 0.5)
	let a_1 = (-0.125 * sec_scale, 0.2 * sec_scale)

	for (x, y) in numbers {
		let c_x = 1.0 + x * a_0.at(0) + y * a_1.at(0)
		let c_y = 1.0 + x * a_0.at(1) + y * a_1.at(1)
		circle((c_x, c_y), radius: 0.03, fill: black, stroke: none)
	}

	let s = 1.5
	let e_0 = (1 + a_0.at(0) * s * 0.9, 1 + a_0.at(1) * s * 0.9)
	let e_1 = (1 + a_1.at(0) * s * 0.9, 1 + a_1.at(1) * s * 0.9)
	line((1, 1), e_0, mark: (end: ">", fill: black))
	line((1, 1), e_1, mark: (end: ">", fill: black))

	content(e_0, anchor: "north", padding: 0.1, $v_0$)
	content(e_1, anchor: "south", padding: 0.1, $v_1$)
})

#figure(
	caption: [Eigenwerte und zugehörige Eigenvektoren der Kovarianzmatrix für eine Punktmenge. Die Länge der Vektoren ist anhängig vom zugehörigen Eigenwert.],
	grid(
		columns: 2,
		subfigure(test(1.0), caption: $lambda_0 = 4 lambda_1$), subfigure(test(2.0), caption: $lambda_0 = 2 lambda_1$),
	),
) <analyse_eigenvektoren>

Mit den Eigenwerten $lambda_(i alpha)$ absteigend nach größer sortiert wird die Krümmung $c_i$ berechnet.

$ c_i = (3 lambda_(i 2)) / (lambda_(i 0) + lambda_(i 1) + lambda_(i 2)) $

$c_i$ liegt dabei im abgeschlossenen Bereich $[0; 1]$, weil $0 <= lambda_(i 0) <= lambda_(i 1) <= lambda_(i 2)$ ist.


=== Eigenschaften für die Visualisierung <eigenschaften_visualisierung>

Für die Visualisierung werden die Position, Orientierung und Größe von einem Punkte benötigt. Die Position ist in den Eingabedaten gegeben und die anderen Eigenschaften werden mit der lokalen Umgebung vom Punkt berechnet. In @analyse_render ist ein Beispiel gegeben.

#figure(
	caption: [
		Ausschnitt von einer Punktwolke. Die dichteren Punkte beim Stamm sind kleiner als die umliegenden Punkte und die Orientierung ändert sich beim Übergang vom Stamm zum Boden.
	],
	rect(image("../images/auto-crop/properties.png", height: 30%), inset: 0.5pt),
) <analyse_render>

Für die Orientierung wird die Normale bestimmt, welche orthogonal zur geschätzten zugehörigen Oberfläche vom Punkt ist. Dafür werden die Eigenvektoren aus @krümmung verwendet. Der Eigenvektor, welcher zum kleinsten Eigenwert gehört, ist dabei orthogonal zur geschätzten Ebene mit der größten Ausdehnung.

Für die Punktgröße wird der durchschnittliche Abstand zu den umliegenden Punkten bestimmt. Dadurch werden die Punkte in Bereichen mit hoher Punktdichte kleiner.


== Baumeigenschaften

Für den Baum wird die Gesamthöhe und die Höhe und Durchmesser vom Stamm und der Krone gesucht. Dafür werden die Punkte in Scheiben unterteilt, diese dem Boden, Stamm oder Krone zugeordnet und dann wird mit den Scheiben die gesuchten Werte berechnet. Die einstellbaren Parameter dafür sind in @analyse_klassifkation_parameter gelistet.

#figure(
	caption: [Parameter für die Klassifikation.],
	table(
		columns: (auto, 1fr),
		align: (x, y) => if y == 0 { center } else { (center, left).at(x) },
		[*Name*], [*Funktion*],
		$w$,      [Breite von einer Scheibe],
		$h_g$,    [Maximale Suchhöhe für den Boden],
		$s_g$,    [Skalierungsfaktor für die Mindestfläche vom Boden],
		$h_t$,    [Höhe für die Berechnung vom Stammdurchmesser],
		$r_t$,    [Bereich für die Berechnung vom Stammdurchmesser],
		$d_c$,    [Differenz zwischen den Stammdurchmesser und dem Mindestdurchmesser der Krone],
	),
) <analyse_klassifkation_parameter>


=== Unterteilung in Scheiben

Zuerst werden die Punkte in gleich breite Scheiben unterteilt. Dafür wird mit der Breite $w$, $h_min$ und $h_max$ die Anzahl der benötigten Scheiben $c$ und für jeden Punkt $i$ der Index $s_i$ der zugehörigen Scheibe berechnet.

$ c = floor((h_max - h_min) / w) + 1 #h(40pt) s_i = floor((p_(i y) - h_min) / w) $

Für jede Scheibe wird der horizontale konvexe Bereich bestimmt, der alle Punkte in der Scheibe beinhaltet. Dafür werden die Methoden wie bei der Segmentierung in @segmentierung_bereiche_chapter verwendet. Mit den Bereichen wird die Fläche bestimmt, welche von den Punkten in der Scheibe belegt wird. In @analyse_klassifkation_slices ist ein Beispiel gegeben.

#figure(
	caption: [Baum in Scheiben unterteilt mit der zugehörigen Fläche für jede Scheibe.],
	image("../images/klassifkation_slices.svg"),
) <analyse_klassifkation_slices>


=== Bodenhöhe

Mit den Flächen wird zuerst die kleinste Fläche $a_min$ und die größte Fläche $a_max$ bestimmt.

Danach wird die Bodenhöhe $g$ gesucht. Dafür werden die Suchhöhe $h_g$ und der Skalierungsfaktor $s_g$ verwendet. Von unten wird die erste Scheibe gesucht, welche eine größere Fläche als $s_g dot a_min$ hat. Ist die Scheibe höher als $h_g$, wird die Höhe der untersten Scheibe als Boden verwendet. Ist die Scheibe niedriger als $h_g$, wird die nächste Scheibe gesucht, dessen Fläche kleiner als $s_g dot a_min$ ist, und die Höhe von dieser Scheibe wird als $g$ verwendet.


=== Stammdurchmesser

Mit der berechneten Bodenhöhe $g$, der Messhöhe $h_t$ und dem Bereich $r_t$ wird der Stammdurchmesser $d_t$ bestimmt. Zuerst werden alle Punkte bestimmt, deren Höhen im Bereich $[g + h_t - r_t / 2, g + h_t + r_t / 2)$ liegen. Mit dem MSAC-Algorithmus#footnote([#strong[m]-estimator #strong[sa]mple #strong[c]onsensus]) wird der Kreis gesucht, welcher am besten die Punkte beschreibt.

Beim MSAC-Algorithmus werden wiederholt genug zufällige Datenpunkte ausgewählt, dass aus diesen der gewünschte Wert eindeutig berechnet werden kann. Danach wird für jeden Datenpunkt die Abweichung zum Wert bestimmt. Die Abweichung wird auf einen Maximalwert beschränkt, um den Einfluss von weit entfernten Datenpunkten zu verringern. Die Summe von allen Abweichungen ist der Fehler für den momentanen Wert. Der Wert mit dem geringsten Fehler wird als das finale Ergebnis verwendet @msac.

Am Anfang wird als Durchmesser der Standardwert #number(0.5) m und als bester Fehler der größtmögliche Wert verwendet. Dann werden wiederholt drei zufällige Punkte ausgewählt, mit denen das Zentrum und der Durchmesser vom zugehörige Kreis eindeutig berechnet werden kann. Mit allen Punkten wird der Fehler für den Kreis berechnet. Um den Effekt von Datenpunkten zu verringern, welche nicht zum Stamm gehören wird die Abweichung auf #number(0.2) m beschränkt. Ist der momentane Fehler kleiner als der bisher bester Fehler, wird der Durchmesser als neuen besten Wert verwendet und der beste Fehler wird aktualisiert.

Nach allen Iterationen wird der Durchmesser vom besten Kreis als der geschätzte Stammdurchmesser verwendet.


=== Baumhöhe

Mit dem Stammdurchmesser $d_t$ und der Mindestdifferenz $d_c$ wird die Höhe vom Anfang der Krone bestimmt. Dafür wird die Scheibe gesucht, dessen Durchmesser $d_c$ größer als $d_t + d_c$ ist. Die zugehörige geschätzte Mindestfläche $a_m$ kann abhängig vom Durchmesser geschätzt werden.

$ a_m = pi dot ((d_t + d_c) / 2)^2 $

Danach wird die erste Scheibe höher als der Boden gesucht, dessen Fläche größer als $a_m$ ist. Der Baum geht vom Boden bis zur höchsten Scheibe, der Stamm vom Boden bis zu dieser Scheibe und die Krone von dieser Scheibe bis zur höchsten Scheibe.


=== Durchmesser von der Baumkrone

Für den Durchmesser von der Baumkrone wird für alle Scheiben in der Krone die Scheibe mit der größten Fläche $a_c$ gesucht. Mit der Fläche wird der zugehörige Durchmesser $d_c$ geschätzt.

$ d_c = 2 dot sqrt(a_c / pi) $
