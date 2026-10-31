{
  buildPerlModule,
  fetchurl,
  lib,
  Moose,
  aliased,
  namespaceautoclean,
  ModuleBuildTiny,
  TestFatal,
}:
buildPerlModule {
  pname = "MooseX-LazyRequire";
  version = "0.11";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-LazyRequire-0.11.tar.gz";
    hash = "sha256-72IMHgGdr5zz8jqUPSWpTJHpOrMSvNY74ul0DsC5Qog=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestFatal
  ];
  propagatedBuildInputs = [
    Moose
    aliased
    namespaceautoclean
  ];
  meta = {
    description = "Required attributes which fail only when trying to use them";
    homepage = "https://github.com/moose/MooseX-LazyRequire";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
