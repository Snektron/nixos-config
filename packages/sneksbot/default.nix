{ python3 }: with python3.pkgs; buildPythonApplication {
  pname = "sneksbot";
  version = "1.0";

  src = ./.;

  propagatedBuildInputs = [ python-telegram-bot ];

  pyproject = true;

  build-system = [ setuptools ];
}
