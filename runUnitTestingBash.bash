#!/bin/bash

echo "set BullsEYE configuration"

export PATH=$PATH:/opt/st/stm32cubeide_1.8.0/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.9-2020-q2-update.linux64_2.0.0.202105311346/tools/bin

#Bullseye Configuration
export BULLSEYE_LOC=/opt/BullseyeCoverage/bin
export COVFILE=$PWD/$1/$2/Test.cov
export COV_HTML_OUTPUT=$PWD/$1/$2/cov_html_output
export PATH=$PATH:$BULLSEYE_LOC

echo $PATH

echo "BULLSEYE_LOC: "$BULLSEYE_LOC
echo "COVFILE: "$COVFILE
echo "COV_HTML_OUTPUT: "$COV_HTML_OUTPUT

echo "commandline paramters"
echo "Project name : "$1
echo "Configuration name : "$2


#switch to UnitTesting output folder of supplied project and configuration -> could hardcode UnitTesting in path.
#cd $1/$2/


#cleanup files
rm $COVFILE
#del %PROJECT_CONFIG%

rm -rf /s /q $1/$2/%COV_HTML_OUTPUT%

$BULLSEYE_LOC/cov01 --on
/opt/st/stm32cubeide_1.8.0/stm32cubeide -nosplash --launcher.suppressErrors  -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data . -cleanBuild $1/UnitTesting -E PATH=$PATH -E CC="$BULLSEYE_LOC/covc -i $BULLSEYE_LOC/gcc" -markerType cdt
#make -e CC="$BULLSEYE_LOC/covc -i $BULLSEYE_LOC/gcc" -B $1
$1/$2/$1 xml "$1/$2/out"
$BULLSEYE_LOC/cov01 --off
$BULLSEYE_LOC/covselect --file $COVFILE --add '!../CUnit/src/'
#$BULLSEYE_LOC/covselect --file $COVFILE --add '!../Test/'
$BULLSEYE_LOC/covselect --file $COVFILE --list
echo START BULLSEYE HTML REPORT
/opt/bullshtml/bullshtml -f $COVFILE $COV_HTML_OUTPUT
echo STOP BULLSEYE HTML REPORT
