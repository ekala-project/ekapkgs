{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmodbus";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "stephane";
    repo = "libmodbus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eGbgQpXBHxVnXRQKzzF2zfSVlaQNTu1CwrU0ZxaqA3Y=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "Library to send/receive data according to the Modbus protocol";
    homepage = "https://libmodbus.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix ++ windows;
  };
})
