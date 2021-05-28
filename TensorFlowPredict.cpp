//In this example, I load a Deeplab v3+ model after freezing and optimzation in Python
//Predict on an input image with TensorFlow and CUDA 10 in C++

#pragma once
#define COMPILER_MSVC
#define NOMINMAX

#include <chrono>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <stdlib.h>


//Include TensorFlow headers
#include "tensorflow/core/platform/env.h"
#include "tensorflow/core/public/session.h"

typedef std::vector<std::pair<std::string, tensorflow::Tensor>> tensor_dict;

int main()
{
	tensorflow::Status status;

	std::string delimiter = ".";
	std::string ofilename;
	std::vector<tensorflow::Tensor> outputs;
	
	//You need an image to predict
	std::string imgpath("D:\\Workspace\\TensorFlowPredict-Build\\bin\\Release\\test.png");
	//A model you trained and exported from Python 
	std::string mdlpath("D:\\Workspace\\TensorFlowPredict-Build\\bin\\Release\\optimized_graph_500_500.pb");

	//Need a tensorflow session and a Graph
	std::unique_ptr<tensorflow::Session> session(tensorflow::NewSession({}));
	tensorflow::GraphDef graph;

	//read model file
	status = ReadBinaryProto(tensorflow::Env::Default(), mdlpath, &graph);


	//check wheter the model has been loaded correctly
	if (!status.ok()) {
		std::cout << status.ToString() << "\n";
		return -1;
	}

	//add graph to scope
	status = session->Create(graph);
	if (!status.ok()) {
		std::cout << status.ToString() << "\n";
		return -1;
	}


	//Read image with OpenCV
	cv::Mat frame;
	frame = cv::imread(imgpath);
	
	//Handel the Tensorflow image channel order
	//wrong order will result to wrong prediction mask
	cvtColor(frame, frame, CV_BGR2RGB);
	
	//Set input and case data to TensorFlow
	tensorflow::Tensor inputs(tensorflow::DT_UINT8, tensorflow::TensorShape({ 1,frame.rows,frame.cols,3 }));
	uint8_t *p = inputs.flat<tensorflow::uint8>().data();
	
	//According to the data format you specified when you save the model,
	//You also need to handle the input data type carefully
	cv::Mat cameraImg(frame.rows, frame.cols, CV_8UC3, p);
	frame.convertTo(cameraImg, CV_8UC3);


	std::cout << "input dimension of the image: " << inputs.DebugString() << "\n";

	//get the appropriate input and out layer names from the graph/mode to execute
	//They need to agree with the names you specified when you output the model in Python
	auto inputlayer = "ImageTensor";
	auto outputlayer = "SemanticPredictions";

	std::cout << "Input layer name: " << inputlayer << "\n";
	std::cout << "Output layer name: " << outputlayer << "\n";
	
	//We run it 20 times to measure the speed
	//The first run will take several seconds because TensorFlow needs warm upper_bound
	//From the second time, it will be very fast
	for (int i=0;i<20;i++)
	{
		std::chrono::steady_clock::time_point session_begin = std::chrono::steady_clock::now();
		status = session->Run({ {inputlayer, inputs} }, { outputlayer }, {}, &outputs);
		std::chrono::steady_clock::time_point session_end = std::chrono::steady_clock::now();
		std::cout << "Session Time = " << std::chrono::duration_cast<std::chrono::microseconds>(session_end - session_begin).count() / 1000000.0 << " sec" << std::endl;
	}
	
	//Check any errors during the prediction
	if (!status.ok()) {
		LOG(ERROR) << status.ToString();
		return -1;
	}
	
	//Print some output image information
	std::cout << "Output dimension of the image" << outputs[0].DebugString() << "\n";

	//create filename
	ofilename.append(imgpath.substr(0, imgpath.find(delimiter)));
	ofilename.append("_mask.png");

	std::cout << "output filename: " << ofilename << "\n";

	//Now write this to a image file
	//Again use OpenCV to save image file, again need to handle the data type carefully
	//The data type of your output should be compatable with the cv::Mat format you use
	cv::Mat outMatrix(outputs[0].dim_size(1), outputs[0].dim_size(2), CV_32S, outputs[0].flat<tensorflow::int32>().data());

	//The model I trained has two classes: 1 for front device and 0 for background
	//Therefore, it is mapped to 0-255 for visualization
	cv::imwrite(ofilename, 255 * outMatrix);
	
	
	//End TensorFlow session, free memory
	session->Close();
	return 0;
}