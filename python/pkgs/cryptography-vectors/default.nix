{
  lib,
  buildPythonPackage,
  python3Packages,
  uv-build,
}:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (python3Packages.cryptography) version src;
  pyproject = true;

  sourceRoot = "${src.name}/vectors";

  build-system = [ uv-build ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];

  meta = {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    license = with lib.licenses; [ asl20 bsd3 ];
  };
}
