{
  lib,
  stdenv,
  fetchurl,
  docbook_xml_dtd_45,
  docbook-xsl,
  intltool,
  itstool,
  libxslt,
  pkg-config,
  gtk3,
  xxd,
  yelp-tools,
  curl,
  gdk-pixbuf,
  json-glib,
  libnova,
  libxml2,
  gpsbabel,
  withGeoClue ? true,
  geoclue2,
  withGeoTag ? true,
  gexiv2_0_10,
  withMagic ? true,
  file,
  withMBTiles ? true,
  sqlite,
  withMd5Hash ? true,
  nettle,
  withOAuth ? true,
  liboauth,
  withRealtimeGPSTracking ? true,
  gpsd,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "viking";
  version = "1.11";

  src = fetchurl {
    url = "mirror://sourceforge/viking/viking-${finalAttrs.version}.tar.bz2";
    hash = "sha256-/iHVwRHvIId9HNlbGkvDT6rp3ToXuskj9BjhJxo8/JE=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook-xsl
    intltool
    itstool
    libxslt
    pkg-config
    gtk3.wrapGAppsHook
    xxd
    yelp-tools
  ];

  buildInputs = [
    curl
    gdk-pixbuf
    gtk3
    json-glib
    libnova
    libxml2
    xz
  ]
  ++ lib.optional withGeoClue geoclue2
  ++ lib.optional withGeoTag gexiv2_0_10
  ++ lib.optional withMagic file
  ++ lib.optional withMBTiles sqlite
  ++ lib.optional withMd5Hash nettle
  ++ lib.optional withOAuth liboauth
  ++ lib.optional withRealtimeGPSTracking gpsd;

  configureFlags = [
    (lib.enableFeature withGeoClue "geoclue")
    (lib.enableFeature withGeoTag "geotag")
    (lib.enableFeature withMagic "magic")
    "--disable-mapnik"
    (lib.enableFeature withMBTiles "mbtiles")
    (lib.enableFeature withMd5Hash "nettle")
    (lib.enableFeature withOAuth "oauth")
    (lib.enableFeature withRealtimeGPSTracking "realtime-gps-tracking")
  ];

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ gpsbabel ]}
    )
  '';

  meta = {
    description = "GPS data editor and analyzer";
    mainProgram = "viking";
    homepage = "https://sourceforge.net/projects/viking/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
