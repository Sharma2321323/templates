{
  pkgs, ...
}:
{
  # Template metadata
  name = "Svelte + Vite";
  description = "A simple Svelte starter template with Vite";

  # Use the stable channel
  channel = "stable-24.05";

  # Use a stable LTS Node.js version and add typescript for LSP support in the IDE
  packages = [ pkgs.nodejs_20 pkgs.typescript ];

  # Scripts to run when a new project is created
  bootstrap = ''
    set -x
    echo "--- Starting bootstrap process with Node.js 20 and Vite 5 ---"

    # Create a new Svelte + Vite project using the TypeScript template
    yes | npm create vite@5 . -- --template svelte-ts
    echo "--- Vite project created with svelte-ts template ---"

    # Install initial dependencies from package.json
    npm install
    echo "--- Initial dependencies installed ---"

    # Install ESLint, Prettier, and TypeScript dev dependencies
    npm install @eslint/js@^9.0.0 eslint@^9.0.0 eslint-config-prettier@^9.0.0 eslint-plugin-svelte@^2.36.0 globals@^15.0.0 prettier@^3.1.0 typescript-eslint@^7.11.0 --save-dev
    echo "--- Dev dependencies installed ---"

    # Add lint and format scripts to package.json
    npm pkg set scripts.lint="eslint ."
    npm pkg set scripts.format="prettier --write ."
    echo "--- Scripts added to package.json ---"

    # Create the .idx directory for IDE-specific files
    mkdir -p .idx
    echo "--- .idx directory created ---"

    # Copy the template's .idx content into the new project's .idx directory
    cp ${./.idx/eslint.config.js} .idx/
    cp ${./.idx/airules.md} .idx/
    echo "--- .idx files copied ---"

    # Copy the eslint config to the project root
    cp .idx/eslint.config.js .
    echo "--- ESLint config copied to project root ---"

    echo "--- Bootstrap process finished ---"
    set +x
  '';

  # Visible files and folders
  visible = [
    ".idx"
    "src"
    "package.json"
    "svelte.config.js"
    "vite.config.js"
    "README.md"
    "eslint.config.js"
    "tsconfig.json"
    "tsconfig.node.json"
  ];
}
