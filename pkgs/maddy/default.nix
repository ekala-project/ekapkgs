{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pam,
  coreutils,
  installShellFiles,
  scdoc,
}:

buildGoModule (finalAttrs: {
  pname = "maddy";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ngpfFDuCq1AK3bFNcEEjvad0n8R3v6disBvuu6dey9Q=";
  };

  vendorHash = "sha256-C37OlonhH/aKTdixEhfcEQBkSVk2mz0w9HyDDuEQARU=";

  tags = [ "libpam" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foxcpp/maddy.Version=${finalAttrs.version}"
    "-X github.com/foxcpp/maddy.DefaultLibexecDirectory=/run/wrappers/bin"
  ];

  subPackages = [
    "cmd/maddy"
    "cmd/maddy-pam-helper"
    "cmd/maddy-shadow-helper"
  ];

  buildInputs = [ pam ];

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postInstall = ''
    for f in docs/man/*.scd; do
      local page="docs/man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    ln -s "$out/bin/maddy" "$out/bin/maddyctl"

    mkdir -p "$out/libexec/maddy"
    mv "$out/bin/maddy-pam-helper" "$out/bin/maddy-shadow-helper" "$out/libexec/maddy"

    mkdir -p $out/lib/systemd/system

    substitute dist/systemd/maddy.service $out/lib/systemd/system/maddy.service \
      --replace-fail "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace-fail "/bin/kill" "${coreutils}/bin/kill"

    substitute dist/systemd/maddy@.service $out/lib/systemd/system/maddy@.service \
      --replace-fail "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace-fail "/bin/kill" "${coreutils}/bin/kill"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=strict-prototypes";

  meta = {
    description = "Composable all-in-one mail server";
    homepage = "https://maddy.email";
    license = lib.licenses.gpl3Plus;
    mainProgram = "maddy";
  };
})
