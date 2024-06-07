# nRF application makefile
PROJECT_NAME = $(shell basename "$(realpath ./)")

# Configurations
NRF_IC = nrf52840
SDK_VERSION = 16
SOFTDEVICE_MODEL = blank

# LF Paths
APP_HEADER_PATHS += \
	./include/ \
	./include/api/ \
	./include/core/  \
	./include/core/utils/ \
	./include/core/platform/ \
	./low_level_platform/api/ \
	./tag/api/ \
	./trace/api/types \
	./logging/api/ \
	./version/api/ \
	./platform/api \

APP_SOURCE_PATHS += \
	./lib/ \
	./core/ \
	./core/platform/ \
	./core/utils/ \
	./core/utils/hashset \
	./core/modal_models/ \
	./low_level_platform/impl/src/ \

#  LF Sources
APP_SOURCES += \
	lf_nrf52_support.c \
	reactor.c \
	reactor_common.c \
	environment.c \
	lf_token.c \
	clock.c \
	mixed_radix.c \
	hashset_itr.c \
	hashset.c \
	pqueue_base.c \
	pqueue.c \
	pqueue_tag.c \
	port.c \
	tag.c \
	utils/pqueue.c \
	utils/vector.c \
	utils/util.c \
	modal_models/modes.c \
	schedule.c \
	lf_atomic_irq.c \


override CFLAGS += -DLF_SINGLE_THREADED=1
override CFLAGS += -DPLATFORM_NRF52
override CFLAGS += -DINITIAL_EVENT_QUEUE_SIZE=10
override CFLAGS += -DINITIAL_REACT_QUEUE_SIZE=10
# Suppress warnings
override CFLAGS += -w

# Main source and header files
APP_HEADER_PATHS += .
APP_SOURCE_PATHS += .
APP_SOURCES += $(notdir $(wildcard ./*.c))

NRF_BASE_DIR = $(PROJECT_ROOT)/nrf52x-base/

APP_HEADER_PATHS += $(NRF_BASE_DIR)/sdk/nrf5_sdk_16.0.0/components/toolchain/cmsis/include
# FIXME: Hardwired board
APP_HEADER_PATHS += $(NRF_BASE_DIR)/boards/nrf52840dk/

# Additional #define's to be added to code by the compiler
BOARD_VARS = \
	BOARD_$(BOARD_UPPER)\
	USE_APP_CONFIG\
	DEBUG\
	DEBUG_NRF\


# Include board Makefile (if any)
# Sample board Makefiles are provided $(NRF_BASE_DIR)/boards/...
# The Board.mk file pulls in the app_config.h file that is in this same
# platforms directory. That file is a copy of the app_config.h file in the
# (NRF_BASE_DIR)/boards/nrf52840dk/ directory, modified by adding the following line:
#    #define TIMER3_ENABLED 1
# The Lingua Franca runtime uses timer 3 for its timer functionality.
include $(PROJECT_ROOT)/platform/Board.mk

# Include main Makefile
include $(NRF_BASE_DIR)/make/AppMakefile.mk

# The following does not get included in includes.mk. WTF????
SDK_SOURCE_PATHS += $(SDK_ROOT)components/libraries/util/

