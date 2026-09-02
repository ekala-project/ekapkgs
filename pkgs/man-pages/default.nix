{
  lib,
  stdenv,
  fetchurl,
  groff,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "man-pages";
  version = "6.18";

  outputs = [
    "man"
    "out"
  ];

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-${finalAttrs.version}.tar.xz";
    hash = "sha256-yTT63ItZdIxoIno09lgdLd+Cgrc83NUlRsjNiLdLJNE=";
  };

  postPatch = ''
    substituteInPlace man/man7/man.7 \
      --replace-fail '.so man7/groff_man.7' '.so ${lib.getMan groff}/share/man/man7/groff_man.7'
  '';

  dontBuild = true;
  enableParallelInstalling = true;

  makeFlags = [
    "-R"
    "VERSION=${finalAttrs.version}"
    "prefix=${placeholder "out"}"
    "bindir=${placeholder "out"}/bin"
    "mandir=${placeholder "man"}/share/man"
  ];

  preConfigure = ''
    export DISTDATE="$(date --utc --date="@$SOURCE_DATE_EPOCH")"
  '';

  meta = {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    outputsToInstall = [ "man" ];
    priority = 30;
  };
})
