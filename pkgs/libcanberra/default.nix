{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libtool,
  gtk2,
  pulseaudio,
  libvorbis,
  libcap,
  withAlsa ? stdenv.hostPlatform.isLinux,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "libcanberra";
  version = "0.30";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${pname}-${version}.tar.xz";
    sha256 = "0wps39h8rx2b00vyvkia5j40fkak3dpipp1kzilqla0cgvk73dn2";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pulseaudio
    libvorbis
    libtool
    gtk2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ]
  ++ lib.optional withAlsa alsa-lib;

  configureFlags = [
    "--disable-oss"
    "--disable-gstreamer"
    "--with-builtin=dso"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system";

  patches = [
    (fetchpatch {
      name = "0001-gtk-Don-t-assume-all-GdkDisplays-are-GdkX11Displays-.patch";
      url = "http://git.0pointer.net/libcanberra.git/patch/?id=c0620e432650e81062c1967cc669829dbd29b310";
      sha256 = "0rc7zwn39yxzxp37qh329g7375r5ywcqcaak8ryd0dgvg8m5hcx9";
    })
  ];

  postInstall = ''
    for f in $out/lib/*.la; do
      sed 's|-lltdl|-L${libtool.lib}/lib -lltdl|' -i $f
    done
  '';

  meta = {
    description = "Implementation of the XDG Sound Theme and Name Specifications";
    mainProgram = "canberra-gtk-play";
    homepage = "http://0pointer.de/lennart/projects/libcanberra/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
}
