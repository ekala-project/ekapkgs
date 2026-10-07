{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smarty3";
  version = "5.8.5";

  src = fetchFromGitHub {
    owner = "smarty-php";
    repo = "smarty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MKLrToUVpLDWH9UkwtnAlYyPY2ow7TskITQKNRLGXjc=";
  };

  installPhase = ''
    mkdir $out
    cp -r libs/* $out
  '';

  meta = {
    description = "Smarty 3 template engine";
    longDescription = ''
      Smarty is a template engine for PHP, facilitating the
      separation of presentation (HTML/CSS) from application
      logic. This implies that PHP code is application
      logic, and is separated from the presentation.
    '';
    homepage = "https://www.smarty.net";
    license = lib.licenses.lgpl21Plus;
  };
})
