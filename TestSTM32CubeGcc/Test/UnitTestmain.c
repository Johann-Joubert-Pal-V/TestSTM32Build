#include "../CUnit/hdr/CUnit.h"
#include "../CUnit/hdr/TestDB.h"
#include "InitDeinit.h"
#include "../CUnit/hdr/Automated.h"
#include "../CUnit/hdr/Basic.h"
#include <assert.h>
#include <stdbool.h>

//#define CU_DLL

#define OUTPUTFILE_LENGTH 50

static void runAutomatedTests(char* pFileName);
static void runBasicTestsOutputToFile(char* pFileName);
static void runBasicTests(void);

static CU_TestInfo cmdTests[] = {
	{ "CmdTest1", CmdTest1 },
	{ "CmdTest2", CmdTest2 },
	{ "CmdTest3", CmdTest3 },
	{ "CmdTest4", CmdTest4 },
	CU_TEST_INFO_NULL,
};

static CU_SuiteInfo CmdSuite[] =
{
	{ "cmdTestSuite", CmdTestInit, CmdTestDeinit, CmdTestSetup, CmdTestTeardown, cmdTests },
	CU_SUITE_INFO_NULL,
};

int test_main(int argc, char* argv[])
{
	CU_initialize_registry();

	assert(NULL != CU_get_registry());
	assert(!CU_is_test_running());

	/* Register suites. */
	if (CU_register_suites(CmdSuite) != CUE_SUCCESS) {
		fprintf(stderr, "suite registration failed - %s\n",
			CU_get_error_msg());
	}
	else
	{
		char outputFile[OUTPUTFILE_LENGTH] = "TestAutomated";

		if (argc > 1)
		{
			/* parse output file name */
			if (argc > 2)
			{
				if (strlen(argv[2]) < OUTPUTFILE_LENGTH)
				{
					strcpy(outputFile, argv[2]);
				}
			}

			/* parse output type */
			if (!strcmp("xml", argv[1]))
			{
				runAutomatedTests(outputFile);
			}
			else if (!strcmp("txt", argv[1]))
			{
				strcat(outputFile, ".txt");

				runBasicTestsOutputToFile(outputFile);
			}
			else
			{
				printf("invalid parameter\n");
			}
		}
		else
		{
			runBasicTests();
		}
	}

	return 0;
}

static void runAutomatedTests(char* pFileName)
{
	CU_set_error_action(CUEA_IGNORE);
	CU_set_output_filename(pFileName);
	CU_list_tests_to_file();
	CU_automated_run_tests();
	CU_cleanup_registry();
}

static void runBasicTestsOutputToFile(char* pFileName)
{
	(void)freopen(pFileName, "w+", stdout);

	runBasicTests();

	(void)freopen("CON", "w", stdout);
}

static void runBasicTests(void)
{
	CU_basic_set_mode(CU_BRM_VERBOSE);
	CU_set_error_action(CUEA_IGNORE);
	printf("\nTests completed with return value %d.\n", CU_basic_run_tests());
	CU_cleanup_registry();
}
