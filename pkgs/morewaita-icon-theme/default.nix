{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  adwaita-icon-theme,
  gtk3,
  xdg-utils,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "morewaita-icon-theme";
  version = "49";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DxZ7XnIIF3EKGMPXahD+aHp6lCLRmrnywn7+qWCVflo=";
  };

  postPatch = ''
    patchShebangs install.sh
  '';

  nativeBuildInputs = [
    gtk3
    xdg-utils
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
  ];

  installPhase = ''
    runHook preInstall

    THEMEDIR="$out/share/icons/MoreWaita" ./install.sh

    runHook postInstall
  '';

  meta = {
    description = "Adwaita style extra icons theme for Gnome Shell";
    homepage = "https://github.com/somepaulo/MoreWaita";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
