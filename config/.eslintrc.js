module.exports = {
  root: true,
  ignorePatterns: [
    '**/js/dev/*.js',
    '**/js/prod/*.js',
    '**/node_modules/*.js',
    '**/gulp/**/*.js',
    '**/gulp/*.js',
    'gulpfile.js',
  ],
  parser: '@babel/eslint-parser',
  parserOptions: {
    requireConfigFile: false,
  },
  extends: ['eslint:recommended'],
  rules: {
    indent: ['error', 2],
    'no-console': 'warn',
  },
  env: {
    browser: true,
    jquery: true,
    es6: true,
  },
};
