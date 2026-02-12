import globals from "globals";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import svelte from "eslint-plugin-svelte";
import prettier from "eslint-config-prettier";

export default [
  // 1. Global ignores
  {
    ignores: ["build/", ".svelte-kit/", "dist/"],
  },
  // 2. Main configuration for JS/TS files
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
      }
    }
  },
  // 3. Svelte configuration
  ...svelte.configs['flat/recommended'],
  // 4. Prettier config
  prettier,
  ...svelte.configs['flat/prettier'],
];
