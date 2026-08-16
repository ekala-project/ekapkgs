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

}
