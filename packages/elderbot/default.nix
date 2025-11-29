{ python3 }: with python3.pkgs; buildPythonApplication {
  pname = "elderbot";
  version = "1.0";

  src = ./.;

  propagatedBuildInputs = [ telethon ];

  pyproject = true;

  build-system = [ setuptools ];
}
