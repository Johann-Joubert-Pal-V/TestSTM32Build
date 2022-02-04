
echo "commandline paramters"
echo "Project name : "$1

/opt/st/stm32cubeide_1.8.0/stm32cubeide -nosplash --launcher.suppressErrors  -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data . -import $1


#generate makefiles for UnitTesting

#The following arguments are required
#-E PATH=$PATH  		assign the system PATH to the eclipse workspace path
#-E CC=/usr/bin/gcc 	assign CC to the system GCC compiler
#-markerType cdt 		suppress the eclipse errors/warnings about enviromental variables not found ,which are windows specific.
/opt/st/stm32cubeide_1.8.0/stm32cubeide -nosplash --launcher.suppressErrors  -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data . -cleanBuild $1/UnitTesting -E PATH=$PATH -E CC=/usr/bin/gcc -markerType cdt


#generate makefiles for Debug
#TEMP /opt/st/stm32cubeide_1.8.0/stm32cubeide -nosplash --launcher.suppressErrors  -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data . -cleanBuild $1/Debug -E CC=gcc -markerType cdt

#generate makefiles for Release
#TEMP /opt/st/stm32cubeide_1.8.0/stm32cubeide -nosplash --launcher.suppressErrors  -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data . -cleanBuild $1/Release -E CC=gcc -markerType cdt
