import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
from torch.autograd import Variable
from torchvision import datasets,transforms,models
from torch.utils import data
from torch.utils.data import Dataset, DataLoader
from torch.utils import data
from torch.nn.modules.module import Module

import numpy as np
import matplotlib.pyplot as plt
import os
import re
from PIL import Image

import cupy as cp
from cupy.core.dlpack import toDlpack
from cupy.core.dlpack import fromDlpack
from torch.utils.dlpack import to_dlpack
from torch.utils.dlpack import from_dlpack


def draw_hist(arr, layername, flag):
    array = arr.cpu().numpy()
    array = abs(array)
    a_max = np.max(array)
    a_min = np.min(array)
    array_flatten = array.flatten() 

    f = open('E:\\project\\QuantizationMac\\model\\feature_list\\summary\\'+flag+'\\'+flag+'_peek_value.txt','a')
    f.write(str(layername)+' '+str(a_max)+' '+str(a_min)+'\n')
    f.close()
    #bin_pos = np.logspace(-16,16,33,base=2)
    #bin_pos = np.logspace(-8,0,9,base=2)
    bin_list = np.arange(a_min, a_max+(a_max-a_min)/11, (a_max-a_min)/11)
    plt.hist(array_flatten, bins = bin_list)
    plt.savefig('E:\\project\\QuantizationMac\\model\\feature_list\\summary\\'+flag+'\\'+layername+'_hist.png')
    plt.close()



model_vgg = models.vgg16(pretrained=True)
pretrained_dict = model_vgg.state_dict()
pretrained_dict = {k: v for k,v in pretrained_dict.items()}

pretrained_dict = {k: v for k,v in pretrained_dict.items()}
for k in pretrained_dict:
    if k.endswith("weight"):
        layer_order = k
        draw_hist(pretrained_dict[k], layer_order, 'filter')
    
    if k.endswith("bias"):
        layer_order = k
        draw_hist(pretrained_dict[k], layer_order, 'bias')









