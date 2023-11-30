add_executable(projet_nsi
        projet_nsi.c
        )

target_sources(projet_nsi PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/projet_nsi.c
        ${CMAKE_CURRENT_LIST_DIR}/usb_descriptors.c
        )

# Make sure TinyUSB can find tusb_config.h
target_include_directories(projet_nsi PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

# pull in common dependencies
target_link_libraries(projet_nsi PUBLIC pico_stdlib tinyusb_device tinyusb_board)

# create map/bin/hex file etc.
pico_add_extra_outputs(projet_nsi)

# add url via pico_set_program_url
example_auto_set_url(projet_nsi)
