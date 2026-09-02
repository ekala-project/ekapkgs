{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmtouch";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "vmtouch";
    rev = "v${finalAttrs.version}";
    sha256 = "08da6apzfkfjwasn4dxrlfxqfx7arl28apdzac5nvm0fhvws0dxk";
  };

  buildInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Portable file system cache diagnostics and control";
    homepage = "https://hoytech.com/vmtouch/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "vmtouch";
  };
})
