{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hicolor-icon-theme";
  version = "0.18";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "default-icon-theme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uoB7u/ok7vMxKDl8pINdnV9VsvmsntBcZuz3Q4zGz7M=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
  ];

  outputs = [
    "out"
    "dev"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = "https://www.freedesktop.org/wiki/Software/icon-theme/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
  };
})
