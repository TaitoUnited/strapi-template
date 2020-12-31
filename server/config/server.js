var fs = require("fs");

module.exports = ({ env }) => ({
  host: env("API_BINDADDR", "0.0.0.0"),
  port: env.int("API_PORT", 8080),
  admin: {
    auth: {
      secret:
        (process.env.ADMIN_JWT_SECRET_FILE &&
          fs.readFileSync(process.env.ADMIN_JWT_SECRET_FILE, "utf8")) ||
        "XKPhFnmabMRTF7iXfEjANa4TdeA9Vyuj9jn7UXXn", // Used during build only
    },
  },
});
