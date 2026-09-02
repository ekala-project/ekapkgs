{
  lib,
  fetchurl,
  libxml2,
  libxslt,
  itstool,
  pkg-config,
  meson,
  ninja,
  python3,
  yelp-xsl,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "yelp-tools";
  version = "42.1";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-tools/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "PklqQCDUFFuZ/VCKJfoJM2pQOk6JAAKEIecsaksR+QU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  propagatedBuildInputs = [
    libxml2
    libxslt
  ];

  buildInputs = [
    itstool
    yelp-xsl
  ];

  pythonPath = [
    python3.pkgs.lxml
  ];

  strictDeps = false;

  doCheck = true;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/yelp-tools";
    description = "Small programs that help you create, edit, manage, and publish your Mallard or DocBook documentation";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
