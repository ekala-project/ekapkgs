{
  callPackage,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
buildGnomeExtension {
  uuid = "paperwm@paperwm.github.com";
  pname = "paperwm";
  version = "148";
  sha256 = "1spfm6lv284lk1idqdsmfn7lvia328pkrgnqlmh8yzwpmidjd6in";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIlRpbGluZyB3aW5kb3cgbWFuYWdlciB3aXRoIGEgdHdpc3QiLAogICJuYW1lIjogIlBhcGVyV00iLAogICJzZXR0aW5ncy1zY2hlbWEiOiAib3JnLmdub21lLnNoZWxsLmV4dGVuc2lvbnMucGFwZXJ3bSIsCiAgInNoZWxsLXZlcnNpb24iOiBbCiAgICAiNDUiLAogICAgIjQ2IiwKICAgICI0NyIsCiAgICAiNDgiLAogICAgIjQ5IiwKICAgICI1MCIKICBdLAogICJ1cmwiOiAiaHR0cHM6Ly9naXRodWIuY29tL3BhcGVyd20vUGFwZXJXTSIsCiAgInV1aWQiOiAicGFwZXJ3bUBwYXBlcndtLmdpdGh1Yi5jb20iLAogICJ2ZXJzaW9uIjogMTQ4LAogICJ2ZXJzaW9uLW5hbWUiOiAiNTAuMC4xIgp9";
  description = "Tiling window manager with a twist";
  homepage = "https://extensions.gnome.org/extension/6099/paperwm/";
  # TODO: gnome-shell dependency (being ported)
}
