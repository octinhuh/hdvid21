# demonstration of the YCbCr encoder/decoder functionality

import numpy as np
import cv2
#import matplotlib.pyplot as plt
#import matplotlib.image as mpimg

K_VALS = [.299, .587, .114] # ITU-R BT.601
#K_VALS = [.2627, .678, .0593] # ITU-R BT.2020
R = 0
G = 1
B = 2

def color_matrix(values):
  """
  Generates a color matrix from the K values
  :param values: list of values [Kr, Kg, Kb]
  :return: 3x3 matrix (list) of the color matrix
  """
  kr = values[0]
  kg = values[1]
  kb = values[2]

  matrix = []
  matrix.append(values)
  matrix.append([-.5*kr/(1-kb), -.5*kg/(1-kb), .5])
  matrix.append([.5, -.5*kg/(1-kr), -.5*kb/(1-kr)])

  return matrix

def rgb_to_ycbcr(image, constants=K_VALS):
  """
  Converts an RGB image (list of lists of lists of uint8's) to a YCbCr image
  :param values: input image
  :param constants: The conversion constants to use [Kr, Kg, Kb]
  :return: a new 3-channel image in YCbCr encoding
  """

  kr = constants[0]
  kg = constants[1]
  kb = constants[2]
  m = color_matrix(constants)

  new_image = []

  for y in range(len(image)):

    row = []
    for x in range(len(image[y])):


      pixel = []
      
      # JPEG conversion
      r = image[y][x][R]
      g = image[y][x][G]
      b = image[y][x][B]

      luma_p = 0 + (kr*r) + (kg*g) + (kb*b)
      cb = 128 + (m[1][0]*r) + (m[1][1]*g) + (m[1][2]*b)
      cr = 128 + (m[2][0]*r) + (m[2][1]*g) + (m[2][2]*b)

      pixel = [luma_p, cr, cb]

      row.append(np.array(pixel, dtype = 'uint8'))

    new_image.append(np.array(row, dtype = 'uint8'))

  return np.array(new_image, dtype = 'uint8')

def ycbcr_to_rgb(image, constants=K_VALS):
  """
  Converts a YCbCr image (list of lists of lists of uint8's) to an RGB image
  :param values: input image
  :param constants: The conversion constants to use
  :return: a new 3-channel image in RGB encoding
  """

  m = np.linalg.inv(np.array(color_matrix(constants)))

  new_image = []

  for y in range(len(image)):

    row = []
    for x in range(len(image[y])):

      pixel = []
      
      # JPEG conversion
      luma_p = image[y][x][R]
      cr = image[y][x][G]
      cb = image[y][x][B]

      r = luma_p + (m[0][2] * (cr-128))
      g = luma_p + (m[1][1] * (cb-128)) + (m[1][2] * (cr-128))
      b = luma_p + (m[2][1] * (cb-128))

      pixel = [r, g, b]

      # restricting range of the values to 0-255
      for i in range(len(pixel)):
        if pixel[i] < 0:
          pixel[i] = 0
        elif pixel[i] > 255:
          pixel[i] = 255

      row.append(np.array(pixel, dtype = 'uint8'))

    new_image.append(np.array(row, dtype = 'uint8'))

  return np.array(new_image, dtype = 'uint8')

if __name__ == "__main__":

  img = cv2.imread('me.png')
  img2 = rgb_to_ycbcr(img)
  #img3 = cv2.cvtColor(img2, cv2.COLOR_YCrCb2RGB)
  #img4 = cv2.cvtColor(img, cv2.COLOR_RGB2YCrCb)
  img5 = ycbcr_to_rgb(img2)

  cv2.imshow('original', img)
  cv2.imshow('converted', img2)
  cv2.imshow('reconstructed', img5)

  cv2.waitKey(0)
  cv2.destroyAllWindows()