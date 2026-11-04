{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Mail-Sendmail";
  version = "0.80";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Mail-Sendmail-0.80.tar.gz";
    hash = "sha256-W4qYy1zDnYBEGjiqsBCIXd+A5vzY5uAxQ5LLI+fCaOQ=";
  };
  # The test suite simply loads the module and attempts to send an email to
  # the module's author, the latter of which is a) more of an integration
  # test, b) impossible to verify, and c) won't work from a sandbox. Replace
  # it in its entirety with the following simple smoke test.
  checkPhase = ''
    perl -I blib/lib -MMail::Sendmail -e 'print "1..1\nok 1\n"'
  '';
  meta = {
    description = "Simple platform independent mailer";
    homepage = "https://github.com/neilb/Mail-Sendmail";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
