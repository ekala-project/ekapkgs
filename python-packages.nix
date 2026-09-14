# Python package overrides for ekapkgs
#
# Applied after upstream python-packages overlays.
# Use final.pkgs to access top-level packages.
final: prev: {

  # lxml: In the python scope, libxml2 and libxslt default to their
  # "py" output which only contains Python bindings.  The build needs
  # the "dev" output for headers and pkg-config files.
  lxml = prev.lxml.overridePythonAttrs (old: {
    buildInputs = old.buildInputs ++ [
      final.pkgs.libxml2.dev
      final.pkgs.libxslt.dev
    ];
  });

  pycairo = prev.pycairo.overridePythonAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.pkgs.meson.configurePhaseHook ];
  });

  pygobject3 = final.buildPythonPackage rec {
    pname = "pygobject";
    version = "3.56.3";

    outputs = [
      "out"
      "dev"
    ];

    pyproject = false;

    src = final.pkgs.fetchurl {
      url = "mirror://gnome/sources/pygobject/${final.pkgs.lib.versions.majorMinor version}/pygobject-${version}.tar.gz";
      hash = "sha256-EnYOSg49BLbrleBveifjYsgm1WfqYTNzqSwAO2xw0tY=";
    };

    depsBuildBuild = [ final.pkgs.pkg-config ];

    nativeBuildInputs = [
      final.pkgs.pkg-config
      final.pkgs.meson
      final.pkgs.meson.configurePhaseHook
      final.pkgs.ninja
      final.pkgs.gobject-introspection
    ];

    buildInputs = [
      final.pkgs.cairo
      final.pkgs.glib
    ];

    propagatedBuildInputs = [
      final.pycairo
      final.pkgs.gobject-introspection
    ];

    mesonFlags = [
      "-Dpython=${final.python.pythonOnBuildForHost.interpreter}"
    ];

    meta = {
      homepage = "https://pygobject.readthedocs.io/";
      description = "Python bindings for Glib";
      license = final.pkgs.lib.licenses.lgpl21Plus;
      platforms = final.pkgs.lib.platforms.unix;
    };
  };

  nftables = final.buildPythonPackage {
    pname = "nftables";
    inherit (final.pkgs.nftables) version src;
    pyproject = true;

    postPatch = ''
      substituteInPlace "src/nftables.py" \
        --replace-fail 'NFTABLES_VERSION = "0.1"' 'NFTABLES_VERSION = "${final.pkgs.nftables.version}"' \
        --replace-fail "libnftables.so.1" "${final.pkgs.nftables}/lib/libnftables.so.1"
    '';

    setSourceRoot = "sourceRoot=$(echo */py)";

    build-system = [ final.setuptools ];

    pythonImportsCheck = [ "nftables" ];

    meta = {
      description = "Python bindings for nftables";
      homepage = "https://netfilter.org/projects/nftables/";
      license = final.pkgs.lib.licenses.gpl2Only;
      platforms = final.pkgs.lib.platforms.linux;
    };
  };

  pydbus = final.buildPythonPackage rec {
    pname = "pydbus";
    version = "0.6.0";
    pyproject = true;

    src = final.pkgs.fetchFromGitHub {
      owner = "LEW21";
      repo = "pydbus";
      rev = "v${version}";
      hash = "sha256-MHwt9XaGcjMjq3FuVWMVqyIEgFoZnhmDhbMaEJUbfkA=";
    };

    build-system = [ final.setuptools ];
    dependencies = [ final.pygobject3 ];

    meta = {
      description = "Pythonic D-Bus library";
      homepage = "https://github.com/LEW21/pydbus";
      license = final.pkgs.lib.licenses.lgpl2Plus;
    };
  };

}
