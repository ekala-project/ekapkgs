{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "apg";
  version = "unstable-2015-01-29";

  src = fetchFromGitHub {
    owner = "wilx";
    repo = "apg";
    rev = "7ecdbac79156c8864fa3ff8d61e9f1eb264e56c2";
    sha256 = "sha256-+7TrJACdm/i/pc0dsp8edEIOjx8cip+x0Qc2gONajSE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openssl ];

  meta = {
    description = "Tools for random password generation";
    homepage = "https://github.com/wilx/apg";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
