#ifdef TESTING
	#define FASTLOAD
	#define DEPLOY_TEST
	#define ROGUEWORLD
#endif

#ifdef FASTLOAD
	#define FORCE_MAP "_maps/roguetown.json"
#else
	#define FORCE_MAP "_maps/roguetown.json"
#endif

//#define WARTIME
