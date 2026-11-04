{
  buildPerlPackage,
  fetchurl,
  TestException,
  ModuleRuntime,
}:
buildPerlPackage {
  pname = "Class-Accessor-Grouped";
  version = "0.10014";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Class-Accessor-Grouped-0.10014.tar.gz";
    hash = "sha256-NdWwPvwJ9n86MVXJYkEmw+FiyOPKmP+CbbNYUzpExLs=";
  };

  buildInputs = [ TestException ];

  propagatedBuildInputs = [ ModuleRuntime ];

  meta = {
    description = "Lets you build groups of accessors";
  };
}
