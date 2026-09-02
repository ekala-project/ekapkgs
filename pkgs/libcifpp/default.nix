{
  lib,
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  eigen,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcifpp";
  version = "10.0.4";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+lD543SYLoHrds97en4zfDHkQBf4wL0NOg2LcshJI8k=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # disable network access
    "-DCIFPP_DOWNLOAD_CCD=OFF"
  ];

  buildInputs = [
    boost
    eigen
    zlib
  ];

  # cmake requires the existence of this directory when building dssp
  postInstall = ''
    mkdir -p $out/share/libcifpp
  '';

  meta = {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
