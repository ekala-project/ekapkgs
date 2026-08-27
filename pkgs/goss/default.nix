{
  bash,
  buildGo126Module,
  fetchFromGitHub,
  getent,
  lib,
  makeWrapper,
  systemd ? null,
}:

buildGo126Module rec {
  pname = "goss";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "goss-org";
    repo = "goss";
    tag = "v${version}";
    hash = "sha256-4DCPPeTL2x6mMpcP/cdyQWpqehGWkk7MWM7P93WzwCA=";
  };

  vendorHash = "sha256-NlOS5APp9R45QpYKwP673pmN7CR+Ufz8LxWyMkrVeq0=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goss-org/goss/util.Version=v${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall =
    let
      runtimeDependencies = [
        bash
        getent
      ]
      ++ lib.optionals (systemd != null) [ systemd ];
    in
    ''
      wrapProgram $out/bin/goss \
        --prefix PATH : "${lib.makeBinPath runtimeDependencies}"
    '';

  meta = {
    homepage = "https://github.com/goss-org/goss/";
    changelog = "https://github.com/goss-org/goss/releases/tag/v${version}";
    description = "Quick and easy server validation";
    license = lib.licenses.asl20;
    mainProgram = "goss";
    maintainers = [ ];
  };
}
