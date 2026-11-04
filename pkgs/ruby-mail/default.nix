{
  buildRubyGem,
  lib,
  ruby,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "mail";
  version = "2.9.1";
  source.sha256 = "1s30l5z7jkazgi4m6l6mh80rgsyhh2pp1pa5h70xclsj8z54wmq6";

  meta = {
    description = "Ruby mail handler for generating, parsing, and sending email";
    homepage = "https://github.com/mikel/mail";
    license = lib.licenses.mit;
    platforms = ruby.meta.platforms;
  };
}
