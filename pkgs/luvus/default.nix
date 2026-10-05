{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  pkg-config,
  curl,
  gitMinimal,
  gh,
  openssh,
  bashInteractive,
  coreutils,
  procps,
  sqlite,
  tzdata,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  runtimeTools = [
    gitMinimal
    gh
    openssh
    bashInteractive
    coreutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ procps ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luvus";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "RizRiyz";
    repo = "luvus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QhiPA1oV/WRgPrAeR+PlbFxKfquMkyKsjjPLLRzPiDw=";
  };

  cargoHash = "sha256-yqfN+zngeryaPxKbVW4UihOvdjHw/toXBAX7yEbr6MY=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ sqlite ];

  env.LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";

  nativeCheckInputs = [
    curl
    gitMinimal
  ];

  checkFlags = [
    "--test-threads=1"
    "--skip=app::tests::clicking_a_pane_title_shows_the_real_command"
    "--skip=app::tests::keyboard_copy_mode_yanks_history_and_cancel_restores_its_viewport"
    "--skip=app::tests::keyboard_copy_word_navigation_uses_visual_columns"
    "--skip=app::files::tests::previewing_from_a_dashboard_tab_opens_a_tab_and_still_reuses_it"
    "--skip=app::tests::resize_yields_to_pane_title_and_zoom_but_still_grabs_the_seam"
    "--skip=app::tests::resume_session_opens_pane"
    "--skip=platform::tests::process_tree_finds_this_process_and_its_children"
    "--skip=app::settings::tests::enter_routes_an_installed_theme_through_removal"
    "--skip=app::diff::tests::dashboard_diff_click_opens_a_tab_then_reuses_it"
    "--skip=platform::tests::unix_stoppable_pid_accepts_a_luvus_executable_with_arguments"
    "--skip=app::files::tests::files_show_hidden_defaults_on_and_the_setting_persists"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export LUVUS_HOME=$(mktemp -d)
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  postFixup = ''
    wrapProgram $out/bin/luvus \
      --prefix PATH : ${lib.makeBinPath runtimeTools} \
      --set-default TZDIR ${tzdata}/share/zoneinfo
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Mission control for your AI coding agents";
    homepage = "https://luvus.dev";
    changelog = "https://github.com/RizRiyz/luvus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "luvus";
    platforms = lib.platforms.unix;
  };
})
