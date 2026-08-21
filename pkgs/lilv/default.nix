{
  lib,
  stdenv,
  fetchurl,
  lv2,
  meson,
  ninja,
  pkg-config,
  python3,
  libsndfile,
  serd,
  sord,
  sratom,
}:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.26.4";

  src = fetchurl {
    url = "https://download.drobilla.net/lilv-${version}.tar.xz";
    hash = "sha256-HItfy3hxgXPmfXblGtQj9RE6n/aEY/JWYZWuRjlgieM=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    libsndfile
    serd
    sord
    sratom
  ];

  propagatedBuildInputs = [ lv2 ];

  mesonFlags = [
    "-Ddocs=disabled"
    "-Dtests=disabled"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux (
    lib.mesonOption "default_lv2_path" "~/.lv2:/usr/local/lib/lv2:/usr/lib/lv2:~/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2"
  );

  meta = {
    homepage = "http://drobilla.net/software/lilv";
    description = "C library to make the use of LV2 plugins";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
