include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO OpenImageIO/oiio
    REF Release-1.8.14
    SHA512 7e4c542d1732d8894105185adad548a79ba30dbebbe3a1e17a003a3e2ce976c9727280c893b72d240fd97c0ab9474adb3cb1f93452a3a81427780f7385b6fb1b
    HEAD_REF master
    PATCHES
        # fix_libraw: replace 'LibRaw_r_LIBRARIES' occurences by 'LibRaw_LIBRARIES'
        #             since libraw port installs 'raw_r' library as 'raw'
        ${CMAKE_CURRENT_LIST_DIR}/fix_libraw.patch
)

file(REMOVE_RECURSE "${SOURCE_PATH}/ext")
file(MAKE_DIRECTORY "${SOURCE_PATH}/ext/robin-map/tsl")

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(BUILDSTATIC ON)
    set(LINKSTATIC ON)
else()
    set(BUILDSTATIC OFF)
    set(LINKSTATIC OFF)
endif()

# Features
set(USE_LIBRAW OFF)
if("libraw" IN_LIST FEATURES)
    set(USE_LIBRAW ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DOIIO_BUILD_TOOLS=OFF
        -DOIIO_BUILD_TESTS=OFF
        -DHIDE_SYMBOLS=ON
        -DUSE_FFMPEG=OFF
        -DUSE_FIELD3D=OFF
        -DUSE_FREETYPE=OFF
        -DUSE_GIF=OFF
        -DUSE_LIBRAW=${USE_LIBRAW}
        -DUSE_NUKE=OFF
        -DUSE_OCIO=OFF
        -DUSE_OPENCV=OFF
        -DUSE_OPENJPEG=OFF
        -DUSE_PTEX=OFF
        -DUSE_PYTHON=OFF
        -DUSE_QT=OFF
        -DBUILDSTATIC=${BUILDSTATIC}
        -DLINKSTATIC=${LINKSTATIC}
        -DBUILD_MISSING_PYBIND11=OFF
        -DBUILD_MISSING_DEPS=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Clean
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/doc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/doc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/openimageio)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/openimageio/LICENSE ${CURRENT_PACKAGES_DIR}/share/openimageio/copyright)
