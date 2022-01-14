

REM PC-LINT Configuration
set PC_LINT_LOC=C:\PC-Lint\windows\config\
set PC_LINT_LNT_LOC=C:\PC-Lint\windows\lnt\
set PC_LINT_PROJECT_CONFIG=project_config.lnt
REM Temporary filename for imposter log
set IMPOSTER_LOG=imposter_log.txt
set PC_LINT_ANALYSIS_FILE=analysis.log

REM BULLSEYE CONFIGURATION
set BULLSEYE_LOC=C:\BullseyeCoverage\BullseyeCoverage\bin\
set COVFILE=Test.cov
set COV_HTML_OUTPUT=cov_html_output


REM disable local echo of commands, display output only.
@echo off				

echo %IMPOSTER_LOG%
echo %1%
echo %2%
echo %3%

REM set PROJECT_CONFIG = %1%

REM SET IMPOSTER_MODULES_IN_WORKING_DIR=1
REM SET IMPOSTER_PATH_ARGUMENT_RELATIVE_TO_WORKING_DIR_OPTION_INTRODUCERS=/I;-I
REM SET "IMPOSTER_COMPILER=%PCLP_CFG_CL_PATH%"


REM INSERT COMMAND TO GENERATE co-GCC.h and co-gcc.lnt and maybe compile imposter.exe
REM Pass commandline parameters to either clean files, build coverage report, pc-lint or just compile, maybe also add target.


REM clean upfiles
del %PC_LINT_PROJECT_CONFIG%
del %PC_LINT_ANALYSIS_FILE%
del %COVFILE%
del %IMPOSTER_LOG%
REM del %PROJECT_CONFIG%

rmdir /s /q %COV_HTML_OUTPUT%

REM Generate PC-LINT compiler configuration
%PC_LINT_LOC%pclp_config.py --compiler=gcc --compiler-bin=C:\mingw\mingw64\bin\gcc --config-output-lnt-file=co-gcc.lnt --config-output-header-file=co-gcc.h --generate-compiler-config
REM Compile PC-LINT imposter compiler
gcc %PC_LINT_LOC%imposter.c -o imposter 

REM Use PC-LINT imposter compiler to compile project
make -e CC=imposter.exe -B TestSTM32CubeGcc

REM Generate the PC-LINT project configuration
%PC_LINT_LOC%pclp_config.py --compiler=gcc --imposter-file=%IMPOSTER_LOG% --config-output-lnt-file=%PC_LINT_PROJECT_CONFIG% --generate-project-config
REM Use the PC-LINT compiler, jenkins and project configuration to LINT the project files
pclp64 -max_threads=4 -os(%PC_LINT_ANALYSIS_FILE%) co-gcc.lnt env-jenkins.lnt %PC_LINT_LNT_LOC%au-misra3.lnt %PC_LINT_LNT_LOC%au-misra3-amd1.lnt %PC_LINT_LNT_LOC%au-misra3-amd2.lnt %PC_LINT_PROJECT_CONFIG%
REM pclp64 -max_threads=4 -wlib(0) -os(%PC_LINT_ANALYSIS_FILE%) co-gcc.lnt C:\PC-Lint\windows\lnt\env-jenkins.lnt %PC_LINT_PROJECT_CONFIG%



%BULLSEYE_LOC%cov01 --on
make -e CC="%BULLSEYE_LOC%covc.exe -i %BULLSEYE_LOC%gcc.exe" -B TestSTM32CubeGcc
".\TestSTM32CubeGcc.exe" xml out
%BULLSEYE_LOC%cov01 --off

REM TODO add coverage regions inclusion/exclusion to remove CUNIT files.
REM covselect --file "%COVFILE%" --add c:
echo "START HTML REPORT"
C:\Git\BuildServer\BullsEyeTest\bullshtml\bullshtml.exe -f %COVFILE% -e UTF_8 %COV_HTML_OUTPUT%
REM C:\BullseyeCoverage\BullseyeCoverage\bin\covhtml.exe --file %COVFILE% %COV_HTML_OUTPUT%
REM C:\BullseyeCoverage\BullseyeCoverage\bin\covxml.exe --xsl --file %COVFILE% -o %COV_HTML_OUTPUT%/clover.xml
echo "END HTML REPORT"