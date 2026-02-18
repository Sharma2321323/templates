{ pkgs, ... }: {
  packages = [ pkgs.cargo ];

  bootstrap = ''
    cargo new app
    mkdir -p app/.idx
    cp ${./dev.nix} app/.idx/dev.nix
    chmod +w app/.idx/dev.nix
    mv app "$out"

    # Create a package.json for npm scripts
    echo '{
      "name": "rust-project",
      "version": "1.0.0",
      "scripts": {
        "lint": "eslint .",
        "format": "prettier --write ."
      }
    }' > "$out/package.json"

    # Create a .eslintrc.json for ESLint configuration
    echo '{
      "root": true,
      "extends": [
        "eslint:recommended",
        "prettier"
      ],
      "parserOptions": {
        "ecmaVersion": 2021,
        "sourceType": "module"
      },
      "env": {
        "es2021": true,
        "node": true
      }
    }' > "$out/.eslintrc.json"

    # Create a .prettierrc.json for Prettier configuration
    echo '{}' > "$out/.prettierrc.json"

    # Create ignore files
    echo "target" > "$out/.eslintignore"
    echo "target" > "$out/.prettierignore"

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"
  '';
}
