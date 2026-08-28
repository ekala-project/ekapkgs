{
  lib,
  stdenv,
  fetchFromGitHub,
  fontforge,
  python3,
}:

let
  inherit (python3.pkgs) fonttools;
in
stdenv.mkDerivation rec {
  pname = "liberation-fonts";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "liberationfonts";
    repo = "liberation-fonts";
    rev = version;
    hash = "sha256-Wg1uoD2k/69Wn6XU+7wHqf2KO/bt4y7pwgmG7+IUh4Q=";
  };

  nativeBuildInputs = [
    fontforge
    python3
    fonttools
  ];

  postPatch = ''
    substituteInPlace scripts/setisFixedPitch-fonttools.py --replace \
      'font = ttLib.TTFont(fontfile)' \
      'font = ttLib.TTFont(fontfile, recalcTimestamp=False)'
  '';

  installPhase = ''
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;

    for i in AUTHORS ChangeLog LICENSE README.md; do
      install -m444 -Dt $out/share/doc/${pname}-${version} $i || true
    done
  '';

  meta = {
    description = "Liberation Fonts, replacements for Times New Roman, Arial, and Courier New";
    license = lib.licenses.ofl;
    homepage = "https://github.com/liberationfonts";
    platforms = lib.platforms.all;
  };
}
