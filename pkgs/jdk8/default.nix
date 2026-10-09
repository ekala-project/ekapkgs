{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib ? null,
  cups ? null,
  fontconfig ? null,
  freetype ? null,
  libx11,
  libxext,
  libXi,
  libxrender,
  libXtst,
  zlib,
}:

let
  version = "8u504b01";
  # Eclipse Temurin (Adoptium) OpenJDK 8. Some older toolchains (e.g. GWT
  # 2.6.1 in OpenTSDB) only run on Java 8; corepkgs' java scope starts at 11.
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u504b01.tar.gz";
      hash = "sha256-nHDhAvUnrGdKwv6cfUe5oE4tGYQrpauOmzPzaLut+uo=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/OpenJDK8U-jdk_aarch64_linux_hotspot_8u504b01.tar.gz";
      hash = "sha256-V7ftivnUhUK7Sf94lESAQLF76gpItBZ30R7K7GEpdo0=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openjdk8";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "jdk8: unsupported system ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    [
      zlib
      libx11
      libxext
      libXi
      libxrender
      libXtst
    ]
    ++ lib.optionals (alsa-lib != null) [ alsa-lib ]
    ++ lib.optionals (cups != null) [ cups ]
    ++ lib.optionals (fontconfig != null) [ fontconfig ]
    ++ lib.optionals (freetype != null) [ freetype ]
  );

  # AWT/Swing libraries are optional; ignore them if absent.
  autoPatchelfIgnoreMissingDeps = [
    "libXtst.so.6"
    "libXi.so.6"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r * $out/
    rm -rf $out/demo $out/sample || true
    runHook postInstall
  '';

  passthru = {
    home = finalAttrs.finalPackage;
    javaVersion = 8;
    # Temurin JDK 8 is a full JDK; its bundled JRE is the same tree.
    jre = finalAttrs.finalPackage;
    ekapkgs-update.skip = true;
  };

  meta = {
    description = "Eclipse Temurin OpenJDK 8 (Adoptium)";
    homepage = "https://adoptium.net/";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "java";
  };
})
