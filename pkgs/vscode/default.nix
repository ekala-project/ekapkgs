{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  srcOnly,
  stdenvNoCC,
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
      x86_64-linux = "sha256-0yAx6eIT1ZUyrzzzL8uLNXoc3RBBeWe09bW6MENtwNw=";
      aarch64-linux = "sha256-lgmnZVxLwqEBs0P/IqqR9meLRtlWW5FMBgi9fy5Xf6Y=";
    }
    .${system} or throwSystem;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.140.0";

  # The update server (update.code.visualstudio.com) expects the version path
  # segment in X.Y.Z form, so we normalize X.Y to X.Y.0 (e.g. "1.110" -> "1.110.0").
  downloadVersion = lib.versions.pad 3 version;

  # This is used for VS Code - Remote SSH test
  rev = "07f806f999227108933c2e30515b26eecc1fda74";
in
buildVscode {
  pname = "vscode";

  executableName = "code";
  longName = "Visual Studio Code";
  shortName = "Code";
  inherit
    version
    rev
    commandLineArgs
    useVSCodeRipgrep
    ;

  src = fetchurl {
    name = "VSCode_${downloadVersion}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${downloadVersion}/${plat}/stable";
    inherit hash;
  };

  sourceRoot = "";

  # As tests run without networking, we need to download this for the Remote SSH server
  vscodeServer = srcOnly {
    name = "vscode-server-${rev}.tar.gz";
    src = fetchurl {
      name = "vscode-server-${rev}.tar.gz";
      url = "https://update.code.visualstudio.com/commit:${rev}/server-linux-x64/stable";
      hash = "sha256-H2XuevLt4hUrTxvt94HqKCM0OBc+uYMaDz9yHF191qw=";
    };
    stdenv = stdenvNoCC;
  };

  hasVsceSign = true;

  meta = {
    description = "Code editor developed by Microsoft";
    mainProgram = "code";
    longDescription = ''
      Code editor developed by Microsoft. It includes support for debugging,
      embedded Git control, syntax highlighting, intelligent code completion,
      snippets, and code refactoring. It is also customizable, so users can
      change the editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://code.visualstudio.com/";
    downloadPage = "https://code.visualstudio.com/Updates";
    changelog = "https://code.visualstudio.com/updates/v${
      lib.replaceString "." "_" (lib.versions.majorMinor version)
    }";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
