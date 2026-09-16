{
  buildPerlPackage,
  fetchurl,
  file,
  ConfigAutoConf,
  TestFatal,
}:
buildPerlPackage {
  pname = "File-LibMagic";
  version = "1.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/File-LibMagic-1.23.tar.gz";
    hash = "sha256-Uuax3Hyy2HpM30OboUXguejPKMwmpIo8+Zd8g0Y5Z+4=";
  };
  buildInputs = [
    file
    ConfigAutoConf
    TestFatal
  ];
  makeMakerFlags = [ "--lib=${file}/lib" ];
  preCheck = ''
    substituteInPlace t/oo-api.t \
      --replace "/usr/share/file/magic.mgc" "${file}/share/misc/magic.mgc"
  '';
  meta = {
    description = "Determine MIME types of data or files using libmagic";
  };
}
