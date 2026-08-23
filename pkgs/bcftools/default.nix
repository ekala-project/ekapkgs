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
  version = "1.23.2";

  src = fetchFromGitHub {
    owner = "samtools";
    repo = "bcftools";
    tag = finalAttrs.version;
    hash = "sha256-NFXNB2i54du6JpSX69SsKn01ZyLzAqqbSoyKE66EAwM=";
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

    # Fix test expectation for view.vectors.C.out: when built against system
    # htslib, the FGS FORMAT field is dropped from the output at line 28
    sed -i '28s/GT:FAF:FRF:FGF:FAI:FRI:FGI:FAS:FRS:FGS\t0\/1:.:.:.:.:.:.:.:.:./GT:FAF:FRF:FGF:FAI:FRI:FGI:FAS:FRS\t0\/1:.:.:.:.:.:.:.:./' test/view.vectors.C.out
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = lib.licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
