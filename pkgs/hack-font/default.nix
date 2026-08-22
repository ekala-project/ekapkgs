{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hack-font";
  version = "3.003";

  src = fetchzip {
    url = "https://github.com/chrissimpkins/Hack/releases/download/v${version}/Hack-v${version}-ttf.zip";
    hash = "sha256-SxF4kYp9aL/9L9EUniquFadzWt/+PcvhUQOIOvCrFRM=";
  };

  installPhase = ''
    runHook preInstall
    find . -iname '*.ttf' -exec install -m644 -D -t "$out/share/fonts/truetype" {} +
    runHook postInstall
  '';

  meta = {
    description = "Typeface designed for source code";
    longDescription = ''
      Hack is hand groomed and optically balanced to be a workhorse face for
      code. It has deep roots in the libre, open source typeface community and
      expands upon the contributions of the Bitstream Vera & DejaVu projects.
      The face has been re-designed with a larger glyph set, modifications of
      the original glyph shapes, and meticulous attention to metrics.
    '';
    homepage = "https://sourcefoundry.org/hack/";
    license = lib.licenses.free;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
