{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gpgme,
  libgpg-error,
  pkg-config,
  python3,
  x11Support ? true,
  libxcb ? null,
  libxkbcommon ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpg-tui";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DTVtMwKAZjPwT6c7FYoaT12Axoz3j1cMFKjDDsaHyjk=";
  };

  cargoHash = "sha256-d2PYJajDKukwDERSjQcPSJaYbZDftNLBYEXq+7ZdlKw=";

  nativeBuildInputs = [
    gpgme
    libgpg-error
    pkg-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpg-error
  ]
  ++ lib.optionals x11Support [
    libxcb
    libxkbcommon
  ];

  meta = {
    description = "Terminal user interface for GnuPG";
    homepage = "https://github.com/orhun/gpg-tui";
    changelog = "https://github.com/orhun/gpg-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "gpg-tui";
  };
})
