# (C)2004-2010 SourceMod Development Team
# Makefile written by David "BAILOPAN" Anderson

###########################################
### EDIT THESE PATHS FOR YOUR OWN SETUP ###
###########################################

SMSDK = ../sourcemod
HL2SDK_ORIG = ../hl2sdk-episode1
HL2SDK_OB = ../hl2sdk-orangebox
HL2SDK_CSS = ../hl2sdk-css
HL2SDK_HL2DM = ../hl2sdk-hl2dm
HL2SDK_DODS = ../hl2sdk-dods
HL2SDK_TF2 = ../hl2sdk-tf2
HL2SDK_L4D = ../hl2sdk-l4d
HL2SDK_L4D2 = ../hl2sdk-l4d2
HL2SDK_CSGO = ../hl2sdk-csgo
MMSOURCE = ../mmsource

#####################################
### EDIT BELOW FOR OTHER PROJECTS ###
#####################################

PROJECT = Template

#Uncomment for Metamod: Source enabled extension
USEMETA = true

# smsdk_ext.cpp gets added automatically
OBJECTS = sdk/smsdk_ext.cpp extension.cpp

##############################################
### CONFIGURE ANY OTHER FLAGS/OPTIONS HERE ###
##############################################

C_OPT_FLAGS = -DNDEBUG -O3 -funroll-loops -pipe -fno-strict-aliasing
C_DEBUG_FLAGS = -D_DEBUG -DDEBUG -g -ggdb3
C_GCC4_FLAGS = -fvisibility=hidden
CPP_GCC4_FLAGS = -fvisibility-inlines-hidden
CPP = gcc
CPP_OSX = clang

##########################
### SDK CONFIGURATIONS ###
##########################

override ENGSET = false

# Check for valid list of engines
ifneq (,$(filter original orangebox css hl2dm dods tf2 left4dead left4dead2 csgo,$(ENGINE)))
	override ENGSET = true
endif

OS := $(shell uname -s)

ifeq "$(OS)" "Darwin"
	LIB_EXT = dylib
	HL2LIB = $(HL2SDK)/lib/mac
else
	LIB_EXT = so
	ifeq "$(ENGINE)" "original"
		HL2LIB = $(HL2SDK)/linux_sdk
	else
		HL2LIB = $(HL2SDK)/lib/linux
	endif
endif

ifeq "$(ENGINE)" "original"
	HL2SDK = $(HL2SDK_ORIG)
	CFLAGS += -DSOURCE_ENGINE=1
	LIB_SUFFIX = _i486.$(LIB_EXT)
	BUILD_SUFFIX = .1.ep1
endif
ifeq "$(ENGINE)" "orangebox"
	HL2SDK = $(HL2SDK_OB)
	CFLAGS += -DSOURCE_ENGINE=3
	LIB_SUFFIX = _i486.$(LIB_EXT)
	BUILD_SUFFIX = .2.ep2
endif
ifeq "$(ENGINE)" "css"
	HL2SDK = $(HL2SDK_CSS)
	CFLAGS += -DSOURCE_ENGINE=6
	LIB_PREFIX = lib
	LIB_SUFFIX = _srv.$(LIB_EXT)
	BUILD_SUFFIX = .2.css
endif
ifeq "$(ENGINE)" "hl2dm"
	HL2SDK = $(HL2SDK_HL2DM)
	CFLAGS += -DSOURCE_ENGINE=7
	LIB_PREFIX = lib
	LIB_SUFFIX = _srv.$(LIB_EXT)
	BUILD_SUFFIX = .2.hl2dm
endif
ifeq "$(ENGINE)" "dods"
	HL2SDK = $(HL2SDK_DODS)
	CFLAGS += -DSOURCE_ENGINE=8
	LIB_PREFIX = lib
	LIB_SUFFIX = _srv.$(LIB_EXT)
	BUILD_SUFFIX = .2.dods
endif
ifeq "$(ENGINE)" "tf2"
	HL2SDK = $(HL2SDK_TF2)
	CFLAGS += -DSOURCE_ENGINE=9
	LIB_PREFIX = lib
	LIB_SUFFIX = _srv.$(LIB_EXT)
	BUILD_SUFFIX = .2.tf2
endif
ifeq "$(ENGINE)" "left4dead"
	HL2SDK = $(HL2SDK_L4D)
	CFLAGS += -DSOURCE_ENGINE=10
	LIB_PREFIX = lib
	LIB_SUFFIX = .$(LIB_EXT)
	BUILD_SUFFIX = .2.l4d
endif
ifeq "$(ENGINE)" "left4dead2"
	HL2SDK = $(HL2SDK_L4D2)
	CFLAGS += -DSOURCE_ENGINE=12
	LIB_PREFIX = lib
	LIB_SUFFIX = _srv.$(LIB_EXT)
	BUILD_SUFFIX = .2.l4d2
endif
ifeq "$(ENGINE)" "csgo"
	HL2SDK = $(HL2SDK_CSGO)
	CFLAGS += -DSOURCE_ENGINE=15
	LIB_PREFIX = lib
	LIB_SUFFIX = .$(LIB_EXT)
	BUILD_SUFFIX = .2.csgo
endif

HL2PUB = $(HL2SDK)/public

ifeq "$(ENGINE)" "original"
	INCLUDE += -I$(HL2SDK)/public/dlls
	METAMOD = $(MMSOURCE)/core-legacy
else
	INCLUDE += -I$(HL2SDK)/public/game/server
	METAMOD = $(MMSOURCE)/core
endif

INCLUDE += -I. -I.. -Isdk -Ipublic -Ilisteners -I$(SMSDK)/public -I$(SMSDK)/public/amtl -I$(SMSDK)/public/amtl/amtl -I$(SMSDK)/sourcepawn/include

ifeq "$(USEMETA)" "true"
	LINK_HL2 = $(HL2LIB)/tier1_i486.a $(LIB_PREFIX)vstdlib$(LIB_SUFFIX) $(LIB_PREFIX)tier0$(LIB_SUFFIX)
	ifeq "$(ENGINE)" "csgo"
		LINK_HL2 += $(HL2LIB)/interfaces_i486.a -lstdc++
	endif

	LINK += $(LINK_HL2)

	INCLUDE += -I$(HL2PUB) -I$(HL2PUB)/engine -I$(HL2PUB)/tier0 -I$(HL2PUB)/tier1 -I$(METAMOD) \
		-I$(METAMOD)/sourcehook 
	CFLAGS += -DSE_EPISODEONE=1 -DSE_DARKMESSIAH=2 -DSE_ORANGEBOX=3 -DSE_BLOODYGOODTIME=4 -DSE_EYE=5 \
		-DSE_CSS=6 -DSE_HL2DM=7 -DSE_DODS=8 -DSE_TF2=9 -DSE_LEFT4DEAD=10 -DSE_NUCLEARDAWN=11 \
		-DSE_LEFT4DEAD2=12 -DSE_ALIENSWARM=13 -DSE_PORTAL2=14 -DSE_CSGO=15 -DSE_DOTA=16 -D_LINUX -fpermissive 
endif

LINK += -m32 -lm -ldl -lstdc++

CFLAGS += -DPOSIX -Dstricmp=strcasecmp -D_stricmp=strcasecmp -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp \
	-D_snprintf=snprintf -D_vsnprintf=vsnprintf -D_alloca=alloca -Dstrcmpi=strcasecmp -DCOMPILER_GCC -Wall -Wno-class-memaccess -Wdelete-non-virtual-dtor \
	-Wno-overloaded-virtual -Wno-switch -Wno-unused -msse -DSOURCEMOD_BUILD -DHAVE_STDINT_H -m32 -std=c++14
CPPFLAGS += -Wno-non-virtual-dtor -fno-exceptions -fno-rtti -lstdc++

################################################
### DO NOT EDIT BELOW HERE FOR MOST PROJECTS ###
################################################

BINARY = $(PROJECT).ext$(BUILD_SUFFIX).$(LIB_EXT)

ifeq "$(DEBUG)" "true"
	BIN_DIR = Debug
	CFLAGS += $(C_DEBUG_FLAGS)
else
	BIN_DIR = Release
	CFLAGS += $(C_OPT_FLAGS)
endif

ifeq "$(USEMETA)" "true"
	BIN_DIR := $(BIN_DIR).$(ENGINE)
endif

ifeq "$(OS)" "Darwin"
	CPP = $(CPP_OSX)
	LIB_EXT = dylib
	CFLAGS += -D_GNUC -DOSX -D_OSX
	LINK += -dynamiclib -lstdc++ -mmacosx-version-min=10.5
else
	LIB_EXT = so
	CFLAGS += -D_GNUC -D_LINUX 
	LINK += -shared
endif

IS_CLANG := $(shell $(CPP) --version | head -1 | grep clang > /dev/null && echo "1" || echo "0")

ifeq "$(IS_CLANG)" "1"
	CPP_MAJOR := $(shell $(CPP) --version | grep clang | sed "s/.*version \([0-9]\)*\.[0-9]*.*/\1/")
	CPP_MINOR := $(shell $(CPP) --version | grep clang | sed "s/.*version [0-9]*\.\([0-9]\)*.*/\1/")
else
	CPP_MAJOR := $(shell $(CPP) -dumpversion >&1 | cut -b1)
	CPP_MINOR := $(shell $(CPP) -dumpversion >&1 | cut -b3)
endif

# If not clang
ifeq "$(IS_CLANG)" "0"
	CFLAGS += -mfpmath=sse
endif

# Clang || GCC >= 4
ifeq "$(shell expr $(IS_CLANG) \| $(CPP_MAJOR) \>= 4)" "1"
	CFLAGS += $(C_GCC4_FLAGS)
	CPPFLAGS += $(CPP_GCC4_FLAGS)
endif

# Clang >= 3 || GCC >= 4.7
ifeq "$(shell expr $(IS_CLANG) \& $(CPP_MAJOR) \>= 3 \| $(CPP_MAJOR) \>= 4 \& $(CPP_MINOR) \>= 7)" "1"
	CFLAGS += -Wno-delete-non-virtual-dtor
endif

# OS is Linux and not using clang
ifeq "$(shell expr $(OS) \= Linux \& $(IS_CLANG) \= 0)" "1"
	LINK += -static-libgcc
endif

OBJ_BIN := $(OBJECTS:%.cpp=$(BIN_DIR)/%.o)

# This will break if we include other Makefiles, but is fine for now. It allows
#  us to make a copy of this file that uses altered paths (ie. Makefile.mine)
#  or other changes without mucking up the original.
MAKEFILE_NAME := $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

$(BIN_DIR)/%.o: %.cpp
	$(CPP) $(INCLUDE) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

all: check
	mkdir -p $(BIN_DIR)/sdk
	if [ "$(USEMETA)" = "true" ]; then \
		ln -sf $(HL2LIB)/$(LIB_PREFIX)vstdlib$(LIB_SUFFIX); \
		ln -sf $(HL2LIB)/$(LIB_PREFIX)tier0$(LIB_SUFFIX); \
	fi
	$(MAKE) -f $(MAKEFILE_NAME) extension

check:
	if [ "$(USEMETA)" = "true" ] && [ "$(ENGSET)" = "false" ]; then \
		echo "You must supply one of the following values for ENGINE:"; \
		echo "csgo, css, dods, hl2dm, left4dead, left4dead2, nd, orangebox, original, or tf2"; \
		exit 1; \
	fi

extension: check $(OBJ_BIN)
	$(CPP) $(INCLUDE) $(OBJ_BIN) $(LINK) -o $(BIN_DIR)/$(BINARY)

debug:
	$(MAKE) -f $(MAKEFILE_NAME) all DEBUG=true

default: all

clean: check
	rm -rf $(BIN_DIR)/*.o
	rm -rf $(BIN_DIR)/sdk/*.o
	rm -rf $(BIN_DIR)/$(BINARY)

