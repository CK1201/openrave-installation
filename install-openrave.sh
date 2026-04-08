#!/bin/bash
#
# Authors:
#   Francisco Suarez <fsuarez6.github.io>
#
# Description:
#   OpenRAVE Installation Script

# Check ubuntu version
UBUNTU_VER=$(lsb_release -sr)
if [ ${UBUNTU_VER} != '14.04' ] && [ ${UBUNTU_VER} != '16.04' ] && [ ${UBUNTU_VER} != '18.04' ] \
  && [ ${UBUNTU_VER} != '20.04' ] && [ ${UBUNTU_VER} != '24.04' ]; then
    echo "ERROR: Unsupported Ubuntu version: ${UBUNTU_VER}"
    echo "  Supported versions are: 14.04, 16.04, 18.04, 20.04, and 24.04"
    exit 1
fi

if [ ${UBUNTU_VER} != '24.04' ]; then
  # Sympy version 0.7.1
  echo ""
  echo "Downgrading sympy to version 0.7.1..."
  echo ""
  pip install --upgrade --user sympy==0.7.1
fi

# OpenRAVE
if [ ${UBUNTU_VER} = '14.04' ] || [ ${UBUNTU_VER} = '16.04' ]; then
	RAVE_COMMIT=7c5f5e27eec2b2ef10aa63fbc519a998c276f908
	echo ""
	echo "Installing OpenRAVE 0.9 from source (Commit ${RAVE_COMMIT})..."
	echo ""
	mkdir -p ~/git; cd ~/git
	git clone https://github.com/rdiankov/openrave.git
elif [ ${UBUNTU_VER} = '18.04' ] || [ ${UBUNTU_VER} = '20.04' ]; then
	RAVE_COMMIT=2024b03554c8dd0e82ec1c48ae1eb6ed37d0aa6e
	echo ""
	echo "Installing OpenRAVE 0.53.1 from source (Commit ${RAVE_COMMIT})..."
	echo ""
	mkdir -p ~/git; cd ~/git
	git clone -b production https://github.com/rdiankov/openrave.git
elif [ ${UBUNTU_VER} = '24.04' ]; then
	RAVE_COMMIT=b4154086688f7b6d4b17f33bb344f89cfc801d61
	echo ""
	echo "Installing OpenRAVE from production branch for Ubuntu 24.04 (Commit ${RAVE_COMMIT})..."
	echo ""
	mkdir -p ~/git; cd ~/git
	git clone -b production https://github.com/rdiankov/openrave.git
fi
cd openrave; git reset --hard ${RAVE_COMMIT}
if [ ${UBUNTU_VER} = '24.04' ]; then
	# Ubuntu 24.04 ships RapidJSON with the two-argument CopyFrom overload.
	sed -i \
		-e 's/CopyFrom(_docGripperInfo, allocator, true)/CopyFrom(_docGripperInfo, allocator)/' \
		-e 's/CopyFrom(_docGripperInfo, docGripperInfo.GetAllocator(), true)/CopyFrom(_docGripperInfo, docGripperInfo.GetAllocator())/' \
		-e 's/CopyFrom(_docSensorGeometry, allocator, true)/CopyFrom(_docSensorGeometry, allocator)/' \
		src/libopenrave/robot.cpp
fi
mkdir build; cd build
if [ ${UBUNTU_VER} = '14.04' ] || [ ${UBUNTU_VER} = '16.04' ]; then
  	cmake -DODE_USE_MULTITHREAD=ON -DOSG_DIR=/usr/local/lib64/ ..
elif [ ${UBUNTU_VER} = '18.04' ] || [ ${UBUNTU_VER} = '20.04' ]; then
  	cmake -DODE_USE_MULTITHREAD=ON -DOSG_DIR=/usr/local/lib64/ \
  		-DUSE_PYBIND11_PYTHON_BINDINGS:BOOL=TRUE 			   \
  		-DBoost_NO_BOOST_CMAKE=1 ..
elif [ ${UBUNTU_VER} = '24.04' ]; then
  	cmake -DODE_USE_MULTITHREAD=ON -DOPT_PYTHON=OFF -DOPT_PYTHON3=ON \
  		-DOPT_BULLET=OFF -DOPT_FCL_COLLISION=OFF ..
fi
make -j `nproc`
sudo make install
if [ ${UBUNTU_VER} = '24.04' ]; then
	PYTHON3_SITE_DIR=$(python3 -c 'import sysconfig; print(sysconfig.get_path("platlib"))')
	if [ "${PYTHON3_SITE_DIR}" != "/usr/local/lib/python3/dist-packages" ]; then
		echo "/usr/local/lib/python3/dist-packages" | sudo tee "${PYTHON3_SITE_DIR}/openravepy-local.pth" >/dev/null
	fi
fi
