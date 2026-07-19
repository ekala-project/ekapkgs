{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jbig2dec";
  version = "0.20";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/jbig2dec/archive/${finalAttrs.version}/jbig2dec-${finalAttrs.version}.tar.gz";
    hash = "sha256-qXBTaaZjOrpTJpNFDsgCxWI5fhuCRmLegJ7ekvZ6/yE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  configureScript = "./autogen.sh";

  meta = {
    homepage = "https://www.jbig2dec.com/";
    description = "Decoder implementation of the JBIG2 image compression format";
    mainProgram = "jbig2dec";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
