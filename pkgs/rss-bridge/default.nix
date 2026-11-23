{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rss-bridge";
  version = "2026-09-30";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    tag = finalAttrs.version;
    sha256 = "sha256-QHIfCe6bP/m+UTC5bZUh94fxM3gAtEvWDkf3MyaGb7I=";
  };

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru = {
    tests = {
    };
  };

  meta = {
    description = "RSS feed for websites missing it";
    homepage = "https://github.com/RSS-Bridge/rss-bridge";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
  };
})
