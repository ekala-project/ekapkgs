{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  fontconfig,
  python,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  sdl2-compat,
  pkg-config,

  # buildInputs
  freetype,
  libjpeg,
  libpng,
  libx11,
  portmidi,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygame";
    repo = "pygame";
    tag = version;
    hash = "sha256-paSDF0oPogq0g0HSDRagGu0OfsqIku6q4GGAMveGntk=";
    postFetch = "rm -rf $out/docs/reST";
  };

  patches = [
    (replaceVars ./fix-dependency-finding.patch {
      buildinputs_include = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getDev dep}/"
          "${lib.getDev dep}/include"
          "${lib.getDev dep}/include/SDL2"
        ]) buildInputs
      );
      buildinputs_lib = builtins.toJSON (
        builtins.concatMap (dep: [
          "${lib.getLib dep}/"
          "${lib.getLib dep}/lib"
        ]) buildInputs
      );
    })
    ./skip-mixer-test.patch
    ./skip-failing-tests.patch
    ./0001-Use-SDL_HasSurfaceRLE-when-available.patch
    ./0002-Don-t-assume-that-touch-devices-support-get_num_fing.patch
    ./0001-Use-SDL_AllocFormat-instead-of-creating-it-manually.patch
  ];

  postPatch = ''
    substituteInPlace src_py/sysfont.py \
      --replace-fail 'path="fc-list"' 'path="${fontconfig}/bin/fc-list"' \
      --replace-fail /usr/X11/bin/fc-list ${fontconfig}/bin/fc-list
  '';

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    sdl2-compat
    pkg-config
  ];

  buildInputs = [
    freetype
    libjpeg
    libpng
    libx11
    portmidi
    sdl2-compat
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  preConfigure = ''
    ${python.pythonOnBuildForHost.interpreter} buildconfig/config.py
  '';

  doCheck = false;

  pythonImportsCheck = [ "pygame" ];

  meta = {
    description = "Python library for games";
    homepage = "https://www.pygame.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    # https://github.com/pygame/pygame/issues/4706
    broken = true; # Incompatible with Python 3.14
  };
}
