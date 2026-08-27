{
  lib,
  callPackage,
  gjs,
  replaceVars,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
(buildGnomeExtension {
  uuid = "appindicatorsupport@rgcjonas.gmail.com";
  pname = "appindicator-support";
  version = "64";
  sha256 = "1s5j8gbjmb1zbwfda7lksd9g246l1m1d593y14c6yshh32xhw7ir";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIkFkZHMgQXBwSW5kaWNhdG9yLCBLU3RhdHVzTm90aWZpZXJJdGVtIGFuZCBsZWdhY3kgVHJheSBpY29ucyBzdXBwb3J0IHRvIHRoZSBTaGVsbCIsCiAgImdldHRleHQtZG9tYWluIjogIkFwcEluZGljYXRvckV4dGVuc2lvbiIsCiAgIm5hbWUiOiAiQXBwSW5kaWNhdG9yIGFuZCBLU3RhdHVzTm90aWZpZXJJdGVtIFN1cHBvcnQiLAogICJzZXR0aW5ncy1zY2hlbWEiOiAib3JnLmdub21lLnNoZWxsLmV4dGVuc2lvbnMuYXBwaW5kaWNhdG9yIiwKICAic2hlbGwtdmVyc2lvbiI6IFsKICAgICI0NSIsCiAgICAiNDYiLAogICAgIjQ3IiwKICAgICI0OCIsCiAgICAiNDkiLAogICAgIjUwIgogIF0sCiAgInVybCI6ICJodHRwczovL2dpdGh1Yi5jb20vdWJ1bnR1L2dub21lLXNoZWxsLWV4dGVuc2lvbi1hcHBpbmRpY2F0b3IiLAogICJ1dWlkIjogImFwcGluZGljYXRvcnN1cHBvcnRAcmdjam9uYXMuZ21haWwuY29tIiwKICAidmVyc2lvbiI6IDY0Cn0=";
  description = "Adds AppIndicator, KStatusNotifierItem and legacy Tray icons support to the Shell";
  homepage = "https://extensions.gnome.org/extension/615/appindicator-support/";
}).overrideAttrs
  (old: {
    # Patch to use absolute gjs path (from nixpkgs extensionOverrides)
    patches = [
      (replaceVars ./fix-gjs-path.patch {
        gjs = lib.getExe gjs;
      })
    ];
    # TODO: gnome-shell dependency (being ported)
  })
