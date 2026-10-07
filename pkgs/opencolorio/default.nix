{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  expat,
  yaml-cpp,
  pystring,
  imath,
  minizip-ng,
  zlib,
  # Only required on Linux
  glew,
  freeglut,
  # Python bindings
  pythonBindings ? true,
  python3Packages,
  # Build apps
  buildApps ? true,
  lcms2,
  openexr,
}:

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenColorIO";
    rev = "v${version}";
    hash = "sha256-+EeQbu8739inUW6Az5TfDxajDzUZ1lmh7rgpBSHtp+U=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # these tests don't like being run headless on darwin. no builtin
    # way of skipping tests so this is what we're reduced to.
    substituteInPlace tests/cpu/Config_tests.cpp \
      --replace 'OCIO_ADD_TEST(Config, virtual_display)' 'static void _skip_virtual_display()' \
      --replace 'OCIO_ADD_TEST(Config, virtual_display_with_active_displays)' 'static void _skip_virtual_display_with_active_displays()'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ]
  ++ lib.optionals pythonBindings [ python3Packages.python ];

  buildInputs = [
    expat
    yaml-cpp
    pystring
    imath
    minizip-ng
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glew
    freeglut
  ]
  ++ lib.optionals pythonBindings [
    python3Packages.python
    python3Packages.pybind11
  ]
  ++ lib.optionals buildApps [
    lcms2
    openexr
  ];

  cmakeEntries = {
    OCIO_INSTALL_EXT_PACKAGES = "NONE";
    OCIO_USE_SSE2NEON = false;
    OCIO_BUILD_GPU_TESTS = false;
  };

  cmakeFlags = [
      "-Dminizip-ng_INCLUDE_DIR=${minizip-ng}/include/minizip-ng"
    ] ++ lib.optional (!pythonBindings) "-DOCIO_BUILD_PYTHON=OFF" ++ lib.optional (!buildApps) "-DOCIO_BUILD_APPS=OFF";

  doCheck = false;

  meta = with lib; {
    homepage = "https://opencolorio.org";
    description = "Color management framework for visual effects and animation";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
