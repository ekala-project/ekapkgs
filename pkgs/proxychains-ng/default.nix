{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxychains-ng";
  version = "4.18";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = "proxychains-ng";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-3l/JKuxSByW1ehj3ufbrDo+Km7Vjv+xy1x/hw7D9o5o=";
  };

  patches = [
    ./swap-priority-4-and-5-in-get_config_path.patch
  ];

  installFlags = [
    "install-config"
    "install-zsh-completion"
  ];

  meta = {
    description = "Preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "proxychains4";
  };
})
