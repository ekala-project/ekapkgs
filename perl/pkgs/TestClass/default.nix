{
  buildPerlPackage,
  fetchurl,
  lib,
  TestException,
  MROCompat,
  ModuleRuntime,
  TryTiny,
}:
buildPerlPackage {
  pname = "Test-Class";
  version = "0.52";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SZ/SZABGAB/Test-Class-0.52.tar.gz";
    hash = "sha256-QMGx04jwqGdHacJ1KfDMNjTKD9nY9ysZbAUxYRk0vII=";
  };

  buildInputs = [ TestException ];

  propagatedBuildInputs = [
    MROCompat
    ModuleRuntime
    TryTiny
  ];

  preCheck = ''
    rm t/runtests_die.t
    rm t/runtests_die_empty.t
    rm t/runtests_die_nearlyempty.t
    rm t/runtests_result.t
    rm t/todo.t
  '';

  meta = {
    description = "Easily create test classes in an xUnit/JUnit style";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
