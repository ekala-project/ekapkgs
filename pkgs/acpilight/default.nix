{
  lib,
  stdenv,
  fetchgit,
  python3,
  coreutils,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acpilight";
  version = "1.2";

  src = fetchgit {
    url = "https://gitlab.com/wavexx/acpilight.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PNjW/04hndcdmsY1ej1TriUblPogsm2ounObbrodGeQ=";
  };

  postConfigure = ''
    substituteInPlace 90-backlight.rules --replace-fail /bin ${coreutils}/bin
    substituteInPlace Makefile --replace-fail udevadm true
  '';

  buildInputs = [ python3 ];

  makeFlags = [ "DESTDIR=$(out) prefix=" ];

  nativeBuildInputs = [
    udevCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://gitlab.com/wavexx/acpilight";
    description = "ACPI backlight control";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "xbacklight";
  };
})
