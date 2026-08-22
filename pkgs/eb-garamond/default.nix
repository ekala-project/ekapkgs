{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  fontforge,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eb-garamond";
  version = "0.016";

  src = fetchFromGitHub {
    owner = "georgd";
    repo = "EB-Garamond";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ajieKhTeH6yv2qiE2xqnHFoMS65//4ZKiccAlC2PXGQ=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [
    installFonts
    fontforge
    python3
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "@\$(SFNTTOOL) -w \$< \$@" "@fontforge -lang=ff -c 'Open(\$\$1); Generate(\$\$2)' \$< \$@"
    # Remove ttfautohint dependency (not available)
    sed -i '/ttfautohint/d' Makefile
    sed -i '/@mv \$@.tmp \$@/d' Makefile
  '';

  buildPhase = ''
    runHook preBuild
    make WEB=build EOT="" all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
