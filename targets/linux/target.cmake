######################################
# building variables
######################################

# debug build?
set(DEBUG 1)

# optimization
# set(OPT -Og)

# default board: default
if(NOT BOARD)
  set(BOARD "default")
endif()

# default modules
if(NOT MODULES)
  set(MODULES 
    events
    gpio
    led
    button
    pwm
    adc
    i2c
    spi
    uart
    graphics
    at
    storage
    wifi
    stream
    net
    http
    url
    rtc
    path
    flash
    fs
    vfs_lfs
    vfs_fat
    startup
    __ujest
    __test_utils)
endif()

project(kaluma-project C CXX ASM)

set(OUTPUT_TARGET kaluma)
set(TARGET_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src)
set(TARGET_INC_DIR ${CMAKE_CURRENT_LIST_DIR}/include)
set(BOARD_DIR ${CMAKE_CURRENT_LIST_DIR}/boards/${BOARD})

set(SOURCES
  ${SOURCES}
  ${TARGET_SRC_DIR}/adc.c
  ${TARGET_SRC_DIR}/system.c
  ${TARGET_SRC_DIR}/gpio.c
  ${TARGET_SRC_DIR}/pwm.c
  ${TARGET_SRC_DIR}/tty.c
  ${TARGET_SRC_DIR}/flash.c
  ${TARGET_SRC_DIR}/uart.c
  ${TARGET_SRC_DIR}/i2c.c
  ${TARGET_SRC_DIR}/spi.c
  ${TARGET_SRC_DIR}/rtc.c
  ${TARGET_SRC_DIR}/socket.c
  ${TARGET_SRC_DIR}/main.c
  ${BOARD_DIR}/board.c)

include_directories(${TARGET_INC_DIR} ${BOARD_DIR})

set(TARGET_HEAPSIZE 1024)
set(JERRY_TOOLCHAIN toolchain_linux_i686.cmake)

# set(CMAKE_SYSTEM_PROCESSOR amd64)
# set(CMAKE_C_FLAGS "${OPT} -Wall -fdata-sections -ffunction-sections")
if(DEBUG EQUAL 1)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -gdwarf-2")
endif()
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -MMD -MP")

#set(PREFIX)
set(CMAKE_ASM_COMPILER ${PREFIX}gcc)
set(CMAKE_C_COMPILER ${PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${PREFIX}g++)
set(CMAKE_LINKER ${PREFIX}ld)
set(CMAKE_OBJCOPY ${PREFIX}objcopy)

set(TARGET_LIBS c m)
# set(CMAKE_EXE_LINKER_FLAGS "-u -Wl")

include(${CMAKE_SOURCE_DIR}/tools/kaluma.cmake)

add_executable(${OUTPUT_TARGET} ${SOURCES} ${JERRY_LIBS})
target_link_libraries(${OUTPUT_TARGET} ${JERRY_LIBS} ${TARGET_LIBS})

# add_custom_command(OUTPUT ${OUTPUT_TARGET}.hex ${OUTPUT_TARGET}.bin
#   COMMAND ${CMAKE_OBJCOPY} -O ihex ${OUTPUT_TARGET}.elf ${OUTPUT_TARGET}.hex
#   COMMAND ${CMAKE_OBJCOPY} -O binary -S ${OUTPUT_TARGET}.elf ${OUTPUT_TARGET}.bin
#   DEPENDS ${OUTPUT_TARGET}.elf)

# add_custom_target(kaluma ALL DEPENDS ${OUTPUT_TARGET}.hex ${OUTPUT_TARGET}.bin)
