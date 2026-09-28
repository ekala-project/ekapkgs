{
  lib,
  newScope,
  stdenv,
  fetchurl,
  makeSetupHook,
  runCommand,
  gstreamer,
  python3,
}:

let
  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://qt";
  };
in
lib.makeScope newScope (
  self:
  let
    # Extend scope with Qt-specific attrs for module callPackage
    callQtModule =
      path: args:
      self.newScope {
        inherit (self) qtModule;
        inherit srcs python3 stdenv;
      } path args;

    onlyPluginsAndQml =
      drv:
      let
        inherit (self.qtbase) qtPluginPrefix qtQmlPrefix;
      in
      (runCommand "${drv.name}-only-plugins-qml" { } ''
        mkdir -p $(dirname "$out/${qtPluginPrefix}")
        test -d "${drv}/${qtPluginPrefix}" && ln -s "${drv}/${qtPluginPrefix}" "$out/${qtPluginPrefix}" || true
        test -d "${drv}/${qtQmlPrefix}" && ln -s "${drv}/${qtQmlPrefix}" "$out/${qtQmlPrefix}" || true
      '');
  in
  {
    inherit srcs;

    qtModule = callQtModule ./qtModule.nix { };

    qtbase = callQtModule ./modules/qtbase {
      withGtk3 = true;
      inherit (srcs.qtbase) src version;
    };
    env = callQtModule ./qt-env.nix { };
    qt3d = callQtModule ./modules/qt3d.nix { };
    qt5compat = callQtModule ./modules/qt5compat.nix { };
    qtcharts = callQtModule ./modules/qtcharts.nix { };
    qtconnectivity = callQtModule ./modules/qtconnectivity.nix { };
    qtdatavis3d = callQtModule ./modules/qtdatavis3d.nix { };
    qtdeclarative = callQtModule ./modules/qtdeclarative { };
    qtdoc = callQtModule ./modules/qtdoc.nix { };
    qtgraphs = callQtModule ./modules/qtgraphs.nix { };
    qtgrpc = callQtModule ./modules/qtgrpc.nix { };
    qthttpserver = callQtModule ./modules/qthttpserver.nix { };
    qtimageformats = callQtModule ./modules/qtimageformats.nix { };
    qtlanguageserver = callQtModule ./modules/qtlanguageserver.nix { };
    qtlocation = callQtModule ./modules/qtlocation.nix { };
    qtlottie = callQtModule ./modules/qtlottie.nix { };
    qtmultimedia = callQtModule ./modules/qtmultimedia {
      inherit (gstreamer)
        gstreamer
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-libav
        ;
    };
    qtmqtt = callQtModule ./modules/qtmqtt.nix { };
    qtnetworkauth = callQtModule ./modules/qtnetworkauth.nix { };
    qtpositioning = callQtModule ./modules/qtpositioning.nix { };
    qtsensors = callQtModule ./modules/qtsensors.nix { };
    qtserialbus = callQtModule ./modules/qtserialbus.nix { };
    qtserialport = callQtModule ./modules/qtserialport.nix { };
    qtshadertools = callQtModule ./modules/qtshadertools.nix { };
    qtspeech = callQtModule ./modules/qtspeech.nix { };
    qtquick3d = callQtModule ./modules/qtquick3d.nix { };
    qtquick3dphysics = callQtModule ./modules/qtquick3dphysics.nix { };
    qtquickeffectmaker = callQtModule ./modules/qtquickeffectmaker.nix { };
    qtquicktimeline = callQtModule ./modules/qtquicktimeline.nix { };
    qtremoteobjects = callQtModule ./modules/qtremoteobjects.nix { };
    qtsvg = callQtModule ./modules/qtsvg.nix { };
    qtscxml = callQtModule ./modules/qtscxml.nix { };
    qttools = callQtModule ./modules/qttools { };
    qttranslations = callQtModule ./modules/qttranslations.nix {
      qttools = self.qttools.override {
        qtbase = self.qtbase.override { qttranslations = null; };
        qtdeclarative = null;
      };
    };
    qtvirtualkeyboard = callQtModule ./modules/qtvirtualkeyboard.nix { };
    qtwayland = callQtModule ./modules/qtwayland.nix { };
    qtwebchannel = callQtModule ./modules/qtwebchannel.nix { };
    qtwebengine = callQtModule ./modules/qtwebengine { };
    qtwebsockets = callQtModule ./modules/qtwebsockets.nix { };
    qtwebview = callQtModule ./modules/qtwebview.nix { };

    wrapQtAppsHook = callQtModule (
      {
        wrapQtAppsHook,
        makeBinaryWrapper,
        qtwayland,
        qtbase,
      }:
      makeSetupHook {
        name = "wrap-qt6-apps-hook";
        propagatedBuildInputs = [ makeBinaryWrapper ];
        depsTargetTargetPropagated = [
          (onlyPluginsAndQml qtbase)
        ];
        meta.license = lib.licenses.mit;
      } ./hooks/wrap-qt-apps-hook.sh
    ) { };

    qmake = callQtModule (
      { qtbase }:
      makeSetupHook {
        name = "qmake6-hook";
        propagatedBuildInputs = [ qtbase ];
        substitutions = {
          fix_qmake_libtool = ./hooks/fix-qmake-libtool.sh;
        };
        meta.license = lib.licenses.mit;
      } ./hooks/qmake-hook.sh
    ) { };
  }
)
