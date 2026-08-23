{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "asciidoctor";
  gemdir = ./.;

  exes = [
    "asciidoctor"
    "asciidoctor-pdf"
  ];

  meta = {
    description = "Faster Asciidoc processor written in Ruby";
    homepage = "https://asciidoctor.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
