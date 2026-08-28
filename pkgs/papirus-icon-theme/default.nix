{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "papirus-icon-theme";
  version = "20250501";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    tag = finalAttrs.version;
    hash = "sha256-KbUjHmNzaj7XKj+MOsPM6zh2JI+HfwuXvItUVAZAClk=";
  };

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv Papirus* $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Pixel perfect icon theme for Linux";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
