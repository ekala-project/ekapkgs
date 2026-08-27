{
  callPackage,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
buildGnomeExtension {
  uuid = "dash-to-dock@micxgx.gmail.com";
  pname = "dash-to-dock";
  version = "105";
  sha256 = "0bzsl74m6vxl1clzjipqcibn8p07n3azy4n2v47imf2bb80kbp5p";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIkEgZG9jayBmb3IgdGhlIEdub21lIFNoZWxsLiBUaGlzIGV4dGVuc2lvbiBtb3ZlcyB0aGUgZGFzaCBvdXQgb2YgdGhlIG92ZXJ2aWV3IHRyYW5zZm9ybWluZyBpdCBpbiBhIGRvY2sgZm9yIGFuIGVhc2llciBsYXVuY2hpbmcgb2YgYXBwbGljYXRpb25zIGFuZCBhIGZhc3RlciBzd2l0Y2hpbmcgYmV0d2VlbiB3aW5kb3dzIGFuZCBkZXNrdG9wcy4gU2lkZSBhbmQgYm90dG9tIHBsYWNlbWVudCBvcHRpb25zIGFyZSBhdmFpbGFibGUuIiwKICAiZ2V0dGV4dC1kb21haW4iOiAiZGFzaHRvZG9jayIsCiAgIm5hbWUiOiAiRGFzaCB0byBEb2NrIiwKICAib3JpZ2luYWwtYXV0aG9yIjogIm1pY3hneEBnbWFpbC5jb20iLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ1IiwKICAgICI0NiIsCiAgICAiNDciLAogICAgIjQ4IiwKICAgICI0OSIsCiAgICAiNTAiCiAgXSwKICAidXJsIjogImh0dHBzOi8vbWljaGVsZWcuZ2l0aHViLmlvL2Rhc2gtdG8tZG9jay8iLAogICJ1dWlkIjogImRhc2gtdG8tZG9ja0BtaWN4Z3guZ21haWwuY29tIiwKICAidmVyc2lvbiI6IDEwNQp9";
  description = "A dock for the Gnome Shell for easier launching of applications and faster switching between windows";
  homepage = "https://extensions.gnome.org/extension/307/dash-to-dock/";
  # TODO: gnome-shell dependency (being ported)
}
