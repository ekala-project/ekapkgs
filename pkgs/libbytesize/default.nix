{
  lib,
  autoreconfHook,
  docbook_xml_dtd_43,
  docbook_xsl,
  fetchFromGitHub,
  gettext,
  gmp,
  gtk-doc,
  libxslt,
  mpfr,
  pcre2,
  pkg-config,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbytesize";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = finalAttrs.version;
    hash = "sha256-MQADGFruQODQ8rxu1R8TF9zqd4jKLtyRQrWFds5UNS0=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    gtk-doc
    libxslt
    pkg-config
    python3Packages.python
  ];

  buildInputs = [
    gmp
    mpfr
    pcre2
  ];

  strictDeps = true;

  postInstall = ''
    substituteInPlace $out/${python3Packages.python.sitePackages}/bytesize/bytesize.py \
      --replace-fail 'CDLL("libbytesize.so.1")' "CDLL('$out/lib/libbytesize.so.1')"

    ${python3Packages.python.pythonOnBuildForHost.interpreter} -m compileall $out/${python3Packages.python.sitePackages}/bytesize
  '';

  meta = {
    homepage = "https://github.com/storaged-project/libbytesize";
    description = "Tiny library providing a C 'class' for working with arbitrary big sizes in bytes";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "bscalc";
    platforms = lib.platforms.linux;
  };
})
