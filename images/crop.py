# (left top right bottom)
patterns = [
	("point_", (700, 400, 900, 0)),
]

from PIL import Image
import os

for pattern in patterns:
	name = pattern[0]
	amount = pattern[1]

	for file in os.listdir():
		if "crop" in file:
			continue
		if not file.endswith("png"):
			continue
		if name not in file:
			continue
		img = Image.open(file)
		img = img.crop((amount[0], amount[1], img.width - amount[2], img.height - amount[3]))
		img.save(file[:-4] + "-crop.png")
