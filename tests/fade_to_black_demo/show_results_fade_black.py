"""
show_results.py
HDVID21
Shows the difference between the input RGB data and the encoded/decoded result
from the ycbcr vhdl simulation
"""

import numpy as np
import cv2, json, sys

DEFAULT_SETTINGS = "tests/fade_to_black_demo/test-settings.json"

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
  img = cv2.imread(settings["image"]["name"]) # values will be changed

  out = cv2.VideoWriter('output_vid.mp4', cv2.VideoWriter_fourcc(*'MJPG'), settings["rate"], (200, 110))
  #out.write(original)
  # put the output csv data into result
  with open(settings["output name"], "r") as f:
    print("Reconstructing image...")
    csv_str = f.readlines()

    for i in range(settings["frames"]):
      print("Processing frame:", i + 1)
      
      line_index = ((original.shape[0] * original.shape[1]) * i, \
        (original.shape[0] * original.shape[1]) * (i + 1))
      build_image(csv_str[line_index[0]:line_index[1]], img)
      out.write(img)

  #cv2.imshow('last_frame', img)
  #cv2.waitKey(0)
  #cv2.destroyAllWindows()