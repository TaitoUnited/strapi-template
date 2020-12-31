var fs = require("fs");

module.exports = {
  jwtSecret:
    (process.env.JWT_SECRET_FILE &&
      fs.readFileSync(process.env.JWT_SECRET_FILE, "utf8")) ||
    "KrfJHuxhL9gmdpHebWHTLfzji34RULpbuiPpCKmd", // Used during build only
};
