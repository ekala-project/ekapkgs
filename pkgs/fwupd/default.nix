{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  pkgsBuildBuild,
  python3,

  # nativeBuildInputs
  ensureNewerSourcesForZipFilesHook,
  gettext,
  gi-docgen,
  gobject-introspection,
  meson,
  ninja,
  shared-mime-info,
  vala,
  gtk3,
  writableTmpDirAsHomeHook,
  mesonEmulatorHook,

  # buildInputs
  bash-completion,
  curl,
  elfutils,
  fwupd-efi,
  gnutls,
  gusb,
  libdrm,
  libgudev,
  libjcat,
  libmbim,
  libmnl,
  libqmi,
  libuuid,
  libxmlb,
  libxml2,
  # modemmanager removed - build fails due to python-dbus issue
  pango,
  polkit,
  readline,
  sqlite,
  tpm2-tss,
  valgrind,
  xz,

  # mesonFlags
  hwdata,

  # env
  makeFontsConf,
  freefont_ttf,

  # preFixup
  bubblewrap,
  efibootmgr,
  tpm2-tools,

  enablePassim ? false,
}:

let
  isx86 = stdenv.hostPlatform.isx86;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fwupd";
  version = "2.1.8";

  outputs = [
    "out"
    "lib"
    "dev"
    "devdoc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "fwupd";
    repo = "fwupd";
    tag = finalAttrs.version;
    hash = "sha256-96YywlleFv3JRNQ/qy14qJC2ryQZDTHT3kNchtyB0cE=";
  };

  patches = [
    ./0001-Install-fwupdplugin-to-out.patch
    ./0002-Add-output-for-installed-tests.patch
    ./0003-Add-option-for-installation-sysconfdir.patch
  ];

  postPatch = ''
    patchShebangs \
      generate-build/generate-version-script.py \
      generate-build/generate-man.py \
      po/test-deps \
      plugins/uefi-capsule/tests/grub2-mkconfig \
      plugins/uefi-capsule/tests/grub2-reboot
    substituteInPlace plugins/redfish/meson.build \
      --replace-fail "get_option('tests')" "false"
  '';

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
    (python3.withPackages (p: [
      p.jinja2
      p.setuptools
    ]))
  ];

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    gettext
    gi-docgen
    gnutls.bin
    gobject-introspection
    libjcat.bin
    libxml2
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    shared-mime-info
    vala
    gtk3.wrapGAppsNoGuiHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    bash-completion
    curl
    elfutils
    fwupd-efi
    gnutls
    gusb
    libdrm
    libgudev
    libjcat
    libmbim
    libmnl
    libqmi
    libuuid
    libxmlb
    pango
    polkit
    readline
    sqlite
    tpm2-tss
    valgrind
    xz
  ];

  mesonEntries = {
    systemd_root_prefix = "${placeholder "out"}";
    installed_test_prefix = "${placeholder "installedTests"}";
    sysconfdir_install = "${placeholder "out"}/etc";
    efi_os_dir = "nixos";
    efi_app_location = "${fwupd-efi}/libexec/fwupd/efi";
    vendor_metadata = true;
    plugin_uefi_capsule_splash = false;
    vendor_ids_dir = "${hwdata}/share/hwdata";
  };

  mesonFeatures = {
    supported_build = true;
    hsi = isx86;
    umockdev_tests = false;
    plugin_modem_manager = false;
  };

  mesonFlags = [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--libexecdir=${placeholder "
      out"}/libexec"
    ] ++ lib.optionals (!enablePassim) [
    (lib.mesonEnable "passim" false)
  ];

  dontWrapGApps = true;

  doCheck = false;

  env = {
    FONTCONFIG_FILE =
      let
        fontsConf = makeFontsConf {
          fontDirectories = [ freefont_ttf ];
        };
      in
      fontsConf;
    PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";
  };

  preFixup =
    let
      binPath = [
        bubblewrap
        efibootmgr
        tpm2-tools
      ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
        --prefix PATH : "${lib.makeBinPath binPath}"
      )
    '';

  postFixup = ''
    find -L "$out/bin" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d ''' file; do
      if [[ "$file" != *.efi ]]; then
        echo "Wrapping program $file"
        wrapGApp "$file"
      fi
    done
    moveToOutput "share/doc" "$devdoc"
    moveToOutput "etc/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    filesInstalledToEtc = [
      "fwupd/fwupd.conf"
      "fwupd/remotes.d/lvfs-embargo.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "fwupd/remotes.d/vendor-directory.conf"
      "pki/fwupd/LVFS-CA-2025PQ.pem"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/LVFS-CA-2025PQ.pem"
      "pki/fwupd-metadata/LVFS-CA.pem"
      "grub.d/35_fwupd"
    ];
    inherit fwupd-efi;
  };

  meta = {
    homepage = "https://fwupd.org/";
    changelog = "https://github.com/fwupd/fwupd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
