{
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  fetchurl,
  pkg-config,
  itstool,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yelp-xsl";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${lib.versions.major finalAttrs.version}/yelp-xsl-${finalAttrs.version}.tar.xz";
    hash = "sha256-WdQ6j4/me3hPFPmgTdSnoJKn9KZKZecbkP4CpHpQ++w=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    itstool
    libxslt
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      xslt/common/domains/gen_yelp_xml.sh
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/yelp-xsl";
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2
      bsd3
    ];
    platforms = lib.platforms.unix;
  };
})
