{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  openssl,
  libogg,
  libopus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opusfile";
  version = "0.12";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opusfile-${finalAttrs.version}.tar.gz";
    sha256 = "02smwc5ah8nb3a67mnkjzqmrzk43j356hgj2a97s9midq40qd38i";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libogg
  ];

  propagatedBuildInputs = [ libopus ];

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./include-multistream.patch
    (fetchpatch {
      name = "CVE-2022-47021.patch";
      url = "https://github.com/xiph/opusfile/commit/0a4cd796df5b030cb866f3f4a5e41a4b92caddf5.patch";
      sha256 = "sha256-XThI/ys5caB+OncFVfxm5IsvQPy1MbLQKwIlYjPvTJQ=";
    })
  ];

  configureFlags = [ "--disable-examples" ];

  meta = {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = "https://www.opus-codec.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
