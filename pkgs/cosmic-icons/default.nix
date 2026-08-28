{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  pop-icon-theme,
  hicolor-icon-theme,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmic-icons";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-QUTAYIQ6qAhjZK/9BZjJzTViECLUwO/MyaOqiRb1Ans=";
  };

  strictDeps = true;

  nativeBuildInputs = [ just ];

  propagatedBuildInputs = [
    pop-icon-theme
    hicolor-icon-theme
  ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  dontDropIconThemeCache = true;

  meta = {
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ ];
  };
})
