{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iftop";
  version = "1.0pre4";

  src = fetchurl {
    url = "https://ex-parrot.com/pdw/iftop/download/iftop-${finalAttrs.version}.tar.gz";
    sha256 = "15sgkdyijb7vbxpxjavh5qm5nvyii3fqcg9mzvw7fx8s6zmfwczp";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/iftop/-/raw/750d49dd3fabc338586a86f5bb0a5b97a5ff5fa2/debian/patches/bug-debian-1096832-ftbfs-with-GCC-15.patch";
      hash = "sha256-BhjN7AZNCJCqrY2IAutUYYDZkLq+TD2YnKYZxHgVdYg=";
    })
  ];

  env.LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-lgcc_s";

  buildInputs = [
    ncurses
    libpcap
  ];

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    description = "Display bandwidth usage on a network interface";
    license = lib.licenses.gpl2Plus;
    homepage = "http://ex-parrot.com/pdw/iftop/";
    platforms = lib.platforms.unix;
    mainProgram = "iftop";
  };
})
