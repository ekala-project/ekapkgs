{
  lib,
  stdenv,
  fetchurl,
  aspell,
  which,
}:

stdenv.mkDerivation {
  pname = "aspell-dict-is";
  version = "0.51.1-0";

  src = fetchurl {
    url = "mirror://gnu/aspell/dict/is/aspell-is-0.51.1-0.tar.bz2";
    sha256 = "1mp3ccr4q0a0vam6h2bspm5r6vkkvnmjfhxqilg66y2rc35m10m1";
  };

  strictDeps = true;

  nativeBuildInputs = [
    aspell
    which
  ];

  dontAddPrefix = true;
  configurePlatforms = [ ];

  unpackPhase = ''
    runHook preUnpack
    tar -xf $src --strip-components=1 || true
    runHook postUnpack
  '';

  postPatch = ''
    cp icelandic.alias íslenska.alias
    sed -i 's/ .slenska\.alias/ íslenska.alias/g' Makefile.pre
  '';

  preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

  meta = {
    description = "Aspell dictionary for Icelandic";
    homepage = "http://ftp.gnu.org/gnu/aspell/dict/0index.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
