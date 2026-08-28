{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  asciidoc,
  jansson,
  jose,
  http-parser,
  systemd,
  meson,
  ninja,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tang";
  version = "15";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nlC2hdNzQZrfirjS2gX4oFp2OD1OdxmLsN03hfxD3ug=";
  };

  nativeBuildInputs = [
    asciidoc
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    jansson
    jose
    http-parser
    systemd
  ];

  outputs = [
    "out"
    "man"
  ];

  postFixup = ''
    wrapProgram $out/bin/tang-show-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-keygen --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-rotate-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
  '';

  meta = {
    description = "Server for binding data to network presence";
    homepage = "https://github.com/latchset/tang";
    changelog = "https://github.com/latchset/tang/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "tangd";
  };
})
