{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  pkg-config,
  taglib,
  zlib,

  # Disable on-the-fly transcoding,
  # removing the dependency on ffmpeg.
  transcodingSupport ? true,
  ffmpeg,
  # Setting this to false does not disable the jukebox feature,
  # but avoids the dependency on mpv at least.
  jukeboxSupport ? true,
  mpv,
}:

buildGo126Module (finalAttrs: {
  pname = "gonic";
  version = "0.22.0";
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "gonic";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-I0+5mzybWc8NP3yfePFyHEsSTDfniYQjIaZpe4djGGM=";
  };

  vendorHash = "sha256-OynYgtqWNMyrUvysi9cNqL0nAfUXP8cOEx02lSP6E7E=";

  postPatch =
    lib.optionalString transcodingSupport ''
      substituteInPlace \
        transcode/transcode.go \
        --replace-fail \
          '`ffmpeg' \
          '`${lib.getBin ffmpeg}/bin/ffmpeg'
    ''
    + lib.optionalString jukeboxSupport ''
      substituteInPlace \
        jukebox/jukebox.go \
        --replace-fail \
          '"mpv"' \
          '"${lib.getBin mpv}/bin/mpv"'
    ''
    + ''
      substituteInPlace server/ctrlsubsonic/testdata/test* \
        --replace-quiet \
          '"audio/flac"' \
          '"audio/x-flac"'
    '';

  meta = {
    homepage = "https://github.com/sentriz/gonic";
    description = "Music streaming server / subsonic server API implementation";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gonic";
  };
})
