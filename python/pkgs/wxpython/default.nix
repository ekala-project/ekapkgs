{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  replaceVars,

  # build
  autoPatchelfHook,
  attrdict,
  cython,
  doxygen,
  pkg-config,
  python,
  requests,
  sip,
  which,
  waf,

  # runtime
  cairo,
  gstreamer,
  gtk3,
  libGL,
  libGLU,
  libsm,
  libxinerama,
  libxtst,
  libxxf86vm,
  libglvnd,
  libgbm,
  pango,
  webkitgtk_4_1,
  wxwidgets_3_2,
  xorgproto,

  # propagates
  numpy,
  pillow,
  six,
}:

let
  wxGTK = wxwidgets_3_2.override { withWebKit = true; };
in
buildPythonPackage rec {
  pname = "wxpython";
  version = "4.2.5";
  pyproject = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ROg20bzNmcOHkLsDS27PcNkGD2c0MgVg98Sw0AYUR5M=";
  };

  patches = [
    (replaceVars ./4.2-ctypes.patch {
      libgdk = "${lib.getLib gtk3}/lib/libgdk-3${stdenv.hostPlatform.extensions.sharedLibrary}";
      libpangocairo = "${lib.getLib pango}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      libcairo = "${lib.getLib cairo}/lib/libcairo${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
    ./0001-add-missing-bool-c.patch
  ];

  postPatch = ''
    ln -s ${lib.getExe waf} bin/waf
    substituteInPlace build.py \
      --replace-fail "distutils.dep_util" "setuptools.modified" \
      --replace-fail "runcmd(cmd, fatal=False)" "runcmd(cmd, fatal=True)"
  '';

  nativeBuildInputs = [
    attrdict
    cython
    pkg-config
    requests
    setuptools
    sip
    which
    wxGTK
    autoPatchelfHook
  ];

  buildInputs = [
    wxGTK
    gstreamer.pkgs.gst-plugins-base
    gstreamer
    libGL
    libGLU
    libsm
    libxinerama
    libxtst
    libxxf86vm
    libglvnd
    libgbm
    webkitgtk_4_1
    xorgproto
  ];

  propagatedBuildInputs = [
    numpy
    pillow
    six
  ];

  buildPhase = ''
    runHook preBuild

    export DOXYGEN=${doxygen}/bin/doxygen
    export PATH="${wxGTK}/bin:$PATH"

    ${python.pythonOnBuildForHost.interpreter} build.py -v --use_syswx dox etg sip --nodoc build_py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python.pythonOnBuildForHost.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms

    runHook postInstall
  '';

  meta = {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    # webkitgtk_4_1 -> spidermonkey build failure in ekapkgs
    broken = true;
  };
}
