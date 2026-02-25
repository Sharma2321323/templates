{ pkgs, adk_agent_name ? "", region ? "us-central1", ... }: {
  channel = "stable-25.05";
  packages = [ pkgs.nodejs_20 ];
  # Shell script that produces the final environment
  bootstrap = ''
   # Copy the folder containing the `idx-template` files to the final
   # project folder for the new workspace. ${./.} inserts the directory
   # of the checked-out Git folder containing this template.
   cp -rf ${./.} "$out"

   # Set some permissions
   chmod -R +w "$out"

   # Create .env file with the parameter values
   cat > "$out/.env" << EOF
   AGENT_NAME=${adk_agent_name}
   REGION=${region}
   WS_NAME=$WS_NAME
   EOF

   # cd into the output directory to run npm commands
   cd "$out"

   # Create package.json directly
   cat > "$out/package.json" << EOF
   {
     "name": "agent-garden-project",
     "version": "1.0.0",
     "description": "A new agent project",
     "main": "index.js",
     "scripts": {
       "start": "node index.js",
       "dev": "nodemon index.js",
       "lint": "eslint .",
       "eslint": "eslint .",
       "format": "prettier --write ."
     },
     "keywords": [],
     "author": "",
     "license": "ISC",
     "devDependencies": {
       "eslint": "^8.57.0",
       "prettier": "^3.2.5",
       "eslint-config-prettier": "^9.1.0",
       "nodemon": "^3.1.0"
     }
   }
   EOF

   # Create a simple index.js file
   cat > "$out/index.js" << EOF
   console.log("Welcome to your new agent project! The `dev` script is running.");
   EOF

   # Create .eslintrc.json
   cat > "$out/.eslintrc.json" << EOF
   {
     "root": true,
     "extends": [
       "eslint:recommended",
       "prettier"
     ],
     "rules": {
       "no-unused-vars": "off"
     },
     "parserOptions": {
       "ecmaVersion": "latest",
       "sourceType": "module"
     },
     "env": {
       "browser": true,
       "es6": true,
       "node": true
     }
   }
   EOF

   # Create .prettierrc.json
   cat > "$out/.prettierrc.json" << EOF
   {
     "semi": true,
     "singleQuote": true,
     "trailingComma": "es5"
   }
   EOF

   # Install all dependencies from the new package.json
   npm install

   # cd back to the original directory
   cd -

   # Remove the template files themselves and any connection to the template's
   # Git repository
   rm -rf "$out/.git" "$out/idx-template".{nix,json}
 ''';
}
