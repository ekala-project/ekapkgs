{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  restic ? null,
  bash,
}:

buildGo126Module (finalAttrs: {
  pname = "resticprofile";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "creativeprojects";
    repo = "resticprofile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ezelvyroQG1EW3SU63OVHJ/T4qjN5DRllvPIXnei1Z4=";
  };

  postPatch = ''
    substituteInPlace schedule_jobs.go \
        --replace-fail "os.Executable()" "\"$out/bin/resticprofile\", nil"

    substituteInPlace shell/command.go \
        --replace-fail '"bash"' '"${lib.getExe bash}"'
  ''
  + lib.optionalString (restic != null) ''
    substituteInPlace filesearch/filesearch.go \
        --replace-fail 'paths := getSearchBinaryLocations()' 'return "${lib.getExe restic}", nil; paths := getSearchBinaryLocations()'
  '';

  vendorHash = "sha256-M9S6F/Csz7HnOq8PSWjpENKm1704kVx9zDts1ieraTE=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=unknown"
    "-X main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    rm batt/battery_test.go
    rm commands_test.go
    rm config/path_test.go
    rm lock/lock_test.go
    rm preventsleep/caffeinate_test.go
    rm priority/ioprio_test.go
    rm restic/downloader_test.go
    rm schedule/*_test.go
    rm update_test.go
    rm user/user_test.go
    rm util/tempdir_test.go
    rm -f darwin/*_test.go
    rm -f schtasks/*_test.go
    rm -f util/maybe/duration_test.go
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 $GOPATH/bin/resticprofile -t $out/bin

    installShellCompletion --cmd resticprofile \
        --bash <($out/bin/resticprofile generate --bash-completion) \
        --zsh <($out/bin/resticprofile generate --zsh-completion)

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/creativeprojects/resticprofile/releases/tag/v${finalAttrs.version}";
    description = "Configuration profiles manager for restic backup";
    homepage = "https://creativeprojects.github.io/resticprofile/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3
    ];
    mainProgram = "resticprofile";
  };
})
