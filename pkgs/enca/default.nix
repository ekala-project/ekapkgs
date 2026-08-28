{
  lib,
  stdenv,
  fetchurl,
  recode,
}:

stdenv.mkDerivation rec {
  pname = "enca";
  version = "1.19";

  src = fetchurl {
    url = "https://dl.cihar.com/enca/${pname}-${version}.tar.xz";
    sha256 = "1f78jmrggv3jymql8imm5m9yc8nqjw5l99mpwki2245l8357wj1s";
  };

  buildInputs = [
    recode
  ];

  meta = {
    description = "Detects the encoding of text files and reencodes them";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
