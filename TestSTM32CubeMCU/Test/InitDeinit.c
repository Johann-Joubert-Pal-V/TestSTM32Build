#include "InitDeinit.h"
#include <CUnit.h>

int CmdTestInit(void)
{
	return 0;
}

int CmdTestDeinit(void)
{
	return 0;
}

void CmdTestSetup(void)
{
}

void CmdTestTeardown(void)
{
}

void CmdTest1(void)
{
	int testValue = 1;

	CU_ASSERT_EQUAL(testValue, 0);
}

void CmdTest2(void)
{
	int testValue = 0;

	CU_ASSERT_EQUAL(testValue, 0);
}

void CmdTest3(void)
{
	int testValue = 0;

	CU_ASSERT_EQUAL(testValue, 0);
}

void CmdTest4(void)
{
	int testValue = 1;

	CU_ASSERT_EQUAL(testValue, 0);
}

