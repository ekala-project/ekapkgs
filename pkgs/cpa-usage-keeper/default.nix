{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

let
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "Willxup";
    repo = "cpa-usage-keeper";
    tag = "v${version}";
    hash = "sha256-2ILugPaxNc4FjhdwKUMWdyr+VemrDEk0+lUiN+XqCwM=";
  };

  frontend = buildNpmPackage {
    pname = "cpa-usage-keeper-frontend";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-Fy8eVMC+6YhSDjzsphdqu3Wg8fqQGzMWw55dayN4XMI=";
    npmDepsFetcherVersion = 2;

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "cpa-usage-keeper";
  inherit version src;

  vendorHash = "sha256-aPHZro8Qwy5ptgudMgnfpcktwyVVZTi+XMrr0RTtl6k=";

  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X cpa-usage-keeper/internal/version.Version=v${version}"
  ];

  preBuild = ''
    rm -rf web/dist
    cp -r ${frontend} web/dist
  '';

  postInstall = ''
    mv $out/bin/server $out/bin/cpa-usage-keeper
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    inherit frontend;
  };

  meta = {
    description = "Standalone CliProxyAPI usage tracker with SQLite persistence and built-in dashboard";
    homepage = "https://github.com/Willxup/cpa-usage-keeper";
    changelog = "https://github.com/Willxup/cpa-usage-keeper/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "cpa-usage-keeper";
    platforms = lib.platforms.unix;
  };
}
