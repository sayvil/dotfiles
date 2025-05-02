const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
const readline = require('readline');

// Directory paths
const directories = {
  'bisheng': path.resolve(__dirname, '../../Marriott/pacsys/mar-bi-sheng/pacsys-components/src/static/languages'),
  'pacsys-theme': path.resolve(__dirname, '../../Pacsys/mar-pacsys-wordpress/pacsys-theme/languages'),
  'pacsys-plugin': [
    path.resolve(__dirname, '../../Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang'),
    path.resolve(__dirname, '../../Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang'),
  ],
  'pacsys-wp': [
    path.resolve(__dirname, '../../Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang'),
    path.resolve(__dirname, '../../Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang'),
    path.resolve(__dirname, '../../Pacsys/mar-pacsys-wordpress/pacsys-theme/languages'),
  ],
};

// Function to recursively find `.po` files and update them
function updatePoFiles(directory, translations) {
  fs.readdir(directory, { withFileTypes: true }, (err, entries) => {
    if (err) {
      console.error('Error reading directory:', err);
      return;
    }

    entries.forEach(entry => {
      const entryPath = path.join(directory, entry.name);

      if (entry.isDirectory()) {
        // Recursively process subdirectories
        updatePoFiles(entryPath, translations);
      } else if (entry.isFile() && entry.name.endsWith('.po')) {
        const langCode = path.basename(entry.name, '.po');

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
    });
}

// Get the target directory and CSV file from the command-line arguments
const target = process.argv[2];
const csvFilePath = process.argv[3];

if (!target || !directories[target]) {
  console.error('Error: Please specify a valid target directory (e.g., bisheng, pacsys-theme, pacsys-plugin, pacsys-wp).');
  process.exit(1);
}

if (!csvFilePath) {
  console.error('Error: Please specify the path to the CSV file.');
  process.exit(1);
}

// Load translations and run the script
loadTranslationsFromCSV(csvFilePath, translations => {
  const targetDirectories = Array.isArray(directories[target]) ? directories[target] : [directories[target]];
  targetDirectories.forEach(dir => updatePoFiles(dir, translations));

  // Ensure the reminder is displayed last
  console.log('\nAll updates are complete.');
  console.log('Reminder: Run `runmopo` to generate the .mo and .json versions of the updated .po files.');
});
