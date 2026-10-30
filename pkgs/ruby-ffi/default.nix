{
  buildRubyGem,
  lib,
  ruby,
  pkg-config,
  libffi,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "ffi";
  version = "1.17.2";
  source.sha256 = "19kdyjg3kv7x0ad4xsd4swy5izsbb1vl1rpb6qqcqisr5s23awi9";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libffi ];

  meta = {
    description = "Ruby FFI library for loading dynamic libraries and binding functions";
    homepage = "https://github.com/ffi/ffi/wiki";
    license = lib.licenses.bsd3;
    platforms = ruby.meta.platforms;
  };
}
