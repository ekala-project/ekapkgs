{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  ncurses,
  bash,
  gawk,
  gettext,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vim";
  version = "9.2.0389";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-shhdJn1bPJ/68a54UZMn1fla7P4tjVUN4DGLbx3ohOg=";
  };

  outputs = [
    "out"
    "xxd"
  ];

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    ncurses
    bash
    gawk
  ];

  hardeningDisable = if stdenv.cc.isClang then [ "strictflexarrays1" ] else [ "fortify" ];

  postPatch = ''
    substituteInPlace runtime/ftplugin/man.vim \
      --replace "/usr/bin/man " "man "
  '';

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ];

  preConfigure = ''
    export HOST_PATH
    substituteInPlace src/which.sh --replace '$PATH' '$HOST_PATH'
  '';

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  postInstall =
    let
      vimrc = fetchurl {
        name = "default-vimrc";
        url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/68f6d131750aa778807119e03eed70286a17b1cb/trunk/archlinux.vim";
        sha256 = "18ifhv5q9prd175q3vxbqf6qyvkk6bc7d2lhqdk0q78i68kv9y0c";
      };
    in
    ''
      ln -s $out/bin/vim $out/bin/vi
      mkdir -p $out/share/vim
      cp "${vimrc}" $out/share/vim/vimrc

      for tool in ex xxd vi view vimdiff; do
        if [ ! -e "$out/bin/$tool" ]; then
          echo "ERROR: install phase did not install '$tool'."
          exit 1
        fi
      done
    '';

  postFixup = ''
    moveToOutput bin/xxd "$xxd"
    moveToOutput share/man/man1/xxd.1.gz "$xxd"
    for manFile in $out/share/man/*/man1/xxd.1*; do
      moveToOutput "share/man/$(basename "$(dirname "$(dirname "$manFile")")")/man1/xxd.1.gz" "$xxd"
    done
  '';

  meta = {
    description = "Most popular clone of the VI editor";
    homepage = "https://www.vim.org";
    license = lib.licenses.vim;
    platforms = lib.platforms.unix;
    mainProgram = "vim";
  };
})
