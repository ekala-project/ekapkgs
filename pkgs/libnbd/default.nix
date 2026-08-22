{
  lib,
  stdenv,
  fetchurl,
  bash-completion,
  pkg-config,
  perl,
  buildPythonBindings ? false,
  buildOcamlBindings ? false,
  ocamlPackages,
  python3,
  libxml2,
  fuse3,
  gnutls,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libnbd";
  version = "1.22.5";

  src = fetchurl {
    url = "https://download.libguestfs.org/libnbd/${lib.versions.majorMinor version}-stable/libnbd-${version}.tar.gz";
    hash = "sha256-y/Ria/R8jC+Zu5bHnlqM7JozNzyt6i/Bu/4E5uFbbjw=";
  };

  nativeBuildInputs = [
    bash-completion
    pkg-config
    perl
    autoreconfHook
  ]
  ++ lib.optionals buildPythonBindings [ python3 ]
  ++ lib.optionals buildOcamlBindings (
    with ocamlPackages;
    [
      findlib
      ocaml
    ]
  );

  buildInputs = [
    fuse3
    gnutls
    libxml2
  ];

  postPatch = lib.optionalString buildOcamlBindings ''
    substituteInPlace ocaml/Makefile.am \
        --replace-fail '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib'
  '';

  configureFlags = lib.optionals buildPythonBindings [
    "--with-python-installdir=${placeholder "out"}/${python3.sitePackages}"
  ];

  installFlags = [ "bashcompdir=$(out)/share/bash-completion/completions" ];

  postInstall = lib.optionalString buildPythonBindings ''
    LIBNBD_PYTHON_METADATA='${placeholder "out"}/${python3.sitePackages}/nbd-${version}.dist-info/METADATA'
    install -Dm644 -T ${./libnbd-metadata} $LIBNBD_PYTHON_METADATA
    substituteAllInPlace $LIBNBD_PYTHON_METADATA
  '';

  meta = {
    homepage = "https://gitlab.com/nbdkit/libnbd";
    description = "Network Block Device client library in userspace";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    broken = buildOcamlBindings && !lib.versionAtLeast ocamlPackages.ocaml.version "4.05";
  };
}
