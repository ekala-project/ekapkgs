{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  autoPatchelfHook,
  alsa-lib,
  freetype,
  giflib,
  harfbuzz,
  lcms2,
  libjpeg,
  libpng,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  pcsclite,
  wayland,
  zlib,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "3419.22";

  platformMap = {
    x86_64-linux = "linux-amd64";
    aarch64-linux = "linux-aarch64";
    aarch64-darwin = "macos-aarch64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "junie: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-yYt3MDYEbRdubmUPdFqqjq8LHtC99OeumWUR00GhLig=";
    aarch64-linux = "sha256-IkASLPuEW+g12K6r7euj5BgAHGDwL1xrG/5zfJOr6vA=";
    aarch64-darwin = "sha256-rkK/o12/wb/pKZs00p0xfLI00XwTanJgZLKPDpZBfWs=";
  };
in
stdenv.mkDerivation {
  pname = "junie";
  inherit version;

  src = fetchurl {
    url = "https://github.com/JetBrains/junie/releases/download/${version}/junie-release-${version}-${platform}.zip";
    hash = hashes.${system};
  };

  nativeBuildInputs = [ unzip makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    freetype
    giflib
    harfbuzz
    lcms2
    libjpeg
    libpng
    libx11
    libxext
    libxi
    libxrender
    libxtst
    pcsclite
    stdenv.cc.cc.lib
    wayland
    zlib
  ];

  sourceRoot = ".";

  # Don't strip: the bundled JRE's jimage (lib/modules) gets corrupted.
  dontStrip = true;

  installPhase =
    ''
      mkdir -p $out/bin
    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -R Applications/junie.app $out/Applications/
          makeWrapper $out/Applications/junie.app/Contents/MacOS/junie $out/bin/junie
        ''
      else
        # Linux archive is a plain jpackage app-image: junie-app/{bin,lib}.
        ''
          mkdir -p $out/opt
          cp -r junie-app $out/opt/junie
          ln -s $out/opt/junie/bin/junie $out/bin/junie
        ''
    );

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  # OpenJDK resolves user.home via getpwuid() and ignores $HOME; in the Nix
  # sandbox that path is unusable, so point it at a scratch dir.
  versionCheckKeepEnvironment = [ "JAVA_TOOL_OPTIONS" ];
  preVersionCheck = ''
    export JAVA_TOOL_OPTIONS="-Duser.home=$(mktemp -d)"
  '';

  meta = {
    description = "Junie, JetBrains AI coding agent CLI";
    homepage = "https://github.com/JetBrains/junie";
    changelog = "https://github.com/JetBrains/junie/releases/tag/${version}";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "junie";
  };
}
