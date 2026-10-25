{
  version,
  src-kind,
  src-hash,
  src-url ? null,
  src-owner ? null,
  src-repo ? null,
  needsAutoreconf,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  perl,
  swig,
  autoreconfHook,
  gd,
  ncurses,
  python311,
  libxml2,
  tcl,
  libusb-compat-0_1,
  pkg-config,
  boost,
  libtool,
  buildPackages,
  pythonBindings ? true,
  tclBindings ? true,
  perlBindings ? stdenv.buildPlatform == stdenv.hostPlatform,
}:

let
  python3 = python311;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hamlib";
  inherit version;

  src =
    if src-kind == "fetchFromGitHub" then
      fetchFromGitHub {
        owner = src-owner;
        repo = src-repo;
        tag = version;
        hash = src-hash;
      }
    else
      fetchurl {
        url = src-url;
        sha256 = src-hash;
      };

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    swig
    pkg-config
    libtool
  ]
  ++ lib.optionals needsAutoreconf [ autoreconfHook ]
  ++ lib.optionals pythonBindings [ python3 ]
  ++ lib.optionals tclBindings [ tcl ]
  ++ lib.optionals perlBindings [ perl ];

  buildInputs = [
    gd
    libxml2
    libusb-compat-0_1
    boost
  ]
  ++ lib.optionals pythonBindings [
    python3
    ncurses
  ]
  ++ lib.optionals tclBindings [ tcl ];

  configureFlags = [
    "CC_FOR_BUILD=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optionals perlBindings [ "--with-perl-binding" ]
  ++ lib.optionals tclBindings [
    "--with-tcl-binding"
    "--with-tcl=${tcl}/lib/"
  ]
  ++ lib.optionals pythonBindings [ "--with-python-binding" ];

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "Runtime library to control radio transceivers and receivers";
    homepage = "https://hamlib.sourceforge.net";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
})
