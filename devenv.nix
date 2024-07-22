{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "sandbox";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    postgresql_15
    cargo-pgrx
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
    enable = true;
    package = pkgs.postgresql_15;
    settings.port = 5432;
    listen_addresses = "127.0.0.1";
    initialDatabases = [{ name = "mydb"; }];
    extensions = extensions: [
      extensions.timescaledb
    ];
    settings.shared_preload_libraries = "timescaledb";
    initialScript = ''
      CREATE EXTENSION IF NOT EXISTS timescaledb;
    '';
  };

  services.postgres = {
  };

  pre-commit.hooks = {
    shellcheck.enable = true;
    mdsh.enable = true;
    # SQL
    sqllint = {
      enable = true;
      name = "SQL linter";
      entry = "${pkgs.sqlfluff}/bin/sqlfluff lint --dialect postgres -e CP01,CP05,LT02 --nofail";
      files = "\\.sql$";
      pass_filenames = true;
    };
  };

  # https://devenv.sh/languages/
  # languages.ansible.enable = true;
  # languages.c.enable = true;
  # languages.clojure.enable = true;
  # languages.cplusplus.enable = true;
  # languages.crystal.enable = true;
  # languages.cue.enable = true;
  # languages.dart.enable = true;
  # languages.deno.enable = true;
  # languages.dotnet.enable = true;
  # languages.elixir.enable = true;
  # languages.elm.enable = true;
  # languages.erlang.enable = true;
  # languages.fortran.enable = true;
  # languages.gawk.enable = true;
  # languages.gleam.enable = true;
  # languages.go.enable = true;
  # languages.haskell.enable = true;
  # languages.idris.enable = true;
  # languages.java.enable = true;
  # languages.javascript.enable = true;
  # languages.jsonnet.enable = true;
  # languages.julia.enable = true;
  # languages.kotlin.enable = true;
  # languages.lua.enable = true;
  # languages.nim.enable = true;
  languages.nix.enable = true;
  # languages.ocaml.enable = true;
  # languages.odin.enable = true;
  # languages.opentofu.enable = true;
  # languages.pascal.enable = true;
  # languages.perl.enable = true;
  # languages.php.enable = true;
  # languages.purescript.enable = true;
  # languages.python.enable = true;
  # languages.python.version = "3.11.3";
  # languages.r.enable = true;
  # languages.racket.enable = true;
  # languages.raku.enable = true;
  # languages.robotframework.enable = true;
  # languages.ruby.enable = true;
  languages.rust.enable = true;
  languages.rust.channel = "stable";
  # languages.scala.enable = true;
  # languages.shell.enable = true;
  # languages.solidity.enable = true;
  # languages.standardml.enable = true;
  # languages.swift.enable = true;
  # languages.terraform.enable = true;
  # languages.texlive.enable = true;
  # languages.typescript.enable = true;
  # languages.unison.enable = true;
  # languages.v.enable = true;
  # languages.vala.enable = true;
  # languages.zig.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks.shellcheck.enable = true;


  # See full reference at https://devenv.sh/reference/options/
}
