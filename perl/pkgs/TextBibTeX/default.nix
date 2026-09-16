{
  buildPerlModule,
  fetchurl,
  lib,
  stdenv,
  perl,
  CaptureTiny,
  ConfigAutoConf,
  ExtUtilsLibBuilder,
}:
buildPerlModule {
  pname = "Text-BibTeX";
  version = "0.91";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AM/AMBS/Text-BibTeX-0.91.tar.gz";
    hash = "sha256-PwETz4/nHcdIRjbcjipYFjfsvMgtC+KbvUbQvz+M2zc=";
  };
  buildInputs = [
    CaptureTiny
    ConfigAutoConf
    ExtUtilsLibBuilder
  ];
  patches = [ ./use-lib.patch ];
  perlPostHook = lib.optionalString stdenv.hostPlatform.isDarwin ''
    oldPath="$(pwd)/btparse/src/libbtparse.dylib"
    newPath="$out/lib/libbtparse.dylib"
    install_name_tool -id "$newPath" "$newPath"
    install_name_tool -change "$oldPath" "$newPath" "$out/bin/biblex"
    install_name_tool -change "$oldPath" "$newPath" "$out/bin/bibparse"
    install_name_tool -change "$oldPath" "$newPath" "$out/bin/dumpnames"
    install_name_tool -change "$oldPath" "$newPath" "$out/${perl.libPrefix}/${perl.version}/darwin"*"-2level/auto/Text/BibTeX/BibTeX.bundle"
  '';
}
