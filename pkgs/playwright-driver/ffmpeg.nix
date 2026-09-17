# Playwright's pinned ffmpeg blob for trace/video, not pkgs.ffmpeg.
{ fetchzip
, revision
, system
, throwSystem
,
}:
let
  download =
    (import ./browser-downloads.nix {
      name = "ffmpeg";
      inherit revision;
    }).${system} or throwSystem;
in
fetchzip {
  inherit (download) url stripRoot hash;
}
