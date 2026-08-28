{
  lib,
  fetchFromGitHub,
  linkFarm,
  makeWrapper,
  rustPlatform,
  tree-sitter-grammars ? null,
}:

let
  grammarToAttrSet = drv: {
    name = "lib" + (lib.strings.removeSuffix "-grammar" (lib.strings.getName drv)) + ".so";
    path = "${drv}/parser";
  };

  libPath =
    if tree-sitter-grammars != null then
      linkFarm "grammars" (map grammarToAttrSet tree-sitter-grammars.allGrammars)
    else
      null;
in
rustPlatform.buildRustPackage rec {
  pname = "diffsitter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "afnanenayet";
    repo = "diffsitter";
    rev = "v${version}";
    hash = "sha256-XkEaOwPv2hKpadtGHpx+QsRLL/Cq9wQvgkTQ7/zXsTQ=";
    fetchSubmodules = false;
  };

  cargoHash = "sha256-t/XF35nQMTbi7HpW+JkemMEYptTI/Kg7tXLIQmLxQxw=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "dynamic-grammar-libs"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    rm $out/bin/diffsitter_completions
  ''
  + lib.optionalString (libPath != null) ''
    wrapProgram "$out/bin/diffsitter" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  doCheck = false;

  meta = {
    homepage = "https://github.com/afnanenayet/diffsitter";
    description = "Tree-sitter based AST difftool to get meaningful semantic diffs";
    license = lib.licenses.mit;
  };
}
