import os
import shutil
import json

import pygsheets

PATH = "../../treee/cwd/auto/"

KEYS = ["source_points", "leaf_points", "branch_points", "segments"]
TIMES = ["import", "segment", "calculate", "lods"]


client = pygsheets.authorize()
sh = client.open('Masterarbeit')
wks = sh.sheet1

table = []

for file in os.listdir(PATH):
    path = PATH + file
    if not os.path.isdir(path):
        continue
    path += "/statistics.json"
    if not os.path.exists(path):
        continue
    data = json.load(open(path))
    row = []
    row.append(file)
    for key in KEYS:
        row.append(data[key])
    for time in TIMES:
        row.append(data["times"][time])
    table.append(row)

table.sort()
table.insert(0, ["data"] + KEYS + TIMES)


print(table)


wks.update_values("D3", table)