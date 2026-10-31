{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flex,
  bison,
  perl,
  pkg-config,
  texinfo,
  buildPackages,
  which,
  # runtime
  c-ares,
  json_c,
  libcap,
  elfutils,
  libunwind,
  libyang,
  net-snmp,
  openssl,
  pam,
  pcre2,
  python3,
  readline,
  rtrlib,
  protobufc,
  sqlite,
  lua5_3,
  # general options
  snmpSupport ? true,
  rpkiSupport ? true,
  numMultipath ? 64,
  watchfrrSupport ? true,
  cumulusSupport ? false,
  irdpSupport ? true,
  mgmtdSupport ? true,
  scriptingSupport ? true,
  # routing daemon options
  bgpdSupport ? true,
  ripdSupport ? true,
  ripngdSupport ? true,
  ospfdSupport ? true,
  ospf6dSupport ? true,
  ldpdSupport ? true,
  nhrpdSupport ? true,
  eigrpdSupport ? true,
  babeldSupport ? true,
  isisdSupport ? true,
  pimdSupport ? true,
  pim6dSupport ? true,
  sharpdSupport ? true,
  fabricdSupport ? true,
  vrrpdSupport ? true,
  pathdSupport ? true,
  bfddSupport ? true,
  pbrdSupport ? true,
  staticdSupport ? true,
  # BGP options
  bgpAnnounce ? true,
  bgpBmp ? true,
  bgpVnc ? true,
  # OSPF options
  ospfApi ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frr";
  version = "10.7.1";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = "frr";
    rev = "frr-${finalAttrs.version}";
    hash = "sha256-TnQLkzh9K3C9HBVORCdFRGgR+zLm+/V0+zwdwpKEUNs=";
  };

  env.CXXFLAGS = "-std=gnu++23";

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
    protobufc
    python3.pkgs.sphinx
    texinfo
  ];

  buildInputs = [
    c-ares
    json_c
    libunwind
    libyang
    openssl
    pam
    pcre2
    protobufc
    python3
    readline
    rtrlib
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ]
  ++ lib.optionals snmpSupport [ net-snmp ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [ elfutils ]
  ++ lib.optionals scriptingSupport [ lua5_3 ];

  depsBuildBuild = [
    buildPackages.python3
  ]
  ++ lib.optionals scriptingSupport [ buildPackages.lua5_3 ];

  clippy-helper = buildPackages.callPackage ./clippy-helper.nix {
    frrVersion = finalAttrs.version;
    frrSource = finalAttrs.src;
  };

  configureFlags = [
    "--disable-zeromq"
    "--disable-silent-rules"
    "--enable-configfile-mask=0640"
    "--enable-group=frr"
    "--enable-logfile-mask=0640"
    "--enable-multipath=${toString numMultipath}"
    "--enable-config-rollbacks"
    "--enable-user=frr"
    "--enable-vty-group=frrvty"
    "--localstatedir=/var"
    "--sbindir=${placeholder "out"}/libexec/frr"
    "--sysconfdir=/etc"
    "--with-clippy=${finalAttrs.clippy-helper}/bin/clippy"
    "--disable-grpc"
    (lib.strings.enableFeature snmpSupport "snmp")
    (lib.strings.enableFeature rpkiSupport "rpki")
    (lib.strings.enableFeature watchfrrSupport "watchfrr")
    (lib.strings.enableFeature irdpSupport "irdp")
    (lib.strings.enableFeature mgmtdSupport "mgmtd")
    (lib.strings.enableFeature scriptingSupport "scripting")
    (lib.strings.enableFeature bgpdSupport "bgpd")
    (lib.strings.enableFeature ripdSupport "ripd")
    (lib.strings.enableFeature ripngdSupport "ripngd")
    (lib.strings.enableFeature ospfdSupport "ospfd")
    (lib.strings.enableFeature ospf6dSupport "ospf6d")
    (lib.strings.enableFeature ldpdSupport "ldpd")
    (lib.strings.enableFeature nhrpdSupport "nhrpd")
    (lib.strings.enableFeature eigrpdSupport "eigrpd")
    (lib.strings.enableFeature babeldSupport "babeld")
    (lib.strings.enableFeature isisdSupport "isisd")
    (lib.strings.enableFeature pimdSupport "pimd")
    (lib.strings.enableFeature pim6dSupport "pim6d")
    (lib.strings.enableFeature sharpdSupport "sharpd")
    (lib.strings.enableFeature fabricdSupport "fabricd")
    (lib.strings.enableFeature vrrpdSupport "vrrpd")
    (lib.strings.enableFeature pathdSupport "pathd")
    (lib.strings.enableFeature bfddSupport "bfdd")
    (lib.strings.enableFeature pbrdSupport "pbrd")
    (lib.strings.enableFeature staticdSupport "staticd")
    (lib.strings.enableFeature bgpAnnounce "bgp-announce")
    (lib.strings.enableFeature bgpBmp "bgp-bmp")
    (lib.strings.enableFeature bgpVnc "bgp-vnc")
    (lib.strings.enableFeature ospfApi "ospfapi")
    (lib.strings.enableFeature cumulusSupport "cumulus")
  ]
  ++ lib.optionals snmpSupport [
    "NETSNMP_CONFIG=${lib.getDev net-snmp}/bin/net-snmp-config"
  ];

  postPatch = ''
    substituteInPlace tools/frr-reload \
      --replace-quiet /usr/lib/frr/ $out/libexec/frr/
    sed -i '/^PATH=/ d' tools/frr.in tools/frrcommon.sh.in
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://frrouting.org/";
    description = "FRR BGP/OSPF/ISIS/RIP/RIPNG routing daemon suite";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
