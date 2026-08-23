{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  libtraceevent ? null,
  pciutils,
  perl,
  pkg-config,
  sqlite,
  stdenv,
  enableDmidecode ? stdenv.hostPlatform.isx86_64,
  dmidecode ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rasdaemon";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "rasdaemon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CN9fSo7CQFkbpxPRwFSNJovTJBAjqEhqQzwHfYirGmo=";
  };

  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libtraceevent
    (perl.withPackages (
      ps: with ps; [
        DBDSQLite
      ]
    ))
    pciutils
    sqlite
  ]
  ++ lib.optionals enableDmidecode [
    dmidecode
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-all"
  ];

  postPatch = ''
    patchShebangs contrib/
  '';

  preConfigure = ''
    substituteInPlace Makefile.am \
      --replace-fail '"$(DESTDIR)@sysconfdir@/ras/dimm_labels.d"' '"$(prefix)@sysconfdir@/ras/dimm_labels.d"' \
      --replace-fail '"$(DESTDIR)@SYSCONFDEFDIR@/rasdaemon"' '"$(prefix)@SYSCONFDEFDIR@/rasdaemon"' \
      --replace-fail '"$(DESTDIR)@sysconfdir@/ras/triggers' '"$(prefix)@sysconfdir@/ras/triggers'
  '';

  outputs = [
    "out"
    "dev"
    "man"
    "inject"
  ];

  postInstall = ''
    install -Dm 0755 contrib/edac-fake-inject $inject/bin/edac-fake-inject
    install -Dm 0755 contrib/edac-tests $inject/bin/edac-tests
  '';

  postFixup = lib.optionalString (enableDmidecode && dmidecode != null) ''
    substituteInPlace $out/bin/ras-mc-ctl \
      --replace-fail 'find_prog ("dmidecode")' '"${dmidecode}/bin/dmidecode"'
  '';

  meta = {
    description = ''
      A Reliability, Availability and Serviceability (RAS) logging tool using EDAC kernel tracing events
    '';
    longDescription = ''
      Rasdaemon is a RAS (Reliability, Availability and Serviceability) logging
      tool. It records memory errors, using the EDAC tracing events. EDAC is a
      Linux kernel subsystem with handles detection of ECC errors from memory
      controllers for most chipsets on i386 and x86_64 architectures. EDAC
      drivers for other architectures like arm also exists.
    '';
    homepage = "https://github.com/mchehab/rasdaemon";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    changelog = "${finalAttrs.meta.homepage}/releases/tag/v${finalAttrs.version}";
    maintainers = [ ];
  };
})
