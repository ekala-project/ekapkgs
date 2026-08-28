{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

let
  version = "2.8.8";
  folder =
    with builtins;
    let
      parts = splitVersion version;
    in
    concatStringsSep "." [
      (elemAt parts 0)
      (elemAt parts 1)
    ];
in
stdenv.mkDerivation {
  pname = "hyphen";
  inherit version;

  src = fetchurl {
    url = "https://sourceforge.net/projects/hunspell/files/Hyphen/${folder}/hyphen-${version}.tar.gz";
    sha256 = "01ap9pr6zzzbp4ky0vy7i1983fwyqy27pl0ld55s30fdxka3ciih";
  };

  nativeBuildInputs = [ perl ];

  # Do not install the en_US dictionary.
  installPhase = ''
    runHook preInstall
    make install-libLTLIBRARIES
    make install-binSCRIPTS
    make install-includeHEADERS

    # license
    install -D -m644 COPYING "$out/share/licenses/hyphen/LICENSE"
    runHook postInstall
  '';

  meta = {
    description = "Text hyphenation library";
    mainProgram = "substrings.pl";
    homepage = "https://sourceforge.net/projects/hunspell/files/Hyphen/";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      gpl2
      lgpl21
      mpl11
    ];
  };
}
