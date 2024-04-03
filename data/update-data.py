import os
import shutil
import json


PATH = "./../treee/cwd/auto/"

KEYS = ["source_points", "leaf_points", "branch_points", "segments"]
TIMES = ["import", "segment", "calculate", "lods"]

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

res = open("data/data.tsv", "w")
for row in table:
    for entry in row:
        res.write(f"{entry}\t")
    res.write("\n")