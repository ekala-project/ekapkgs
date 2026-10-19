{ fetchFromGitHub, libiconv }:

finalAttrs: {
  version = "0.996";

  src = fetchFromGitHub {
    owner = "taku910";
    repo = "mecab";
    rev = "5a7db65493a0b57d5fc31734e65300320aaf94c8";
    hash = "sha256-fyRWVXSEELcATcvkTVtt96IRMRuv3CV2AeCC3O1x25E=";
    rootDir = "mecab";
  };

  sourceRoot = "${finalAttrs.src.name}/mecab";

  buildInputs = [ libiconv ];

  configureFlags = [
    "--with-charset=utf8"
  ];

  makeFlags = [ "CXXFLAGS=-std=c++14" ];

  doCheck = true;
}
