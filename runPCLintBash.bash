#!/bin/bash

echo "set PC-LINT configuration"

#PC LINT CONFIGURATION
export PC_LINT_LOC=/opt/PC-LINT/config
export PC_LINT_LNT_LOC=/opt/PC-LINT/lnt
export PC_LINT_PROJECT_CONFIG=./project_config.lnt

#Temporary filename for imposter log
export IMPOSTER_LOG=./imposter_log.txt
export PC_LINT_ANALYSIS_FILE=./analysis.log

#Bullseye Configuration
export BULLSEYE_LOC=/opt/BullseyeCoverage/bin
export COVFILE=Test.cov
export COV_HTML_OUTPUT=./cov_html_output
export PATH=$PATH:$BULLSEYE_LOC

echo $PATH


echo $PC_LINT_LOC
echo $PC_LINT_PROJECT_CONFIG
echo $IMPOSTER_LOG
echo $PC_LINT_ANALYSIS_FILE

echo "commandline paramters"
echo "Project : "$1
echo "Output configuration : "$2
echo "Target : "$3


#switch to Configuration (Debug/Release) output folder of supplied project and configuration 
cd $1/$2/


#cleanup files
rm $PC_LINT_PROJECT_CONFIG
rm $PC_LINT_ANALYSIS_FILE
rm $IMPOSTER_LOG
rm $COVFILE
rm $IMPOSTER_LOG
#del %PROJECT_CONFIG%

rm -rf /s /q %COV_HTML_OUTPUT%

pipenv run pip3 install regex
pipenv run pip3 install pyyaml

#Generate PC-LINT compiler configuration
pipenv run $PC_LINT_LOC/pclp_config.py --compiler=gcc --compiler-bin=/usr/bin/gcc --config-output-lnt-file=co-gcc.lnt --config-output-header-file=co-gcc.h --generate-compiler-config
#Compile PC-LINT imposter compiler
gcc $PC_LINT_LOC/imposter.c -o imposter 

#TODO would be better to make a copy and edit the file there
sed -i 's/arm-none-eabi-gcc/$(CC)/g' makefile Core/Src/subdir.mk Core/Startup/subdir.mk Drivers/STM32F3xx_HAL_Driver/Src/subdir.mk

make clean
#make -e CC=$PC_LINT_LOC/imposter -B TestSTM32CubeGcc
#Use PC-LINT imposter compiler to compile project
make -e CC=./imposter -B $3

#Generate the PC-LINT project configuration
pipenv run $PC_LINT_LOC/pclp_config.py --compiler=gcc --imposter-file=$IMPOSTER_LOG --config-output-lnt-file=$PC_LINT_PROJECT_CONFIG --generate-project-config
#Use the PC-LINT compiler, jenkins and project configuration to LINT the project files
#/opt/PC-LINT/pclp64_linux -max_threads=4 -os=$PC_LINT_ANALYSIS_FILE -vf co-gcc.lnt env-jenkins.lnt $PC_LINT_PROJECT_CONFIG $PC_LINT_LNT_LOC/au-misra3.lnt $PC_LINT_LNT_LOC/au-misra3-amd1.lnt $PC_LINT_LNT_LOC/au-misra3-amd2.lnt 
#/opt/PC-LINT/pclp64_linux -max_threads=4 -os=$PC_LINT_ANALYSIS_FILE co-gcc.lnt env-jenkins.lnt $PC_LINT_PROJECT_CONFIG

