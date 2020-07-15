import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
from torch.autograd import Variable
from torchvision import datasets,transforms,models
from torch.utils import data
from torch.utils.data import Dataset, DataLoader
from torch.utils import data

import numpy as np
from numpy import *
import os
import re
from PIL import Image

val_root = "E:\\project\\dataset\\ILSVRC2012_img_val\\"
#val_root = "E:\\project\\dataset\\val100\\"
label_path = "E:\\project\\dataset\\val.txt"
batch_size = 50
set_num = len([os.path.join(val_root,img) for img in os.listdir(val_root)])
use_gpu = torch.cuda.is_available()
#torch.set_default_tensor_type('torch.cuda.HalfTensor')


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

net = models.vgg16(pretrained=True)
net.eval()

top1_rate = 0
top5_rate = 0

for i,[data,labels] in enumerate(val_dataset_loader):
    with torch.no_grad():
        input = Variable(data)
        if use_gpu:
            input = input.cuda()
            net = net.cuda()
        #groundtruth = Variable(labels.long())
        output = net(input)

    out = output.cuda().data.cpu().numpy()
    out_index = np.argsort(-out,axis=1)
    groundtruth = labels.detach().numpy()

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
