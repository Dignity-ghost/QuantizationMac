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
import os
import re
from PIL import Image

import cupy as cp
from cupy.core.dlpack import toDlpack
from cupy.core.dlpack import fromDlpack
from torch.utils.dlpack import to_dlpack
from torch.utils.dlpack import from_dlpack

val_root = "E:\\project\\dataset\\ILSVRC2012_img_val\\"
#val_root = "E:\\project\\dataset\\val100\\"
label_path = "E:\\project\\dataset\\val.txt"
batch_size = 10
set_num = len([os.path.join(val_root,img) for img in os.listdir(val_root)])
use_gpu = torch.cuda.is_available()
#torch.set_default_tensor_type('torch.cuda.HalfTensor')

#quantization list
filter_quanlist = [-7, -7, -7, -8, -7, -8, -7, -8, -8, -9, -8, -9, -9, -11, -11, -9]
bias_quanlist   = [-6, -7, -8, -7, -8, -8, -8, -8, -6, -7, -8, -6, -7, -10, -9, -10]


val_transform = transforms.Compose([
        transforms.Resize(224),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                    	     std=[0.229, 0.224, 0.225])
    ])


def quan(arr, quan_unit):
    unit = 2 ** (quan_unit)
    quan_arr = arr
    quan_arr = np.array(quan_arr)
    quan_arr = (np.round(quan_arr / unit))
    quan_arr[quan_arr>127] = 127
    quan_arr[quan_arr<-127] = -127
    quan_arr = quan_arr * unit
    
    return torch.from_numpy(quan_arr)

    

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

class int_ReLU(nn.Module):

    def __init__(self, quan_unit):
        super(int_ReLU, self).__init__()
        self.unit = 2 ** quan_unit
        self.main = nn.Sequential(nn.ReLU(inplace=True))

    def forward(self, input):
        input = self.main(input)
        div_cp = self.unit
        div_cp = cp.asarray(div_cp)
        input = fromDlpack(to_dlpack(input))
        input = cp.rint(input / div_cp)
        input[input>255] = 255
        input = input * div_cp
        input = from_dlpack(toDlpack(input))
        input = input.type(torch.cuda.FloatTensor)
        #div_cp = self.unit
        #input = (input / div_cp).round()
        #input[input>255] = 255
        #input = input * div_cp
        return input


class My_vgg16(nn.Module):
    #def __init__(self, input_quanlist, num_classes=1000, init_weights=False):
    def __init__(self, num_classes=1000, init_weights=False):

        input_quanlist  = [0, -4, -3, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -4, -5]

        super(My_vgg16, self).__init__()

        self.features = nn.Sequential(

            nn.Conv2d(3, 64, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),
            
            int_ReLU(input_quanlist[0]),
            
            nn.Conv2d(64, 64, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[1]),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(64, 128, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[2]),

            nn.Conv2d(128, 128, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[3]),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(128, 256, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[4]),

            nn.Conv2d(256, 256, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[5]),

            nn.Conv2d(256, 256, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[6]),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(256, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[7]),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[8]),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[9]),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[10]),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[11]),

            nn.Conv2d(512, 512, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),

            int_ReLU(input_quanlist[12]),

            nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),
            
            nn.AdaptiveAvgPool2d((7,7)))

        self.classifier = nn.Sequential(

            nn.Linear(512 * 7 * 7, 4096),

            int_ReLU(input_quanlist[13]),

            nn.Dropout(p=0.5),

            nn.Linear(4096, 4096),

            int_ReLU(input_quanlist[14]),

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


cnt = 0
pretrained_dict = {k: v for k,v in pretrained_dict.items()}
for k in pretrained_dict:
    if k.endswith("weight"):
        pretrained_dict[k] = quan(pretrained_dict[k], filter_quanlist[cnt])
    if k.endswith("bias"):
        pretrained_dict[k] = quan(pretrained_dict[k], bias_quanlist[cnt])
        cnt = cnt + 1

#my_vgg = My_vgg16(input_quanlist)
my_vgg = My_vgg16()
my_dict = my_vgg.state_dict()
my_dict.update(pretrained_dict)
my_vgg.load_state_dict(my_dict)


my_vgg.eval()

top1_rate = 0
top5_rate = 0

print("Begin to read batch...")
for i,[data,labels] in enumerate(val_dataset_loader):
    with torch.no_grad():
        input = Variable(data)
        if use_gpu:
            input = input.cuda()
            #print(input.dtype)
            my_vgg = my_vgg.cuda()
        output = my_vgg(input)
        #print("out type", output.dtype)


    out = output.cuda().data.cpu().numpy()
#    out = output.numpy()
    out_index = np.argsort(-out,axis=1)
    groundtruth = labels.cpu().numpy()
#    groundtruth = labels.numpy()

    for k in range(batch_size):
        pred = out_index[k]
        if groundtruth[k] == pred[0]:
            top1_rate = top1_rate + 1
        if groundtruth[k] in pred[0:5]:
            top5_rate = top5_rate + 1

    if i%50 == 0:
        print("Dealing progess:", i/(50000/batch_size)*100,'%')

print("correct_top1 number is", top1_rate)
top1_rate = top1_rate / set_num
print("top1 rate is", top1_rate)

print("correct_top5 number is", top5_rate)
top5_rate = top5_rate / set_num
print("top5 rate is", top5_rate)
