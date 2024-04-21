#import "setup.typ": *

#set heading(numbering: none, outlined: false)

#v(1fr)

#align(center, block(width: 80%, [


	== Abstrakt

	#align(left)[
		Diese Arbeit beschäftigt sich mit der Verarbeitung, Analyse und Visualisierung von Waldgebieten mithilfe von Punktwolken. Dabei wird der komplette Ablauf vom Datensatz bis zur Visualisierung der einzelnen Bäume mit relevanten Informationen durchgeführt.

		Ein Datensatz ist dabei ein Lidar-Scan von einem Waldgebiet, welcher als Liste von Punkten gegeben ist. Die Punkte können in beliebiger Reihenfolge abgespeichert sein und für jeden Punkt wird nur die dreidimensionale Position benötigt.

		Zuerst werden die Punkte automatisch in einzelne Bäume unterteilt. Die Analyse berechnet für die Bäume und einzelne Punkte danach relevante Informationen und die Daten werden für die Visualisierung in Echtzeit vorbereitet.

		In dem zugehörigen Softwareprojekt sind die vorgestellten Methoden, Datenstrukturen und Algorithmen umgesetzt. Die Analyse und Visualisierung der Waldgebiete werden mit der Umsetzung getestet und ausgewertet.
	]
]))

#v(2fr)

#image("../images/auto-crop/br06-uls.png")

#v(1fr)
