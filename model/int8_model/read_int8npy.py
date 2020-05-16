import numpy as np
from numpy import *

npy_path = "E:\\project\\dataset\\vgg16.npy"
data_dict = np.load(npy_path, encoding='latin1').item()
keys = sorted(data_dict.keys())
q_num = 128

for key in keys:
    weights = data_dict[key][0]
    biases = data_dict[key][1]
    wmax_loc = np.unravel_index(np.argmax(weights),weights.shape)
    wmin_loc = np.unravel_index(np.argmin(weights),weights.shape)
    wmax = weights[wmax_loc]
    wmin = weights[wmin_loc]
    bmax_loc = np.unravel_index(np.argmax(biases),biases.shape)
    bmin_loc = np.unravel_index(np.argmin(biases),biases.shape)
    bmax = biases[bmax_loc]
    bmin = biases[bmin_loc]
    if wmax > abs(wmin):
        wq = wmax
    else:
        wq = abs(wmin)
    if bmax > abs(bmin):
        bq = bmax
    else:
        bq = abs(bmin)    
    wq = wq / q_num
    bq = bq / q_num
    weights = ((weights / wq).astype(np.int) * wq).astype(np.float32)
    biases = ((biases / bq).astype(np.int) * bq).astype(np.float32)
    data_dict[key][0] = weights
    data_dict[key][1] = biases

np.save('E:\\project\\dataset\\vgg16_int8.npy', data_dict)