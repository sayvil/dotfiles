# Dotfiles

This repository contains various configuration files and scripts for development.

## Translation Update Scripts

For detailed documentation on the `update-po-files.py` script and related translation update tools, please refer to the [README-mopo.md](README-mopo.md) file.

## Other Scripts

### `update_changelog.py`
**Description:**
Updates the `CHANGELOG.md` file with new commits since the last release. It groups commits by date and increments the version number.

**Command to Run:**
```bash
python update_changelog.py
```

---

### `run_all.py`
**Description:**
Runs a predefined set of scripts in sequence. Useful for automating multiple tasks.

**Command to Run:**
```bash
python scripts/inage-cdn/run_all.py
```

---

### `create-html.py`
**Description:**
Converts a Markdown file (`README.md`) into an HTML file with a Table of Contents and custom styling.

**Command to Run:**
```bash
python scripts/inage-cdn/create-html.py
```

---

### `convert_from_md.py`
**Description:**
Parses a Markdown file and generates structured data in JSON or CSV format. Supports filtering and tagging.

**Commands to Run:**
- Generate both JSON and CSV:
  ```bash
  python scripts/inage-cdn/convert_from_md.py all
  ```
- Generate only JSON:
  ```bash
  python scripts/inage-cdn/convert_from_md.py json
  ```
- Generate only CSV:
  ```bash
  python scripts/inage-cdn/convert_from_md.py csv
  ```

---

### `mopo.sh`
**Description:**
Generates `.mo` files from `.po` files in a specified directory.

**Commands to Run:**
- Process `.po` files in the current directory:
  ```bash
  sh scripts/mopo.sh
  ```
- Process `.po` files in a specific directory:
  ```bash
  sh scripts/mopo.sh /path/to/language/directory
  ```

---

### `mopo-remote.sh`
**Description:**
Generates `.mo` and `.json` files from `.po` files in a specified directory. Formats the `.json` files for consistency.

**Commands to Run:**
- Process `.po` files in the current directory:
  ```bash
  sh scripts/mopo-remote.sh
  ```
- Process `.po` files in a specific directory:
  ```bash
  sh scripts/mopo-remote.sh /path/to/language/directory
  ```

---

### `update-po-files.js`
**Description:**
Updates `.po` files with translations from a `.csv` or `.json` input file. Supports recursive directory structures and multiple naming conventions.

**Commands to Run:**
- Update translations for a specific target (e.g., `bisheng`):
  ```bash
  node scripts/update-po-files.js bisheng
  ```
- Use a JSON input file:
  ```bash
  node scripts/update-po-files.js bisheng json
  ```
- Update translations and generate `.mo` files:
  ```bash
  node scripts/update-po-files.js bisheng mopo
  ```

---

### `update-po-files-csv.js`
**Description:**
Similar to `update-po-files.js`, but specifically processes `.csv` input files for updating `.po` files.

**Command to Run:**
```bash
node update-po-files-csv.js <target> <path/to/csv-file>
```

---

### `update-po-from-this.json` and `update-po-from-this.csv`
**Description:**
These files contain translation data used by the `update-po-files.js` and `update-po-files-csv.js
