{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  htslib,
  zlib,
  bzip2,
  xz,
  curl,
  perl,
  python3,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcftools";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "samtools";
    repo = "bcftools";
    tag = finalAttrs.version;
    hash = "sha256-ZBYolu3EQww9+LyY/5GxdscMlHroCgQM9jVHJCyyU5o=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    python3
  ];

  buildInputs = [
    htslib
    zlib
    bzip2
    xz
    curl
  ];

  nativeCheckInputs = [
    htslib
  ];

  strictDeps = true;

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preCheck = ''
    patchShebangs misc/
    patchShebangs test/
    sed -i -e 's|/bin/bash|${bash}/bin/bash|' test/test.pl

  '';

  doCheck = true;

  meta = {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = lib.licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = lib.platforms.unix;
  };
})
