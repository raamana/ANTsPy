#!/bin/bash

# make this where you want to build ITK

CXX_STD=CXX11
JTHREADS=2
if [[ `uname` -eq Darwin ]] ; then
  CMAKE_BUILD_TYPE=Release
fi
if [[ $TRAVIS -eq true ]] ; then
  CMAKE_BUILD_TYPE=Release
  JTHREADS=2
fi

#mkdir $HOME/itkbuild-linux;

#cd /home/travis/
cd $TRAVIS_BUILD_DIR

itkgit=https://github.com/InsightSoftwareConsortium/ITK.git
# itktag=2714cc1805f50504f5b9a60d0f62ffec8e73989 # 4.11
itktag=c5138560409c75408ff76bccff938f21e5dcafc6 #4.12
# if ther is a directory but no git,
# remove it

# if no directory, clone ITK in `itksource-linux` dir
git clone $itkgit itksource-linux;
cd itksource-linux;
git checkout master;
git checkout $itktag;
cd ../

mkdir itkbuild-linux
cd itkbuild-linux
compflags=" -fPIC -O2  "
cmake \
    -DCMAKE_BUILD_TYPE:STRING="${CMAKE_BUILD_TYPE}" \
    -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} -Wno-c++11-long-long -fPIC -O2 -DNDEBUG  "\
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -Wno-c++11-long-long -fPIC -O2 -DNDEBUG  "\
    -DITK_USE_GIT_PROTOCOL:BOOL=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=${R_PACKAGE_DIR}/libs/  \
    -DITK_LEGACY_REMOVE:BOOL=OFF  \
    -DITK_FUTURE_LEGACY_REMOVE:=BOOL=ON \
    -DITKV3_COMPATIBILITY:BOOL=ON \
    -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
    -DKWSYS_USE_MD5:BOOL=ON \
    -DITK_WRAPPING:BOOL=OFF \
    -DModule_MGHIO:BOOL=ON \
    -DModule_ITKDeprecated:BOOL=OFF \
    -DModule_ITKReview:BOOL=ON \
    -DModule_ITKVtkGlue:BOOL=ON \
    -D ITKGroup_Core=ON \
    -D Module_ITKReview=ON \
    -D ITKGroup_Filtering=ON \
    -D ITKGroup_IO=ON \
    -D ITKGroup_Numerics=ON \
    -D ITKGroup_Registration=ON \
    -D ITKGroup_Segmentation=ON \
    -DCMAKE_C_VISIBILITY_PRESET:BOOL=hidden \
    -DCMAKE_CXX_VISIBILITY_PRESET:BOOL=hidden \
    -DCMAKE_VISIBILITY_INLINES_HIDDEN:BOOL=ON ../itksource-linux/
make -j 3
#make install
cd ../


