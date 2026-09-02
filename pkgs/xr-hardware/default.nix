{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  udevCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xr-hardware";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado/utilities";
    repo = "xr-hardware";
    tag = finalAttrs.version;
    hash = "sha256-w35/LoozCJz0ytHEHWsEdCaYYwyGU6sE13iMckVdOzY=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];
  dontConfigure = true;
  dontBuild = true;

  installTargets = "install_package";
  installFlags = "DESTDIR=${placeholder "out"}";
  meta = {
    description = "Hardware description for XR devices";
    homepage = "https://gitlab.freedesktop.org/monado/utilities/xr-hardware";
    license = lib.licenses.boost;
    platforms = lib.platforms.linux;
  };
})
