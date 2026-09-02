{
  fetchurl,
  lib,
  stdenv,
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acct";
  version = "6.6.4";

  src = fetchurl {
    url = "mirror://gnu/acct/acct-${finalAttrs.version}.tar.gz";
    sha256 = "0gv6m8giazshvgpvwbng98chpas09myyfw1zr2y7hqxib0mvy5ac";
  };

  doCheck = true;

  patches = [
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/psacct/raw/rawhide/f/psacct-6.6.4-sprintf-buffer-overflow.patch";
      hash = "sha256-l74tLIuhpXj+dIA7uAY9L0qMjQ2SbDdc+vjHMyVouFc=";
    })
    (fetchpatch2 {
      url = "https://salsa.debian.org/abower/acct/-/raw/7aeb2192d729bcd4583a75765add28c65a7fcf47/debian/patches/Fix-FTBFS-with-C23.patch";
      hash = "sha256-q1LtmhYopgSWIzIoONbKjgigIBU+LPvSvtUM3iL36c0=";
    })
  ];

  meta = {
    description = "GNU Accounting Utilities, login and process accounting utilities";
    license = lib.licenses.gpl3Plus;
    homepage = "https://www.gnu.org/software/acct/";
    platforms = lib.platforms.linux;
  };
})
