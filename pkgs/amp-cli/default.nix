{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.0.1790798464-g1c0876";

  platformMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };

  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "amp-cli: unsupported system ${system}");

  hashes = {
    x86_64-linux = "sha256-11xR1x4pZ1x24/kc1MuKvYwPRcRhK7GGOtEmuFBT894=";
    aarch64-linux = "sha256-aX5Y5lzQMhCfNHrRLffPQx+40XIvGixyX7x+tSfdhaM=";
    aarch64-darwin = "sha256-bMP4plkxwG8IlJ/i448hfJiUx6b4S6uSXoqVfuucO+U=";
  };
in
stdenv.mkDerivation {
  pname = "amp-cli";
  inherit version;

  src = fetchurl {
    url = "https://static.ampcode.com/cli/${version}/amp-${platform}";
    hash = hashes.${system};
  };

  dontUnpack = true;
  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/amp
    runHook postInstall
  '';

  # TODO(corepkgs): add ripgrep to the runtime PATH
  postFixup = ''
    wrapProgram $out/bin/amp \
      --argv0 amp \
      --set AMP_SKIP_UPDATE_CHECK 1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "CLI for Amp, an agentic coding tool from Sourcegraph";
    homepage = "https://ampcode.com/";
    changelog = "https://ampcode.com/chronicle";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "amp";
  };
}
