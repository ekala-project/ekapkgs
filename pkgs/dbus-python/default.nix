{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch,
  dbus,
  dbus-glib,
  pkg-config,
  meson,
  python3,
}:

python3Packages.buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.4.0";
  pyproject = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mRZm5Jj2Db8+Sbi3Z49VWbimUDT99hquYs3s232Jx3A=";
  };

  patches = [
    # reduce required dependencies
    # https://gitlab.freedesktop.org/dbus/dbus-python/-/merge_requests/23
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/dbus/dbus-python/-/commit/d5e19698a8d6e1485f05b67a5b2daa2392819aaf.patch";
      hash = "sha256-Rmj/ByRLiLnIF3JsMBElJugxsG8IARcBdixLhoWgIYU=";
    })
  ];

  postPatch = ''
    # we provide patchelf natively, not through the python package
    sed -i '/patchelf/d' pyproject.toml

    patchShebangs test/*.sh
  '';

  nativeBuildInputs = [
    dbus # build systems checks for `dbus-run-session` in PATH
    meson
    pkg-config
  ];

  build-system = with python3Packages; [ meson-python ];

  buildInputs = [
    dbus
    dbus-glib
  ];

  # workaround bug in meson-python
  # https://github.com/mesonbuild/meson-python/issues/240
  postInstall = ''
    mkdir -p $dev/lib
    mv $out/${python3.sitePackages}/.dbus_python.mesonpy.libs/pkgconfig/ $dev/lib
  '';

  # make sure the Cflags in the pkgconfig file are correct and make the structure backwards compatible
  postFixup = ''
    ln -s $dev/include/*/dbus_python/dbus-1.0/ $dev/include/dbus-1.0
  '';

  nativeCheckInputs = [ dbus.out ];

  doCheck = false;

  meta = {
    description = "Python DBus bindings";
    homepage = "https://gitlab.freedesktop.org/dbus/dbus-python";
    license = lib.licenses.mit;
    platforms = dbus.meta.platforms;
  };
}
