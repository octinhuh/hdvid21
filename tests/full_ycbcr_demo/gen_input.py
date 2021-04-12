"""
gen_input.py
HDVID21
Generates an input file for the full ycbcr demo testbench
"""

import numpy as np
import cv2, json, sys

DEFAULT_SETTINGS = "test-settings-CHR.json"

def gen_input(image):
  """
  Loads in the image data from the given dictionary builds the output lines
  :image: image information dictionary, with a file name, width, and height
  :ofp: file pointer to the csv being created
  :return: list of lines to put into the file
  """

  data = cv2.imread(image["name"])
  data = cv2.cvtColor(data, cv2.COLOR_BGR2RGB)
  lines = []

  # iterate through each pixel
  for row in data:
    for pixel in row:
      line = []
      for color in pixel:
        line.append(str(color))

      lines.append(",".join(line) + "\n")
  
  return lines

if __name__ == "__main__":

  settings_file = DEFAULT_SETTINGS

  if len(sys.argv) > 1:
    settings_file = sys.argv[1]

  print("Opening settings configuration:", settings_file)

  settings = {}
  with open(settings_file, "r") as f:
    settings = json.load(f)

  print("Generating {} with data from {}".format(settings["output name"], \
    settings["image"]["name"]))

  with open(settings["input name"], "w") as f:
    lines = gen_input(settings["image"])
    f.writelines(lines)