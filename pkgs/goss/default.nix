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
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "goss-org";
    repo = "goss";
    tag = "v${version}";
    hash = "sha256-GdkLasokpWegjK4kZzAskp1NGwcuMjrjjau75cEo8kg=";
  };

  vendorHash = "sha256-Rf6Xt54y1BN2o90rDW0WvEm4H5pPfsZ786MXFjsAFaM=";

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
      ] ++ lib.optionals (systemd != null) [ systemd ];
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
