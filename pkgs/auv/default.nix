{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  leptonica,
  libxkbcommon,
  pipewire,
  tesseract,
  versionCheckHook,
}:

let
  version = "0.0.20";

  platformMap = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system for auv: ${stdenv.hostPlatform.system}");

  hashes = {
    x86_64-linux = "sha256-5+VZFQt6CLyDuL42PWz8mGuV/8aqYLX881A+0IogGOM=";
    aarch64-linux = "sha256-JUNKF/esjntXWbfnNJv7Smb0swzFiUE6T1aygTOTVOA=";
    aarch64-darwin = "sha256-E03tdArJnWnZJzy3y823kLydv+VuuQ3/lnL7gs49f1U=";
  };

  leptonicaSonameAlias = stdenvNoCC.mkDerivation {
    pname = "leptonica-liblept-soname-alias";
    inherit (leptonica) version;
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      ln -s ${lib.getLib leptonica}/lib/libleptonica.so.6 $out/lib/liblept.so.5
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  pname = "auv";
  inherit version;

  src = fetchurl {
    url = "https://github.com/moeru-ai/auv/releases/download/v${version}/auv-${platform}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    leptonica
    leptonicaSonameAlias
    libxkbcommon
    pipewire
    tesseract
    stdenv.cc.cc.lib
  ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 auv $out/bin/auv
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Scriptable computer-use automation CLI that turns GUI operations into reusable commands";
    homepage = "https://github.com/moeru-ai/auv";
    changelog = "https://github.com/moeru-ai/auv/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "auv";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
