{
  qtModule,
  qtbase,
  qtdeclarative,
  pkg-config,
  alsa-lib,
  gstreamer,
  libpulseaudio,
  wayland,
}:

qtModule {
  pname = "qtmultimedia";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gstreamer.gstreamer
    gstreamer.gst-plugins-base
    libpulseaudio
    alsa-lib
    wayland
  ];
  outputs = [
    "bin"
    "dev"
    "out"
  ];
  qmakeFlags = [ "GST_VERSION=1.0" ];
}
