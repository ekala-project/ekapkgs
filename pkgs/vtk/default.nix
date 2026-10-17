{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,

  # core dependencies
  python3Packages,
  eigen,
  boost,
  verdict,

  # data libraries
  lz4,
  xz,
  zlib,
  expat,
  jsoncpp,
  libxml2,
  utf8cpp,
  nlohmann_json,

  # io modules
  hdf5,
  libjpeg,
  libpng,
  libtiff,
  sqlite,
  libogg,
  libtheora,
  ffmpeg,

  # threading
  onetbb,
  llvmPackages,

  # rendering
  freetype,
  fontconfig,
  libx11,
  libxfixes,
  libxrender,
  libxcursor,
  gl2ps,
  libGL,
  tk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtk";
  version = "9.5.2";

  src = fetchurl {
    url = "https://www.vtk.org/files/release/${lib.versions.majorMinor finalAttrs.version}/VTK-${finalAttrs.version}.tar.gz";
    hash = "sha256-zuZLmNJw/3MC2vHvE0WN/11awey0XUdyODX399ViyYk=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gdal-3.13-const-conversion.patch";
      url = "https://github.com/Kitware/VTK/commit/2395603fdddc40c29efc64c632ae98225ca2a58e.patch";
      hash = "sha256-Gcnt1JXWPkhfNLhtk9SXYqx/0cLkjO4xiRfR8YiaY8I=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    python3Packages.pythonRecompileBytecodeHook
  ]
  ++ lib.optional (
    stdenv.buildPlatform == stdenv.hostPlatform
  ) python3Packages.pythonImportsCheckHook;

  buildInputs = [
    ffmpeg
    fontconfig
    libGL
    tk
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxfixes
    libxrender
    libxcursor
  ];

  # propagated by vtk-config.cmake
  propagatedBuildInputs = [
    eigen
    boost
    verdict
    freetype
    lz4
    xz
    zlib
    expat
    jsoncpp
    libxml2
    utf8cpp
    nlohmann_json
    libjpeg
    libpng
    libtiff
    sqlite
    libogg
    libtheora
    onetbb
    hdf5
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    gl2ps
  ]
  # create meta package providing dist-info for python3Packages.vtk
  ++ [
    (python3Packages.mkPythonMetaPackage {
      inherit (finalAttrs) pname version meta;
      dependencies = with python3Packages; [
        numpy
        matplotlib
      ];
    })
  ];

  cmakeFlags = [
    # During installPhase, keep rpath from target_link_libraries()
    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")

    # Minimal build: don't build all modules, just what we need
    (lib.cmakeBool "VTK_BUILD_ALL_MODULES" false)
    (lib.cmakeBool "VTK_VERSIONED_INSTALL" false)
    (lib.cmakeBool "VTK_SMP_ENABLE_OPENMP" true)
    (lib.cmakeFeature "VTK_SMP_IMPLEMENTATION_TYPE" "TBB")

    # Enable modules needed by FreeCAD/SMESH
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_CommonCore" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_CommonDataModel" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_FiltersVerdict" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOXML" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_FiltersCore" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_FiltersGeneral" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOLegacy" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_FiltersExtraction" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_FiltersSources" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_FiltersGeometry" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingCore" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_InteractionStyle" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingFreeType" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingOpenGL2" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOImage" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOExport" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingAnnotation" "YES")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_ImagingCore" "YES")

    # Use system packages where we have them
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_eigen" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_expat" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_freetype" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_hdf5" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_jpeg" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_jsoncpp" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_libxml2" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_lz4" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_lzma" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_nlohmannjson" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_png" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_tiff" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_utf8" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_zlib" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_verdict" true)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_gl2ps" stdenv.hostPlatform.isLinux)

    # Disable rendering backends we don't need
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingRayTracing" "NO")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingOpenXR" "NO")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingOpenVR" "NO")
    (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_RenderingAnari" "NO")

    # Python support
    (lib.cmakeBool "VTK_USE_TK" true)
    (lib.cmakeFeature "VTK_GROUP_ENABLE_Tk" "YES")
    (lib.cmakeBool "VTK_WRAP_PYTHON" true)
    (lib.cmakeBool "VTK_BUILD_PYI_FILES" true)
    (lib.cmakeFeature "VTK_PYTHON_VERSION" "3")

    # No MPI
    (lib.cmakeBool "VTK_USE_MPI" false)
    (lib.cmakeFeature "VTK_GROUP_ENABLE_MPI" "NO")

    # No Qt
    (lib.cmakeFeature "VTK_GROUP_ENABLE_Qt" "NO")

    # Vendored libraries that don't have external packages
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_fast_float" false)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_pegtl" false)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_ioss" false)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_token" false)
    (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_fmt" false)
  ];

  pythonImportsCheck = [ "vtk" ];

  dontWrapQtApps = true;

  postFixup =
    # Remove thirdparty find modules that have been provided
    ''
      rm -rf $out/lib/cmake/vtk/patches
      rm -f $out/lib/cmake/vtk/Find{EXPAT,Freetype,utf8cpp,LibXml2,FontConfig,TBB}.cmake
    ''
    # libvtkglad.so will find and load libGL.so at runtime
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath ${lib.getLib libGL}/lib $out/lib/libvtkglad.so
    '';

  passthru = {
    pythonSupport = true;
    mpiSupport = false;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    changelog = "https://docs.vtk.org/en/latest/release_details/${lib.versions.majorMinor finalAttrs.version}.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
