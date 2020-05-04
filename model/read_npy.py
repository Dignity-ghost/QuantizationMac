import numpy as np

data_dict = np.load('/home/linux/file/package/tensorflow_material/vgg16.npy', encoding='latin1').item()
keys = sorted(data_dict.keys())

for key in keys:
    weights = data_dict[key][0]
    biases = data_dict[key][1]
    print('\n')
    print(key)
    print('weights shape: ', weights.shape)
    print('biases shape: ', biases.shape)
