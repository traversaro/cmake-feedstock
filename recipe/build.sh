#!/bin/sh
set -ex

CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_FIND_ROOT_PATH=${PREFIX} -DCMAKE_INSTALL_RPATH=${PREFIX}/lib"
CMAKE_ARGS="$CMAKE_ARGS -DCURSES_INCLUDE_PATH=${PREFIX}/include -DBUILD_CursesDialog=ON -DCMake_HAVE_CXX_MAKE_UNIQUE:INTERNAL=FALSE"
CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_PREFIX_PATH=${PREFIX}"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
   cmake ${CMAKE_ARGS} \
       -DCMAKE_VERBOSE_MAKEFILE=1 \
       -DCMAKE_INSTALL_PREFIX=$PREFIX \
       -DCMAKE_USE_SYSTEM_LIBRARIES=ON \
       -DBUILD_QtDialog=OFF \
       -DCMAKE_USE_SYSTEM_LIBRARY_LIBARCHIVE=OFF \
       -DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=OFF \
       .
else
  ./bootstrap \
       --verbose \
       --prefix="${PREFIX}" \
       --system-libs \
       --no-qt-gui \
       --no-system-libarchive \
       --no-system-jsoncpp \
       --parallel=${CPU_COUNT} \
       -- \
       ${CMAKE_ARGS}
fi

# CMake automatically selects the highest C++ standard available

make install -j${CPU_COUNT}

