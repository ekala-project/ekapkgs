{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  libtsm,
  systemdLibs,
  libxkbcommon,
  libdrm,
  libGLU,
  libGL,
  freetype,
  fontconfig,
  zlib,
  pango,
  pkg-config,
  docbook_xsl,
  docbook_xml_dtd_42,
  python3,
  ncurses,
  libxslt,
  libgbm,
  seatd,
  ninja,
  check,
  bash,
  gawk,
  inotify-tools,
  buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kmscon";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "kmscon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3830e1GzzLT2fhheWwNRkURzYkHv4k8uEMoCqKkjJY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libGLU
    libGL
    libdrm
    libtsm
    libxkbcommon
    freetype
    fontconfig
    zlib
    pango
    systemdLibs
    libgbm
    seatd
    check
    # Needed for autoPatchShebangs when strictDeps = true
    bash
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    docbook_xsl
    pkg-config
    libxslt # xsltproc
    docbook_xml_dtd_42
    python3
    ncurses
  ];

  outputs = [
    "out"
    "man"
  ];

  env = {
    PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
    DESTDIR = "/";
  };

  postPatch = ''
    patchShebangs scripts/terminfo
  '';

  postFixup = ''
    substituteInPlace $out/bin/kmscon \
      --replace-fail "awk" "${lib.getExe gawk}"
    substituteInPlace $out/bin/kmscon-launch-gui \
      --replace-fail "inotifywait" "${lib.getExe' inotify-tools "inotifywait"}"
  '';

  meta = {
    description = "KMS/DRM based System Console";
    mainProgram = "kmscon";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/";
    changelog = "https://github.com/kmscon/kmscon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
