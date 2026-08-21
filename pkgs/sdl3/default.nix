{
  lib,
  stdenv,
  alsa-lib,
  cmake,
  dbus,
  fetchFromGitHub,
  libGL,
  libdecor,
  libdrm,
  libusb1,
  libxkbcommon,
  libgbm,
  ninja,
  sndio,
  systemdLibs,
  validatePkgConfig,
  vulkan-headers,
  vulkan-loader,
  libxcb,
  wayland,
  wayland-scanner,
  xorg,
  zenity,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  dbusSupport ? stdenv.hostPlatform.isLinux,
  drmSupport ? stdenv.hostPlatform.isLinux,
  openglSupport ? lib.meta.availableOn stdenv.hostPlatform libGL,
  libudevSupport ? stdenv.hostPlatform.isLinux,
  sndioSupport ? false,
  testSupport ? true,
  waylandSupport ? stdenv.hostPlatform.isLinux,
  libdecorSupport ? stdenv.hostPlatform.isLinux,
  x11Support ? true,
  # these are disabled because their deps are not available in ekapkgs
  ibusSupport ? false,
  jackSupport ? false,
  pipewireSupport ? false,
  pulseaudioSupport ? false,
}:

assert lib.assertMsg (
  waylandSupport -> openglSupport
) "SDL3 requires OpenGL support to enable Wayland";

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3";
  version = "3.2.12";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-CPCbbVbi0gwSUkaEBOQPJwCU2NN9Lex2Z4hqBfIjn+o=";
  };

  postPatch =
    # Tests timeout on Darwin
    lib.optionalString testSupport ''
      substituteInPlace test/CMakeLists.txt \
        --replace-fail 'set(noninteractive_timeout 10)' 'set(noninteractive_timeout 30)'
    ''
    + lib.optionalString waylandSupport ''
      substituteInPlace src/video/wayland/SDL_waylandmessagebox.c \
        --replace-fail '"zenity"' '"${lib.getExe zenity}"'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    validatePkgConfig
  ]
  ++ lib.optional waylandSupport wayland-scanner;

  buildInputs = finalAttrs.dlopenBuildInputs ++ lib.optional waylandSupport zenity;

  dlopenBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libusb1
    ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional dbusSupport dbus
    ++ lib.optionals drmSupport [
      libdrm
      libgbm
    ]
    ++ lib.optional libdecorSupport libdecor
    ++ lib.optional libudevSupport systemdLibs
    ++ lib.optional openglSupport libGL
    ++ lib.optionals waylandSupport [
      libxkbcommon
      wayland
    ]
    ++ lib.optionals x11Support [
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcursor
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
    ]
    ++ [
      libxcb
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optional (openglSupport && !stdenv.hostPlatform.isDarwin) libGL
    ++ lib.optional x11Support xorg.libX11;

  cmakeFlags = [
    (lib.cmakeBool "SDL_ALSA" alsaSupport)
    (lib.cmakeBool "SDL_DBUS" dbusSupport)
    (lib.cmakeBool "SDL_IBUS" ibusSupport)
    (lib.cmakeBool "SDL_JACK" jackSupport)
    (lib.cmakeBool "SDL_KMSDRM" drmSupport)
    (lib.cmakeBool "SDL_LIBUDEV" libudevSupport)
    (lib.cmakeBool "SDL_OPENGL" openglSupport)
    (lib.cmakeBool "SDL_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "SDL_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "SDL_SNDIO" sndioSupport)
    (lib.cmakeBool "SDL_TEST_LIBRARY" testSupport)
    (lib.cmakeBool "SDL_WAYLAND" waylandSupport)
    (lib.cmakeBool "SDL_WAYLAND_LIBDECOR" libdecorSupport)
    (lib.cmakeBool "SDL_X11" x11Support)

    (lib.cmakeBool "SDL_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = testSupport && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # See comment below. We actually *do* need these RPATH entries
  dontPatchELF = true;

  env = {
    # Many dependencies are not directly linked to, but dlopen()'d at runtime. Adding them to the RPATH
    # helps them be found
    NIX_LDFLAGS = lib.optionalString (
      stdenv.hostPlatform.hasSharedLibraries && stdenv.hostPlatform.extensions.sharedLibrary == ".so"
    ) "-rpath ${lib.makeLibraryPath (finalAttrs.dlopenBuildInputs)}";
  };

  meta = {
    description = "Cross-platform development library";
    homepage = "https://libsdl.org";
    changelog = "https://github.com/libsdl-org/SDL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "sdl3" ];
  };
})
