{
  python3Packages,
  lib,
  fetchzip,
  fontforge,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nerd-font-patcher";
  version = "3.5.1";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${finalAttrs.version}/FontPatcher.zip";
    sha256 = "sha256-gZ41oZPnsVLcchA58eJ1Vl28ccqePpOZd/ZCEKYywX4=";
    stripRoot = false;
  };

  propagatedBuildInputs = [ fontforge ];

  pyproject = false;

  patches = [
    ./use-nix-paths.patch
  ];

  dontBuild = true;

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "${fontforge}/lib/python3*/site-packages"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share $out/lib
    install -Dm755 font-patcher $out/bin/nerd-font-patcher
    cp -ra src/glyphs $out/share/
    cp -ra bin/scripts/name_parser $out/lib/
  '';

  meta = {
    description = "Font patcher to generate Nerd font";
    mainProgram = "nerd-font-patcher";
    homepage = "https://nerdfonts.com/";
    license = lib.licenses.mit;
  };
})
