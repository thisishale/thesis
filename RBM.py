
# coding: utf-8

# In[4]:


import numpy as np
import pandas as pd
import msgpack
import glob
import tensorflow as tf
from tensorflow.python.ops import control_flow_ops
from tqdm import tqdm
import h5py
I=0
def da(batch_size, layer_num, weights, biases, dat_len, file_name, f_name):
    global I    
    for I in range(0,dat_len-batch_size,batch_size):
        h5f = h5py.File(file_name,'r')
        Data = h5f[f_name][I:I+batch_size]
        h5f.close()
        for j in range(layer_num):
            #print(weights[j].shape)
            #print(biases[j].shape)
            Data = np.matmul(Data,weights[j])+biases[j]
        yield(Data)
def rbm_layer(n_visible, n_hidden, num_epochs, batch_size, lr, ws, bs, layer_n, len_data, name, data_name):
    ### HyperParameters
    # First, let's take a look at the hyperparameters of our model:

#     n_visible      = 1799 #This is the size of the visible layer. 
#     n_hidden       = 50 #This is the size of the hidden layer

#     num_epochs = 20 #The number of training epochs that we are going to run. For each epoch we go through the entire data set.
#     batch_size = 128 #The number of training examples that we are going to send through the RBM at a time. 
#     lr         = tf.constant(0.0005, tf.float32) #The learning rate of our model

    ### Variables:
    # Next, let's look at the variables we're going to use:

    x  = tf.placeholder(tf.float32, [None, n_visible], name="x") #The placeholder variable that holds our data
    W  = tf.Variable(tf.random_normal([n_visible, n_hidden], 0.01), name="W") #The weight matrix that stores the edge weights
    bh = tf.Variable(tf.zeros([1, n_hidden],  tf.float32, name="bh")) #The bias vector for the hidden layer
    bv = tf.Variable(tf.zeros([1, n_visible],  tf.float32, name="bv")) #The bias vector for the visible layer


    #### Helper functions. 

    #This function lets us easily sample from a vector of probabilities
    def sample(probs):
        #Takes in a vector of probabilities, and returns a random vector of 0s and 1s sampled from the input vector
        return tf.floor(probs + tf.random_uniform(tf.shape(probs), 0, 1))


    #This function runs the gibbs chain. We will call this function in two places:
    #    - When we define the training update step
    #    - When we sample our music segments from the trained RBM
    def gibbs_sample(k):
        #Runs a k-step gibbs chain to sample from the probability distribution of the RBM defined by W, bh, bv
        def gibbs_step(count, k, xk):
            #Runs a single gibbs step. The visible values are initialized to xk
            hk = sample(tf.sigmoid(tf.matmul(xk, W) + bh)) #Propagate the visible values to sample the hidden values
            #xk = sample(tf.sigmoid(tf.matmul(hk, tf.transpose(W)) + bv)) #Propagate the hidden values to sample the visible values
            #hk = sample(tf.matmul(xk, W) + bh)
            #xk = sample(tf.matmul(hk, tf.transpose(W)) + bv)
            #hk = sample(tf.sigmoid(tf.matmul(xk, W) + bh))
            xk = sample(tf.truncated_normal((1,n_visible),tf.matmul(hk, tf.transpose(W)) + bv,1))
            return count+1, k, xk

        #Run gibbs steps for k iterations
        ct = tf.constant(0) #counter
        [_, _, x_sample] = control_flow_ops.while_loop(lambda count, num_iter, *args: count < num_iter,
                                             gibbs_step, [ct, tf.constant(k), x], back_prop = False)
        #This is not strictly necessary in this implementation, but if you want to adapt this code to use one of TensorFlow's
        #optimizers, you need this in order to stop tensorflow from propagating gradients back through the gibbs step
        x_sample = tf.stop_gradient(x_sample) 
        return x_sample


    ### Training Update Code
    # Now we implement the contrastive divergence algorithm. First, we get the samples of x and h from the probability distribution
    #The sample of x
    x_sample = gibbs_sample(1) 
    #The sample of the hidden nodes, starting from the visible state of x
    h = sample(tf.sigmoid(tf.matmul(x, W) + bh)) 
    #The sample of the hidden nodes, starting from the visible state of x_sample
    h_sample = sample(tf.sigmoid(tf.matmul(x_sample, W) + bh)) 

    #Next, we update the values of W, bh, and bv, based on the difference between the samples that we drew and the original values
    size_bt = tf.cast(tf.shape(x)[0], tf.float32)
    W_adder  = tf.multiply(lr/size_bt, tf.subtract(tf.matmul(tf.transpose(x), h), tf.matmul(tf.transpose(x_sample), h_sample)))
    bv_adder = tf.multiply(lr/size_bt, tf.reduce_sum(tf.subtract(x, x_sample), 0, True))
    bh_adder = tf.multiply(lr/size_bt, tf.reduce_sum(tf.subtract(h, h_sample), 0, True))
    #When we do sess.run(updt), TensorFlow will run all 3 update steps
    updt = [W.assign_add(W_adder), bv.assign_add(bv_adder), bh.assign_add(bh_adder)]



    ### Run the graph!
    # Now it's time to start a session and run the graph! 

    with tf.Session() as sess:
        #First, we train the model
        #initialize the variables of the model
        init = tf.initialize_all_variables()
        sess.run(init)
        #Run through all of the training data num_epochs times
        for epoch in tqdm(range(num_epochs)):
            #Train the RBM on batch_size examples at a time
            for X_batch in da(batch_size, layer_n, ws, bs, len_data, name, data_name):
                feed_dict = {x: X_batch} 
                var1 = sess.run(updt, feed_dict)
    return var1



