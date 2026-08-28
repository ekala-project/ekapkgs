{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "procmail";
  version = "3.24";

  src = fetchurl {
    url = "https://github.com/BuGlessRB/procmail/archive/refs/tags/v${finalAttrs.version}.tar.gz";
    sha256 = "UU6kMzOXg+ld+TIeeUdx5Ih7mCOsVf2yRpcCz2m9OYk=";
  };

  patches = [
    ./reproducible.patch
    (fetchpatch {
      name = "clang-16.patch";
      url = "https://github.com/BuGlessRB/procmail/commit/8cfd570fd14c8fb9983859767ab1851bfd064b64.patch";
      hash = "sha256-CaQeDKwF0hNOrxioBj7EzkCdJdsq44KwkfA9s8xK88g=";
    })
  ];

  postPatch = ''
    sed -i Makefile \
      -e "s%^RM.*$%#%" \
      -e "s%^BASENAME.*%\BASENAME=$out%" \
      -e "s%^LIBS=.*%LIBS=-lm%"
    sed -e "s%getline%thisgetline%g" -i src/*.c src/*.h
    sed -e "3i\
    .PHONY: install
    " -i Makefile
  '';

  meta = {
    description = "Mail processing and filtering utility";
    homepage = "https://github.com/BuGlessRB/procmail/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
