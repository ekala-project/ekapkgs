{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autologin";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "autologin";
    tag = finalAttrs.version;
    hash = "sha256-Cy4v/1NuaiSr5Bl6SQMWk5rga8h1QMBUkHpN6M3bWOc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];
  buildInputs = [ pam ];

  meta = {
    description = "Run a command inside of a new PAM user session";
    homepage = "https://git.sr.ht/~kennylevinsen/autologin";
    changelog = "https://git.sr.ht/~kennylevinsen/autologin/refs/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "autologin";
  };
})
