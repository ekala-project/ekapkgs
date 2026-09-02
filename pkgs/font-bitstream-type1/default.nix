{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  fontforge,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-bitstream-type1";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bitstream-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-3i8ji0zXLbQiigumeCnXait8A54imT1mpyLuOFJIxig=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    mkfontscale
    fontforge
  ];

  postBuild = ''
    # convert Postscript (Type 1) font to otf
    for i in $(find -type f -name '*.pfa' -o -name '*.pfb'); do
        name=$(basename $i | cut -d. -f1)
        fontforge -lang=ff -c "Open(\"$i\"); Generate(\"$name.otf\")"
    done
  '';

  postInstall = ''
    # install the otf fonts
    fontDir="$out/share/fonts/X11/otf"
    install -Dm444 -t "$fontDir" *.otf
    mkfontscale "$fontDir"
  '';

  meta = {
    description = "Bitstream Charter PostScript Type 1 and OpenType fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bitstream-type1";
    license = lib.licenses.bitstreamCharter;
    platforms = lib.platforms.unix;
  };
})
