{
  lib,
  stdenv,
  fetchFromGitHub,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtable-dumper";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "vtable-dumper";
    rev = finalAttrs.version;
    sha256 = "0sl7lnjr2l4c2f7qaazvpwpzsp4gckkvccfam88wcq9f7j9xxbyp";
  };

  buildInputs = [ elfutils ];
  makeFlags = [ "prefix=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-I${elfutils.dev}/include";
  env.NIX_LDFLAGS = "-L${lib.getLib elfutils}/lib -lelf";

  meta = {
    homepage = "https://github.com/lvc/vtable-dumper";
    description = "Tool to list content of virtual tables in a C++ shared library";
    mainProgram = "vtable-dumper";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
})
