import numpy as np
import matplotlib.pyplot as plt
import os 

arr_path = 'E:\/project\/QuantizationMac\/model\/feature_list\/'
save_path = 'E:\/project\/QuantizationMac\/model\/feature_list\/summary\/input\/'
#layer_num = 1

def load_layer(array_path, layer_prder):
    for root, dirs, files in os.walk(arr_path):
        if root.endswith('\/'+str(layer_num)):
            for arr_name in os.listdir(root+'\/'):
                if arr_name.startswith(str(0)):
                    layer_arr = np.load(root+'\/'+arr_name)
                else:
                    layer_arr = np.concatenate((layer_arr, np.load(root+'\/'+arr_name)), axis=0)
            
    return layer_arr

for layer_num in range(1,16,1):
    layer = load_layer(arr_path, layer_num)
    a_max = np.max(layer)
    a_min = np.min(layer)
    f = open(save_path+'input_peek_value.txt','a')
    f.write(str(layer_num)+' '+str(a_max)+' '+str(a_min)+'\n')
    f.close()
    layer_flatten = layer.flatten()
    bin_list = np.arange(a_min, a_max+(a_max-a_min)/11, (a_max-a_min)/11)
    plt.hist(layer_flatten, bins = bin_list)
    plt.savefig(save_path+str(layer_num)+'_hist.png')
    plt.close()





