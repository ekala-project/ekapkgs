{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sshs";
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = "sshs";
    rev = finalAttrs.version;
    hash = "sha256-Xr1S6KSw3a/+TIrw2hUPpUOd22+49YMuGK2TVxfwPHU=";
  };

  cargoHash = "sha256-Py85+zv54KHFXjhiThTPXgJQmCImXN42ePOjazjzxIQ=";

  meta = {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = lib.licenses.mit;
    mainProgram = "sshs";
  };
})
