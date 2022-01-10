

REM PC-LINT Configuration
set PC_LINT_LOC=C:\PC-Lint\windows\config\
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
REM del %PROJECT_CONFIG%

rmdir /s /q %COV_HTML_OUTPUT%

make -e CC=%PC_LINT_LOC%imposter.exe -B TestSTM32CubeGcc

%PC_LINT_LOC%pclp_config.py --compiler=gcc --imposter-file=%IMPOSTER_LOG% --config-output-lnt-file=%PC_LINT_PROJECT_CONFIG% --generate-project-config
pclp64 -os(%PC_LINT_ANALYSIS_FILE%) co-gcc.lnt C:\PC-Lint\windows\lnt\env-jenkins.lnt %PC_LINT_PROJECT_CONFIG%
REM TEMP del %IMPOSTER_LOG%


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