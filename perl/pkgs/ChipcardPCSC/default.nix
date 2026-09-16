{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
  pcsclite,
  pkg-config,
}:
buildPerlPackage {
  pname = "Chipcard-PCSC";
  version = "1.4.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/W/WH/WHOM/Chipcard-PCSC-v1.4.16.tar.gz";
    hash = "sha256-O14p1jRDXxQm7Nzfebo1G04mWPNsPCK+N7HTHjbKj6k=";
  };
  buildInputs = [ pcsclite ];
  nativeBuildInputs = [ pkg-config ];
  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-I${pcsclite.dev}/include/PCSC"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-int"
      "-Wno-error=int-conversion"
    ]
  );
  postPatch = ''
    substituteInPlace Makefile.PL --replace pkg-config $PKG_CONFIG
  '';
  env.NIX_CFLAGS_LINK = "-L${lib.getLib pcsclite}/lib -lpcsclite";
  doCheck = false;
  meta = {
    description = "Communicate with a smart card using PC/SC";
  };
}
