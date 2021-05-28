# TensorFlow C++ Prediction on GPU with CUDA and CMake on Windows
**TensorFlowPredict** is an example to show how can you use CMake to run TensorFlow Prediction in C++ on the GPU with your pre-trained model in Python.

* While this repository only described the CMake and Prediction codes, the difficult parts are:
1. Build TensorFlow with CUDA and CMake.
2. Link TensorFlow as an external library for your project.
3. Export a compatible model for TensorFlow C++ API.

## How to build TensorFlow C++ with CUDA in CMake
1. The latest TensorFlow version I build successfully is 1.10.0 with CUDA 9.0 and 10.0. Because Google decided to use their own Bazel and stop supporting CMake. Therefore, it will be difficult to build a new TensorFlow version.
2. Only "Release" configuration can be built. No "Debug" configuration.
3. When building TensorFlow, you also need to build the "Install". The install path can be modified from CMake.
4. The article 	[Building a standalone C++ Tensorflow program on Windows](https://joe-antognini.github.io/machine-learning/windows-tf-project) gives some insight about how you can build a static C++ Tensorflow library on Windows. But, more changes are needed.


## How to link TensorFlow as an external library for your project in CMake
1. Make sure you have built TensorFlow in Release including the "Install" group.
2. You can reuse my FindTensorFlow.cmake after modifying the TensorFlow path in CMakeList.


## How to get a compatible model for TensorFlow C++ API
1. When training a model in Python, you can use a different TensorFlow version to get better performance. However, you need to use the same version of your TensorFlow C++ API when you freeze and export the model.
2. Optimize the model with the TensorFLow "transorm_graph" project you build in C++ with CMake. Make sure the input and output layer names are agreed with later prediction codes. The following picture gives an example.

<img src="../master/Data/Example.png?raw=true" width="600" >

## An example of TensorFlowPredict Project
* We use semantic segmentation as an example. The model is trained by DeepLav v3+ in Python. I used a pre-trained model on VOC2012 dataset as the starting checkpoint. The last layer is changed to apply a transfer learning on a new dataset with two classes: 1 for foreground device and 0 for background. The weights of different classes are modified accordingly to achieve better MIOU result.

* The pre-trained model is not uploaded to the repository. See [optimized_graph_500_500.pb](https://drive.google.com/file/d/1m1EtdutciAbcgHDLsoCeKI92I-VEs_4K/view?usp=sharing)


*We run 20 times on the input image to measure the average performance of TensorFlow Prediction on the GPU. The code is tested on a computer with a GeForce GTX 1080 GPU.
The first run is slow (7.579 sec) because TensorFlow session needs a warmup period. From the second run, the prediction will become faster (0.05 sec).*

<img src="../master/Data/test.png?raw=true" width="400" height="400">

*The input image and predicted output mask. The same input image will always produce the same prediction mask because the model has been frozen*

<img src="../media/images/test_mask.png?raw=true" width="400" height="400">


