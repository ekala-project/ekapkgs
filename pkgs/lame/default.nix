{
  lib,
  stdenv,
  fetchurl,
  nasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lame";
  version = "3.100";

  src = fetchurl {
    url = "mirror://sourceforge/lame/lame-${finalAttrs.version}.tar.gz";
    sha256 = "07nsn5sy3a8xbmw1bidxnsj5fj6kg9ai04icmqw40ybkp353dznx";
  };

  outputs = [
    "out"
    "lib"
    "doc"
  ];
  outputMan = "out";

  nativeBuildInputs = [ nasm ];

  configureFlags = [
    "--enable-nasm"
    "--enable-cpml"
    "--with-fileio=lame"
    "--enable-analyzer-hooks"
    "--enable-decoder"
    "--enable-frontend"
    "--enable-dynamic-frontends"
  ];

  preConfigure = ''
    sed -i '/lame_init_old/d' include/libmp3lame.sym
  '';

  meta = {
    description = "High quality MPEG Audio Layer III (MP3) encoder";
    homepage = "http://lame.sourceforge.net";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "lame";
  };
})
