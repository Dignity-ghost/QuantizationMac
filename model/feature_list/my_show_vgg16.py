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

#val_root = "E:\\project\\dataset\\ILSVRC2012_img_val\\"
val_root = "E:\\project\\dataset\\val100\\"
label_path = "E:\\project\\dataset\\val.txt"
batch_size = 25
set_num = len([os.path.join(val_root,img) for img in os.listdir(val_root)])
use_gpu = torch.cuda.is_available()
#torch.set_default_tensor_type('torch.cuda.HalfTensor')


def draw_hist(arr, layername):
    array = arr.cpu().numpy()
    array = abs(array)
    array_flatten = array.flatten() 
    bin_pos = np.logspace(-16,16,33,base=2)
    plt.hist(array_flatten, bins = bin_pos)
    plt.savefig('E:\\project\\QuantizationMac\\model\\feature_list\\summary\\'+layername+'_hist.png')


val_transform = transforms.Compose([
        transforms.Resize(224),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                    	     std=[0.229, 0.224, 0.225])
    ])


class Mydataset(Dataset):
    
    def __init__(self,root,txtpath,data_transforms=None):
        self.root = root
        self.txt = txtpath
        self.imgs = [os.path.join(root,img) for img in os.listdir(root)] 
        self.len = len(self.imgs)
        label = [l.strip() for l in open(label_path).readlines()]
        label_list = []
        for i in range(len(label)):
            label[i] = re.split(r' ', label[i])
            label[i][1] = int(label[i][1])
            label_list.append(label[i][1])
        self.label_list = label_list
        self.transforms = data_transforms

    def __len__(self):
        data_len = self.len
        return data_len
    
    def __getitem__(self,index):
        img_path = self.imgs[index]
        data = Image.open(img_path).convert('RGB')
        label = self.label_list[index]  
        #print(label,index)
        if self.transforms is not None:
            data = self.transforms(data)
        return data,label


val_dataset = Mydataset(val_root,label_path,val_transform)
val_dataset_loader = data.DataLoader(val_dataset,batch_size, shuffle=False,num_workers=0)   


class hist_ReLU(nn.Module):

    def __init__(self, layer_order, batch_order):
        super(hist_ReLU, self).__init__()
        self.layer_order = layer_order
        self.batch_order = batch_order
        self.main = nn.Sequential(nn.ReLU(inplace=True))

    def forward(self, input):
        input = self.main(input)
        array = input.cpu().numpy()
        np.save('E:\/project\/QuantizationMac\/model\/feature_list\/'+str(self.layer_order)+'\/'+str(self.batch_order)+'_batch_'+str(self.layer_order)+'_layer.npy', array)
        input = fromDlpack(to_dlpack(input))
        
        return from_dlpack(toDlpack(input))


class My_vgg16(nn.Module):
    def __init__(self, batch_num, num_classes=1000, init_weights=False):

        super(My_vgg16, self).__init__()

        self.features = nn.Sequential(

            nn.Conv2d(3, 64, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),
            
            hist_ReLU(1, batch_num),
            
            nn.Conv2d(64, 64, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(2, batch_num),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(64, 128, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(3, batch_num),

            nn.Conv2d(128, 128, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(4, batch_num),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(128, 256, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(5, batch_num),

            nn.Conv2d(256, 256, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(6, batch_num),

            nn.Conv2d(256, 256, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(7, batch_num),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(256, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(8, batch_num),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(9, batch_num),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(10, batch_num),

            nn.MaxPool2d(kernel_size=2, stride=1, padding=1, dilation=1, ceil_mode=False),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(11, batch_num),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(12, batch_num),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            hist_ReLU(13, batch_num),

            nn.MaxPool2d(kernel_size=2, stride=1, padding=0, dilation=1, ceil_mode=False),
            
            nn.AdaptiveAvgPool2d((7,7)))

        self.classifier = nn.Sequential(

            nn.Linear(512 * 7 * 7, 4096),

            hist_ReLU(14, batch_num),

            nn.Dropout(p=0.5),

            nn.Linear(4096, 4096),

            hist_ReLU(15, batch_num),

            nn.Dropout(p=0.5),

            nn.Linear(4096, num_classes),
        )

        if init_weights:
            self._initialize_weights()

 
    def forward(self, x):
        x = self.features(x)
        x = x.view(x.size(0), -1)
        x = self.classifier(x)
        return x

 
model_vgg = models.vgg16(pretrained=True)
pretrained_dict = model_vgg.state_dict()
pretrained_dict = {k: v for k,v in pretrained_dict.items()}

pretrained_dict = {k: v for k,v in pretrained_dict.items()}
for k in pretrained_dict:
    if k.endswith("weight"):
        layer_order = 'filter\\' + k
        draw_hist(pretrained_dict[k], layer_order)
    
    if k.endswith("bias"):
        layer_order = 'bias\\' + k
        draw_hist(pretrained_dict[k], layer_order)




top1_rate = 0
top5_rate = 0

for i,[data,labels] in enumerate(val_dataset_loader):
    my_vgg = My_vgg16(i)
    my_dict = my_vgg.state_dict()
    my_dict.update(pretrained_dict)
    my_vgg.load_state_dict(my_dict)

    my_vgg.eval()
    with torch.no_grad():
        input = Variable(data)
        if use_gpu:
            input = input.cuda()
            my_vgg = my_vgg.cuda()
        output = my_vgg(input)


    out = output.cuda().data.cpu().numpy()
    out_index = np.argsort(-out,axis=1)
    groundtruth = labels.detach().numpy()

    for k in range(batch_size):
        pred = out_index[k]
        if groundtruth[k] == pred[0]:
            top1_rate = top1_rate + 1
        if groundtruth[k] in pred[0:5]:
            top5_rate = top5_rate + 1

top1_rate = top1_rate / set_num
print("top1 rate is", top1_rate)
top5_rate = top5_rate / set_num
print("top5 rate is", top5_rate)

