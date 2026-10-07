{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.5";
  pname = "nanomsg";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = finalAttrs.version;
    sha256 = "sha256-GnpWBME9oN6Rqq+MDUwQhRKtNkoG/OKxXASCdvJHNvQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Socket library that provides several common communication patterns";
    homepage = "https://nanomsg.org/";
    license = lib.licenses.mit;
    mainProgram = "nanocat";
    platforms = lib.platforms.unix;
  };
})
