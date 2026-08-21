{
  lib,
  stdenvNoCC,
  fetchgit,
  majorVersion ? null,
}:

stdenvNoCC.mkDerivation {
  pname = "nv-codec-headers";
  version = "12.1.14.0";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n12.1.14.0";
    hash = "sha256-WJYuFmMGSW+B32LwE7oXv/IeTln6TNEeXSkquHh85Go=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "FFmpeg version of headers for NVENC";
    homepage = "https://ffmpeg.org/";
    downloadPage = "https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
