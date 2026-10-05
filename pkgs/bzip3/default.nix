{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bzip3";
  version = "1.5.4";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "iczelia";
    repo = "bzip3";
    tag = finalAttrs.version;
    hash = "sha256-uLL87HbohLNTm+Pq96iNlN+zqjG/bxCV7BJk1H7DvgY=";
  };

  postPatch = ''
    echo -n "${finalAttrs.version}" > .tarball-version
    patchShebangs build-aux

    # build-aux/ax_subst_man_date.m4 calls git if the file exists
    rm .gitignore
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--disable-arch-native"
  ];

  meta = {
    description = "Better and stronger spiritual successor to BZip2";
    homepage = "https://github.com/iczelia/bzip3";
    changelog = "https://github.com/iczelia/bzip3/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
