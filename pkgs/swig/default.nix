{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bison,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swig";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hFHEE9wy8Lja9G396tI4fj4LhOkpPKJkDuy1L62AXr4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
    pcre2
  ];

  buildInputs = [ pcre2 ];

  configureFlags = [ "--without-tcl" ];

  postPatch = ''
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    description = "Interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "swig";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
