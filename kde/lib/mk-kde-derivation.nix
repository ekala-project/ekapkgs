self:
{
  lib,
  stdenv,
  makeSetupHook,
  cmake,
  ninja,
  qt6,
  python3,
  python3Packages,
  jq,
}:
let
  dependencies = (lib.importJSON ../generated/dependencies.json).dependencies;
  projectInfo = lib.importJSON ../generated/projects.json;

  licenseInfo = lib.importJSON ../generated/licenses.json;
  licensesBySpdxId = lib.licensesSpdx // {
    # https://community.kde.org/Policies/Licensing_Policy
    "LicenseRef-KDE-Accepted-GPL" = lib.licenses.gpl3Plus;
    "LicenseRef-KFQF-Accepted-GPL" = lib.licenses.gpl3Plus;
    "LicenseRef-KDE-Accepted-LGPL" = lib.licenses.lgpl3Plus;

    # https://sjfonts.sourceforge.net/
    "LicenseRef-SJFonts" = lib.licenses.gpl2Plus;

    # https://invent.kde.org/education/kiten/-/blob/master/LICENSES/LicenseRef-EDRDG.txt
    "LicenseRef-EDRDG" = lib.licenses.cc-by-sa-30;

    # https://invent.kde.org/kdevelop/kdevelop/-/blob/master/LICENSES/LicenseRef-MIT-KDevelop-Ideal.txt
    "LicenseRef-MIT-KDevelop-Ideal" = lib.licenses.mit;

    # FIXME: typo lol
    "ICS" = lib.licenses.isc;
    "BSD-3-Clauses" = lib.licenses.bsd3;

    # These are only relevant to Qt commercial users
    "Qt-Commercial-exception-1.0" = null;
    "LicenseRef-Qt-Commercial" = null;
    "LicenseRef-Qt-Commercial-exception-1.0" = null;

    # Qt exception clauses
    "LicenseRef-Qt-LGPL-exception-1.0" = null;
    "Qt-LGPL-exception-1.1" = null;
    "Qt-GPL-exception-1.0" = null;
    "LicenseRef-Qt-exception" = null;
    "Font-exception-2.0" = null;

    # SPDX IDs not in lib.licensesSpdx
    "AGPL-3.0-or-later" = lib.licenses.agpl3Plus;
    "Artistic-2.0" = lib.licenses.artistic2;
    "BSD-1-Clause" = lib.licenses.bsd1;
    "CC-BY-3.0" = lib.licenses.cc-by-30;
    "CPL-1.0" = lib.licenses.cpl10;
    "FSFAP" = null;
    "FSFULLR" = null;
    "GFDL-1.2-only" = lib.licenses.fdl12Only;
    "GFDL-1.2-or-later" = lib.licenses.fdl12Plus;
    "GPL-2.0" = lib.licenses.gpl2Only;
    "MPL-1.1" = lib.licenses.mpl11;
    "ODbL-1.0" = lib.licenses.ofl;
    "W3C-20150513" = lib.licenses.w3c;
    "bzip2-1.0.6" = lib.licenses.bsdOriginal;
    None = null;
  };

  moveOutputsHook = makeSetupHook {
    name = "kf6-move-outputs-hook";
    meta.license = lib.licenses.mit;
  } ./move-outputs-hook.sh;

  qmllintHook = makeSetupHook {
    name = "qmllint-validate-hook";
    substitutions = {
      qmllint = "${qt6.qtdeclarative}/bin/qmllint";
      jq = lib.getExe jq;
    };
    meta.license = lib.licenses.mit;
  } ./qmllint-hook.sh;
in
{
  pname,
  version ? self.sources.${pname}.version,
  src ? self.sources.${pname},
  extraBuildInputs ? [ ],
  extraNativeBuildInputs ? [ ],
  extraPropagatedBuildInputs ? [ ],
  extraCmakeFlags ? [ ],
  excludeDependencies ? [ ],
  hasPythonBindings ? false,
  ...
}@args:
let
  depNames = dependencies.${pname} or [ ];
  filteredDepNames = builtins.filter (dep: !(builtins.elem dep excludeDependencies)) depNames;

  # FIXME(later): this is wrong for cross, some of these things really need to go into nativeBuildInputs,
  # but cross is currently very broken anyway, so we can figure this out later.
  deps = builtins.filter (dep: dep != null) (map (dep: self.${dep} or null) filteredDepNames);
  pyDeps = builtins.concatMap (dep: if dep ? python then [ dep.python ] else [ ]) deps;

  traceDuplicateDeps =
    attrName: attrValue:
    let
      pretty = lib.generators.toPretty { };
      duplicates = builtins.filter (
        dep: dep != null && builtins.elem (lib.getName dep) filteredDepNames
      ) attrValue;
    in
    if duplicates != [ ] then
      lib.warn "Duplicate dependencies in ${attrName} of package ${pname}: ${pretty duplicates}"
    else
      lib.id;

  traceAllDuplicateDeps = lib.flip lib.pipe [
    (traceDuplicateDeps "extraBuildInputs" extraBuildInputs)
    (traceDuplicateDeps "extraPropagatedBuildInputs" extraPropagatedBuildInputs)
  ];

  defaultArgs = {
    inherit version src;

    outputs = [
      "out"
      "dev"
      "devtools"
    ]
    ++ lib.optionals hasPythonBindings [ "python" ];

    nativeBuildInputs = [
      cmake
      cmake.configurePhaseHook
      ninja
      qt6.wrapQtAppsHook
      moveOutputsHook
      qmllintHook
    ]
    ++ lib.optionals hasPythonBindings [
      python3Packages.shiboken6
      python3Packages.shiboken6-generator
      (python3.withPackages (ps: [
        ps.build
        ps.setuptools
      ]))
    ]
    ++ extraNativeBuildInputs;

    buildInputs = [
      qt6.qtbase
    ]
    ++ lib.optionals hasPythonBindings (
      [
        python3Packages.pyside6
      ]
      # pyDeps manually propagated in moveOutputsHook
      ++ pyDeps
    )
    ++ extraBuildInputs;

    # FIXME: figure out what to propagate here
    propagatedBuildInputs = deps ++ extraPropagatedBuildInputs;
    strictDeps = true;

    cmakeFlags = [ "-DQT_MAJOR_VERSION=6" ] ++ extraCmakeFlags;

    doInstallCheck = true;

    separateDebugInfo = true;

    env.LANG = "C.UTF-8";
  };

  cleanArgs = removeAttrs args [
    "extraBuildInputs"
    "extraNativeBuildInputs"
    "extraPropagatedBuildInputs"
    "extraCmakeFlags"
    "excludeDependencies"
    "hasPythonBindings"
    "meta"
  ];

  meta = {
    description = projectInfo.${pname}.description;
    homepage = "https://invent.kde.org/${projectInfo.${pname}.repo_path}";
    donationPage = "https://kde.org/donate/";
    license = lib.filter (l: l != null) (map (l: licensesBySpdxId.${l}) licenseInfo.${pname});
    # Platforms are currently limited to what upstream tests in CI, but can be extended if there's interest.
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  }
  // (args.meta or { });

  pos = builtins.unsafeGetAttrPos "pname" args;
in
traceAllDuplicateDeps (stdenv.mkDerivation (defaultArgs // cleanArgs // { inherit meta pos; }))
