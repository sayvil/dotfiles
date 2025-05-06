const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
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

// Function to recursively find `.po` files and update them
function updatePoFiles(directory, translations) {
  fs.readdir(directory, { withFileTypes: true }, (err, entries) => {
    if (err) {
      console.error(`Error reading directory: ${directory}`, err);
      return;
    }

    entries.forEach(entry => {
      const entryPath = path.join(directory, entry.name);

      if (entry.isDirectory()) {
        // Recursively process subdirectories
        updatePoFiles(entryPath, translations);
      } else if (entry.isFile() && entry.name.endsWith('.po')) {
        // Extract the language code from the file name
        const langCode = entry.name.match(/(?:-|^)(\w{2}_\w{2})\.po$/)?.[1];

        if (!langCode) {
          console.warn(`Could not determine language code for file: ${entry.name}`);
          return;
        }

        // Read the `.po` file content
        const poContent = fs.readFileSync(entryPath, 'utf8');

        translations.forEach(({ msgid, translations }) => {
          // Check if the `msgid` exists
          const msgidRegex = new RegExp(`msgid\\n"${msgid}"\\nmsgstr\\n"(.*?)"`, 'g');
          const match = msgidRegex.exec(poContent);

          if (match) {
            // If `msgstr` is empty, update it
            if (match[1] === '') {
              const updatedContent = poContent.replace(
                msgidRegex,
                `msgid\n"${msgid}"\nmsgstr\n"${translations[langCode] || ''}"`
              );
              fs.writeFileSync(entryPath, updatedContent, 'utf8');
              console.log(`Updated empty msgstr in: ${entryPath}`);
            }
          } else {
            // If `msgid` does not exist, append it
            const newTranslation = `\n\nmsgid\n"${msgid}"\nmsgstr\n"${translations[langCode] || ''}"\n`;
            fs.appendFileSync(entryPath, newTranslation, 'utf8');
            console.log(`Added new msgid to: ${entryPath}`);
          }
        });
      }
    });
  });
}

// Function to load translations from a CSV file
function loadTranslationsFromCSV(filePath, callback) {
  const translations = [];
  fs.createReadStream(filePath)
    .pipe(csv())
    .on('data', row => {
      const msgid = row.msgid;
      const translationData = { msgid, translations: {} };

      Object.keys(row).forEach(key => {
        if (key !== 'msgid') {
          translationData.translations[key] = row[key];
        }
      });

      translations.push(translationData);
    })
    .on('end', () => {
      callback(translations);
    })
    .on('error', err => {
      console.error(`Error reading CSV file: ${filePath}`, err);
      process.exit(1);
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
const flags = process.argv.slice(3); // e.g., ['json', 'mopo']

if (!target || !directories[target]) {
  console.error('Error: Please specify a valid target directory (e.g., bisheng, pacsys-theme, pacsys-plugin, pacsys-wp).');
  process.exit(1);
}

// Determine input type and whether to run `mopo`
const inputType = flags.includes('json') ? 'json' : 'csv';
const runMopoFlag = flags.includes('mopo');

// Load translations and run the script
const filePath = inputType === 'json' ? 'update-po-from-this.json' : 'update-po-from-this.csv';

if (inputType === 'csv') {
  loadTranslationsFromCSV(filePath, (translations) => {
    const targetDirectories = Array.isArray(directories[target]) ? directories[target] : [directories[target]];
    targetDirectories.forEach(dir => updatePoFiles(dir, translations));
    console.log('\nAll updates are complete.');
    if (runMopoFlag) {
      runMopo(target, targetDirectories);
    }
  });
} else if (inputType === 'json') {
  const translations = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const targetDirectories = Array.isArray(directories[target]) ? directories[target] : [directories[target]];
  targetDirectories.forEach(dir => updatePoFiles(dir, translations));
  console.log('\nAll updates are complete.');
  if (runMopoFlag) {
    runMopo(target, targetDirectories);
  }
}
