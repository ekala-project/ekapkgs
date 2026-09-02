{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "drill";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = "drill";
    rev = finalAttrs.version;
    sha256 = "sha256-YnInBTqqzbZmFpuw7oyowl9/4BsxFo+/Wd3dVmuPw7A=";
  };

  cargoHash = "sha256-Wxn1A5i1rDQXc8+yxfE7nO3cCT/Re/IGW8UQFsFvbEg=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  env = {
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  checkFlags = [
    "--skip=actions::request::tests::measures_full_body_transfer_time"
    "--skip=actions::request::tests::large_body_without_assign_is_drained_not_retained"
  ];

  meta = {
    description = "HTTP load testing application inspired by Ansible syntax";
    homepage = "https://github.com/fcsonline/drill";
    license = lib.licenses.gpl3Only;
    mainProgram = "drill";
  };
})
