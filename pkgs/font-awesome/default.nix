{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "font-awesome";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "FortAwesome";
    repo = "Font-Awesome";
    rev = "7.3.1";
    hash = "sha256-FQ2XvDi2JQ/XR8xgy3f8uJnsQW/lF0/IehCJvSHS1Y4=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Font Awesome - OTF font";
    homepage = "https://fontawesome.com/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
