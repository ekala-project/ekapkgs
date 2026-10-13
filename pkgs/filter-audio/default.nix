{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filter-audio";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "irungentoo";
    repo = "filter_audio";
    tag = "v${finalAttrs.version}";
    sha256 = "1dv4pram317c1w97cjsv9f6r8cdxhgri7ib0v364z08pk7r2avfn";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Lightweight audio filtering library made from webrtc code";
    homepage = "https://github.com/irungentoo/filter_audio";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
