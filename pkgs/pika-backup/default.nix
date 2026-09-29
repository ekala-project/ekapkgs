{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  replaceVars,
  cargo,
  desktop-file-utils,
  git,
  itstool,
  meson,
  ninja,
  pkg-config,
  python3,
  rustc,
  borgbackup,
  gtk4,
  libadwaita,
  libsecret,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "pika-backup";
  version = "0.8.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    tag = version;
    hash = "sha256-7Nr/KmjI7zcocfsPxVsYRC+Tye9Qu7pa+14f6nAPgRk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-tQz+2+6Yeqenis7QDRlmMTQIaLRE1uOC4tTRUrEeyXw=";
  };

  patches = [
    (replaceVars ./borg-path.patch {
      borg = lib.getExe borgbackup;
    })
  ];

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    git
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    rustc
    rustPlatform.cargoSetupHook
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    libsecret
    openssl
  ];

  meta = {
    description = "Simple backups based on borg";
    homepage = "https://apps.gnome.org/app/org.gnome.World.PikaBackup";
    changelog = "https://gitlab.gnome.org/World/pika-backup/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
