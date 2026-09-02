{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  pkg-config,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "portaudio";
  version = "190700_20210406";

  src = fetchurl {
    url = "https://files.portaudio.com/archives/pa_stable_v${finalAttrs.version}.tgz";
    sha256 = "1vrdrd42jsnffh6rq8ap2c6fr4g9fcld89z649fs06bwqx1bzvs7";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  configureFlags = [
    "--disable-mac-universal"
    "--enable-cxx"
  ];

  # Disable parallel build as it fails
  enableParallelBuilding = false;

  postPatch = ''
    # workaround for the configure script which expects an absolute path
    export AR=$(which $AR)
  '';

  installPhase = ''
    make install
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # fixup .pc file to find alsa library
    sed -i "s|-lasound|-L${alsa-lib.out}/lib -lasound|" "$out/lib/pkgconfig/"*.pc
  '';

  passthru = {
    api_version = 19;
  };

  meta = {
    description = "Portable cross-platform Audio API";
    homepage = "https://www.portaudio.com/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
