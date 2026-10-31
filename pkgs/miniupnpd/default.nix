{
  stdenv,
  lib,
  fetchurl,
  iptables,
  libuuid,
  linuxHeaders,
  openssl,
  pkg-config,
  which,
  iproute2,
  gnused,
  coreutils,
  gnugrep,
  gawk,
  makeWrapper,
  firewall ? "iptables",
  nftables,
  libmnl,
  libnftnl,
}:

let
  scriptBinEnv =
    lib.makeBinPath
      {
        iptables = [
          coreutils
          which
          iproute2
          iptables
          gnused
          gnugrep
          gawk
        ];
        nftables = [
          coreutils
          which
          nftables
        ];
      }
      .${firewall};
in
stdenv.mkDerivation rec {
  pname = "miniupnpd";
  version = "2.3.10";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/miniupnpd-${version}.tar.gz";
    sha256 = "sha256-+cNO02MvtgzSSN1Yl72YR5oQOnVoiwVsovBp5oqzKYc=";
  };

  buildInputs = [
    iptables
    libuuid
    openssl
  ]
  ++ lib.optionals (firewall == "nftables") [
    libmnl
    libnftnl
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  dontAddPrefix = true;
  configurePlatforms = [ ];
  configureFlags = [
    "--host-os=${stdenv.hostPlatform.uname.system}"
    "--host-os-version=${linuxHeaders.version}"
    "--host-machine=${stdenv.hostPlatform.uname.processor}"
    "--firewall=${firewall}"
    "--ipv6"
    "--igd2"
    "--leasefile"
    "--regex"
    "--vendorcfg"
    "--portinuse"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "INSTALLPREFIX=$(out)"
  ];

  postFixup =
    {
      iptables = ''
        for script in $out/etc/miniupnpd/ip{,6}tables_{init,removeall}.sh
        do
          wrapProgram $script --prefix PATH : '${scriptBinEnv}:$PATH'
        done
      '';
      nftables = ''
        for script in $out/etc/miniupnpd/nft_{delete_chain,flush,init,removeall}.sh
        do
          wrapProgram $script --suffix PATH : '${scriptBinEnv}:$PATH'
        done
      '';
    }
    .${firewall};

  meta = {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "Daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    mainProgram = "miniupnpd";
  };
}
