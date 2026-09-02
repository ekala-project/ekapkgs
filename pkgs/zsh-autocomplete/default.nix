{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-autocomplete";
  version = "26.08.04";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-autocomplete";
    rev = version;
    sha256 = "sha256-aba38Cmnps2n6Tr/1i3BjPZ4TbQPsDBURXF1fcd8cDI=";
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-autocomplete.plugin.zsh $out/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    cp -R Completions $out/share/zsh-autocomplete/Completions
    cp -R Functions $out/share/zsh-autocomplete/Functions
  '';

  meta = {
    description = "Real-time type-ahead completion for Zsh. Asynchronous find-as-you-type autocompletion";
    homepage = "https://github.com/marlonrichert/zsh-autocomplete/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
