{
  lib,
  nix-update-script,
  buildNpmPackage,
  fetchFromCodeberg,
  nodejs,
  kwin,
  kpackage,
  zip,
}:
let
  # Inside `rec`, `nodejs` would refer to the attribute itself.
  nodejs_22 = nodejs.v22;
in
buildNpmPackage rec {
  pname = "krohnkite";
  version = "0.9.9.2";

  src = fetchFromCodeberg {
    owner = "anametologin";
    repo = "Krohnkite";
    rev = version;
    hash = "sha256-gulKg23BeWL270B2omRYJIuAHIsKu1cBVpimgButM9I=";
  };

  npmDepsHash = "sha256-6+meI602VKIzqunTOwNRLZOO7/LscjNm545icc2WN0c=";

  dontWrapQtApps = true;

  nodejs = nodejs_22;

  nativeBuildInputs = [
    kpackage
    zip
    kwin
  ];

  npmBuildScript = "tsc";

  installPhase = ''
    runHook preInstall

    substituteInPlace Makefile --replace-fail '7z a -tzip' 'zip -r'
    # Override PROJECT_VER and PROJECT_REV because we don't have .git
    make \
      KWINPKG_FILE=krohnkite.kwinscript \
      PROJECT_REV=${version} \
      PROJECT_VER=${version} \
      krohnkite.kwinscript
    kpackagetool6 --type=KWin/Script --install=krohnkite.kwinscript --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic Tiling Extension for KWin 6";
    homepage = "https://codeberg.org/anametologin/Krohnkite";
    changelog = "https://codeberg.org/anametologin/Krohnkite/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ben9986
      dramforever
    ];
    platforms = lib.platforms.all;
  };
}
