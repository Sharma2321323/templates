
# No user-configurable parameters
# Accept additional arguments to this template corresponding to template
# parameter IDs
{ pkgs, adk_agent_name ? "", region ? "us-central1", ... }: {
  channel = "stable-25.05";
  packages = [ pkgs.nodejs_20 ];
  # Shell script that produces the final environment
  bootstrap = ''
   # Copy the folder containing the \`idx-template\` files to the final
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

   # Initialize a node project
   npm init -y

   # Install eslint, prettier, and nodemon
   npm install eslint@^8.57.0 prettier eslint-config-prettier nodemon --save-dev

   # Create a simple index.js file
   echo 'console.log("Welcome to your new agent project! The \\`dev\\` script is running.");' > index.js

   # Create .eslintrc.json
   echo '{\n     "root": true,\n     "extends": [\n       "eslint:recommended",\n       "prettier"\n     ],\n     "rules": {\n       "no-unused-vars": "off"\n     },\n     "parserOptions": {\n       "ecmaVersion": "latest",\n       "sourceType": "module"\n     },\n     "env": {\n       "browser": true,\n       "es6": true,\n       "node": true\n     }\n   }' > .eslintrc.json

   # Create .prettierrc.json
   echo '{\n     "semi": true,\n     "singleQuote": true,\n     "trailingComma": "es5"\n   }' > .prettierrc.json

   # Add scripts to package.json
   node -e '
     const fs = require("fs");
     const pkg = JSON.parse(fs.readFileSync("package.json", "utf-8"));
     pkg.main = "index.js";
     pkg.scripts = {
       "start": "node index.js",
       "dev": "nodemon index.js",
       "lint": "eslint .",
       "eslint": "eslint .",
       "format": "prettier --write ."
     };
     fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2));
   '
   # cd back to the original directory
   cd -

   # Remove the template files themselves and any connection to the template's
   # Git repository
   rm -rf "$out/.git" "$out/idx-template".{nix,json}
 '';
}
