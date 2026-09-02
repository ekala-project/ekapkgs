{
  lib,
  buildGo126Module,
  fetchFromCodeberg,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "noti";
  version = "3.8.0";

  src = fetchFromCodeberg {
    owner = "roble";
    repo = "noti";
    tag = finalAttrs.version;
    hash = "sha256-WCkzSvJoSwlloxKD2AseYIwOZTMnSU69y75J7RAl/XE=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/noti" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/variadico/noti/internal/command.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  postInstall = ''
    installManPage docs/man/dist/*
  '';

  meta = {
    description = "Monitor a process and trigger a notification";
    homepage = "https://codeberg.org/roble/noti";
    license = lib.licenses.mit;
    mainProgram = "noti";
  };
})
