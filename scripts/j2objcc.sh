#!/bin/bash
# Copyright 2011 Google Inc.  All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# A convenience wrapper for compiling files translated by j2objc using Clang.
# The JRE emulation and proto wrapper library include and library paths are
# added, as well as standard Clang flags for compiling and linking Objective-C
# applications on iOS.
#
# Usage:
#   j2objcc <clang options> <files>
#

if [ -L "$0" ]; then
  readonly DIR=$(dirname $(readlink "$0"))
else
  readonly DIR=$(dirname "$0")
fi

readonly INCLUDE_PATH=${DIR}/include
readonly LIB_PATH=${DIR}/lib

declare CC_FLAGS="-Werror -Wno-parentheses -Wno-objc-string-compare"
declare OBJC=-ObjC
declare LIBS="-ljre_emul -licucore -lstdc++"
declare LINK_FLAGS="${LIBS} -framework Foundation -framework ExceptionHandling -L ${LIB_PATH}"

for arg; do
  case $arg in
    # Check whether linking is disabled by a -c, -S, or -E option.
    -[cSE]) LINK_FLAGS="" ;;
    # Check whether we need to build for C++ instead of C.
    objective-c\+\+) CC_FLAGS="${CC_FLAGS} -std=gnu++98" OBJC= ;;
  esac
done

xcrun clang $* -I ${INCLUDE_PATH} ${CC_FLAGS} ${OBJC} ${LINK_FLAGS}
