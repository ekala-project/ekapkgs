{
  lib,
  stdenv,
  fetchFromGitHub,
  scons,
  pkg-config,
  perl,
  gettext,
  installShellFiles,
  vulkan-loader,
  libGL,
  alsa-lib,
  dbus,
  fontconfig,
  freetype,
  glslang,
  libtheora,
  libwebp,
  mbedtls,
  miniupnpc,
  openxr-loader,
  pcre2,
  zstd,
  enet,
  libjpeg_turbo,
  sdl3,
  libpulseaudio,
  speechd,
  glib,
  udev,
  libxkbcommon,
  libx11,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libdecor,
  wayland,
  wayland-scanner,
  withAlsa ? true,
  withDbus ? true,
  withFontconfig ? true,
  withPulseaudio ? true,
  withSpeechd ? true,
  withTouch ? true,
  withUdev ? true,
  withWayland ? true,
  withX11 ? true,
}:
let
  version = "4.7.2-stable";

  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (
    k: v: if builtins.isString v then "${k}=${v}" else "${k}=${builtins.toJSON v}"
  );

  arch = stdenv.hostPlatform.linuxArch;

  binary = lib.concatStringsSep "." [
    "godot"
    "linuxbsd"
    "editor"
    arch
  ];
in
stdenv.mkDerivation {
  __structuredAttrs = true;

  pname = "godot";
  inherit version;

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    tag = version;
    hash = "sha256-RyUaOUkE6rYQcn1KKRY2GQ4vj8Gs7N24EJ+vU13meJE=";
    leaveDotGit = true;
    postFetch = ''
      hash=$(git -C "$out" rev-parse HEAD)
      rm -r "$out"/.git
      mkdir "$out"/.git
      echo "$hash" > "$out"/.git/HEAD
    '';
  };

  outputs = [
    "out"
    "man"
  ];
  separateDebugInfo = true;

  env = {
    BUILD_NAME = "ekapkgs";
  };

  sconsFlags = mkSconsFlagsFromAttrSet {
    precision = "single";
    production = true;
    platform = "linuxbsd";
    target = "editor";
    debug_symbols = true;

    alsa = withAlsa;
    dbus = withDbus;
    fontconfig = withFontconfig;
    pulseaudio = withPulseaudio;
    speechd = withSpeechd;
    touch = withTouch;
    udev = withUdev;
    wayland = withWayland;
    x11 = withX11;

    module_mono_enabled = false;

    ccflags = "-fno-strict-aliasing";
    linkflags = "-Wl,--build-id";

    # Use builtin for libraries not available or needing special overrides
    builtin_msdfgen = true;
    builtin_rvo2_2d = true;
    builtin_rvo2_3d = true;
    builtin_xatlas = true;
    builtin_clipper2 = true;
    builtin_embree = true;
    builtin_recastnavigation = true;
    builtin_wslay = true;
    # Harfbuzz in ekapkgs lacks withRaster/withCairo needed for godot 4.7
    builtin_harfbuzz = true;
    builtin_icu4c = true;
    builtin_graphite = true;

    use_sowrap = false;
    redirect_build_objects = false;
  };


  strictDeps = true;

  postPatch = ''
    # Allow scons to see NIX env vars like NIX_CFLAGS_COMPILE
    perl -pi -e '{ $r += s:(env = Environment\(.*):\1\nenv["ENV"] = os.environ: } END { exit ($r != 1) }' SConstruct

    # Disable all builtin libraries by default; we selectively re-enable via sconsFlags
    perl -pi -e '{ $r |= s:(opts.Add\(BoolVariable\("builtin_.*, )True(\)\)):\1False\2: } END { exit ($r != 1) }' SConstruct

    substituteInPlace thirdparty/glad/egl.c \
      --replace-fail \
        'static const char *NAMES[] = {"libEGL.so.1", "libEGL.so"}' \
        'static const char *NAMES[] = {"${lib.getLib libGL}/lib/libEGL.so"}'

    substituteInPlace thirdparty/glad/gl.c \
      --replace-fail \
        'static const char *NAMES[] = {"libGLESv2.so.2", "libGLESv2.so"}' \
        'static const char *NAMES[] = {"${lib.getLib libGL}/lib/libGLESv2.so"}'

    substituteInPlace thirdparty/glad/gl{,x}.c \
      --replace-fail \
        '"libGL.so.1"' \
        '"${lib.getLib libGL}/lib/libGL.so"'

    substituteInPlace thirdparty/volk/volk.c \
      --replace-fail \
        'dlopen("libvulkan.so.1"' \
        'dlopen("${lib.getLib vulkan-loader}/lib/libvulkan.so"'
  '';

  nativeBuildInputs = [
    gettext
    installShellFiles
    perl
    pkg-config
    scons
  ]
  ++ lib.optionals withWayland [ wayland-scanner ];

  buildInputs = [
    enet
    freetype
    glslang
    libtheora
    libwebp
    mbedtls
    miniupnpc
    openxr-loader
    pcre2
    zstd
    libjpeg_turbo
    sdl3
  ]
  ++ lib.optional withAlsa alsa-lib
  ++ lib.optional (withX11 || withWayland) libxkbcommon
  ++ lib.optionals withX11 [
    libx11
    libxcursor
    libxext
    libxfixes
    libxi
    libxinerama
    libxrandr
    libxrender
  ]
  ++ lib.optionals withWayland [
    libdecor
    wayland
  ]
  ++ lib.optionals withDbus [
    dbus
  ]
  ++ lib.optionals withFontconfig [
    fontconfig
  ]
  ++ lib.optional withPulseaudio libpulseaudio
  ++ lib.optionals withSpeechd [
    speechd
    glib
  ]
  ++ lib.optional withUdev udev;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,libexec}
    cp -r bin/${binary} "$out"/libexec/

    cd "$out"/bin
    ln -s ../libexec/${binary} godot${lib.versions.majorMinor version}
    ln -s godot${lib.versions.majorMinor version} godot${lib.versions.major version}
    ln -s godot${lib.versions.major version} godot
    cd -

    installManPage misc/dist/linux/godot.6

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop \
      "$out/share/applications/org.godotengine.Godot${lib.versions.majorMinor version}.desktop"

    substituteInPlace "$out/share/applications/org.godotengine.Godot${lib.versions.majorMinor version}.desktop" \
      --replace-fail "Exec=godot" "Exec=$out/bin/godot" \
      --replace-fail "Godot Engine" "Godot Engine ${lib.versions.majorMinor version}"

    cp misc/logo/icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp misc/logo/icon.png "$out/share/icons/godot.png"

    runHook postInstall
  '';

  requiredSystemFeatures = [
    "big-parallel"
  ];

  meta = {
    changelog = "https://github.com/godotengine/godot/releases/tag/${version}";
    description = "Free and Open Source 2D and 3D game engine";
    homepage = "https://godotengine.org";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
    ];
    mainProgram = "godot";
  };
}
