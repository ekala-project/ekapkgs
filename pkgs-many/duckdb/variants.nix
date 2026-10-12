{
  base = {
    version = "1.4.3";
    src-hash = "sha256-zYiyY/8mYCyKuSQYNxepGbZPVgdCgULLmhZlWAAW0QA=";
    withJdbc = false;
    withOdbc = false;
  };
  jdbc = {
    withJdbc = true;
  };
  odbc = {
    withOdbc = true;
  };
  full = {
    withJdbc = true;
    withOdbc = true;
  };
}
