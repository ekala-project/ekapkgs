{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  fstrm,
  libevent,
  openssl,
  pkg-config,
  protobuf,
  protobufc,
  systemdMinimal ? null,
  bind8Stats ? false,
  checking ? false,
  ipv6 ? true,
  minimalResponses ? true,
  mmap ? false,
  nsec3 ? true,
  ratelimit ? false,
  recvmmsg ? false,
  rootServer ? false,
  rrtypes ? false,
  zoneStats ? false,
  withDnstap ? true,
  withSystemd ? false,
  configFile ? "/etc/nsd/nsd.conf",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsd";
  version = "4.15.0";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/nsd/nsd-${finalAttrs.version}.tar.gz";
    hash = "sha256-hPG+4ukqna20HZXsxkET5NPe+GIk3ndM2SADrdjE9XA=";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/NLnetLabs/nsd/commit/15cf8736e3bfa0fd8f426b13637c44e638fa0d40.patch";
      hash = "sha256-JVazJ83U80ASZypjic0epE92PZd3F1yi8UU6EapdW5U=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    removeReferencesTo
  ]
  ++ lib.optionals withDnstap [ protobuf ];

  buildInputs = [
    libevent
    openssl
  ]
  ++ lib.optionals (withSystemd && systemdMinimal != null) [ systemdMinimal ]
  ++ lib.optionals withDnstap [
    fstrm
    protobufc
  ];

  enableParallelBuilding = true;

  postPatch = ''
    sed 's@$(INSTALL_DATA) nsd.conf.sample $(DESTDIR)$(nsdconfigfile).sample@@g' -i Makefile.in
  '';

  configureFlags =
    let
      edf = c: o: if c then [ "--enable-${o}" ] else [ "--disable-${o}" ];
    in
    edf bind8Stats "bind8-stats"
    ++ edf checking "checking"
    ++ edf ipv6 "ipv6"
    ++ edf mmap "mmap"
    ++ edf minimalResponses "minimal-responses"
    ++ edf nsec3 "nsec3"
    ++ edf ratelimit "ratelimit"
    ++ edf recvmmsg "recvmmsg"
    ++ edf rootServer "root-server"
    ++ edf rrtypes "draft-rrtypes"
    ++ edf zoneStats "zone-stats"
    ++ edf withDnstap "dnstap"
    ++ edf withSystemd "systemd"
    ++ [
      "--with-ssl=${openssl.dev}"
      "--with-libevent=${libevent.dev}"
      "--with-nsd_conf_file=${configFile}"
      "--with-configdir=etc/nsd"
    ];

  postFixup = ''
    find "$out" -type f -exec remove-references-to -t ${openssl.dev} -t ${libevent.dev} '{}' +
  '';

  meta = {
    homepage = "https://www.nlnetlabs.nl";
    description = "Authoritative only, high performance, simple and open source name server";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
