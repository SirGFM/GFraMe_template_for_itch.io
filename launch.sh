#!/bin/bash

# TODO Assign the name of the game binary
# NOTE: There should be a ${GAME}_x64 and a ${GAME}_x86
GAME=
# TODO Assign the path to the log file
LOG_PATH=

# This variable will be appended to LD_LIBRARY_PATH
LIBS=

DIR=`dirname "$0"`
cd "${DIR}"

# Clean the previous launch details
echo "" > "${DIR}"/.last_launch

# Getting path to libs and game
if [ $(uname -m) == "x86_64" ]; then
    echo "Running 64 bit version"
    echo "Running 64 bit version" >> "${DIR}"/.last_launch

    LIB_DIR="${DIR}"/lib64/
    BIN="${DIR}"/game/${GAME}_x64
else
    echo "Running 32 bit version"
    echo "Running 32 bit version" >> "${DIR}"/.last_launch

    LIB_DIR="${DIR}"/lib32
    BIN="${DIR}"/game/${GAME}_x86
fi

# Check which lib is installed and which should be used from the package
ldconfig -p | grep libGFraMe > /dev/null
if [ $? -ne 0 ]; then
    echo "Using libGFraMe from package..."
    echo "Using libGFraMe from package..." >> "${DIR}"/.last_launch

    LIBS="${LIB_DIR}"/gframe/
fi

ldconfig -p | grep libCSynth > /dev/null
if [ $? -ne 0 ]; then
    echo "Using libCSynth from package..."
    echo "Using libCSynth from package..." >> "${DIR}"/.last_launch

    if [ -z "${LIBS}" ]; then
        LIBS="${LIB_DIR}"/c_synth/
    else
        LIBS="${LIBS}":"${LIB_DIR}"/c_synth/
    fi
fi

ldconfig -p | grep libSDL2 > /dev/null
if [ $? -ne 0 ]; then
    echo "Using libSDL2 from package..."
    echo "Using libSDL2 from package..." >> "${DIR}"/.last_launch

    if [ -z "${LIBS}" ]; then
        LIBS="${LIB_DIR}"/sdl2/
    else
        LIBS="${LIBS}":"${LIB_DIR}"/sdl2/
    fi
fi

# Run the game
if [ ! -z "${LIBS}" ]; then
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${LIBS}"
fi

"${BIN}"

RV=$?
if [ ${RV} -ne 0 ]; then
    echo "Game exited with error ${RV}"
    echo "Game exited with error ${RV}" >> "${DIR}"/.last_launch

    echo "If it happened while playing, this log might be useful:"
    echo "If it happened while playing, this log might be useful:" >> "${DIR}"/.last_launch
    echo "    ${LOG_PATH}"
    echo "    ${LOG_PATH}" >> "${DIR}"/.last_launch

    echo ""
    echo "" >> "${DIR}"/.last_launch

    echo "Dependencies:"
    echo "Dependencies:" >> "${DIR}"/.last_launch
    echo "SDL (>=2.0.3):"
    echo "SDL (>=2.0.3):" >> "${DIR}"/.last_launch
    echo "    https://www.libsdl.org/release/SDL2-2.0.3.tar.gz"
    echo "    https://www.libsdl.org/release/SDL2-2.0.3.tar.gz" >> "${DIR}"/.last_launch
    echo "libCSynth (master, v1.0.2):"
    echo "libCSynth (master, v1.0.2):" >> "${DIR}"/.last_launch
    echo "    https://github.com/SirGFM/c_synth"
    echo "    https://github.com/SirGFM/c_synth" >> "${DIR}"/.last_launch
    echo "libGFraMe (master, v2.1.0):"
    echo "libGFraMe (master, v2.1.0):" >> "${DIR}"/.last_launch
    echo "    https://github.com/SirGFM/GFraMe"
    echo "    https://github.com/SirGFM/GFraMe" >> "${DIR}"/.last_launch

    echo ""
    echo "" >> "${DIR}"/.last_launch

    echo "Those libs were packaged with the game on ${LIB_DIR}"
    echo "Those libs were packaged with the game on ${LIB_DIR}" >> "${DIR}"/.last_launch
else
    echo "Game should have run successfully!"
    echo "Game should have run successfully!" >> "${DIR}"/.last_launch
fi

