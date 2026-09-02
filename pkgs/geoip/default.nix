{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geoip";
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoip-api-c";
    rev = "v${finalAttrs.version}";
    sha256 = "0ixyp3h51alnncr17hqp1p0rlqz9w69nlhm60rbzjjz3vjx52ajv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "API for GeoIP/Geolocation databases";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    homepage = "https://www.maxmind.com";
  };
})
