#!/bin/python3

import json
import sys
import os

absolute_path = os.path.dirname(__file__)
relative_path = "todo.json"
full_path = os.path.join(absolute_path, relative_path)

file = open(full_path, "r")
list = json.load(file)
file.close()

if sys.argv[1] == "add" and len(sys.argv) == 3:
    file = open(full_path, "w")
    list["items"].append(sys.argv[2])
    json.dump(list, file)
    file.close()

if sys.argv[1] == "remove" and len(sys.argv) == 3 and sys.argv[2] in list["items"]:
    file = open(full_path, "w")
    list["items"].remove(sys.argv[2])
    json.dump(list, file)
    file.close()
  
if sys.argv[1] == "list":
    print(list)


