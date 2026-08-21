{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libcap_ng,
  libnl,
  lz4,
  lzo,
  openssl,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openvpn";
  version = "2.6.19";

  src = fetchurl {
    url = "https://swupdate.openvpn.net/community/releases/openvpn-${finalAttrs.version}.tar.gz";
    hash = "sha256-E3AlJvaHwYslQMGj8uGJGHuqplIR7c9/9ncvpp8FNs8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    lz4
    lzo
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    libnl
    pam
  ];

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-plugin-auth-pam"
  ];

  postInstall = ''
    mkdir -p $out/share/doc/openvpn/examples
    cp -r sample/sample-{config-files,keys,scripts}/ $out/share/doc/openvpn/examples
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Robust and highly flexible tunneling application";
    homepage = "https://openvpn.net/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "openvpn";
    platforms = lib.platforms.unix;
  };
})
