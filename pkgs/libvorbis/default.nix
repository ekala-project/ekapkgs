{
  lib,
  stdenv,
  fetchurl,
  libogg,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvorbis";
  version = "1.3.7";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/vorbis/libvorbis-${finalAttrs.version}.tar.xz";
    sha256 = "0jwmf87x5sdis64rbv0l87mdpah1rbilkkxszipbzg128f9w8g5k";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libogg ];

  meta = {
    description = "Vorbis audio compression reference implementation";
    homepage = "https://xiph.org/vorbis/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
