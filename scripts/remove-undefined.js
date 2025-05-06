const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

// Directory paths
const directories = {
  'bisheng': path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Marriott/pacsys/mar-bi-sheng/pacsys-components/src/static/languages'),
  'pacsys-theme': path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/pacsys-theme/languages'),
  'pacsys-legacy': path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang'),
  'pacsys-temp': path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang'),
  'pacsys-plugin': [
    path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang'),
    path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang'),
  ],
  'pacsys-wp': [
    path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang'),
    path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang'),
    path.resolve(__dirname, '/Users/skennon/Sites/_GIT/Pacsys/mar-pacsys-wordpress/pacsys-theme/languages'),
  ],
};

// Function to recursively find `.po` files and remove `msgid "undefined"` blocks
function updatePoFiles(directory) {
  fs.readdir(directory, { withFileTypes: true }, (err, entries) => {
    if (err) {
      console.error(`Error reading directory: ${directory}`, err);
      return;
    }

    entries.forEach(entry => {
      const entryPath = path.join(directory, entry.name);

      if (entry.isDirectory()) {
        // Recursively process subdirectories
        updatePoFiles(entryPath);
      } else if (entry.isFile() && entry.name.endsWith('.po')) {
        // Read the `.po` file content
        let poContent = fs.readFileSync(entryPath, 'utf8');

        // Regex to match and remove groups where msgid is "undefined"
        const undefinedGroupRegex = /\n*msgid\s+"undefined"\nmsgstr\s+".*?"(\n\n|\n?$)/g;
        const updatedContent = poContent.replace(undefinedGroupRegex, '');

        // Write the updated content back to the file
        fs.writeFileSync(entryPath, updatedContent, 'utf8');
        console.log(`Removed undefined blocks from: ${entryPath}`);
      }
    });
  });
}

// Function to run `mopo-remote.sh` for Bi-Sheng and `.mo` generation for others
function runMopo(target, targetDirectories) {
  targetDirectories.forEach((dir) => {
    console.log(`Running mopo in: ${dir}`);
    const script = target === 'bisheng'
      ? path.resolve(__dirname, './mopo-remote.sh')
      : path.resolve(__dirname, './mopo.sh');
    exec(`sh ${script} ${dir}`, (err, stdout, stderr) => {
      if (err) {
        console.error(`Error running mopo in ${dir}:`, err);
      } else {
        console.log(`mopo output for ${dir}:\n${stdout}`);
      }
    });
  });
}

// Get the target directory and optional flags
const target = process.argv[2];
const flags = process.argv.slice(3); // e.g., ['mopo']

if (!target || !directories[target]) {
  console.error('Error: Please specify a valid target directory (e.g., bisheng, pacsys-theme, pacsys-plugin, pacsys-wp).');
  process.exit(1);
}

// Determine whether to run `mopo`
const runMopoFlag = flags.includes('mopo');

// Run the script
const targetDirectories = Array.isArray(directories[target]) ? directories[target] : [directories[target]];
targetDirectories.forEach(dir => updatePoFiles(dir));

console.log('\nAll updates are complete.');

if (runMopoFlag) {
  runMopo(target, targetDirectories);
}
