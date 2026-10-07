{
  lib,
  stdenv,
  fetchzip,
  boost,
  ceres-solver,
  cmake,
  dbus,
  draco,
  ffmpeg,
  fftw,
  freetype,
  gettext,
  glew,
  gmp,
  jemalloc,
  libdecor,
  libepoxy,
  libffi,
  libGL,
  libGLU,
  libharu,
  libjack2,
  libjpeg,
  libpng,
  libsamplerate,
  libsndfile,
  libspnav,
  libtiff,
  libwebp,
  libx11,
  libxext,
  libxi,
  libxkbcommon,
  libxrender,
  libxxf86vm,
  llvmPackages,
  makeWrapper,
  meshoptimizer,
  onetbb,
  openal,
  opencolorio,
  openexr,
  openimageio,
  openjpeg,
  openpgl,
  opensubdiv,
  openxr-loader,
  pkg-config,
  potrace,
  pugixml,
  python3,
  python3Packages,
  rubberband,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
  zstd,
  jackaudioSupport ? false,
  spaceNavSupport ? stdenv.hostPlatform.isLinux,
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

let
  # embree's ispc dep can't find TBB; disable until fixed upstream
  embreeSupport = false;
  vulkanSupport = !stdenv.hostPlatform.isDarwin;

  libdecor' = libdecor.overrideAttrs (old: {
    # Blender uses private APIs, need to patch to expose them
    patches = (old.patches or [ ]) ++ [ ./libdecor.patch ];
  });

  # openvdb depends on tbb 2021.11.0 which fails to build with GCC 14,
  # and onetbb 2023 is API-incompatible with openvdb 13; disable for now
  openvdbSupport = false;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "blender";
  version = "5.2.0";

  src = fetchzip {
    name = "source";
    url = "https://download.blender.org/source/blender-${finalAttrs.version}.tar.xz";
    hash = "sha256-V2+Oc7GT31JvWccffzUaingEs8CtSFaazgQ+YdZUB7M=";
  };

  patches = [
    ./eigen-3-compat.patch
  ];

  postPatch = ''
    substituteInPlace intern/ghost/intern/GHOST_SystemPathsUnix.cc \
      --replace-fail \
        'static const char *static_libs_path = PREFIX "/" BLENDER_INSTALL_LIBDIR;' \
        'static const char *static_libs_path = BLENDER_INSTALL_LIBDIR;'
  '';

  env.NIX_CFLAGS_COMPILE = "-I${python3}/include/${python3.libPrefix}";

  cmakeEntries = {
    PYTHON_INCLUDE_DIR = "${python3}/include/${python3.libPrefix}";
    PYTHON_LIBPATH = "${python3}/lib";
    PYTHON_LIBRARY = "${python3.libPrefix}";
    PYTHON_NUMPY_INCLUDE_DIRS = "${python3Packages.numpy}/${python3.sitePackages}/numpy/_core/include";
    PYTHON_NUMPY_PATH = "${python3Packages.numpy}/${python3.sitePackages}";
    PYTHON_VERSION = "${python3.pythonVersion}";
    WITH_BUILDINFO = false;
    WITH_CPU_CHECK = false;
    WITH_CYCLES_CUDA_BINARIES = false;
    WITH_CYCLES_DEVICE_CUDA = false;
    WITH_CYCLES_DEVICE_HIP = false;
    WITH_CYCLES_DEVICE_ONEAPI = false;
    WITH_CYCLES_DEVICE_OPTIX = false;
    WITH_CYCLES_EMBREE = embreeSupport;
    WITH_CYCLES_OSL = false;
    WITH_CYCLES_PARALLEL_DEVICE_KERNEL_BUILD = true;
    WITH_HYDRA = false;
    WITH_INSTALL_PORTABLE = false;
    WITH_JACK = jackaudioSupport;
    WITH_LIBS_PRECOMPILED = false;
    WITH_MATERIALX = false;
    WITH_OPENIMAGEDENOISE = false;
    WITH_PIPEWIRE = false;
    WITH_PULSEAUDIO = false;
    WITH_PYTHON_INSTALL = false;
    WITH_PYTHON_INSTALL_NUMPY = false;
    WITH_PYTHON_INSTALL_REQUESTS = false;
    WITH_STRICT_BUILD_OPTIONS = true;
    WITH_SYSTEM_GLOG = true;
    WITH_USD = false;
    WITH_ALEMBIC = false;
    WITH_MANIFOLD = false;
    WITH_OPENVDB = false;
    WITH_NANOVDB = false;
  };

  cmakeFlags = [
      "-C../build_files/cmake/config/blender_release.cmake"
    ] ++ lib.optionals waylandSupport [
    (lib.cmakeBool "WITH_GHOST_WAYLAND" true)
    (lib.cmakeBool "WITH_GHOST_WAYLAND_DYNLOAD" false)
  ] ++ lib.optionals stdenv.cc.isClang [
    (lib.cmakeFeature "PYTHON_LINKFLAGS" "")
  ];

  preConfigure = ''
    (
      expected_python_version=$(grep -E --only-matching 'set\(_PYTHON_VERSION_SUPPORTED [0-9.]+\)' build_files/cmake/Modules/FindPythonLibsUnix.cmake | grep -E --only-matching '[0-9.]+')
      actual_python_version=$(python -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')
      if ! [[ "$actual_python_version" = "$expected_python_version" ]]; then
        echo "wrong Python version, expected '$expected_python_version', got '$actual_python_version'" >&2
        exit 1
      fi
    )
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    llvmPackages.llvm.dev
    makeWrapper
    pkg-config
    python3
    python3Packages.wrapPython
  ]
  ++ lib.optionals waylandSupport [
    wayland-scanner
  ];

  buildInputs = [
    boost
    ceres-solver
    draco
    ffmpeg
    fftw
    fftw.float
    freetype
    gettext
    glew
    gmp.withCxx
    jemalloc
    libepoxy
    libharu
    libjpeg
    libpng
    libsamplerate
    libsndfile
    libtiff
    libwebp
    meshoptimizer
    opencolorio
    openexr
    openimageio
    openjpeg
    openpgl
    opensubdiv
    onetbb
    # openvdb disabled due to tbb build failure
    openxr-loader
    potrace
    pugixml
    python3
    rubberband
    zlib
    zstd
  ]
  # embree disabled due to ispc TBB build failure
  ++ [
    libGL
    libGLU
    libx11
    libxext
    libxi
    libxrender
    libxxf86vm
    openal
  ]
  ++ lib.optionals waylandSupport [
    dbus
    libdecor'
    libffi
    libxkbcommon
    wayland
    wayland-protocols
    wayland-scanner.dev
  ]
  ++ lib.optional jackaudioSupport libjack2
  ++ lib.optional spaceNavSupport libspnav
  ++ lib.optionals vulkanSupport [
    shaderc
    vulkan-headers
    vulkan-loader
  ];

  pythonPath =
    let
      ps = python3Packages;
    in
    [
      ps.cattrs
      ps.numpy
      ps.requests
      ps.zstandard
    ];

  blenderExecutable = placeholder "out" + "/bin/blender";

  postInstall = ''
    buildPythonPath "''${pythonPath[*]}"
    wrapProgram $blenderExecutable \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --add-flags '--python-use-system-env'
  '';

  meta = {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    license = with lib.licenses; [ gpl2Plus ];
    donationPage = "https://fund.blender.org/";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "blender";
  };
})
