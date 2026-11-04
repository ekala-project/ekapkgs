{
  stdenvNoCC,
  makeWrapper,
  neovim,
  neovim-qt-unwrapped,
}:

let
  unwrapped = neovim-qt-unwrapped;
in
stdenvNoCC.mkDerivation {
  pname = "neovim-qt";
  version = unwrapped.version;

  buildCommand = ''
    makeWrapper ${unwrapped}/bin/nvim-qt $out/bin/nvim-qt \
      --prefix PATH : ${neovim}/bin

    mkdir -p $out/share
    ln -s ${unwrapped}/share/applications $out/share/applications
    ln -s ${unwrapped}/share/icons $out/share/icons
  '';

  preferLocalBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  passthru = {
    inherit unwrapped;
  };

  inherit (unwrapped) meta;
}
