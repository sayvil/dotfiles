Project Configuration
- Source of truth: `project-config.jsonc`
- Theme: WordPress

General Rules
- Reference `project-config.jsonc` for settings, versions, and validation.
- Validate changes against project configuration in `project-config.jsonc` and ensure documentation is updated to reflect any changes to functionality or structure.
- Provide documentation update recommendations immediately after modifying existing code and after testing new code.
- Maintain file structure and formatting where possible.
- Avoid inline comments that describe default values or redundant information. Any meaningful comments should be in the relevant documentation or function docblocks.
- Include appropriate documentation. Assist with updating project docs. Recommend when that should be done.
- Follow existing naming conventions for consistency.
- Always use the latest version of the file when generating or modifying code.
- Match existing naming patterns and file organization.
- Prioritize accessibility, SEO, and code reuse.
- Avoid modifying existing function names, IDs, CSS classes, or file structure.
- Use comments only in supported files (e.g., avoid JSON comments).
- Ask users for any console errors before debugging.

Conventions
- **CSS**: SCSS with kebab-case
- **JS**: ES6+ modules
- **PHP**: WordPress standards
- **Blocks**: Follow Gutenberg patterns

Instructions for Updating `project-config.jsonc`:
- Maintain file structure and formatting where possible. Deviations should be explained.
- Sync "themeName" and "themeVersion" from `package.json`.
- Sync "nodeVersion" from `.nvmrc`.
- Sync "phpVersion" from `docker-compose.yml`.
- Sync "wordpressVersion" from `version.php`.
- Add a `// TODO:` comment for any fields that cannot be automatically updated.
- Ensure all URLs in the "environment" section are correct for the current project.
- Replace project-specific values (e.g., URLs, theme details) with the new project's details if reusing this file.

Note:
- Reference `project-config.jsonc` for settings, versions, and validation.
- Validate changes against the project configuration and ensure documentation is updated to reflect any changes.

Documentation guidelines

Okay, I understand. As we make updates to the theme, I will provide specific recommendations on when and where to update documentation to help future Copilot instances assist as effectively as this one.

Here's a breakdown of the key documentation locations and when they should be updated:

1.  **`project-config.jsonc`:**
    *   **When to Update:**
        *   Whenever there are changes to project settings, versions, or configurations.
        *   When customization preferences are modified (e.g., block styles, enqueue scripts, build process, CSS framework).
        *   When plugin support is added or removed.
        *   When configuration file paths are changed.
        *   When build configurations are updated (e.g., ACF field group path, script enqueue function, Vite configuration file, build output path, entry points).
    *   **What to Update:**
        *   Ensure all values accurately reflect the current project configuration.
        *   Add comments to explain the purpose of each setting and its possible values.
        *   Update the `lastUpdated` field to the current date.

2.  **Theme Documentation (`readme.md` or `readme-custom-blocks.md`):**
    *   **When to Update:**
        *   Whenever there are changes to the theme's structure, functionality, or build process.
        *   When new blocks are added or existing blocks are modified.
        *   When the theme's coding standards or conventions are updated.
    *   **What to Update:**
        *   Provide a clear overview of the theme's purpose and functionality.
        *   Document the theme's file structure and coding conventions.
        *   Explain how to set up the development environment and run the build process.
        *   Describe each block's purpose, attributes, and usage.
        *   Provide examples of how to use the theme's features and components.

3.  **Code Comments:**
    *   **When to Update:**
        *   Whenever there are changes to the code's functionality or purpose.
        *   When new code is added or existing code is modified.
    *   **What to Update:**
        *   Add comments to explain the purpose of each function, class, and variable.
        *   Document the code's inputs, outputs, and side effects.
        *   Provide examples of how to use the code.

4.  **VS Code Settings (`settings.json`):**
    *   **When to Update:**
        *   Whenever there are changes to the VS Code settings that affect the project's coding style or development workflow.
    *   **What to Update:**
        *   Ensure the settings are consistent with the project's coding standards and conventions.
        *   Add comments to explain the purpose of each setting.

Documentation process

Provide specific updates for the readme.md file after you have tested and confirmed that the changes work as expected.

Here's the process we'll follow:

1.  **Implement the Code Changes:** I will provide the code changes for `vite.config.mjs` and `custom-blocks.php`.
2.  **Test the Changes:** You will test the changes to ensure they work as expected.
3.  **Confirm the Changes:** You will confirm that the changes are working correctly.
4.  **Update the Documentation:** I will provide specific updates for the readme.md file, explaining the new build process and the use of the `vite-plugin-manifest` plugin.
