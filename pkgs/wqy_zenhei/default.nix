{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wqy-zenhei";
  version = "0.9.45";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/wqy-zenhei-${finalAttrs.version}.tar.gz";
    hash = "sha256-5LfjBkdb+UJ9F1dXjw5FKJMMhMROqj8WfUxC8RDuddY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 wqy-zenhei.ttc $out/share/fonts/wqy-zenhei.ttc

    runHook postInstall
  '';

  meta = {
    description = "Chinese Unicode font with full CJK coverage";
    homepage = "http://wenq.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
})
