{
  mkKdeDerivation,
  pkg-config,
  kirigami-addons,
  gstreamer,
  frei0r,
}:
mkKdeDerivation {
  pname = "kamoso";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    kirigami-addons
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
  ];

  qtWrapperArgs = [ "--set FREI0R_PATH ${frei0r}/lib/frei0r-1" ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';
}
