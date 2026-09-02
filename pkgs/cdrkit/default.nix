{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  libcap,
  zlib,
  bzip2,
  perl,
  quilt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdrkit";
  version = "1.1.11-4";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "cdrkit";
    rev = "debian/9%${finalAttrs.version}";
    hash = "sha256-oOqvSA2MAURf0YOrWM5Ft6Ln43gXw7SEvNxxRrDs8sI=";
  };

  patches = [
    ./cmake-4.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    quilt
  ];

  buildInputs = [
    zlib
    bzip2
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=int-conversion"
    ]
  );

  postPatch = ''
    QUILT_PATCHES=debian/patches quilt push -a
  '';

  postInstall = ''
    ln -s $out/bin/genisoimage $out/bin/mkisofs
    ln -s $out/bin/wodim $out/bin/cdrecord
  '';

  makeFlags = [ "PREFIX=\$(out)" ];

  meta = {
    description = "Portable command-line CD/DVD recorder software, mostly compatible with cdrtools";
    homepage = "http://cdrkit.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
