{ pkgs, packageManager, ... }: {

    packages = [
      pkgs.nodejs_20
      pkgs.git
    ];

    bootstrap = ''
      npx nuxi@latest -y init "$out" \
        --t "minimal" \
        --package-manager ${packageManager} \
        --no-install \
        --git-init  <<< "No"

      (cd "$out" && \
        echo '{
          "root": true,
          "extends": [
            "@nuxtjs/eslint-config-typescript",
            "prettier"
          ]
        }' > .eslintrc.json && \
        node -e '
          const fs = require("fs");
          const pkg = JSON.parse(fs.readFileSync("package.json", "utf-8"));
          pkg.scripts = {
            ...pkg.scripts,
            "lint": "eslint .",
            "format": "prettier --write ."
          };
          pkg.devDependencies = {
            ...pkg.devDependencies,
            "eslint": "^8.57.0",
            "prettier": "^3.2.5",
            "@nuxtjs/eslint-config-typescript": "^12.1.0",
            "eslint-config-prettier": "^9.1.0"
          };
          fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2));
        '
      )

      mkdir -p "$out"/.idx
      cp ${./dev.nix} "$out"/.idx/dev.nix
      cp -rf ${./.idx/airules.md} "$out"/.idx/airules.md
      cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"

      chmod -R u+w "$out"

      sed -i "s/PACKAGE_MANAGER/${packageManager}/g" "$out"/.idx/dev.nix
      sed -i "s|PM_COMMAND|${if packageManager == "npm" then "npm i --no-audit --prefer-offline --no-progress --timing" else "${packageManager} install"}|g" "$out"/.idx/dev.nix
      sed -i "s|PM_INSTALL|${packageManager} install|g" "$out"/.idx/dev.nix
      sed -i 's|PM_NIX_PACKAGE|${if packageManager == "npm" then "" else if packageManager == "pnpm" then "pkgs.nodePackages.pnpm" else if packageManager == "bun" then "pkgs.bun" else "pkgs.yarn"}|g' "$out"/.idx/dev.nix

      ${if packageManager == "npm" then "( cd $out && npm i --package-lock-only --ignore-scripts )" else ""}
    '';
}
