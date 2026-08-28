{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  pkg-config,
  intltool,
  libxslt,
  makeWrapper,
  coreutils,
  zip,
  unzip,
  p7zip,
  gnutar,
  bzip2,
  gzip,
  lhasa,
  xz,
  zstd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.5.4.27";
  pname = "xarchiver";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = finalAttrs.version;
    hash = "sha256-s4RM9loFlKVcOtxNolt6+wZTp3ITdGaHTNUtDnAmqfs=";
  };

  nativeBuildInputs = [
    intltool
    libxslt
    makeWrapper
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  postFixup = ''
    wrapProgram $out/bin/xarchiver \
    --prefix PATH : ${
      lib.makeBinPath [
        zip
        unzip
        p7zip
        gnutar
        bzip2
        gzip
        lhasa
        xz
        zstd
        coreutils
      ]
    }
  '';

  strictDeps = true;

  meta = {
    description = "GTK frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = "https://github.com/ib/xarchiver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "xarchiver";
  };
})
