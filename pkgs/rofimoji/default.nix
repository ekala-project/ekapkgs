{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,

  waylandSupport ? true,
  x11Support ? true,

  wl-clipboard,
  wtype,
  xdotool,
  xsel,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rofimoji";
  version = "6.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    tag = finalAttrs.version;
    hash = "sha256-KOWj/u5JxgHiUf/hPBu+PfPgSRd/HVivU3F8oWqzIv4=";
  };

  nativeBuildInputs = [
    python3Packages.hatchling
    installShellFiles
  ];

  propagatedBuildInputs = [
    python3Packages.configargparse
  ]
  ++ lib.optionals waylandSupport [
    wl-clipboard
    wtype
  ]
  ++ lib.optionals x11Support [
    xdotool
    xsel
  ];

  # The 'extractors' sub-module is used for development
  # and has additional dependencies.
  postPatch = ''
    rm -rf extractors
  '';

  postInstall = ''
    installManPage src/picker/docs/rofimoji.1
  '';

  meta = {
    description = "Simple emoji and character picker for rofi";
    mainProgram = "rofimoji";
    homepage = "https://github.com/fdw/rofimoji";
    changelog = "https://github.com/fdw/rofimoji/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
