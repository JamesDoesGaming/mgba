#ifndef COMMAND_LINE_H
#define COMMAND_LINE_H

#include "util/common.h"

#include "gba-config.h"

enum DebuggerType {
	DEBUGGER_NONE = 0,
#ifdef USE_CLI_DEBUGGER
	DEBUGGER_CLI,
#endif
#ifdef USE_GDB_STUB
	DEBUGGER_GDB,
#endif
	DEBUGGER_MAX
};

struct GBAArguments {
	char* fname;
	char* patch;
	bool dirmode;

	enum DebuggerType debuggerType;
	bool debugAtStart;
};

struct SubParser {
	const char* usage;
	bool (*parse)(struct SubParser* parser, struct GBAOptions* gbaOpts, int option, const char* arg);
	const char* extraOptions;
	void* opts;
};

struct GraphicsOpts {
	int multiplier;
};

bool parseArguments(struct GBAArguments* opts, struct GBAOptions* gbaOpts, int argc, char* const* argv, struct SubParser* subparser);
void freeArguments(struct GBAArguments* opts);

void usage(const char* arg0, const char* extraOptions);

void initParserForGraphics(struct SubParser* parser, struct GraphicsOpts* opts);
struct ARMDebugger* createDebugger(struct GBAArguments* opts);

#endif
