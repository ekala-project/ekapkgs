{
  callPackage,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
buildGnomeExtension {
  uuid = "kimpanel@kde.org";
  pname = "kimpanel";
  version = "91";
  sha256 = "03wyqn3m5b6pcplxnsj4203z2vql4049krvh9xdscn2wb71f3qqz";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIklucHV0IE1ldGhvZCBQYW5lbCB1c2luZyBLREUncyBraW1wYW5lbCBwcm90b2NvbCBmb3IgR25vbWUtU2hlbGwiLAogICJleHRlbnNpb24taWQiOiAia2ltcGFuZWwiLAogICJnZXR0ZXh0LWRvbWFpbiI6ICJnbm9tZS1zaGVsbC1leHRlbnNpb25zLWtpbXBhbmVsIiwKICAibG9jYWxlIjogIi91c3IvbG9jYWwvc2hhcmUvbG9jYWxlIiwKICAibmFtZSI6ICJJbnB1dCBNZXRob2QgUGFuZWwiLAogICJzZXR0aW5ncy1zY2hlbWEiOiAib3JnLmdub21lLnNoZWxsLmV4dGVuc2lvbnMua2ltcGFuZWwiLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ4IiwKICAgICI0OSIsCiAgICAiNTAiCiAgXSwKICAidXJsIjogImh0dHBzOi8vZ2l0aHViLmNvbS93ZW5neHQvZ25vbWUtc2hlbGwtZXh0ZW5zaW9uLWtpbXBhbmVsIiwKICAidXVpZCI6ICJraW1wYW5lbEBrZGUub3JnIiwKICAidmVyc2lvbiI6IDkxCn0=";
  description = "Input Method Panel using KDE's kimpanel protocol for Gnome-Shell";
  homepage = "https://extensions.gnome.org/extension/261/kimpanel/";
  # TODO: gnome-shell dependency (being ported)
}
