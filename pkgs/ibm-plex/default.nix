{
  lib,
  stdenvNoCC,
  symlinkJoin,
  fetchzip,
  families ? [ ],
}:
let
  allFonts = import ./fonts.nix;
  availableFamilyNames = builtins.attrNames allFonts;
  selectedFamilies = if (families == [ ]) then availableFamilyNames else families;
  unknownFamilies = lib.subtractLists availableFamilyNames families;
  fontsToBuild = lib.filterAttrs (name: _: lib.elem name selectedFamilies) allFonts;
  makeFont =
    font:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = lib.toLower (lib.replaceStrings [ " (" ")" " " ] [ "-" "" "-" ] font.name);
      inherit (font) version;

      src = fetchzip {
        inherit (font) hash url;
        stripRoot = font.stripRoot or true;
      };

      # Some fonts include both unhinted and hinted variants of the ttf and woff/woff2
      # type fonts, which collide. Default to installing the hinted variant.
      # Additionally, fonts with webfonts include complete and split forms.
      # Default to the complete forms.
      preInstall = ''
        find . -type d \( -name unhinted -or -name split \) -exec rm -rf {} +
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/truetype $out/share/fonts/opentype
        find . -iname '*.ttf' -exec install -m644 -D -t $out/share/fonts/truetype {} +
        find . -iname '*.otf' -exec install -m644 -D -t $out/share/fonts/opentype {} + || true
        runHook postInstall
      '';

      meta = meta // {
        description = font.name;
      };
    });
  fontDerivations = lib.mapAttrs (_: v: makeFont v) fontsToBuild;
  meta = {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
in
assert lib.assertMsg (unknownFamilies == [ ]) "Unknown font(s): ${toString unknownFamilies}";
symlinkJoin {
  pname = "ibm-plex";
  version = "0-unstable-2026-05-26";
  paths = lib.attrValues fontDerivations;
  passthru = fontDerivations;
  inherit meta;
}
