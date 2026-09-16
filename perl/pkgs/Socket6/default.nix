{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
  which,
}:
buildPerlPackage {
  pname = "Socket6";
  version = "0.29";
  src = fetchurl {
    url = "mirror://cpan/authors/id/U/UM/UMEMOTO/Socket6-0.29.tar.gz";
    hash = "sha256-RokV+joE3PZXT8lX7/SVkV4kVpQ0lwyR7o5OFFn8kRQ=";
  };
  setOutputFlags = false;
  nativeBuildInputs = [ which ];
  patches = [ ./Socket6-sv_undef.patch ];
  preConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace configure \
      --replace-fail 'cross_compiling=no' 'cross_compiling=yes;ipv6_cv_can_inet_ntop=yes'
  '';
  meta = {
    description = "IPv6 related part of the C socket.h defines and structure manipulators";
    license = lib.licenses.bsd3;
  };
}
