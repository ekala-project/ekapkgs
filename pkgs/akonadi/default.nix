{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  accounts-qt,
  kaccounts-integration ? null, # TODO: not yet in ekapkgs
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  ki18n,
  kiconthemes,
  kirigami,
  kitemmodels,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  xz,
  mariadb ? null, # TODO: not yet in ekapkgs
  libpq,
  sqlite,
  backend ? "mysql",
}:

assert lib.assertOneOf "backend" backend [
  "mysql"
  "postgres"
  "sqlite"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "akonadi";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/akonadi-${finalAttrs.version}.tar.xz";
    hash = "sha256-hXRoFxYRUqPIh8MsqrryFjOWeW8q2Pw6xjjiyR9LD70=";
  };

  patches = [
    # Always regenerate MySQL config, as the store paths don't have accurate timestamps
    ./ignore-mysql-config-timestamp.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    accounts-qt
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kirigami
    kitemmodels
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    xz
  ]
  ++ lib.optional (kaccounts-integration != null) kaccounts-integration
  ++ lib.optionals (backend == "mysql" && mariadb != null) [ mariadb ]
  ++ lib.optionals (backend == "postgres") [ libpq ]
  ++ lib.optionals (backend == "sqlite") [ sqlite ];

  cmakeEntries = {
    DATABASE_BACKEND = lib.toUpper backend;
  }
  // lib.optionalAttrs (backend == "mysql" && mariadb != null) {
    MYSQLD_SCRIPTS_PATH = "${lib.getBin mariadb}/bin";
  }
  // lib.optionalAttrs (backend == "postgres") {
    POSTGRES_PATH = "${lib.getBin libpq}/bin";
  };

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
  ''
  + lib.optionalString (backend == "mysql" && mariadb != null) ''
    echo "${mariadb}" > $out/nix-support/depends
  ''
  + lib.optionalString (backend == "postgres") ''
    echo "${libpq}" > $out/nix-support/depends
  '';

  meta = {
    description = "PIM layer providing an asynchronous API to access all kind of PIM data";
    homepage = "https://invent.kde.org/pim/akonadi";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
