{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  desktop-file-utils,
  freecell-solver,
  black-hole-solver,
}:

python3Packages.buildPythonApplication rec {
  pname = "pysolfc";
  version = "3.4.1";
  format = "setuptools";

  src = fetchzip {
    url = "mirror://sourceforge/pysolfc/PySolFC-${version}.tar.xz";
    hash = "sha256-jijrrWhj80n/XFKMFLptDZCsclIhdJHiTrX6CGjVju8=";
  };

  cardsets = stdenv.mkDerivation rec {
    pname = "pysol-cardsets";
    version = "3.1";
    src = fetchzip {
      url = "mirror://sourceforge/pysolfc/PySolFC-Cardsets-${version}.tar.bz2";
      hash = "sha256-NyCnMlMZ6d5+IiyG4cVn/zlDlArLJSs0dIqZiD7Nv4M=";
    };
    installPhase = ''
      runHook preInstall
      cp -r $src $out
      runHook postInstall
    '';
  };

  propagatedBuildInputs = with python3Packages; [
    six
    random2
    configobj
    pysol-cards
    attrs
    pycotap
    pygame
    freecell-solver
    black-hole-solver
    pillow
  ];

  nativeBuildInputs = [ desktop-file-utils ];

  patches = [ ./pysolfc-datadir.patch ];

  postInstall = ''
    mkdir $out/share/PySolFC/cardsets
    cp -r $cardsets/* $out/share/PySolFC/cardsets
  '';

  meta = {
    description = "Collection of more than 1000 solitaire card games";
    mainProgram = "pysol.py";
    homepage = "https://pysolfc.sourceforge.io";
    license = lib.licenses.gpl3;
  };
}
