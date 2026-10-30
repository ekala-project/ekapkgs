{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpmyadmin";
  version = "5.2.1";

  src = fetchurl {
    url = "https://files.phpmyadmin.net/phpMyAdmin/${finalAttrs.version}/phpMyAdmin-${finalAttrs.version}-all-languages.tar.xz";
    hash = "sha256-Nz+Vmd+9ltb+dTFtXa0YnmjDBfKX7fQjd9ud1rQbJVc=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/phpmyadmin
    cp -r * $out/share/phpmyadmin/
    runHook postInstall
  '';

  meta = {
    description = "Web interface for MySQL and MariaDB administration";
    homepage = "https://www.phpmyadmin.net/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
