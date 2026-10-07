{
  lib,
  stdenv,
  fetchurl,
  cmake,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tasksh";
  version = "1.2.0";

  src = fetchurl {
    url = "https://taskwarrior.org/download/tasksh-${finalAttrs.version}.tar.gz";
    sha256 = "1z8zw8lld62fjafjvy248dncjk0i4fwygw0ahzjdvyyppx4zjhkf";
  };

  buildInputs = [ readline ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  };

  meta = {
    description = "REPL for taskwarrior";
    homepage = "http://tasktools.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "tasksh";
  };
})
