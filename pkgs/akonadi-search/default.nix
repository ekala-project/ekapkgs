{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  rustPlatform,
  cargo,
  rustc,
  corrosion,
  xapian,
  akonadi,
  akonadi-mime,
  kcalendarcore,
  kcmutils,
  kcontacts,
  kmime,
  krunner ? null, # TODO: not yet in ekapkgs
  ktextaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "akonadi-search";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/akonadi-search-${finalAttrs.version}.tar.xz";
    hash = "sha256-dQjeNWBvMb2c+igEo2hvIy5Qchz3rSBmA738K4vEjco=";
  };

  cargoRoot = "agent/rs/htmlparser";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version;
    cargoRoot = "agent/rs/htmlparser";
    src = finalAttrs.src;
    hash = "sha256-F9m2+WSrxjQgFDJ+//GCnMvzUD6734IGqnw7sRYIwTU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    qt6.qtbase
    corrosion
    xapian
    akonadi
    akonadi-mime
    kcalendarcore
    kcmutils
    kcontacts
    kmime
    ktextaddons
  ]
  ++ lib.optional (krunner != null) krunner;

  meta = {
    description = "Libraries and daemons to implement searching in Akonadi";
    homepage = "https://invent.kde.org/pim/akonadi-search";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
