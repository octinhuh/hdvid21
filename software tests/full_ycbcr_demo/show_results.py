"""
show_results.py
HDVID21
Shows the difference between the input RGB data and the encoded/decoded result
from the ycbcr vhdl simulation
"""

import numpy as np
import cv2, json, sys

DEFAULT_SETTINGS = "software tests/full_ycbcr_demo/test-settings.json"

def build_image(lines, image):
  """
  Replace the image data with the contents of the given input lines
  :lines: list of strings of each line from the simulation output
  :image: the cv2 image (correct width, height)
  :return: None
  """

  line_num = 0

  for y in range(len(image)):
    for x in range(len(image[y])):

      line = lines[line_num].split(",")

      for z in range(len(image[y][x])):
        image[y][x][z] = int(line[z])
        
      line_num += 1

if __name__ == "__main__":

  settings_file = DEFAULT_SETTINGS

  if len(sys.argv) > 1:
    settings_file = sys.argv[1]

  print("Opening settings configuration:", settings_file)

  settings = {}
  with open(settings_file, "r") as f:
    settings = json.load(f)

  original = cv2.imread(settings["image"]["name"])
  result = cv2.imread(settings["image"]["name"]) # values will be changed
  temp = cv2.imread(settings["image"]["name"])

  # put the output csv data into result
  with open(settings["output name"], "r") as f:
    
    build_image(f.readlines(), result)

  with open("temp.csv", "r") as f:

    build_image(f.readlines(), temp)

  temp = cv2.cvtColor(temp, cv2.COLOR_YCrCb2RGB)

  cv2.imshow('original', original)
  cv2.imshow('result', result)
  cv2.imshow("intermediate", temp)

  cv2.waitKey(0)
  cv2.destroyAllWindows()