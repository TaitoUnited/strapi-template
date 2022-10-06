const fs = require('fs');

const readSecret = (filepath, defaultValue) => {
  const value = filepath && fs.readFileSync(filepath, "utf8");
  if (!value && process.env.NODE_ENV !== 'development') {
    throw new Error(`Secret not found ${filepath}`);
  }
  return value ?? defaultValue;
};

module.exports = {
  readSecret,
};
