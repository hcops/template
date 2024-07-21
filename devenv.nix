{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    postgresql_15
    cargo-pgrx
    #graphqurl
    #graphql-client
    #nixos-generators
    # linter
    #sqlfluff   # SQL
    #shellcheck # Shell
    #mdsh       # Markdown
  ];

  # https://devenv.sh/scripts/
  scripts = {
    hello.exec = "echo Starting $GREET";
    cleanstate.exec = "rm -rf $DEVENV_STATE/*";
    cargoBuild.exec = ''
      echo "Running cargo pgrx install..."
      cargo pgrx install --release -c /usr/bin/pg_config
    '';
  };

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep "2.42.0"
  '';

  # https://devenv.sh/services/
  services.postgres = {
    package = pkgs.postgresql_15.withPackages (p: [ p.age ]);
    enable = true;
    settings.port = 5432;
    listen_addresses = "127.0.0.1";
    initialScript = ''
      CREATE DATABASE "mydb";
    '';
  };

  # pre-commit.hooks = {
  #   shellcheck.enable = true;
  #   mdsh.enable = true;
    # SQL
  #   sqllint = {
  #     enable = true;
  #     name = "SQL linter";
  #     entry = "${pkgs.sqlfluff}/bin/sqlfluff lint --dialect postgres -e CP01,CP05,LT02 --nofail";
  #     files = "\\.sql$";
  #     pass_filenames = true;
  #   };
  # };

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  # https://devenv.sh/reference/options/#languagesrustchannel
  languages.rust.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;


  # See full reference at https://devenv.sh/reference/options/
}