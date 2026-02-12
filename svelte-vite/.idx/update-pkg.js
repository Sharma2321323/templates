const fs = require('fs');
const path = require('path');

// --- Configuration ---
const packageJsonPath = path.join(process.cwd(), 'package.json');

const scriptsToAdd = {
  lint: 'eslint .',
  format: 'prettier --write .',
};

const devDependenciesToAdd = {
  '@eslint/js': 'latest',
  eslint: 'latest',
  'eslint-config-prettier': 'latest',
  'eslint-plugin-svelte': 'latest',
  globals: 'latest',
  prettier: 'latest',
  'typescript-eslint': 'latest',
};

// --- Script Logic ---
try {
  const packageJsonContent = fs.readFileSync(packageJsonPath, 'utf8');
  const packageJson = JSON.parse(packageJsonContent);

  packageJson.scripts = { ...packageJson.scripts, ...scriptsToAdd };
  packageJson.devDependencies = {
    ...packageJson.devDependencies,
    ...devDependenciesToAdd,
  };

  const updatedPackageJsonContent = JSON.stringify(packageJson, null, 2);
  fs.writeFileSync(packageJsonPath, updatedPackageJsonContent);

  console.log('Successfully updated package.json for Svelte with ESLint and Prettier!');
} catch (error) {
  console.error('Error updating package.json:', error);
  process.exit(1);
}
