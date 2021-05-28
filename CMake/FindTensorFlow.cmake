# A decent FindTensorFlow.cmake
# Need to build TensorFlow 1.10.0 with CUDA 9 or 10 in release. Unable to build in debug

IF(NOT EXISTS ${TENSORFLOW_DIR})
	find_package(TENSORFLOW QUIET NO_MODULE)
	mark_as_advanced(TENSORFLOW_DIR)
ENDIF()

IF( EXISTS ${TENSORFLOW_DIR})
	SET(TENSORFLOW_FOUND 1)
	SET(TENSORFLOW_BINARY_DIR ${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/Release)
	
	#Include extra headers ref:https://joe-antognini.github.io/machine-learning/windows-tf-project
	SET(TENSORFLOW_INCLUDE_DIR "${TENSORFLOW_DIR};${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/external/eigen_archive;${TENSORFLOW_DIR}/third_party/eigen3;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/protobuf/src/protobuf/src;${TENSORFLOW_INSTALL_DIR}$/include")
	
	
	SET(TENSORFLOW_LIBRARY_DIR 
	"${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/protobuf/src/protobuf/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_cc.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_cc_ops.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_cc_framework.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_cpu.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_direct_session.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_framework.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_kernels.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_lib.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_ops.dir/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/Release;
	${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build")
	
	
	SET(TENSORFLOW_LIBRARIES "${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/Release/tensorflow.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/zlib/install/lib/zlibstatic.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/gif/install/lib/giflib.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/png/install/lib/libpng16_static.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/jpeg/install/lib/libjpeg.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/lmdb/install/lib/lmdb.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/jsoncpp/src/jsoncpp/src/lib_json/Release/jsoncpp.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/farmhash/install/lib/farmhash.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/fft2d/src/lib/fft2d.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/highwayhash/install/lib/highwayhash.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/protobuf/src/protobuf/Release/libprotobuf.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/Release/tf_protos_cc.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_cc.dir/Release/tf_cc.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_cc_ops.dir/Release/tf_cc_ops.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_cc_framework.dir/Release/tf_cc_framework.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_cpu.dir/Release/tf_core_cpu.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_direct_session.dir/Release/tf_core_direct_session.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_framework.dir/Release/tf_core_framework.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_kernels.dir/Release/tf_core_kernels.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_lib.dir/Release/tf_core_lib.lib;${TENSORFLOW_DIR}/tensorflow/contrib/cmake/build/tf_core_ops.dir/Release/tf_core_ops.lib")
 
	
ELSEIF(TENSORFLOW_FIND_REQUIRED)
	MESSAGE(FATAL_ERROR  "TENSORFLOW NOT FOUND")
ELSE()
	MESSAGE(WARNING "TENSORFLOW NOT FOUND")
ENDIF()
