{
  lib,
  stdenv,
  fetchzip,
  libx11,
  libxinerama,
  libxft,
  writeText,
  pkg-config,
  config ? { },
  conf ? config.dwm.conf or null,
  patches ? config.dwm.patches or [ ],
  extraLibs ? config.dwm.extraLibs or [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwm";
  version = "6.8";

  src = fetchzip {
    url = "https://dl.suckless.org/dwm/dwm-${finalAttrs.version}.tar.gz";
    hash = "sha256-mkMFmqV9NVGTdDGqW8f+T7r0YQNU1KDsn6uRcacoNco=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isStatic pkg-config;

  buildInputs = [
    libx11
    libxinerama
    libxft
  ]
  ++ extraLibs;

  preBuild = ''
    makeFlagsArray+=(
      "PREFIX=$out"
      "CC=$CC"
      ${lib.optionalString stdenv.hostPlatform.isStatic ''
        LDFLAGS="$(''${stdenv.cc.targetPrefix}pkg-config --static --libs x11 xinerama xft)"
      ''}
    )
  '';

  inherit patches;

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.def.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  meta = {
    homepage = "https://dwm.suckless.org/";
    description = "Extremely fast, small, and dynamic window manager for X";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "dwm";
  };
})
