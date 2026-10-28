{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gtk-doc,
  curl,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flickcurl";
  version = "1.26";

  src = fetchFromGitHub {
    owner = "dajobe";
    repo = "flickcurl";
    tag = "flickcurl_1_26";
    hash = "sha256-Lowtny6w9D7Y1sREpgPvZoOvSYdOjzoLRD+Wy6PFOLI=";
  };

  libmtwist = fetchFromGitHub {
    owner = "dajobe";
    repo = "libmtwist";
    rev = "5c9b486cc27202977fb353c46d4ac8a167f370ac";
    hash = "sha256-MJl9XgcB+DZSJ7kp62AIuXurxQhW5PX1krwofBA/AAE=";
  };

  postPatch = ''
    touch NEWS
    rmdir libmtwist
    cp -r $libmtwist libmtwist
    chmod -R u+w libmtwist

    # Generate man pages from .in files (configure doesn't do this)
    for f in docs/*.1.in; do
      cp "$f" "''${f%.in}"
    done
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
  ];

  # flickcurl 1.26 has many C89-isms incompatible with GCC 14+
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=implicit-int"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=int-conversion"
  ];

  configureFlags = [
    "--disable-gtk-doc"
  ];

  buildInputs = [
    curl
    libxml2
  ];

  meta = {
    description = "C library for the Flickr API";
    homepage = "https://librdf.org/flickcurl/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "flickcurl";
  };
})
