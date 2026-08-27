{
  callPackage,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
buildGnomeExtension {
  uuid = "clipboard-indicator@tudmotu.com";
  pname = "clipboard-indicator";
  version = "71";
  sha256 = "0kmp70wrnznny67jgg9r64mz5k2sp73pcr0nhkvp75cw68x0iqfw";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIlRoZSBtb3N0IHBvcHVsYXIgY2xpcGJvYXJkIG1hbmFnZXIgZm9yIEdOT01FLCB3aXRoIG92ZXIgMU0gZG93bmxvYWRzIiwKICAiZ2V0dGV4dC1kb21haW4iOiAiY2xpcGJvYXJkLWluZGljYXRvciIsCiAgIm5hbWUiOiAiQ2xpcGJvYXJkIEluZGljYXRvciIsCiAgInNldHRpbmdzLXNjaGVtYSI6ICJvcmcuZ25vbWUuc2hlbGwuZXh0ZW5zaW9ucy5jbGlwYm9hcmQtaW5kaWNhdG9yIiwKICAic2hlbGwtdmVyc2lvbiI6IFsKICAgICI0NiIsCiAgICAiNDciLAogICAgIjQ4IiwKICAgICI0OSIsCiAgICAiNTAiCiAgXSwKICAidXJsIjogImh0dHBzOi8vZ2l0aHViLmNvbS9UdWRtb3R1L2dub21lLXNoZWxsLWV4dGVuc2lvbi1jbGlwYm9hcmQtaW5kaWNhdG9yIiwKICAidXVpZCI6ICJjbGlwYm9hcmQtaW5kaWNhdG9yQHR1ZG1vdHUuY29tIiwKICAidmVyc2lvbiI6IDcxCn0=";
  description = "Clipboard manager for GNOME Shell";
  homepage = "https://extensions.gnome.org/extension/779/clipboard-indicator/";
  # TODO: gnome-shell dependency (being ported)
}
