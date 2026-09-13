{
  lib,
  stdenv,
  fetchFromGitHub,
  docopt_cpp,
  icu,
  libkiwix,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kiwix-tools";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    tag = finalAttrs.version;
    hash = "sha256-JtHi/rbXMoP0YT1wsBjjx9jK3weptnTs8hm1rhW06Bg=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    docopt_cpp
    icu
    libkiwix
  ];

  meta = {
    description = "Command line Kiwix tools";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/kiwix-tools/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
