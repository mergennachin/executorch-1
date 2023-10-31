#!/bin/bash
# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

# Links the path of python3 include directory to a buck2 out directory.

set -e

# "-I/path/to/include -I/path/to/include" -> "/path/to/include"
INCLUDE=$(python3-config --includes | cut -d' ' -f1 | sed -r 's/^.{2}//')

ln -s "$INCLUDE" "$1"/include

# find libpython3.10.so/.dylib
LIB_DIR=$(python -c 'from distutils import sysconfig; print(sysconfig.get_config_var("LIBDIR"))')
LIB=$(ls -d -1 $LIB_DIR/libpython* | head -n 1)

ln -s "$LIB" "$1"/"$2"
