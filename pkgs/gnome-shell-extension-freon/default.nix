{
  callPackage,
  replaceVars,
  hddtemp,
  liquidctl ? "/run/current-system/sw", # TODO: not yet available in ekapkgs
  lm_sensors,
  netcat-gnu,
  nvme-cli,
  procps,
  smartmontools,
}:

let
  buildGnomeExtension = callPackage ../buildGnomeExtension { };
in
(buildGnomeExtension {
  uuid = "freon@UshakovVasilii_Github.yahoo.com";
  pname = "freon";
  version = "61";
  sha256 = "1d8ll2vg7383xx0hx8rvp4ssyfyhj0kz4y1mkfaxx15z58w2chbx";
  metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIlNob3dzIENQVSB0ZW1wZXJhdHVyZSwgZGlzayB0ZW1wZXJhdHVyZSwgdmlkZW8gY2FyZCB0ZW1wZXJhdHVyZSAoTlZJRElBL0NhdGFseXN0L0J1bWJsZWJlZSZOVklESUEpLCB2b2x0YWdlIGFuZCBmYW4gUlBNIChmb3JrZWQgZnJvbSB4dHJhbm9waGlsaXN0L2dub21lLXNoZWxsLWV4dGVuc2lvbi1zZW5zb3JzKSIsCiAgImdldHRleHQtZG9tYWluIjogImZyZW9uIiwKICAibmFtZSI6ICJGcmVvbiIsCiAgInNldHRpbmdzLXNjaGVtYSI6ICJvcmcuZ25vbWUuc2hlbGwuZXh0ZW5zaW9ucy5mcmVvbiIsCiAgInNoZWxsLXZlcnNpb24iOiBbCiAgICAiNDUiLAogICAgIjQ2IiwKICAgICI0NyIsCiAgICAiNDgiLAogICAgIjQ5IiwKICAgICI1MCIKICBdLAogICJ1cmwiOiAiaHR0cHM6Ly9naXRodWIuY29tL1VzaGFrb3ZWYXNpbGlpL2dub21lLXNoZWxsLWV4dGVuc2lvbi1mcmVvbiIsCiAgInV1aWQiOiAiZnJlb25AVXNoYWtvdlZhc2lsaWlfR2l0aHViLnlhaG9vLmNvbSIsCiAgInZlcnNpb24iOiA2MQp9";
  description = "Shows CPU temperature, disk temperature, video card temperature, voltage and fan RPM";
  homepage = "https://extensions.gnome.org/extension/841/freon/";
}).overrideAttrs (old: {
  # Patch to use absolute paths for sensor tools (from nixpkgs extensionOverrides)
  patches = [
    (replaceVars ./fix-paths.patch {
      inherit
        hddtemp
        liquidctl
        lm_sensors
        procps
        smartmontools
        ;
      netcat = netcat-gnu;
      nvmecli = nvme-cli;
    })
  ];
  # TODO: gnome-shell dependency (being ported)
})
