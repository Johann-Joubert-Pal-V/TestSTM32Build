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
echo "Project name : "$1
echo "Configuration name : "$2


#switch to UnitTesting output folder of supplied project and configuration -> could hardcode UnitTesting in path.
cd $1/$2/


#cleanup files
rm $PC_LINT_PROJECT_CONFIG
rm $PC_LINT_ANALYSIS_FILE
rm $IMPOSTER_LOG
rm $COVFILE
rm $IMPOSTER_LOG
#del %PROJECT_CONFIG%

rm -rf /s /q %COV_HTML_OUTPUT%

$BULLSEYE_LOC/cov01 --on
make -e CC="$BULLSEYE_LOC/covc -i $BULLSEYE_LOC/gcc" -B $1
./$1 xml out
$BULLSEYE_LOC/cov01 --off
#$BULLSEYE_LOC/covselect --file "%COVFILE%" --add '!../CUnit/src/'
$BULLSEYE_LOC/covselect --file "%COVFILE%" --add '!../Test/'
$BULLSEYE_LOC/covselect --file "%COVFILE%" --add '!/var/jenkins_home/workspace/UnitTest_Demo/TestSTM32CubeMCU/CUnit/src/'
$BULLSEYE_LOC/covselect --file "%COVFILE%" --list
echo START BULLSEYE HTML REPORT
/opt/bullshtml/bullshtml -f $COVFILE cov_html_output
echo STOP BULLSEYE HTML REPORT
