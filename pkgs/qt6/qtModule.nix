{
  lib,
  stdenv,
  cmake,
  ninja,
  perl,
  srcs,
  patches ? [ ],
}:

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in
stdenv.mkDerivation (
  args
  // {
    inherit pname version src;
    patches = args.patches or patches.${pname} or [ ];

    buildInputs = args.buildInputs or [ ];
    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
      cmake
      cmake.configurePhaseHook
      ninja
      perl
    ];
    propagatedBuildInputs =
      (lib.warnIf (args ? qtInputs) "qt6.qtModule's qtInputs argument is deprecated" args.qtInputs or [ ])
      ++ (args.propagatedBuildInputs or [ ]);

    cmakeEntries = {
      CMAKE_SYSTEM_VERSION = "";
    };

    cmakeFlags = [
      "--log-level=STATUS"
    ]
    ++ args.cmakeFlags or [ ];

    moveToDev = false;

    outputs = args.outputs or [ "out" ];
    separateDebugInfo = args.separateDebugInfo or false;

    dontWrapQtApps = args.dontWrapQtApps or true;
  }
)
// {
  meta =

    let
      pos = builtins.unsafeGetAttrPos "pname" args;
    in
    {
      homepage = "https://www.qt.io/";
      description = "Cross-platform application framework for C++";
      license = with lib.licenses; [
        fdl13Plus
        gpl2Plus
        lgpl21Plus
        lgpl3Plus
      ];
      platforms = lib.platforms.linux;
      position = "${pos.file}:${toString pos.line}";
    }
    // (args.meta or { });
}
