import re 
label_path = "E:\\project\\dataset\\val.txt"
label = [l.strip() for l in open(label_path).readlines()]
for i in range(len(label)):
    label[i] = re.split(r' ', label[i]) 
    label[i][1] = int(label[i][1])

import numpy as np
import tensorflow as tf

import vgg16
import utils

import os
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

val_path = "E:\\project\\dataset\\val100\\"
batch_size = 5
val_num = 100
top1_rate = 0
top5_rate = 0

for i in range(0,val_num,batch_size):
    batch = utils.load_image(val_path + label[i][0])
    batch = batch.reshape((1, 224, 224, 3))
    for j in range(i+1,i+batch_size):
        img = utils.load_image(val_path + label[j][0])
        if(img.size == 50176):
            img = np.concatenate((img,img,img), axis=-1)
        img = img.reshape((1, 224, 224, 3))
        batch = np.concatenate((batch, img), 0)
    
    tf.reset_default_graph()
    config = tf.compat.v1.ConfigProto(allow_soft_placement=True)
    gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=0.7)
    config.gpu_options.allow_growth = True
    with tf.compat.v1.Session(config = config) as sess:
        images = tf.compat.v1.placeholder("float", [batch_size, 224, 224, 3])
        feed_dict = {images: batch}

        vgg = vgg16.Vgg16()
        with tf.name_scope("content_vgg"):
            vgg.build(images)

        prob = sess.run(vgg.prob, feed_dict=feed_dict)
        tf.get_default_graph().finalize()
        sess.close()

    for k in range(batch_size):
        pred = np.argsort(prob[k])[::-1]
        if label[i+k][1] == pred[0]:
            top1_rate = top1_rate + 1
        if label[i+k][1] in pred[0:4]:
            top5_rate = top5_rate + 1
        
top1_rate = top1_rate / val_num
print("top1 rate is", top1_rate)
top5_rate = top5_rate / val_num
print("top5 rate is", top5_rate)
