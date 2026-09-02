{
  lib,
  stdenv,
  fetchFromGitHub,
  rust,
  rustPlatform,
  cargo-c,
}:

rustPlatform.buildRustPackage rec {
  pname = "libimagequant";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "libimagequant";
    rev = version;
    hash = "sha256-2P8FiRfOuCHxJrB+rnDDOFsrFjPv5GMBK/5sq7eb32w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ cargo-c ];

  postBuild = ''
    pushd imagequant-sys
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    popd
  '';

  postInstall = ''
    pushd imagequant-sys
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    popd
  '';

  meta = {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
