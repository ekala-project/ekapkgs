{
  lib,
  stdenv,
  fetchurl,
  gnutls,
  openssl,
  libgcrypt,
  libgpg-error,
  pkg-config,
  gettext,
  which,
  gtk3,

  pluginSearchPaths ? [
    "/run/current-system/sw/lib/gwenhywfar/plugins"
    ".nix-profile/lib/gwenhywfar/plugins"
  ],
}:

stdenv.mkDerivation rec {
  pname = "gwenhywfar";
  version = "5.11.2beta";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/518/${pname}-${version}.tar.gz";
    hash = "sha256-5/KxLAktb1mPKeJVsLAD2YrBeWyFtzpXCJDb8tzzWyQ=";
  };

  configureFlags = [
    "--with-openssl-includes=${openssl.dev}/include"
    "--with-openssl-libs=${lib.getLib openssl}/lib"
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-guis=gtk3")
  '';

  postPatch =
    let
      isRelative = path: builtins.substring 0 1 path != "/";
      mkSearchPath =
        path:
        ''
          p; g; s,\<PLUGINDIR\>,"${path}",g;
        ''
        + lib.optionalString (isRelative path) ''
          s/AddPath(\(.*\));/AddRelPath(\1, GWEN_PathManager_RelModeHome);/g
        '';

    in
    ''
      sed -i -e '/GWEN_PathManager_DefinePath.*GWEN_PM_PLUGINDIR/,/^#endif/ {
        /^#if/,/^#endif/ {
          H; /^#endif/ {
            ${lib.concatMapStrings mkSearchPath pluginSearchPaths}
          }
        }
      }' src/gwenhywfar.c

      # Strip off the effective SO version from the path so that for example
      # "lib/gwenhywfar/plugins/60" becomes just "lib/gwenhywfar/plugins".
      sed -i -e '/^gwenhywfar_plugindir=/s,/\''${GWENHYWFAR_SO_EFFECTIVE},,' \
        configure
    '';

  nativeBuildInputs = [
    pkg-config
    gettext
    which
  ];

  buildInputs = [
    gtk3
    gnutls
    openssl
    libgcrypt
    libgpg-error
  ];

  meta = {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = "https://www.aquamaniac.de/rdm/projects/gwenhywfar";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
