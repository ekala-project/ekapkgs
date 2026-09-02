{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgpiod";
  version = "2.2.4";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PtkJZ9p6r6S47RjiCRv4cVmlY4BHdB6FCMJ+M/IPnw0=";
  };

  nativeBuildInputs = [
    autoconf-archive
    pkg-config
    autoreconfHook
  ];

  configureFlags = [
    "--enable-tools=yes"
    "--enable-bindings-cxx"
  ];

  meta = {
    description = "C library and tools for interacting with the linux GPIO character device";
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license = with lib.licenses; [
      lgpl21Plus
      lgpl3Plus
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
