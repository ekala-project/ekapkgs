{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "font-awesome";
  version = "6.7.2";

  src = fetchFromGitHub {
    owner = "FortAwesome";
    repo = "Font-Awesome";
    rev = "6.7.2";
    hash = "sha256-MaJG96kYj8ukJVyqOTDpkHH/eWr/ZlbVKk9AvJM7ub4=";
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
