"""
show_results.py
HDVID21
Shows the difference between the input RGB data and the encoded/decoded result
from the ycbcr vhdl simulation
"""

import numpy as np
import cv2, json, sys

DEFAULT_SETTINGS = "test-settings.json"

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
  result1 = cv2.imread(settings["image"]["name"]) # values will be changed
  result2 = cv2.imread(settings["image"]["name"]) # values will be changed
  result3 = cv2.imread(settings["image"]["name"]) # values will be changed
  result4 = cv2.imread(settings["image"]["name"]) # values will be changed
  result5 = cv2.imread(settings["image"]["name"]) # values will be changed
  result6 = cv2.imread(settings["image"]["name"]) # values will be changed
  result7 = cv2.imread(settings["image"]["name"]) # values will be changed
  result8 = cv2.imread(settings["image"]["name"]) # values will be changed
  temp = cv2.imread(settings["image"]["name"])
  out = cv2.VideoWriter('output_vid.mp4', cv2.VideoWriter_fourcc(*'XVID'), 5, (620,916))
  out.write(original)
  # put the output csv data into result
  with open(settings["output name1"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result1)
    out.write(result1)

  with open(settings["output name2"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result2)
    out.write(result2)
  with open(settings["output name3"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result3)
    out.write(result3)
  with open(settings["output name4"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result4)
    out.write(result4)
  with open(settings["output name5"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result5)
    out.write(result5)
  with open(settings["output name6"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result6)
    out.write(result6)
  with open(settings["output name7"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result7)
    out.write(result7)
  with open(settings["output name8"], "r") as f:
    print("Reconstructing image...")
    build_image(f.readlines(), result8)
    out.write(result8)


  print("Displaying result windows")
  cv2.imshow('original', original)
  cv2.imshow('result', result8)

  cv2.waitKey(0)
  cv2.destroyAllWindows()

