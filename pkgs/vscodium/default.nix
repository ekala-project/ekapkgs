{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  commandLineArgs ? "",
  useVSCodeRipgrep ? false,
}:

let
  buildVscode = callPackage ../../build-support/vscode/generic.nix { };

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
    }
    .${system} or throwSystem;

  archive_fmt = "tar.gz";

  hash =
    {
      x86_64-linux = "sha256-rfNUjfBV0Y5HbN7oh0iLp0hrh5rZmjGlRsa1xf8pbCQ=";
      aarch64-linux = "sha256-c9h9RtTcII/hLASX3GB6qwpuK/My9UoLaCajoaoyvDQ=";
    }
    .${system} or throwSystem;

  sourceRoot = ".";

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.126.04524";
  vscodeVersion = "1.126.0";
in
buildVscode {
  inherit sourceRoot commandLineArgs useVSCodeRipgrep vscodeVersion;

  pname = "vscodium";
  inherit version;

  executableName = "codium";
  longName = "VSCodium";
  shortName = "vscodium";

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
    inherit hash;
  };

  meta = {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS (VS Code without MS branding/telemetry/licensing)
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/VSCodium/vscodium";
    downloadPage = "https://github.com/VSCodium/vscodium/releases";
    changelog = "https://github.com/VSCodium/vscodium/releases/tag/${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "codium";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    # requires libc.so.6 and other glibc specifics
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isGnu;
  };
}
