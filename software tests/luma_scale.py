# demonstration of how the luma-scaler hardware should output

import numpy as np
import cv2

IMAGE_NAME = 'me.png'

if __name__ == "__main__":

  img = cv2.imread(IMAGE_NAME)
  img2 = cv2.cvtColor(img, cv2.COLOR_RGB2YCrCb)
  img_conv = cv2.cvtColor(img, cv2.COLOR_RGB2YCrCb)
  img_scaled = cv2.cvtColor(img, cv2.COLOR_RGB2YCrCb)

  scale = 50

  for pixel_y in range(len(img_conv)):
    for pixel_x in range(len(img_conv[0])):

      amount = img_conv[pixel_y][pixel_x][0] + scale
      if amount > 255:
        amount = 255
      elif amount < 0:
        amount = 0

      img_scaled[pixel_y][pixel_x][0] = amount

      img_conv[pixel_y][pixel_x][0] = amount
      img_conv[pixel_y][pixel_x][1] = amount
      img_conv[pixel_y][pixel_x][2] = amount

      img2[pixel_y][pixel_x][1] = img2[pixel_y][pixel_x][0]
      img2[pixel_y][pixel_x][2] = img2[pixel_y][pixel_x][0]

  imgscaled = cv2.cvtColor(img_scaled, cv2.COLOR_YCrCb2RGB)

  cv2.imshow('original',img)
  #cv2.imshow('converted', img2)
  #cv2.imshow('scaled', img_conv)
  cv2.imshow('New output', imgscaled)
  cv2.waitKey(0)
  cv2.destroyAllWindows()