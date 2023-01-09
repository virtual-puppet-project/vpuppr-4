#!/bin/bash

GODOT_CPP_BUILT_FILE=".godot-cpp-built"

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo ""
echo "################################################################################"
echo "# Starting build                                                               #"
echo "################################################################################"
echo ""

echo "Moving to gdextension directory"

cd "$SCRIPT_DIR/gdextension"

if [ ! -f "$GODOT_CPP_BUILT_FILE" ]; then
	echo ""
	echo "################################################################################"
	echo "# godot-cpp first time build                                                   #"
	echo "################################################################################"
	echo ""

	cd godot-cpp

	scons target=editor generate_bindings=yes

	cd ..

	touch "$GODOT_CPP_BUILT_FILE" 

	echo ""
	echo "Wrote temp file"
	echo ""
fi

echo ""
echo "################################################################################"
echo "# Building GDExtenion                                                          #"
echo "################################################################################"
echo ""

scons target=editor

echo ""
echo "################################################################################"
echo "# Finished                                                                     #"
echo "################################################################################"
echo ""

