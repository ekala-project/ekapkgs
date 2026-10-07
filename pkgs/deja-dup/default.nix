{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  itstool,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  glib-networking,
  gtk4,
  libsoup_3,
  libsecret,
  libadwaita,
  libgpg-error,
  json-glib,
  # TODO(ekapkgs): borgbackup build is broken (python3-pkgconfig setup-hook issue)
  # borgbackup,
  duplicity,
  rclone,
  restic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deja-dup";
  version = "50.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    tag = finalAttrs.version;
    hash = "sha256-c4Myy1nV6CupGG53Iqm0Z82yVx/Llgot4IZCrnubacE=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    gettext
    itstool
    blueprint-compiler
    desktop-file-utils
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    libsoup_3
    glib
    glib-networking
    gtk4
    libsecret
    libadwaita
    libgpg-error
    json-glib
  ];

  mesonEntries = {
    duplicity_command = (lib.getExe duplicity);
    rclone_command = (lib.getExe rclone);
    restic_command = (lib.getExe restic);
  };

  mesonFeatures = {
    packagekit = false;
  };

  preFixup = ''
    gappsWrapperArgs+=(
      # Required by duplicity
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  patches = [ ./find-fusermount-setuid.patch ];

  meta = {
    description = "Simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity
      of backing up the Right Way (encrypted, off-site, and regular)
      and uses duplicity as the backend.
    '';
    homepage = "https://apps.gnome.org/DejaDup/";
    changelog = "https://gitlab.gnome.org/World/deja-dup/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "deja-dup";
  };
})
