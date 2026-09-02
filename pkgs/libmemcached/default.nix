{
  lib,
  stdenv,
  fetchurl,
  cyrus_sasl,
  libevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmemcached";
  version = "1.0.18";

  src = fetchurl {
    url = "https://launchpad.net/libmemcached/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.version}/+download/libmemcached-${finalAttrs.version}.tar.gz";
    sha256 = "10jzi14j32lpq0if0p9vygcl2c1352hwbywzvr9qzq7x6aq0nb72";
  };

  buildInputs = [ libevent ];
  propagatedBuildInputs = [ cyrus_sasl ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  meta = {
    homepage = "https://libmemcached.org";
    description = "Open source C/C++ client library and tools for the memcached server";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
