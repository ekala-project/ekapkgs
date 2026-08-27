{
  callPackage,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
buildGnomeExtension {
  uuid = "just-perfection-desktop@just-perfection";
  pname = "just-perfection";
  version = "36";
  sha256 = "13qqbwd9y55dsgyy3fjmlnis95kxmnxfvcshmc4bik0w0blgldd2";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIlR3ZWFrIFRvb2wgdG8gQ3VzdG9taXplIEdOT01FIFNoZWxsLCBDaGFuZ2UgdGhlIEJlaGF2aW9yIGFuZCBEaXNhYmxlIFVJIEVsZW1lbnRzIiwKICAiZG9uYXRpb25zIjogewogICAgImJ1eW1lYWNvZmZlZSI6ICJqdXN0cGVyZmVjdGlvbiIKICB9LAogICJnZXR0ZXh0LWRvbWFpbiI6ICJqdXN0LXBlcmZlY3Rpb24iLAogICJuYW1lIjogIkp1c3QgUGVyZmVjdGlvbiIsCiAgInNldHRpbmdzLXNjaGVtYSI6ICJvcmcuZ25vbWUuc2hlbGwuZXh0ZW5zaW9ucy5qdXN0LXBlcmZlY3Rpb24iLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ1IiwKICAgICI0NiIsCiAgICAiNDciLAogICAgIjQ4IiwKICAgICI0OSIsCiAgICAiNTAiCiAgXSwKICAidXJsIjogImh0dHBzOi8vZ2l0bGFiLmdub21lLm9yZy9qcmFobWF0emFkZWgvanVzdC1wZXJmZWN0aW9uIiwKICAidXVpZCI6ICJqdXN0LXBlcmZlY3Rpb24tZGVza3RvcEBqdXN0LXBlcmZlY3Rpb24iLAogICJ2ZXJzaW9uIjogMzYKfQ==";
  description = "Tweak Tool to Customize GNOME Shell, Change the Behavior and Disable UI Elements";
  homepage = "https://extensions.gnome.org/extension/3843/just-perfection/";
  # TODO: gnome-shell dependency (being ported)
}
