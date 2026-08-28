{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "noto-fonts";
  version = "2025.06.01";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notofonts.github.io";
    rev = "noto-monthly-release-${version}";
    hash = "sha256-6lbNJjkf6lnPPZzHO3vtsXEuPQs6ewslgnQIeDhF2yk=";
  };

  outputs = [
    "out"
    "megamerge"
  ];

  installPhase = ''
    local out_font=$out/share/fonts/noto

    install -m444 -Dt $megamerge/share/fonts/truetype/ megamerge/*.ttf

    for folder in $(ls -d fonts/*/); do
      if [[ -d "$folder"unhinted/variable-ttf ]]; then
        install -m444 -Dt $out_font "$folder"unhinted/variable-ttf/*.ttf
      elif [[ -d "$folder"unhinted/otf ]]; then
        install -m444 -Dt $out_font "$folder"unhinted/otf/*.otf
      else
        install -m444 -Dt $out_font "$folder"unhinted/ttf/*.ttf
      fi
    done
  '';

  meta = {
    description = "Beautiful and free fonts for many languages";
    homepage = "https://www.google.com/get/noto/";
    longDescription = ''
      When text is rendered by a computer, sometimes characters are
      displayed as "tofu". They are little boxes to indicate your device
      doesn't have a font to display the text.
      Google has been developing a font family called Noto, which aims to
      support all languages with a harmonious look and feel. Noto is
      Google's answer to tofu. The name noto is to convey the idea that
      Google's goal is to see "no more tofu".  Noto has multiple styles and
      weights, and freely available to all.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
