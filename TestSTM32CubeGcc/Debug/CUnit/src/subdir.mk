################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../CUnit/src/Automated.c \
../CUnit/src/Basic.c \
../CUnit/src/CUError.c \
../CUnit/src/MyMem.c \
../CUnit/src/TestDB.c \
../CUnit/src/TestRun.c \
../CUnit/src/Util.c 

OBJS += \
./CUnit/src/Automated.o \
./CUnit/src/Basic.o \
./CUnit/src/CUError.o \
./CUnit/src/MyMem.o \
./CUnit/src/TestDB.o \
./CUnit/src/TestRun.o \
./CUnit/src/Util.o 

C_DEPS += \
./CUnit/src/Automated.d \
./CUnit/src/Basic.d \
./CUnit/src/CUError.d \
./CUnit/src/MyMem.d \
./CUnit/src/TestDB.d \
./CUnit/src/TestRun.d \
./CUnit/src/Util.d 


# Each subdirectory must supply rules for building sources it contributes
CUnit/src/%.o: ../CUnit/src/%.c CUnit/src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	${CC} -std=c11 -I"C:\Git\BuildServer\TestSTM32Build\TestSTM32CubeGcc\CUnit\hdr" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


