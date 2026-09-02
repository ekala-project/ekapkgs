{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  imagemagick ? null,
  pkg-config,
  withXorg ? true,
  libx11,
  libv4l ? null,
  xmlto,
  docbook_xsl,
  autoreconfHook,
  dbus ? null,
  enableVideo ? false,
  enableDbus ? false,
  libintl ? null,
  bash,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "zbar";
  version = "0.23.93";

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = version;
    sha256 = "sha256-6gOqMsmlYy6TK+iYPIBsCPAk8tYDliZYMYeTOidl4XQ=";
  };

  patches = [
    (fetchpatch {
      name = "variable-pkg-config-path.patch";
      url = "https://github.com/mchehab/zbar/commit/368571ffa1a0f6cc41f708dd0d27f9b6e9409df8.patch";
      hash = "sha256-4VEuGAyR7rcIijPLlh4pzL82ESm99Wb35PV/FbY9H6Y=";
    })
    (fetchpatch {
      name = "qt5-detection-fix.patch";
      url = "https://github.com/mchehab/zbar/commit/a549566ea11eb03622bd4458a1728ffe3f589163.patch";
      hash = "sha256-NY3bAElwNvGP9IR6JxUf62vbjx3hONrqu9pMSqaZcLY=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    xmlto
    autoreconfHook
    docbook_xsl
  ];

  buildInputs = [
    imagemagick
    libintl
  ]
  ++ lib.optionals enableDbus [
    dbus
  ]
  ++ lib.optionals withXorg [
    libx11
  ]
  ++ lib.optionals enableVideo [
    libv4l
  ];

  nativeCheckInputs = [
    bash
    python3
  ];

  postConfigure = ''
    patchShebangs test
  '';

  configureFlags = [
    "--without-python"
    "--without-qt"
  ]
  ++ (
    if enableDbus then
      [
        "--with-dbusconfdir=${placeholder "out"}/share"
      ]
    else
      [
        "--without-dbus"
      ]
  )
  ++ (
    if enableVideo then
      [
        "--with-gtk=gtk3"
      ]
    else
      [
        "--disable-video"
        "--without-gtk"
      ]
  );

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Bar code reader";
    longDescription = ''
      ZBar is an open source software suite for reading bar codes from various
      sources, such as video streams, image files and raw intensity sensors. It
      supports many popular symbologies (types of bar codes) including
      EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR
      Code.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/mchehab/zbar";
    mainProgram = "zbarimg";
  };
}
