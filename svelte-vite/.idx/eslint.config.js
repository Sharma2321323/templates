
import tseslint from 'typescript-eslint';
import pluginSvelte from 'eslint-plugin-svelte';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default [
  // 1. Global ignores
  {
    ignores: ["dist", "node_modules", "*.cjs", "**/*.config.js"],
  },

  // 2. Recommended rules
  ...tseslint.configs.recommended,
  ...pluginSvelte.configs['flat/recommended'],

  // 3. Svelte configuration
  {
    files: ["**/*.svelte"],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "module",
      globals: {
        ...globals.browser,
      },
      parserOptions: {
        parser: tseslint.parser,
        extraFileExtensions: [".svelte"],
      },
    },
    rules: {
      // override/add rules settings here, such as:
      // 'svelte/rule-name': 'error'
    },
  },

  // 4. Prettier config must be last to override other formatting rules.
  prettier,
];
