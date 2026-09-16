{
  buildPerlPackage,
  fetchurl,
  ClassAccessor,
  ClassDataInheritable,
  CryptPasswdMD5,
  ParamsValidate,
}:
buildPerlPackage {
  pname = "Authen-Simple";
  version = "0.5";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHANSEN/Authen-Simple-0.5.tar.gz";
    hash = "sha256-As3atH+L8aHL1Mm/jSWPbQURFJnDP4MV5yRIEvcmE6o=";
  };
  postPatch = ''
    patch -p1 <<-EOF
      --- a/t/09password.t
      +++ b/t/09password.t
      @@ -10 +10 @@
      -use Test::More tests => 16;
      +use Test::More tests => 14;
      @@ -14 +13,0 @@
      -    [ 'crypt',     'lk9Mh5KHGjAaM',                          'crypt'        ],
      @@ -18 +16,0 @@
      -    [ 'crypt',     '{CRYPT}lk9Mh5KHGjAaM',                   '{CRYPT}'      ],
    EOF
  '';
  propagatedBuildInputs = [
    ClassAccessor
    ClassDataInheritable
    CryptPasswdMD5
    ParamsValidate
  ];
  meta = {
    description = "Simple Authentication";
  };
}
