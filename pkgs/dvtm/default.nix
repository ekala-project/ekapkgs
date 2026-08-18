{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  customConfig ? null,
}:

stdenv.mkDerivation {
  pname = "dvtm";
  version = "0.15";

  src = fetchurl {
    url = "https://www.brain-dump.org/projects/dvtm/dvtm-0.15.tar.gz";
    sha256 = "0475w514b7i3gxk6khy8pfj2gx9l7lv2pwacmq92zn1abv01a84g";
  };

  patches = [
    # https://github.com/martanne/dvtm/pull/69
    # Use self-pipe instead of signal blocking fixes issues on darwin.
    (fetchurl {
      url = "https://github.com/martanne/dvtm/commit/1f1ed664d64603f3f1ce1388571227dc723901b2.patch";
      sha256 = "1cby8x3ckvhzqa8yxlfrwzgm8wk7yz84kr9psdjr7xwpnca1cqrd";
    })
  ];

  postPatch = lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  nativeBuildInputs = [ ncurses ];
  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/share/terminfo $out/share/terminfo
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = "http://www.brain-dump.org/projects/dvtm";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
