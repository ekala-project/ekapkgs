{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paperkey";
  version = "1.6";

  src = fetchurl {
    url = "https://www.jabberwocky.com/software/paperkey/paperkey-${finalAttrs.version}.tar.gz";
    sha256 = "1xq5gni6gksjkd5avg0zpd73vsr97appksfx0gx2m38s4w9zsid2";
  };

  postPatch = ''
    for a in checks/*.sh ; do
      substituteInPlace $a \
        --replace /bin/echo echo
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Store OpenPGP or GnuPG on paper";
    mainProgram = "paperkey";
    homepage = "https://www.jabberwocky.com/software/paperkey/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
