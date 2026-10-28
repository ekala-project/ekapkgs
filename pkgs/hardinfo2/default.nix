{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glslang,
  pkg-config,
  libsForQt5,
  makeWrapper,
  gtk4,
  cups,
  gtk3,
  json-glib,
  lerc,
  libdatrie,
  libdecor,
  libepoxy,
  libnghttp2 ? null,
  libpsl,
  libselinux,
  libsepol,
  libsoup_3,
  libsysprof-capture,
  libthai,
  libxkbcommon,
  libxdmcp,
  libxtst,
  pcre2,
  sqlite,
  util-linux,
  vulkan-headers,
  wayland,
  # runtime
  dmidecode,
  gawk,
  iperf,
  mesa-demos,
  sysbench,
  udisks,
  vulkan-tools,
  xdg-utils,
  xrandr,

  printingSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hardinfo2";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "hardinfo2";
    repo = "hardinfo2";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-rrb7iwR5kd7kJSncbE+yzdG55L7IaF7919kLsl/A5pY=";
  };

  patches = [
    ./remove-update.patch
    ./default-no-theme.patch
  ];

  # fix absolute path for xdg-open
  postPatch = ''
    substituteInPlace deps/sysobj_early/gui/uri_handler.c \
      --replace-fail /usr/bin/xdg-open "${lib.getExe' xdg-utils "xdg-open"}"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    glslang
    gtk4.wrapGAppsHook
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    json-glib
    lerc
    libdatrie
    libdecor
    libepoxy
    libnghttp2
    libpsl
    libselinux
    libsepol
    libsoup_3
    libsysprof-capture
    libthai
    libxkbcommon
    pcre2
    sqlite
    util-linux
    libxdmcp
    libxtst
    vulkan-headers
    wayland
  ];

  hardeningDisable = [ "fortify" ];

  cmakeEntries = {
    CMAKE_INSTALL_DATAROOTDIR = "$(out)/share";
    CMAKE_INSTALL_SERVICEDIR = "$(out)/lib";
  };

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  runtimeDeps = [
    # system stats
    dmidecode
    mesa-demos # glxinfo + vkgears for benchmark

    # display info
    vulkan-tools # vulkaninfo
    xrandr

    # additional tooling for benchmarks
    gawk
    iperf
    sysbench
    udisks
  ];

  runtimeLibs = lib.optionals printingSupport [ cups ];

  postFixup = ''
    wrapProgram $out/bin/hardinfo2 \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.runtimeLibs}

      substituteInPlace $out/lib/systemd/system/hardinfo2.service \
        --replace-fail "ExecStart=/usr/bin/hwinfo2_fetch_sysdata" "ExecStart=$out/bin/hwinfo2_fetch_sysdata"
  '';

  meta = {
    description = "System information and benchmarks for Linux systems";
    homepage = "http://www.hardinfo2.org/";
    downloadPage = "https://github.com/hardinfo2/hardinfo2/";
    changelog = "https://github.com/hardinfo2/hardinfo2/releases/tag/release-${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "hardinfo2";
  };
})
