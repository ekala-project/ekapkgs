{
  lib,
  nodejs,
  fetchFromGitHub,
  pnpm,
}:

let
  version = "1.7.1";
in
nodejs.buildPnpmApplication {
  pname = "skills";
  inherit version;

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    tag = "v${version}";
    hash = "sha256-wynuiFQK0QR6bbClhGNM+tsoyAE/bsHSSwDUPVb8+gE=";
  };

  pnpm = pnpm.v10;
  fetcherVersion = 3;
  pnpmDepsHash = "sha256-kDjPsOHkQaFrRNQMb2EoLrkepOjMxeHglL88YDLFMWM=";

  # The license-generation step shells out to `npx license-checker` (network).
  # The repo already ships a committed ThirdPartyNoticeText.txt, so build only.
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail 'node scripts/generate-licenses.ts && obuild' 'obuild'
  '';

  postInstall = ''
    for bin in skills add-skill; do
      wrapProgram $out/bin/$bin --set DISABLE_TELEMETRY 1
    done
  '';

  meta = {
    description = "The open agent skills tool for installing and managing skills across AI coding agents";
    homepage = "https://github.com/vercel-labs/skills";
    changelog = "https://github.com/vercel-labs/skills/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "skills";
    platforms = lib.platforms.all;
  };
}
