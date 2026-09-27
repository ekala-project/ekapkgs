{
  fetchFromGitHub,
  lib,
  gobject-introspection,
  gtk3,
  python3Packages,
  wrapGAppsHook3,
  gdk-pixbuf,
  hidapi,
  # libappindicator fails to build due to libdbusmenu-gtk3 missing Gtk-3.0.gir
  appindicatorSupport ? false,
  libappindicator,
  librsvg,
  upower,
  acl,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "solaar";
  version = "1.1.20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pwr-Solaar";
    repo = "Solaar";
    tag = finalAttrs.version;
    hash = "sha256-h/uiy0TtMicKch2cdXHur5DkvQun2sAw2HpFI7Qstqg=";
  };

  __structuredAttrs = true;

  outputs = [
    "out"
    "udev"
  ];

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    librsvg
    upower
  ]
  ++ lib.optional appindicatorSupport libappindicator;

  propagatedBuildInputs = with python3Packages; [
    hid-parser
    psutil
    pygobject3
    pyudev
    pyyaml
    typing-extensions
    python-xlib
    evdev
    dbus-python
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    pytest-cov-stub
  ];

  preConfigure = ''
    substituteInPlace lib/solaar/listener.py \
      --replace-fail getfacl "${lib.getExe' acl "getfacl"}"
  '';

  postInstall = ''
    ln -s $out/bin/solaar $out/bin/solaar-cli

    install -Dm444 -t $udev/etc/udev/rules.d rules.d-uinput/*.rules
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # solaar.gtk requires Gdk typelib which isn't available in the check sandbox
  pythonImportsCheck = [
    "solaar"
  ];

  meta = {
    description = "Linux devices manager for the Logitech Unifying Receiver";
    longDescription = ''
      Solaar is a Linux manager for many Logitech keyboards, mice, and trackpads that
      connect wirelessly to a USB Unifying, Lightspeed, or Nano receiver, connect
      directly via a USB cable, or connect via Bluetooth. Solaar does not work with
      peripherals from other companies.

      Solaar can be used as a GUI application or via its command-line interface.

      This tool requires either to be run with root/sudo or alternatively to have the udev rules files installed. On NixOS this can be achieved by setting `hardware.logitech.wireless.enable`.
    '';
    homepage = "https://pwr-solaar.github.io/Solaar/";
    changelog = "https://github.com/pwr-Solaar/Solaar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    mainProgram = "solaar";
    platforms = lib.platforms.linux;
  };
})
