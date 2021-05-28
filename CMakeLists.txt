cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(TensorFlowPredict LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/CMake)


# Change to your path
SET(OpenCV_DIR "O:/OpenCV/OpenCV-2.4.11_vs14_x64/build" CACHE PATH "OpenCV directory")

# The most recent version I tested is TensorFlow 1.10.0 with CUDA 9.0 or 10.0 in Release
# TensorFLow stop supporting CMakeList after version 1.10.0
# Need to include both build directory and the install directory
# Change to your path
SET(TENSORFLOW_DIR "O:/tensorflow/tensorflow-1.10.0-gpu" CACHE PATH "TensorFlow directory")
SET(TENSORFLOW_INSTALL_DIR "O:/tensorflow/tensorflow-1.10.0-gpu-install" CACHE PATH "TensorFlow install directory")


#Use OpenCV to help the data management
find_package(OpenCV REQUIRED)

#I write a decent FindTensorFlow for it, not beautiful, but works
find_package(TensorFlow REQUIRED)
include_directories(${TENSORFLOW_INCLUDE_DIR})



set(SOURCE_FILES  TensorFlowPredict.cpp)

add_executable(TensorFlowPredict ${SOURCE_FILES})

target_link_libraries(TensorFlowPredict ${OpenCV_LIBS})
target_link_libraries(TensorFlowPredict ${TENSORFLOW_LIBRARIES})


set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)