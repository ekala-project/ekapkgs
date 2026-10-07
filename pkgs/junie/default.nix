{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  autoPatchelfHook,
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

  nativeBuildInputs = [
    unzip
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # The bundled JRE contains modules for AWT/sound/etc that the CLI doesn't need.
  autoPatchelfIgnoreMissingDeps = [
    "libasound.so.2"
    "libfreetype.so.6"
    "libharfbuzz.so.0"
    "libgif.so.7"
    "libjpeg.so.8"
    "liblcms2.so.2"
    "libpng16.so.16"
    "libpcsclite.so.1"
    "libwayland-client.so.0"
    "libwayland-cursor.so.0"
    "libX11.so.6"
    "libXext.so.6"
    "libXi.so.6"
    "libXrender.so.1"
    "libXtst.so.6"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    zlib
  ];

  sourceRoot = ".";

  # Don't strip: the bundled JRE's jimage (lib/modules) gets corrupted.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
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
  )
  + ''
    runHook postInstall
  '';

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
