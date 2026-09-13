{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
}:

buildGoModule (finalAttrs: {
  pname = "adguardhome";
  version = "0.107.78";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u/fAvBgaoGph+BeTO/QzFtuFvJnnwaJRK3qmRhubj5w=";
  };

  vendorHash = "sha256-+LqNok2kaHQnVJA5cVX1MB31uLFfNxb952lzZk8V8Z8=";

  dashboard = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "adguardhome-dashboard";
    postPatch = ''
      cd client
    '';
    npmDepsHash = "sha256-Yyv8dTKhZ9IlIW/x/57cl/+cpvjjycaFLSyOR0IiIPk=";
    npmBuildScript = "build-prod";
    postBuild = ''
      mkdir -p $out/build/
      cp -r ../build/static/ $out/build/
    '';
  };

  preBuild = ''
    cp -r ${finalAttrs.dashboard}/build/static build
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/AdguardTeam/AdGuardHome/internal/version.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    license = lib.licenses.gpl3Only;
    mainProgram = "AdGuardHome";
  };
})
