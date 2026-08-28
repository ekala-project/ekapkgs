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
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "CrowCpp";
    repo = "Crow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KbX/OzUZmycsKCoS+pov+q3Ms8+kzSy1TJi57GoMME=";
  };

  patches = [
    ./cpm.patch
  ];

  propagatedBuildInputs = [ asio ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "CROW_BUILD_EXAMPLES" false)
    # Requires more non-trivial patches to get around CPM
    (lib.cmakeBool "CROW_GENERATE_SBOM" false)
  ];

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
