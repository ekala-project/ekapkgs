{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.7.4";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-LGyHjwCT8b9/tghngdLdkmnWUsAWuGk5wVfF8XKROaI=";
  };

  patches = [ ./no-resolve-symlinks.patch ];

  dontBuild = true;
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
    rm -rf $out/installer
  '';

  meta = {
    description = "Open Source Webmail Software";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    broken = true; # patch no-resolve-symlinks.patch fails to apply
  };
}
