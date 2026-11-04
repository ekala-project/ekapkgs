{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  installShellFiles,
  ldc,
  pkg-config,
  coreutils,
  curl,
  dbus,
  libnotify,
  sqlite,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onedrive";
  version = "2.5.11";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SUliVuQxnSk8rWOny0VAVOnQS2PQedyzN75QQLL8ELQ=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    ldc
    pkg-config
  ];

  buildInputs = [
    curl
    dbus
    libnotify
    sqlite
    systemd
  ];

  configureFlags = [
    "--enable-notifications"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  postInstall = ''
    installShellCompletion --cmd onedrive \
      --bash contrib/completions/complete.bash \
      --fish contrib/completions/complete.fish \
      --zsh contrib/completions/complete.zsh

    substituteInPlace $out/lib/systemd/user/onedrive.service $out/lib/systemd/system/onedrive@.service \
      --replace-fail "/bin/sh -c 'sleep 15'" "${coreutils}/bin/sleep 15"
  '';

  meta = {
    homepage = "https://github.com/abraunegg/onedrive";
    description = "Complete tool to interact with OneDrive on Linux";
    license = lib.licenses.gpl3Only;
    mainProgram = "onedrive";
    platforms = lib.platforms.linux;
  };
})
