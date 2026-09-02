{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-protocols";
  version = "1.47";

  doCheck =
    stdenv.hostPlatform == stdenv.buildPlatform
    &&
      # https://gitlab.freedesktop.org/wayland/wayland-protocols/-/issues/48
      stdenv.hostPlatform.linker == "bfd"
    &&
      # Even with bfd linker, the above issue occurs on platforms with stricter linker requirements
      # https://gitlab.freedesktop.org/wayland/wayland-protocols/-/issues/48#note_1453201
      !(stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian)
    && lib.meta.availableOn stdenv.hostPlatform wayland;

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/${finalAttrs.pname}/-/releases/${finalAttrs.version}/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-X9Q0m8vJurmkb4z3fR9DQpanoFLIdECglPY/z2KljiA=";
  };

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/
  '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    wayland.scanner
  ];
  nativeCheckInputs = [
    python3
    wayland
  ];
  checkInputs = [ wayland ];
  strictDeps = true;

  mesonFlags = [ "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}" ];

  meta = {
    description = "Wayland protocol extensions";
    homepage = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    pkgConfigModules = [ "wayland-protocols" ];
  };
})
