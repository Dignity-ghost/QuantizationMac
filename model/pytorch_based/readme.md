# VGG16 quantization based on PyTorch

## Introduction of directories

### ./ -- model_vgg16.py is original VGG16 model from PyTorch

### &ensp;&ensp;-- my_vgg16.py is my VGG16 model having the same function of the on from PyTorch

### &ensp;&ensp;-- int8_vgg16.py is based on my_vgg16 having int8 quantization method

### &ensp;&ensp;-- f16_vgg16.py is based on my_vgg16 having float16 quanztization method

### ./other_methods -- f16_vgg16_pure.py uses pure float16 as the formate of all data

### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; --int8_vgg16_peekvalue uses peek value as the scope of quantization

## Key explanation

### my_layer shown as int_ReLU and f16_ReLU which combine the function of ReLU and Quantization for result of every layer

### function quan is to quantizate weights and bias

### this VGG16 is for classification in ImgaeNet2012 validation datatset

### the easy way to use in other equipment is to change the path of dataset and batchsize
