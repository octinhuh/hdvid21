# demonstration of the YCbCr encoder/decoder functionality

K_VALS = [.299, .587, .114] # ITU-R BT.601

def rgb_to_ycbcr(image, constants=K_VALS):
  """
  Converts an RGB image (list of lists of lists of uint8's) to a YCbCr image
  :param values: input image
  :param constants: The conversion constants to use [Kr, Kg, Kb]
  :return: a new 3-channel image in YCbCr encoding
  """

def ycbcr_to_rgb(image, constants=K_VALS):
  """
  Converts a YCbCr image (list of lists of lists of uint8's) to an RGB image
  :param values: input image
  :param constants: The conversion constants to use
  :return: a new 3-channel image in RGB encoding
  """