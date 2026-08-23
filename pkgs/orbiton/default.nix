{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  withGui ? false,
  vte ? null,
}:

buildGo126Module rec {
  pname = "orbiton";
  version = "2.74.4";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "orbiton";
    tag = "v${version}";
    hash = "sha256-LwwHwi1NyKqyzJou4sh+gM2NxNdYvpBN2Zx8SIOHX40=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = lib.optional withGui vte;

  preBuild = "cd v2";

  checkFlags =
    let
      skippedTests = [
        "TestPBcopy"
        "TestPkill"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    cd ..
    installManPage o.1
    mv $out/bin/{orbiton,o}
  ''
  + lib.optionalString withGui ''
    make install-gui PREFIX=$out
    wrapProgram $out/bin/og --prefix PATH : $out/bin
  '';

  meta = {
    description = "Config-free text editor and IDE limited to VT100";
    homepage = "https://roboticoverlords.org/orbiton/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "o";
  };
}
