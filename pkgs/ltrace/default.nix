{
  lib,
  stdenv,
  fetchurl,
  fetchgit,
  autoreconfHook,
  dejagnu,
  elfutils,
}:

stdenv.mkDerivation {
  pname = "ltrace";
  version = "0.7.91";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/ltrace/ltrace-0.7.91.tar.bz2/9db3bdee7cf3e11c87d8cc7673d4d25b/ltrace-0.7.91.tar.bz2";
    sha256 = "sha256-HqellbKh2ZDHxslXl7SSIXtpjV1sodtgVwh8hgTC3Dc=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ elfutils ];
  nativeCheckInputs = [ dejagnu ];

  patches =
    let
      fedora = fetchgit {
        url = "https://src.fedoraproject.org/rpms/ltrace.git";
        rev = "00f430ccbebdbd13bdd4d7ee6303b091cf005542";
        sha256 = "sha256-FBGEgmaslu7xrJtZ2WsYwu9Cw1ZQrWRV1+Eu9qLXO4s=";
      };
      fedoraPatches = builtins.map (p: "${fedora}/${p}") [
        "ltrace-0.7.91-arm.patch"
        "ltrace-0.7.91-account_execl.patch"
        "ltrace-0.7.91-x86_64-irelative.patch"
        "ltrace-0.7.91-s390-fetch-syscall.patch"
        "ltrace-0.7.91-s390-irelative.patch"
        "ltrace-0.7.91-ppc64-fork.patch"
        "ltrace-0.7.91-breakpoint-on_install.patch"
        "ltrace-0.7.91-ppc64-unprelink.patch"
        "ltrace-0.7.91-man.patch"
        "ltrace-0.7.91-cant_open.patch"
        "ltrace-0.7.91-aarch64.patch"
        "ltrace-0.7.2-e_machine.patch"
        "ltrace-0.7.91-ppc64le-support.patch"
        "ltrace-0.7.91-ppc64le-fixes.patch"
        "ltrace-0.7.91-parser-ws_after_id.patch"
        "ltrace-0.7.91-ppc-bias.patch"
        "ltrace-0.7.91-x86-plt_map.patch"
        "ltrace-0.7.91-x86-unused_label.patch"
        "ltrace-0.7.91-unwind-elfutils.patch"
        "ltrace-0.7.91-multithread-no-f-1.patch"
        "ltrace-0.7.91-multithread-no-f-2.patch"
        "ltrace-0.7.91-testsuite-includes.patch"
        "ltrace-0.7.91-testsuite-includes-2.patch"
        "ltrace-0.7.91-ppc64le-configure.patch"
        "ltrace-rh1307754.patch"
        "ltrace-0.7.91-tautology.patch"
        "ltrace-rh1423913.patch"
        "ltrace-0.7.91-aarch64-params.patch"
        "ltrace-0.7.91-null.patch"
        "ltrace-0.7.91-cet.patch"
        "ltrace-0.7.91-aarch64-headers.patch"
        "ltrace-rh1225568.patch"
        "ltrace-0.7.91-testsuite-system_call_params.patch"
        "ltrace-0.7.91-XDG_CONFIG_DIRS.patch"
        "ltrace-0.7.91-rh1799619.patch"
        "ltrace-0.7.91-ppc64le-scv.patch"
        "ltrace-0.7.91-W-use-after-free.patch"
      ];
    in
    fedoraPatches
    ++ [
      ./testsuite-newfstatat.patch
      ./sysdeps-x86.patch
      (fetchurl {
        url = "https://github.com/gentoo/gentoo/raw/a2eb7e103ec985ff90f59e722e0a8a43373972a2/dev-debug/ltrace/files/ltrace-0.7.3-print-test-pie.patch";
        hash = "sha256-QRsUoN3WLzfiY5GDPwVYXtJPFMJt6rcc6eE96SAtI6Q=";
      })
      (fetchurl {
        url = "https://gitlab.com/cespedes/ltrace/-/commit/d888b448740abd4d5846535ef1dc5ba1c74a134a.patch";
        hash = "sha256-9XAeulMUUvLh6Q9ppSL6d5kA2UPPyzCjwibcXH260Bo=";
      })
    ];

  meta = {
    description = "Library call tracer";
    mainProgram = "ltrace";
    homepage = "https://www.ltrace.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
