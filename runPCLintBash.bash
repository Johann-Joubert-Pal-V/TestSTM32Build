#!/bin/bash

echo "set PC-LINT configuration"

#PC LINT CONFIGURATION
export PC_LINT_LOC=/opt/PC-LINT/config
export PC_LINT_LNT_LOC=/opt/PC-LINT/lnt
#export PC_LINT_PROJECT_CONFIG=./project_config.lnt
export PC_LINT_PROJECT_CONFIG=$PWD/$1/$2/project_config.lnt

#Temporary filename for imposter log
export IMPOSTER_LOG=$PWD/$1/$2/imposter_log.txt
export PC_LINT_ANALYSIS_FILE=$PWD/$1/$2/analysis.log

#Add  ARM compiler to path
export PATH=$PATH:/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.9-2020-q2-update.linux64_2.0.0.202105311346/tools/bin

current_path=$PWD
echo "Current Path: "$current_path

echo $PATH


echo "PC_LINT_LOC: "$PC_LINT_LOC
echo "PC_LINT_PROJECT_CONFIG: "$PC_LINT_PROJECT_CONFIG
echo "$IMPOSTER_LOG: "$IMPOSTER_LOG
echo "$PC_LINT_ANALYSIS_FILE: "$PC_LINT_ANALYSIS_FILE

echo "commandline paramters"
echo "Project : "$1
echo "Output configuration : "$2
echo "Target : "$3

#generate makefiles for Debug
#TODO add to system path that there is no hardcoded STM32CubeIDE version number
/opt/st/stm32cubeide_1.8.0/stm32cubeide -nosplash --launcher.suppressErrors  -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data . -cleanBuild $1/Debug -E PATH=$PATH -E CC=gcc -E PostBuildCMD="../../SW-PAL-Vtune/SW-PAL-Vtune/postbuild/postbuild.bash $1 $1 $2" -markerType cdt


#switch to Configuration (Debug/Release) output folder of supplied project and configuration 
cd $1/$2/


#cleanup files
rm $PC_LINT_PROJECT_CONFIG
rm $PC_LINT_ANALYSIS_FILE
rm $IMPOSTER_LOG
rm $COVFILE
rm $IMPOSTER_LOG
#del %PROJECT_CONFIG%

pipenv run pip3 install regex
pipenv run pip3 install pyyaml

#Generate PC-LINT compiler configuration
#pipenv run $PC_LINT_LOC/pclp_config.py --compiler=gcc --compiler-bin=/usr/bin/gcc --config-output-lnt-file=co-gcc.lnt --config-output-header-file=co-gcc.h --generate-compiler-config
pipenv run $PC_LINT_LOC/pclp_config.py --compiler=gcc --compiler-bin=arm-none-eabi-gcc --config-output-lnt-file=co-gcc.lnt --config-output-header-file=co-gcc.h --generate-compiler-config
#Compile PC-LINT imposter compiler
gcc $PC_LINT_LOC/imposter.c -o imposter 

#change the arm-non-eabi-gcc variable to CC to enable swapping of the compiler.
echo "========== CURRENTLY EDITING MAKEFILE BUILD WON'T WORK AFTERWARDS, IF NEEDED BUILD WITH -e CC=arm-none-eabi-gcc ========== "
files=($(find . -type f -name "subdir.mk"))
for item in ${files[*]}
do
  printf "   %s\n" $item
  sed -i 's/arm-none-eabi-gcc/$(CC)/g' $item
done

sed -i 's/arm-none-eabi-gcc/$(CC)/g' makefile


make clean
#make -e CC=$PC_LINT_LOC/imposter -B TestSTM32CubeGcc
#Use PC-LINT imposter compiler to compile project
#make -e "CC=./imposter -DSTM32F303xC -DUSE_HAL_DRIVER -DPROJECT_NAME="DUMMY" -DBUILD_DATE="DUMMY" -DBUILD_MACHINE="DUMMY" -DBUILD_USER="DUMMY" -DGIT_TAG="DUMMY" -DGIT_BRANCH="DUMMY" -DGIT_COMMIT="DUMMY"" -B $3
make -e "CC=./imposter -DSTM32F303xC -DUSE_HAL_DRIVER" -B $3

#Generate the PC-LINT project configuration
pipenv run $PC_LINT_LOC/pclp_config.py --compiler=gcc --imposter-file=$IMPOSTER_LOG --config-output-lnt-file=$PC_LINT_PROJECT_CONFIG --generate-project-config
#Use the PC-LINT compiler, jenkins and project configuration to LINT the project files
#/opt/PC-LINT/pclp64_linux -os=$PC_LINT_ANALYSIS_FILE co-gcc.lnt ../../PAL-V-std_Jenkins.lnt ../../projTestSTM32CubeMCU_Jenkins.lnt ../../loptions.lnt ../../env-jenkins.lnt %PC_LINT_PROJECT_CONFIG%
/opt/PC-LINT/pclp64_linux -os=$PC_LINT_ANALYSIS_FILE co-gcc.lnt ../../PAL-V-std_Jenkins.lnt ../projSW-MainPowerUnit_Jenkins.lnt ../../env-jenkins.lnt %PC_LINT_PROJECT_CONFIG%


cd $current_path