{
  buildGo126Module,
  fetchFromCodeberg,
  installShellFiles,
  lib,
  pam ? null,
  scdoc,
  withModernCSqlite ? false,
  withPam ? false,
  withSqlite ? true,
}:
buildGo126Module (finalAttrs: {
  pname = "soju";
  version = "0.10.1";

  src = fetchFromCodeberg {
    owner = "emersion";
    repo = "soju";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kOV7EFRr+Ca9bQ1bdDMNf1FiiniIHDebsf5SpbJshsI=";
  };

  vendorHash = "sha256-NP4njea0hcklxWFoxPQqrvyWExeRP/TOzUJcamRnx+s=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  buildInputs = lib.optional (withPam && pam != null) pam;

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/emersion/soju/config.DefaultPath=/etc/soju/config"
    "-X codeberg.org/emersion/soju/config.DefaultUnixAdminPath=/run/soju/admin"
  ];

  tags =
    lib.optional (!withSqlite) "nosqlite"
    ++ lib.optional withModernCSqlite "moderncsqlite"
    ++ lib.optional withPam "pam";

  postBuild = ''
    make doc/soju.1 doc/sojuctl.1
  '';

  checkFlags = [
    "-skip TestPostgresMigrations"
  ];

  postInstall = ''
    installManPage doc/soju.1 doc/sojuctl.1
  '';

  meta = {
    description = "User-friendly IRC bouncer";
    homepage = "https://soju.im";
    changelog = "https://codeberg.org/emersion/soju/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    mainProgram = "sojuctl";
  };
})
