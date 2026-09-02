{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freetds";
  version = "1.5.18";

  src = fetchurl {
    url = "https://www.freetds.org/files/stable/freetds-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ayyLk7nufIOFXa90XeWHh5ADLxTbruVT2DqdIRuE3Us=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage = "https://www.freetds.org";
    changelog = "https://github.com/FreeTDS/freetds/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.all;
  };
})
