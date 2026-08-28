{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-tools";
  version = "4.25.9.0";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
    rev = finalAttrs.version;
    hash = "sha256-u7bnFmSEXNGVZTJ71kOTscQLymbjJblJCIY9Uj7/3mM=";
  };

  configureFlags = [
    "--enable-fanotify"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/inotify-tools/inotify-tools/wiki";
    description = "C library and CLI tools providing a simple interface to inotify";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
