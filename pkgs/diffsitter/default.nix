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
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "afnanenayet";
    repo = "diffsitter";
    rev = "v${version}";
    hash = "sha256-ta7JcSPEgpJwieYvtZnNMFvsYvz4FuxthhmKMYe2XUE=";
    fetchSubmodules = false;
  };

  cargoHash = "sha256-YgVsWiINzEsmUMAi6ttEtXutwNDJA2viXnV5rGdSSxU=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "dynamic-grammar-libs"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall =
    ''
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
    maintainers = [ ];
  };
}
