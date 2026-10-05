{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "1.1.65";

  platforms = {
    x86_64-linux = {
      url = "https://qoder-ide.oss-accelerate.aliyuncs.com/qodercli/releases/${version}/qodercli-linux-x64.tar.gz";
      hash = "sha256-tJ67ucgSdXhQBHoghPKYU/bC4kLJC6+NDAM5axoh/Iw=";
    };
    aarch64-linux = {
      url = "https://qoder-ide.oss-accelerate.aliyuncs.com/qodercli/releases/${version}/qodercli-linux-arm64.tar.gz";
      hash = "sha256-0As54fsv4iKxVoU7cOA1XCj9XhPvUeMVnOqM9i+T80k=";
    };
    aarch64-darwin = {
      url = "https://qoder-ide.oss-accelerate.aliyuncs.com/qodercli/releases/${version}/qodercli-darwin-arm64.tar.gz";
      hash = "sha256-jNcjEbD+pJeLOs8GtkMQNygLcX4XXcCmIxvSzwbTl+4=";
    };
  };

  system = stdenv.hostPlatform.system;
  source = platforms.${system} or (throw "qoder-cli: unsupported system ${system}");
in
stdenv.mkDerivation {
  pname = "qoder-cli";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  sourceRoot = ".";

  # bun-compiled binary: stripping corrupts the embedded bytecode.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 qodercli $out/bin/qodercli
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Qoder AI CLI - terminal-based AI assistant for code development";
    homepage = "https://qoder.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "qodercli";
  };
}
