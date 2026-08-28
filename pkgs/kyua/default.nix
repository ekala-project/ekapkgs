{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  autoreconfHook,
  lutok,
  pkg-config,
  sqlite,
}:

let
  atf' = atf.overrideAttrs (_: {
    doInstallCheck = false;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kyua";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "kyua";
    rev = "c85354e09ad93a902c9e8a701c042c045ec2a5b7";
    hash = "sha256-fZ0WFgOTj8Gw8IT5O8DnuaNyZscKpg6B94m+l5UoZGc=";
  };

  setupHooks = ./kyua-check-hook.sh;

  postPatch = ''
    substituteInPlace cli/Makefile.am.inc \
      --replace-fail 'libcli_a_LIBADD = libutils.a' "" \
      --replace-fail 'CLI_LIBS = ' 'CLI_LIBS = libutils.a '
  ''
  + lib.optionalString (finalAttrs.doInstallCheck && stdenv.hostPlatform.isLinux) ''
    sed -i utils/process/Makefile.am.inc -e '/executor_pid_test/d'
    substituteInPlace utils/process/Kyuafile \
      --replace-fail 'atf_test_program{name="executor_pid_test"}' ""
    substituteInPlace engine/atf_test.cpp \
      --replace-fail 'ATF_ADD_TEST_CASE(tcs, test__body_only__crashes);' ""
    substituteInPlace utils/stacktrace_test.cpp \
      --replace-fail 'ATF_ADD_TEST_CASE(tcs, dump_stacktrace__ok);' "" \
      --replace-fail 'ATF_ADD_TEST_CASE(tcs, dump_stacktrace_if_available__append);' "" \
      --replace-fail 'ATF_ADD_TEST_CASE(tcs, find_core__found__long);' "" \
      --replace-fail 'ATF_ADD_TEST_CASE(tcs, find_core__found__short);' "" \
      --replace-fail 'ATF_ADD_TEST_CASE(tcs, unlimit_core_size__hard_is_zero);' ""
    substituteInPlace integration/cmd_test_test.sh \
      --replace-fail 'atf_add_test_case premature_exit' ""
  '';

  strictDeps = true;

  buildInputs = [
    lutok
    sqlite
  ];

  nativeBuildInputs = [
    atf'
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "CXXFLAGS=-std=c++11"
  ];

  doInstallCheck = false;

  __structuredAttrs = true;

  meta = {
    description = "Testing framework for infrastructure software";
    homepage = "https://github.com/freebsd/kyua/";
    changelog = "https://github.com/freebsd/kyua/blob/master/NEWS.md";
    license = lib.licenses.bsd3;
    mainProgram = "kyua";
    platforms = lib.platforms.unix;
  };
})
