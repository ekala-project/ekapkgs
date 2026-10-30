{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  makeWrapper,
  removeReferencesTo,
  libxcrypt,
  ncurses,
  cpio,
  gperf,
  cdrkit,
  qemu,
  pcre2,
  augeas,
  libxml2,
  acl,
  libcap,
  libcap_ng,
  libconfig,
  systemdLibs,
  fuse,
  yajl,
  libvirt,
  hivex,
  db,
  gmp,
  readline,
  numactl,
  libapparmor,
  json_c,
  getopt,
  perlPackages,
  python3,
  ocamlPackages ? { },
  libtirpc,
  appliance ? null,
  javaSupport ? false,
  jdk ? null,
  zstd,
}:

assert appliance == null || lib.isDerivation appliance;

stdenv.mkDerivation (finalAttrs: {
  pname = "libguestfs";
  version = "1.56.2";

  src = fetchurl {
    url = "https://libguestfs.org/download/${lib.versions.majorMinor finalAttrs.version}-stable/libguestfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-u0SJGnleC3khPO4sSRSVpt1ksh9ydEVZFzDX94kBaJo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    removeReferencesTo
    cdrkit
    cpio
    getopt
    gperf
    makeWrapper
    pkg-config
    python3
    python3.pkgs.pycodestyle
    python3.pkgs.setuptools
    qemu
    zstd
  ]
  ++ (with perlPackages; [
    perl
    libintl-perl
    GetoptLong
    ModuleBuild
  ])
  ++ lib.optionals (ocamlPackages ? ocaml) [
    ocamlPackages.ocaml
  ]
  ++ lib.optionals (ocamlPackages ? findlib) [
    ocamlPackages.findlib
  ];

  buildInputs = [
    libxcrypt
    ncurses
    json_c
    pcre2
    augeas
    libxml2
    acl
    libcap
    libcap_ng
    libconfig
    systemdLibs
    fuse
    yajl
    libvirt
    gmp
    readline
    hivex
    db
    numactl
    libapparmor
    perlPackages.ModuleBuild
    python3
    libtirpc
    zstd
  ]
  ++ lib.optionals (ocamlPackages ? ocamlbuild) [
    ocamlPackages.ocamlbuild
  ]
  ++ lib.optionals (ocamlPackages ? ocaml_libvirt) [
    ocamlPackages.ocaml_libvirt
  ]
  ++ lib.optionals (ocamlPackages ? augeas) [
    ocamlPackages.augeas
  ]
  ++ lib.optional javaSupport jdk;

  prePatch = ''
    patchShebangs .
  '';

  configureFlags = [
    "--enable-daemon"
    "--enable-install-daemon"
    "--disable-appliance"
    "--with-distro=NixOS"
    "--with-python-installdir=$(out)/${python3.sitePackages}"
    "--with-readline"
    "CPPFLAGS=-I${lib.getDev libxml2}/include/libxml2"
    "INSTALL_OCAMLLIB=$(out)/lib/ocaml"
    "--with-guestfs-path=$(out)/lib/guestfs"
  ]
  ++ lib.optionals (!javaSupport) [ "--without-java" ];

  patches = [
    ./libguestfs-syms.patch
    # Fixes PERL Sys-Guestfs build failure
    ./Revert-perl-Pass-CFLAGS-through-extra_linker_flags.patch
  ];

  createFindlibDestdir = true;

  installFlags = [ "REALLY_INSTALL=yes" ];

  outputs = [
    "out"
    "guestfsd"
  ];

  postInstall = ''
    # move guestfsd (the component running in the appliance) to a separate output
    mkdir -p $guestfsd/bin
    mv $out/sbin/guestfsd $guestfsd/bin/guestfsd
    remove-references-to -t $out $guestfsd/bin/guestfsd

    mv "$out/lib/ocaml/guestfs" "$OCAMLFIND_DESTDIR/guestfs"
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH     : "$out/bin:${hivex}/bin:${qemu}/bin" \
        --prefix PERL5LIB : "$out/${perlPackages.perl.libPrefix}"
    done
  '';

  postFixup = lib.optionalString (appliance != null) ''
    mkdir -p $out/{lib,lib64}
    ln -s ${appliance} $out/lib64/guestfs
    ln -s ${appliance} $out/lib/guestfs
  '';

  meta = {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    homepage = "https://libguestfs.org/";
    changelog = "https://libguestfs.org/guestfs-release-notes-${lib.versions.majorMinor finalAttrs.version}.1.html";
    platforms = lib.platforms.linux;
  };
})
