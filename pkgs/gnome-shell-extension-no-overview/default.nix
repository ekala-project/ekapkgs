{
  callPackage,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
buildGnomeExtension {
  uuid = "no-overview@fthx";
  pname = "no-overview";
  version = "23";
  sha256 = "1vq9xl020a1rinsk3cnny804y0rkaaq092i1pgj9jqqi1z5rk2jz";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIk5vIG92ZXJ2aWV3IGF0IHN0YXJ0LXVwLiBOb3RoaW5nIG1vcmUuIiwKICAiZG9uYXRpb25zIjogewogICAgInBheXBhbCI6ICJmdGh4NzUiCiAgfSwKICAibmFtZSI6ICJObyBvdmVydmlldyBhdCBzdGFydC11cCIsCiAgIm9yaWdpbmFsLWF1dGhvcnMiOiBbCiAgICAiZnRoeCIKICBdLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ4IiwKICAgICI0OSIsCiAgICAiNTAiCiAgXSwKICAidXJsIjogImh0dHBzOi8vZ2l0aHViLmNvbS9mdGh4L25vLW92ZXJ2aWV3IiwKICAidXVpZCI6ICJuby1vdmVydmlld0BmdGh4IiwKICAidmVyc2lvbiI6IDIzCn0=";
  description = "No overview at start-up";
  homepage = "https://extensions.gnome.org/extension/4099/no-overview/";
  # TODO: gnome-shell dependency (being ported)
}
