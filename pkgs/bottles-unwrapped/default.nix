{
  lib,
  fetchFromGitHub,
  python3Packages,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  appstream-glib,
  desktop-file-utils,
  fvs2,
  gtk4,
  gtksourceview5,
  libadwaita,
  cabextract,
  p7zip,
  xdpyinfo,
  imagemagick,
  lsb-release,
  pciutils,
  procps,
  gamemode,
  gamescope,
  mangohud,
  vkbasalt-cli,
  vulkan-tools,
  vmtouch,
  libportal-gtk4,
  libxml2,
  umu-launcher,
  icoextract,
  removeWarningPopup ? false,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bottles-unwrapped";
  version = "67.4";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = "bottles";
    tag = finalAttrs.version;
    hash = "sha256-Ohzsg/CTmk6ix+hATCncusmN5DqWHcw8jDP0dg67r4o=";
  };

  patches = [
    ./vulkan_icd.patch
    ./redirect-bugtracker.patch
    ./remove-flatpak-check.patch
  ]
  ++ (
    if removeWarningPopup then
      [ ./remove-unsupported-warning.patch ]
    else
      [
        ./warn-unsupported.patch
      ]
  );

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    gtk4.wrapGAppsHook
    gtk4
    appstream-glib
    desktop-file-utils
    libxml2
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libportal-gtk4
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      pyyaml
      pycurl
      chardet
      requests
      markdown
      icoextract
      patool
      pathvalidate
      orjson
      pycairo
      pygobject3
      charset-normalizer
      idna
      urllib3
      certifi
      pefile
      yara-python
      pysocks
    ]
    ++ [
      cabextract
      p7zip
      xdpyinfo
      imagemagick
      vkbasalt-cli
      vulkan-tools

      gamemode
      gamescope
      mangohud
      vmtouch
      fvs2
      umu-launcher

      lsb-release
      pciutils
      procps
    ];

  pyproject = false;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Easy-to-use wineprefix manager";
    homepage = "https://usebottles.com/";
    downloadPage = "https://github.com/bottlesdevs/Bottles/releases";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "bottles";
  };
})
