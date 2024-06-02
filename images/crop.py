# (left top right bottom)
patterns = [
	("point_", (700, 400, 900, 0)),
	("var_", (600, 0, 500, 0)),
	("curve_", (600, 0, 500, 0)),
	("height", (600, 0, 500, 0)),
	("lod_", (536, 17, 1920 - 1502, 1000 - 985)),
	("triangulation_", (760, 15, 1920 - 1219, 1000 - 965)),
	("compare", (747, 27, 1920 - 1140, 1000 - 982)),
	("prop_", (1077, 83, 1073, 80)),
	("compare2", (860, 42, 746, 32)),
	("layers_", (891, 497, 809, 391))
]

from PIL import Image
import os
import shutil


if os.path.exists("crop"):
	shutil.rmtree("crop")
os.makedirs("crop")

if os.path.exists("auto-crop"):
	shutil.rmtree("auto-crop")
os.makedirs("auto-crop")

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
		img.save("./crop/" + file)
		print("crop " + file)

for file in os.listdir():
	if "crop" in file:
		continue
	if not file.endswith("png"):
		continue
	img = Image.open(file)
	box = img.getbbox()
	size = img.size
	img = img.crop(box)
	box = (box[0], box[1], size[0] - box[2], size[1] - box[3])
	img.save("./auto-crop/" + file)
	print("crop", file, box)
