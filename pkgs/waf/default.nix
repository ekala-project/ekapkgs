{
  lib,
  stdenv,
  fetchFromGitLab,
  callPackage,
  ensureNewerSourcesForZipFilesHook,
  python3,
  makeWrapper,
  makeSetupHook,
}:

let
  wafPkg = stdenv.mkDerivation (finalAttrs: {
    pname = "waf";
    version = "2.1.9";

    src = fetchFromGitLab {
      owner = "ita1024";
      repo = "waf";
      rev = "waf-${finalAttrs.version}";
      hash = "sha256-myPGbJW/RkOtEas+qZ/vTL66bekwDBPhC6AmfXECkcw=";
    };

    nativeBuildInputs = [
      ensureNewerSourcesForZipFilesHook
      python3
      makeWrapper
    ];

    buildInputs = [
      python3
    ];

    strictDeps = true;

    configurePhase = ''
      runHook preConfigure
      python waf-light configure
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      python waf-light build
      substituteInPlace waf \
        --replace "w = test(i + '/lib/' + dirname)" \
                  "w = test('$out/${python3.sitePackages}')"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -D waf "$out"/bin/waf
      wrapProgram "$out"/bin/waf --prefix PYTHONPATH : "$out"/${python3.sitePackages}
      mkdir -p "$out"/${python3.sitePackages}/
      cp -r waflib "$out"/${python3.sitePackages}/
      runHook postInstall
    '';

    passthru = {
      inherit python3;
      hook = makeSetupHook {
        name = "waf-setup-hook";
        substitutions = {
          waf = finalAttrs.finalPackage;
        };
        meta = {
          description = "Setup hook for using Waf in Nixpkgs";
          license = lib.licenses.mit;
        };
      } ./setup-hook.sh;
    };

    meta = {
      homepage = "https://waf.io";
      description = "Meta build system";
      license = lib.licenses.bsd3;
      mainProgram = "waf";
      platforms = lib.platforms.unix;
    };
  });
in
wafPkg
