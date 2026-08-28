{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  gettext,
  json-glib,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "girara";
  version = "2026.02.04";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "girara";
    tag = finalAttrs.version;
    hash = "sha256-wTVgldfo8pWdY244nNldiogioijv/k32w1A8pEqOTRE=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    glib
  ];

  buildInputs = [
    libintl
    json-glib
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Ddocs=disabled"
    (lib.mesonEnable "tests" false)
  ];

  doCheck = false;

  meta = {
    homepage = "https://pwmt.org/projects/girara";
    description = "User interface library";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
