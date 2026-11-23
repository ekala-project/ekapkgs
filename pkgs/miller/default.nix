{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.23.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-zBEh71/2I8t1NQadyR/hYdCItNMLdHSLOr6rCIFYn0A=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-0QpTunOoNVgiPI4lh0smkmPBv3owCPShRETxivsk274=";

  postInstall = ''
    mkdir -p $man/share/man/man1
    mv ./man/mlr.1 $man/share/man/man1
  '';

  subPackages = [ "cmd/mlr" ];

  meta = {
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage = "https://github.com/johnkerl/miller";
    license = lib.licenses.bsd2;
    mainProgram = "mlr";
    platforms = lib.platforms.all;
  };
})
