{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxaw,
  libxt,
  wrapWithXFileSearchPathHook ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmessage";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xmessage-${finalAttrs.version}.tar.xz";
    hash = "sha256-cD/Mt6C3ctYdfmA8GJuXOYZqqXuphccnJ1Qg+CmjA1Y=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (wrapWithXFileSearchPathHook != null) wrapWithXFileSearchPathHook;

  buildInputs = [
    libxaw
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  meta = {
    description = "Display a message or query in a window";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xmessage";
    license = lib.licenses.x11;
    mainProgram = "xmessage";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
