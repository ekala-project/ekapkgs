{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mediawiki";
  version = "1.45.4";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-y3yCRGjrWlEacvCOYpHQncivEuCg/9wlMu4/drsMrXw=";
  };

  postPatch = ''
    substituteInPlace includes/installer/CliInstaller.php \
      --replace-fail '$vars = Installer::getExistingLocalSettings();' '$vars = null;'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mediawiki
    cp -r * $out/share/mediawiki
    echo "<?php
      return require(getenv('MEDIAWIKI_CONFIG'));
    ?>" > $out/share/mediawiki/LocalSettings.php

    runHook postInstall
  '';

  passthru.tests = {
  };

  meta = {
    description = "Collaborative editing software that runs Wikipedia";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = lib.platforms.all;
  };
}
