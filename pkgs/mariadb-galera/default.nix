{
  lib,
  stdenv,
  fetchFromGitHub,
  asio_1_32_0 ? null,
  boost,
  check ? null,
  openssl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mariadb-galera";
  version = "26.4.27";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "galera";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-Z1UtNM7HPcbFMr35JVJZCxPl43ZQxy+eBkiQFoVmFhY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    asio_1_32_0
    boost.dev
    check
    openssl
  ];

  preConfigure = ''
    rm -r asio/{asio,asio.hpp}
  '';

  postInstall = ''
    mkdir $out/lib/galera
    ln -s $out/lib/libgalera_smm.so $out/lib/galera/libgalera_smm.so
  '';

  meta = {
    description = "Galera 3 wsrep provider library";
    mainProgram = "garbd";
    homepage = "https://galeracluster.com/";
    license = lib.licenses.lgpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
