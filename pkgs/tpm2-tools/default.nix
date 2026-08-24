{
  stdenv,
  fetchurl,
  lib,
  pkg-config,
  makeWrapper,
  curl,
  openssl,
  tpm2-tss,
  libuuid,
}:

stdenv.mkDerivation rec {
  pname = "tpm2-tools";
  version = "5.7.1";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-C3AcgO50tyQGipuBmhBiQQtO8ai0ro29F4UIJWe0qUc=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    curl
    openssl
    tpm2-tss
    libuuid
  ];

  preFixup =
    let
      ldLibraryPath = lib.makeLibraryPath [
        tpm2-tss
      ];
    in
    ''
      wrapProgram $out/bin/tpm2 --suffix LD_LIBRARY_PATH : "${ldLibraryPath}"
      wrapProgram $out/bin/tss2 --suffix LD_LIBRARY_PATH : "${ldLibraryPath}"
    '';

  # Unit tests disabled, as they rely on a dbus session
  doCheck = false;

  meta = {
    description = "Command line tools that provide access to a TPM 2.0 compatible device";
    homepage = "https://github.com/tpm2-software/tpm2-tools";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
