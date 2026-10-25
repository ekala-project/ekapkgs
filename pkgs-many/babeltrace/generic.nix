{
  version,
  src-kind,
  src-hash,
  src-url ? null,
  src-owner ? null,
  src-repo ? null,
  hasDocs,
  packageAtLeast,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
  libuuid,
  popt,
  elfutils,
  bison,
  flex,
  asciidoc,
  xmlto,
  docbook-xml-dtd,
  docbook_xsl,
  enablePython ? false,
  python ? null,
  pythonPackages ? null,
  swig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babeltrace";
  inherit version;

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals (packageAtLeast "2.0.0") [ "man" ];

  src =
    if src-kind == "fetchFromGitHub" then
      fetchFromGitHub {
        owner = src-owner;
        repo = src-repo;
        rev = "v${version}";
        hash = src-hash;
      }
    else
      fetchurl {
        url = src-url;
        hash = src-hash;
      };

  nativeBuildInputs = [
    autoreconfHook
    glib
    pkg-config
  ]
  ++ lib.optionals hasDocs [
    bison
    flex
    asciidoc
    xmlto
    docbook-xml-dtd.v4_5
    docbook_xsl
  ]
  ++ lib.optionals enablePython [
    swig
    pythonPackages.setuptools
  ];

  buildInputs = [
    glib
    elfutils
  ]
  ++ lib.optionals (!packageAtLeast "2.0.0") [
    libuuid
    popt
  ]
  ++ lib.optional enablePython python;

  configureFlags = [
    (lib.enableFeature (stdenv.hostPlatform == stdenv.buildPlatform) "debug-info")
  ]
  ++ lib.optionals enablePython [
    "--enable-python-bindings"
  ]
  ++ lib.optionals (packageAtLeast "2.0.0" && enablePython) [
    "--enable-python-plugins"
  ];

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "Trace manipulation toolkit";
    homepage = "https://babeltrace.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
