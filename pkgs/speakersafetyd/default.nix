{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  udevCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "speakersafetyd";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "speakersafetyd";
    tag = finalAttrs.version;
    hash = "sha256-duIPpTzZqVSZLxF/CYlxa1PPtnzeABTCYfZZ7lomkls=";
  };

  cargoHash = "sha256-gg1VcCrXKk5QsNvU7wz039md0gpFom6SrLuW6tjNQog=";

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace speakersafetyd.service \
      --replace-fail "/usr" \
                     "$out"

    substituteInPlace Makefile \
      --replace-fail "target/release" \
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
  '';

  installFlags = [
    "DESTDIR=$(out)"
    "BINDIR=bin"
    "UNITDIR=lib/systemd/system"
    "UDEVDIR=lib/udev/rules.d"
    "SHAREDIR=share"
  ];

  dontCargoInstall = true;
  doInstallCheck = true;

  meta = {
    description = "Userspace daemon that implements the Smart Amp protection model";
    mainProgram = "speakersafetyd";
    homepage = "https://github.com/AsahiLinux/speakersafetyd";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
