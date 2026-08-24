{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  libevent,
  ncurses,
  pkg-config,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  withUtf8proc ? true,
  utf8proc,
  withUtempter ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl,
  libutempter,
  withSixel ? true,
}:

let
  bashCompletion = fetchFromGitHub {
    owner = "imomaliev";
    repo = "tmux-bash-completion";
    rev = "f5d53239f7658f8e8fbaf02535cc369009c436d6";
    sha256 = "0sq2g3w0h3mkfa6qwqdw93chb5f1hgkz5vdl8yw8mxwdqwhsdprr";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tmux";
  version = "3.7c";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = finalAttrs.version;
    hash = "sha256-TpZXTeXKQv6MV1vAPu5MIT52d3Pl6dYcOReZa7QANZY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    bison
  ];

  buildInputs = [
    ncurses
    libevent
  ]
  ++ lib.optionals withSystemd [ systemd ]
  ++ lib.optionals withUtf8proc [ utf8proc ]
  ++ lib.optionals withUtempter [ libutempter ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ]
  ++ lib.optionals withSystemd [ "--enable-systemd" ]
  ++ lib.optionals withSixel [ "--enable-sixel" ]
  ++ lib.optionals withUtempter [ "--enable-utempter" ]
  ++ lib.optionals withUtf8proc [ "--enable-utf8proc" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    cp -v ${bashCompletion}/completions/tmux $out/share/bash-completion/completions/tmux
  '';

  meta = {
    homepage = "https://tmux.github.io/";
    description = "Terminal multiplexer";
    changelog = "https://github.com/tmux/tmux/raw/${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "tmux";
    maintainers = [ ];
  };
})
