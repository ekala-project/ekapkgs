{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  versionData = {
    version = "0.230.0";
    droid = {
      aarch64-darwin = "sha256-AE+0jlMoFGSvn01RcBtIHwoZrrTuh22p92i3ACCkEN0=";
      x86_64-linux = "sha256-VHAu3/1IZO+yHoUcz3dw+0PArBc1swmlL3jhpgcMPms=";
      aarch64-linux = "sha256-uYTxtchf5cBYeWK+NV70EF8/WbXNa9C8AcWSProThJ4=";
    };
    ripgrep = {
      aarch64-darwin = "sha256-Jz6MZQpCvuwShJEOGCW2Gj5698DOH87BN/4dbMcd77c=";
      x86_64-linux = "sha256-viR2yXY0K5IWYRtKhMG8LsZIjsXHkeoBmhMnJ2RO8Zw=";
      aarch64-linux = "sha256-Js5szrF6xxDuclPEnqglxhjU+eSaE11StO3OM2xA9iA=";
    };
  };
  inherit (versionData) version;

  platformMap = {
    x86_64-linux = "linux/x64";
    aarch64-linux = "linux/arm64";
    aarch64-darwin = "darwin/arm64";
  };

  platformPath =
    platformMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "droid";
  inherit version;

  src = fetchurl {
    url = "https://downloads.factory.ai/factory-cli/releases/${version}/${platformPath}/droid";
    hash = versionData.droid.${stdenv.hostPlatform.system};
  };

  rgSrc = fetchurl {
    url = "https://downloads.factory.ai/ripgrep/${platformPath}/rg";
    hash = versionData.ripgrep.${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/factory
    install -Dm755 $src $out/bin/droid
    install -Dm755 $rgSrc $out/lib/factory/rg

    wrapProgram $out/bin/droid \
      --prefix PATH : $out/lib/factory

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Factory AI's Droid - AI-powered development agent for your terminal";
    homepage = "https://factory.ai";
    changelog = "https://docs.factory.ai/changelog/cli-updates";
    downloadPage = "https://factory.ai/product/ide";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "droid";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
