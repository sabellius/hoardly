module.exports = {
  preset: "jest-expo",
  // pnpm variant: the `.pnpm` segment is required — the npm/yarn pattern
  // silently breaks under pnpm. If tests fail with "SyntaxError: Cannot use
  // import statement" after adding a dependency, add it to this allowlist.
  transformIgnorePatterns: [
    "node_modules/(?!(.pnpm|(jest-)?react-native|@react-native(-community)?|expo(nent)?|@expo(nent)?/.*|react-navigation|@react-navigation/.*))",
  ],
  collectCoverageFrom: ["src/**/*.{ts,tsx}", "!src/types/**", "!**/*.d.ts"],
  moduleNameMapper: {
    "\\.css$": "<rootDir>/src/types/css-stub.js",
  },
};
