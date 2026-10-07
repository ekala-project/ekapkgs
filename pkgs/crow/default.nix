{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2_3,
  asio,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "CrowCpp";
    repo = "Crow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XFiRxvVoNjk8TVt8X7Ha1E1O90jzoLRyH4PdTtRAWUg=";
  };

  patches = [
    ./cpm.patch
  ];

  propagatedBuildInputs = [ asio ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CROW_BUILD_EXAMPLES = false;
    CROW_GENERATE_SBOM = false;
  };

  doCheck = true;
  nativeCheckInputs = [
    python3
  ];
  checkInputs = [
    catch2_3
  ];

  meta = {
    description = "Fast and Easy to use microframework for the web";
    homepage = "https://crowcpp.org/";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
