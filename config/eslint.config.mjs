import js from '@eslint/js';
import babelParser from '@babel/eslint-parser';
import globals from 'globals';

export default [
  {
    ignores: [
      '**/js/dev/*.js',
      '**/js/prod/*.js',
      '**/node_modules/*.js',
      '**/gulp/**/*.js',
      '**/gulp/*.js',
      'gulpfile.js',
    ],
  },
  {
    files: ['**/*.js'],
    languageOptions: {
      parser: babelParser,
      parserOptions: {
        requireConfigFile: false,
        babelOptions: {
          presets: ['@babel/preset-env', '@babel/preset-react'], // Ensure these presets are installed
        },
        ecmaVersion: 'latest', // Use the latest ECMAScript version
        sourceType: 'module', // Assuming your code uses ES modules
      },
      globals: {
        ...globals.browser, // Automatically include browser globals
        ...globals.es2021, // Automatically include ES2021 globals
      },
    },
    plugins: {
      '@eslint/js': js,
    },
    rules: {
      ...js.configs.recommended.rules,
      indent: ['error', 2], // Enforce 2-space indentation
      'no-console': 'warn', // Warn on console.log usage
      'no-unused-vars': ['error', { 'argsIgnorePattern': '^_' }],
    },
  },
];
