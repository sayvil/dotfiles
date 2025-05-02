# Translation Update Scripts

This repository contains scripts to manage and update translation files for various directories and file formats. The scripts support `.po` and `.json` files and handle multiple naming conventions.

## Supported Projects

While this can be used with any project, the script is configured to support the following projects by default:

- Pacsys Components
- Marriott WordPress Sites (v2.1)


## Features

- Automatically updates `.po` files with translations from a `.csv` or `.json` input file
- Supports multiple file naming conventions:
    - `name-es_ES.po`
    - `es_ES.po`
- Supports optional flags for additional functionality (`json`, `mopo`)
- Generates `.mo` and/or `.json` files based on directories
- Handles recursive directory structures.

## Prerequisites

- Node.js installed on your system.
- Required dependencies installed via `npm install`.

## Generate .mo and .json Files for Use in i18n Scripting

The `mopo.sh` script is used to generate `.mo` files from `.po` files. It will process all `.po` files in the specified directory and its subdirectories.

**Generate `.mo` files in the current directory:**

```bash
sh mopo.sh
```

**Generate `.mo` files in a specific directory:**

```bash
sh mopo.sh /path/to/language/directory
```

If you also need to generate `.json` files from `.po` files, use `mopo-remote.sh` instead of `mopo.sh`

```bash
sh mopo-remote.sh
```

## Usage

### Update Translations

Before running the script, make sure your source `.csv` or `.json` file is up-to-date with the latest translations. By default, the script uses the `update-po-from-this.csv` or `update-po-from-this.json` file.

Here's how it works:
- If a `msgid` already exists and its `msgstr` is empty, the script will fill in the translation.
- If a `msgid` doesn't exist, the new `msgid` and translation will be added.

### Processing Updates

Run the following commands to update translations for specific directories:

- **Bi-Sheng**:

    `/Marriott/pacsys/mar-bi-sheng/pacsys-components/src/static/languages`

    ```bash
    npm run update-bisheng
    ```

- **Pacsys Theme**:

    `/Pacsys/mar-pacsys-wordpress/pacsys-theme/languages`

    ```bash
    npm run update-pacsys-theme
    ```

- **Pacsys Plugin**:

    `/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang` <br>
    `/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang`

    ```bash
    npm run update-pacsys-plugin
    ```

- **Pacsys WP**:

    `/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template-legacy/templates/lang` <br>
    `/Pacsys/mar-pacsys-wordpress/config/mule/gutenberg-template/templates/lang` <br>
    `/Pacsys/mar-pacsys-wordpress/pacsys-theme/languages`

    ```bash
    npm run update-pacsys-wp
    ```

### Optional Flags

You can add optional flags to customize the behavior of the scripts:

> **Note**: The examples provided use the `bisheng` command for demonstration purposes. These commands will work with all the scripts listed above, such as `update-pacsys-theme`, `update-pacsys-plugin`, and `update-pacsys-wp`.

- **`json`**:
  Processes `.json` input files

    ```bash
    npm run update-bisheng json
    ```

- **`mopo`**:

    The `mopo.sh` or `mopo-remote.sh` scripts are used to generate `.mo` and/or `.json` files. The `update-po-files.js` script is set up to use the right one.

    ```bash
    npm run update-bisheng mopo
    ```

- **`json` and `mopo` Together**:
  Updates `.po` files, generates `.mo` files, and processes `.json` input files.
    ```bash
    npm run update-bisheng json mopo
    ```

#### Example:

```bash
npm run update-pacsys-theme mopo
```

This command:

1. Updates `.po` files in the `pacsys-theme` directory.
2. Generates `.mo` files for the updated `.po` files.

### Input File Formats
- **CSV** (default):
  Ensure the update-po-from-this.csv file contains translations in the following format:

    ```csv
    msgid,es_ES,fr_FR,de_DE
    "Select language","Seleccionar idioma","Choisir la langue","Sprache auswählen"
    ```

- **JSON**:
  Use the `json` flag to specify a JSON input file:

    ```bash
    npm run update-bisheng json
    ```

    Example JSON format:

    ```json
    [
        {
            "msgid": "Select language",
            "translations": {
                "es_ES": "Seleccionar idioma",
                "fr_FR": "Choisir la langue",
                "de_DE": "Sprache auswählen"
            }
        }
    ]
    ```


- **Custom Input File**:
    You can specify a different `.csv` or `.json` file by providing its path as an argument to the command:

        ```bash
        npm run update-bisheng -- /path/to/custom-file.csv
        ```

        For JSON files:

        ```bash
        npm run update-bisheng json -- /path/to/custom-file.json
        ```

    Ensure the file follows the correct format as described above.

## Troubleshooting

- **Missing Translations**:
  If `msgstr` values are blank, ensure the `msgid` exists in the input file with the correct language code.

- **Language Code Extraction**:
  The script supports file names like `name-es_ES.po` and `es_ES.po`. Ensure your files follow these conventions.

- **Custom Directory Errors**:
  Use the `--custom-dir` flag to specify a directory and verify its structure.

