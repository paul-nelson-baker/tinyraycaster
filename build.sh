#!/usr/bin/env bash
set -e
BUILD_DIR="build"
BUILD_BIN="tinyraycaster"

# If the build already exists, then run it. If the exit code is non-0, the
# script will terminate and bubble the exit code up (See 'set -e')
# We terminate the script with exit 0, when the app closes normally
if [ -f "${BUILD_DIR}/${BUILD_BIN}" ]; then
  "./${BUILD_DIR}/${BUILD_BIN}"
  exit 0
fi

# Take care of dependencies
if [ "$(uname)" == "Darwin" ]; then
  if brew help >/dev/null && ! brew list sdl2 >/dev/null 2>&1 ; then
    brew install sdl2
  fi
elif [ "$(uname)" == "Linux" ]; then
  # Ubuntu/Debian
  if [ -f /etc/lsb-release ] && ! dpkg -l libsdl2-dev >/dev/null ; then
      sudo apt install -y libsdl2-dev
  fi
fi

# Build the project and run it
if [ ! -d "${BUILD_DIR}" ]; then
  mkdir "${BUILD_DIR}"
fi
cd "${BUILD_DIR}"
cmake ..
make
"./${BUILD_BIN}"
