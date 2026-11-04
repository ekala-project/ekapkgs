{
  buildPerlPackage,
  fetchurl,
  lib,
  ModulePluggable,
}:
buildPerlPackage {
  pname = "Config-Any";
  version = "0.33";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Config-Any-0.33.tar.gz";
    hash = "sha256-wGaOtfLNNVvyBVfwTcGKJUdLegvPp5Vi4xZdmjx4kzM=";
  };

  propagatedBuildInputs = [ ModulePluggable ];

  meta = {
    description = "Load configuration from different file formats, transparently";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
