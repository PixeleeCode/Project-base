module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true
  },
  extends: ["airbnb-base", "plugin:storybook/recommended", "plugin:storybook/recommended"],
  overrides: [],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module"
  },
  rules: {
    semi: ["error", "always"],
    quotes: ["error", "double"]
  }
};