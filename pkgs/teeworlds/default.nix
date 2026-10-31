{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  python3,
  alsa-lib,
  libx11,
  libGLU,
  sdl2-compat,
  lua5_3,
  zlib,
  freetype,
  wavpack,
  icoutils,
  buildClient ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teeworlds";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "teeworlds";
    repo = "teeworlds";
    rev = finalAttrs.version;
    sha256 = "1l19ksmimg6b8zzjy0skyhh7z11ql7n5gvilkv7ay5x2b9ndbqwz";
    fetchSubmodules = true;
  };

  patches = [
    ./rename-VERSION-to-VERSION.txt.patch
    (fetchpatch {
      name = "CVE-2021-43518.patch";
      url = "https://salsa.debian.org/games-team/teeworlds/-/raw/a6c4b23c1ce73466e6d89bccbede70e61e8c9cba/debian/patches/CVE-2021-43518.patch";
      hash = "sha256-2MmsucaaYjqLgMww1492gNmHmvBJm/NED+VV5pZDnBY=";
    })
    (fetchpatch {
      url = "https://github.com/teeworlds/teeworlds/commit/23f33517b4b0621253862b559f6ed0cd0146bae2.patch";
      hash = "sha256-RZvq/my7N68Kea26WuzLmyaTNOm5eZL5Gw9SGYpTeoQ=";
    })
  ];

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace '#define DATA_DIR "data"' \
                '#define DATA_DIR "${placeholder "out"}/share/teeworlds/data"'

    rm -rf 'src/engine/external/wavpack/'
    rm -rf 'src/engine/external/zlib/'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ]
  ++ lib.optionals buildClient [
    icoutils
  ];

  buildInputs = [
    python3
    lua5_3
    zlib
    wavpack
  ]
  ++ lib.optionals buildClient [
    sdl2-compat
    freetype
    libGLU
    alsa-lib
    libx11
  ];

  cmakeFlags = [
    "-DCLIENT=${if buildClient then "ON" else "OFF"}"
  ];

  postInstall = lib.optionalString buildClient ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    icotool --extract --index 1 --output $out/share/icons/hicolor/256x256/apps/teeworlds.png $src/other/icons/teeworlds.ico

    install -D $src/other/teeworlds.desktop $out/share/applications/teeworlds.desktop
  '';

  meta = {
    broken = true; # build failure
    description = "Retro multiplayer shooter game";
    mainProgram = "teeworlds_srv";
    homepage = "https://teeworlds.com/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
