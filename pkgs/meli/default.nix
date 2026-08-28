{
  lib,
  fetchzip,
  rustPlatform,
  pkg-config,
  installShellFiles,
  makeWrapper,
  mandoc ? null,
  rustfmt ? null,
  file ? null,
  openssl,
  dbus ? null,
  sqlite,
  gpgme ? null,
  gnum4 ? null,
  withNotmuch ? true,
  notmuch ? null,
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "0.8.13";

  src = fetchzip {
    urls = [
      "https://git.meli-email.org/meli/meli/archive/v${version}.tar.gz"
      "https://codeberg.org/meli/meli/archive/v${version}.tar.gz"
      "https://github.com/meli/meli/archive/refs/tags/v${version}.tar.gz"
    ];
    hash = "sha256-uyhxNEKoRKrqvU76SuTKl1wlwOdHIxMFLXB5LwsdvQE=";
  };

  cargoHash = "sha256-wDj4g5Cjm6zedjCmpc/A40peHO951lLuEQGsn+i3eT0=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals (mandoc != null) [ mandoc ];

  buildInputs = [
    openssl
    sqlite
  ]
  ++ lib.optionals (dbus != null) [ dbus ];

  postInstall = ''
    installManPage meli/docs/*.{1,5,7}

    wrapProgram $out/bin/meli \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          lib.optional (gpgme != null) gpgme ++ lib.optional (withNotmuch && notmuch != null) notmuch
        )
      } \
      --prefix PATH : ${lib.makeBinPath (lib.optional (gnum4 != null) gnum4)}
  '';

  checkFlags = [
    "--skip=test_cli_subcommands"
    "--skip=accounts::tests::test_accounts_mailbox_by_path_error_msg"
    "--skip=conf::tests::test_conf_config_parse"
    "--skip=mail::compose::gpg::tests::test_gpg_verify_sig"
    "--skip=mail::compose::hooks::tests::test_draft_hook_datewarn"
    "--skip=mail::compose::hooks::tests::test_draft_hook_emptydraftwarn"
    "--skip=mail::compose::hooks::tests::test_draft_hook_headerwarn"
    "--skip=mail::compose::hooks::tests::test_draft_hook_missingattachmentwarn"
    "--skip=mail::compose::tests::test_compose_reply_subject_prefix"
    "--skip=utilities::tests::test_utilities_text_input_field"
  ];

  meta = {
    description = "Terminal e-mail client and e-mail client library";
    mainProgram = "meli";
    homepage = "https://meli.delivery";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
