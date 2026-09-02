{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "speedtest-cli";
  version = "2.1.3";
  pyproject = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w4h7m0isbvfy4zx6m5j4594p5y4pjbpzsr0h4yzmdgd7hip69sy";
  };

  # tests require working internet connection
  doCheck = false;

  meta = {
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    homepage = "https://github.com/sivel/speedtest-cli";
    license = lib.licenses.asl20;
  };
}
