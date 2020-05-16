import numpy as np
from numpy import *

npy_path = "E:\\project\\dataset\\vgg16.npy"
data_dict = np.load(npy_path, encoding='latin1').item()
keys = sorted(data_dict.keys())

for key in keys:
    weights = data_dict[key][0]
    biases = data_dict[key][1]
    weights = weights.astype(np.float16)
    biases = biases.astype(np.float16)
    weights = weights.astype(np.float32)
    biases = biases.astype(np.float32)
    a = sum(weights-data_dict[key][0])
    print("loss",key,a)
    data_dict[key][0] = weights
    data_dict[key][1] = biases

np.save('E:\\project\\dataset\\vgg16_fp16.npy', data_dict)
