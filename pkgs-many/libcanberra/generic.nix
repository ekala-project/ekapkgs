{
  version,
  src-hash,
  gtkSupport ? null,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libtool,
  gtk3 ? null,
  pulseaudio,
  libvorbis,
  libcap,
  withAlsa ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcanberra" + lib.optionalString (gtkSupport != null) "-${gtkSupport}";
  inherit version;

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/libcanberra-${version}.tar.xz";
    hash = src-hash;
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
  ]
  ++ lib.optional (gtkSupport == "gtk3") gtk3
  ++ lib.optional stdenv.hostPlatform.isLinux libcap
  ++ lib.optional withSystemd systemd
  ++ lib.optional withAlsa alsa-lib;

  configureFlags = [
    "--disable-oss"
    "--disable-gtk" # gtk2
  ]
  ++ lib.optional (gtkSupport == "gtk3") "--enable-gtk3"
  ++ lib.optional (gtkSupport != "gtk3") "--disable-gtk3"
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

  enableParallelBuilding = true;

  passthru =
    mkVariantPassthru variantArgs
    // lib.optionalAttrs (gtkSupport != null) {
      gtkModule = if gtkSupport == "gtk3" then "/lib/gtk-3.0/" else null;
    };

  meta = {
    description = "Implementation of the XDG Sound Theme and Name Specifications";
    mainProgram = "canberra-gtk-play";
    homepage = "http://0pointer.de/lennart/projects/libcanberra/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
