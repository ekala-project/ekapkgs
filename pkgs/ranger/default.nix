{
  lib,
  fetchFromGitHub,
  python3Packages,
  file,
  less,
  highlight,
  w3m,
  imagemagick,
}:

python3Packages.buildPythonApplication {
  pname = "ranger";
  version = "1.9.3-unstable-2025-06-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "7e38143eaa91c82bed8f309aa167b1e6f2607576";
    hash = "sha256-O0DjecncpN+Bv8Ng+keuvU9iVtWAV4a50p959pMvkww=";
  };

  LC_ALL = "en_US.UTF-8";

  doCheck = false;

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    less
    file
    python3Packages.pillow
    python3Packages.chardet
    imagemagick
  ];

  preConfigure = ''
    sed -i -e 's|^\s*highlight\b|${highlight}/bin/highlight|' \
      ranger/data/scope.sh

    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${lib.getBin less}/bin/less'"

    # give file previews out of the box
    substituteInPlace ranger/config/rc.conf \
      --replace /usr/share $out/share \
      --replace "#set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"

    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true"
  '';

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "https://ranger.github.io/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "ranger";
  };
}
