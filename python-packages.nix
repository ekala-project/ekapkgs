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
    pyproject = false;
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

    mesonEntries = {
      python = "${final.python.pythonOnBuildForHost.interpreter}";
    };

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

  # python-xlib's setup.py imports pkg_resources which was removed in setuptools 84
  python-xlib = prev.python-xlib.overridePythonAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace setup.py \
        --replace-fail "from pkg_resources import parse_requirements" "" \
        --replace-fail "setuptools_require = next(parse_requirements('setuptools>=30.3.0'))" "" \
        --replace-fail "assert setuptools_version in setuptools_require, '{} is required'.format(setuptools_require)" ""
    '';
  });

  # The python pkgconfig package has a broken setup-hook in corepkgs
  # (unsubstituted @wrapperName@/@suffixSalt@ placeholders).
  # uharfbuzz bundles harfbuzz as a submodule and doesn't need system pkg-config,
  # so we remove pkgconfig from build-system and skip the runtime deps check
  # (which would fail looking for the pkgconfig dist-info).
  uharfbuzz = prev.uharfbuzz.overridePythonAttrs (old: {
    build-system = builtins.filter (dep: (dep.pname or "") != "pkgconfig") (old.build-system or [ ]);
    # The corepkgs python-pkgconfig has a broken setup-hook
    # (unsubstituted @wrapperName@/@suffixSalt@ placeholders).
    # uharfbuzz uses pkgconfig at build time to find system harfbuzz, but
    # since it bundles harfbuzz as a submodule, we can remove the dependency
    # and patch both pyproject.toml and setup.py to skip pkgconfig usage.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace pyproject.toml \
        --replace-fail '"pkgconfig"' ""
      substituteInPlace setup.py \
        --replace-fail "import pkgconfig" "" \
        --replace-fail 'harfbuzz_component_configuration = pkgconfig.parse(harfbuzz_component)' 'harfbuzz_component_configuration = {"include_dirs": [], "define_macros": [], "libraries": [], "library_dirs": []}' \
    '';
  });

  img2pdf = final.buildPythonPackage rec {
    pname = "img2pdf";
    version = "0.6.3";
    pyproject = true;

    src = final.pkgs.fetchFromGitHub {
      owner = "josch";
      repo = "img2pdf";
      tag = version;
      hash = "sha256-uHcGCx5DdUxFnATG3T565R+NatLukPPpnRj0TZHToC0=";
    };

    # Skip the ICC profile patch - the upstream fallback paths are fine.

    build-system = [ final.flit-core ];

    dependencies = [
      final.pikepdf
      final.pillow
    ];

    doCheck = false;

    pythonImportsCheck = [ "img2pdf" ];

    meta = {
      description = "Convert images to PDF via direct JPEG inclusion";
      homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
      license = final.pkgs.lib.licenses.lgpl3Plus;
      mainProgram = "img2pdf";
    };
  };

  # autobahn's wheel metadata lists serialization deps as required,
  # but upstream nix expression only has them as optional-dependencies.
  autobahn = prev.autobahn.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ [
      final.cbor2
      final.msgpack
      final.ujson
      final.py-ubjson
    ];
  });

  pyqt5-multimedia = final.pyqt5.override { withMultimedia = true; };

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

  django-tagging = final.buildPythonPackage rec {
    pname = "django-tagging";
    version = "0.5.0";
    format = "setuptools";

    src = final.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "28d68fa4831705e51ad7d1e845ed6dd9e354f9b6f8a5f63b655a430646ef4e8d";
    };

    # error: invalid command 'test'
    doCheck = false;

    propagatedBuildInputs = [ final.django ];

    meta = {
      description = "Generic tagging application for Django projects";
      homepage = "https://github.com/Fantomas42/django-tagging";
    };
  };

  graphite-web = final.buildPythonPackage (finalAttrs: {
    pname = "graphite-web";
    version = "1.1.10-unstable-2025-02-24";
    format = "setuptools";

    src = final.pkgs.fetchFromGitHub {
      owner = "graphite-project";
      repo = "graphite-web";
      rev = "49c28e2015d605ad9ec93524f7076dd924a4731a";
      hash = "sha256-TxsQPhnI5WhQvKKkDEYZ8xnyg/qf+N9Icej6d6A0jC0=";
    };

    postPatch = ''
      substituteInPlace webapp/graphite/settings.py \
        --replace-fail \
          "join(WEBAPP_DIR, 'content')" \
          "join('$out/webapp', 'content')"
    '';

    dependencies = with final; [
      cairocffi
      django
      django-tagging
      gunicorn
      pyparsing
      python-memcached
      pytz
      six
      txamqp
      urllib3
      whisper
    ];

    pythonRelaxDeps = [
      "django"
      "django-tagging"
    ];

    env = {
      GRAPHITE_NO_PREFIX = "True";
      REDIS_HOST = "127.0.0.1";
    };

    pythonImportsCheck = [ "graphite" ];

    # Tests need a running redis (valkey) and a full django test harness.
    doCheck = false;

    meta = {
      description = "Enterprise scalable realtime graphing";
      homepage = "http://graphiteapp.org/";
      license = final.pkgs.lib.licenses.asl20;
    };
  });
}
