{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  python3,
  addDriverRunpath,
  libx11,
  libxext,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libglvnd";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "glvnd";
    repo = "libglvnd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2U9JtpGyP4lbxtVJeP5GUgh5XthloPvFIw28+nldYx8=";
  };

  patches = [
    (fetchpatch {
      name = "large-file.patch";
      url = "https://gitlab.freedesktop.org/glvnd/libglvnd/-/commit/956d2d3f531841cabfeddd940be4c48b00c226b4.patch";
      hash = "sha256-Y6YCzd/jZ1VZP9bFlHkHjzSwShXeA7iJWdyfxpgT2l0=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    addDriverRunpath
  ];
  buildInputs = [
    libx11
    libxext
    xorgproto
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/GLX/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/EGL/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/GLdispatch/Makefile.am \
      --replace "-Xlinker --version-script=$(VERSION_SCRIPT)" "-Xlinker"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
      "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${addDriverRunpath.driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""

      "-Wno-error=array-bounds"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error"
      "-Wno-int-conversion"
    ]
  );

  configureFlags =
    [ ]
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-tls"
    ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) "--disable-asm";

  outputs = [
    "out"
    "dev"
  ];

  postFixup = ''
    addDriverRunpath $out/lib/libGLX.so
  '';

  passthru = { inherit (addDriverRunpath) driverLink; };

  meta = {
    description = "GL Vendor-Neutral Dispatch library";
    inherit (finalAttrs.src.meta) homepage;
    changelog = "https://gitlab.freedesktop.org/glvnd/libglvnd/-/tags/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      bsd1
      bsd3
      gpl3Only
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
