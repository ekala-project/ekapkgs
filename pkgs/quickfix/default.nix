{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickfix";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "quickfix";
    repo = "quickfix";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IVf7IxK/orqlI2RF8toJ6V0AuACpS78nHcDeR+CwK8c=";
  };

  # autoreconfHook does not work
  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace bootstrap --replace-fail glibtoolize libtoolize
  '';

  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    description = "C++ Fix Engine Library";
    homepage = "http://www.quickfixengine.org";
    license = lib.licenses.free; # similar to BSD 4-clause
    broken = stdenv.hostPlatform.isAarch64;
  };
})
