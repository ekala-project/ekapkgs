{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  docbook_xsl,
  gtk-doc,
  intltool,
  pkg-config,
  aspell,
  enchant,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "gtkspell";
  version = "2.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/${pname}-${version}.tar.gz";
    sha256 = "00hdv28bp72kg1mq2jdz1sdw2b8mb9iclsp7jdqwpck705bdriwg";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-packages/raw/17fb30b5196db378c18e7c115f28e97b962b95ff/trunk/enchant-2.diff";
      sha256 = "0d9409bnapwzwhnfpz3dvl6qalskqa4lzmhrmciazsypbw3ry5rf";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    gtk2
    gtk-doc
    intltool
    pkg-config
  ];

  buildInputs = [
    aspell
    enchant
    gtk2
  ];

  meta = {
    description = "Word-processor-style highlighting and replacement of misspelled words";
    homepage = "https://gtkspell.sourceforge.net";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2;
  };
}
