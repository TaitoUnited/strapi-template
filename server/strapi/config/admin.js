const { readSecret } = require('./utils.js');

module.exports = ({ env }) => ({
  auth: {
    secret: readSecret(env('ADMIN_JWT_SECRET_FILE'), 'ScRnY902SGp8reAVUWEPfg=='),
  },
  apiToken: {
    salt: readSecret(env('API_TOKEN_SALT_FILE'), 'IyZf5mXSqS8Oq0g2idWvkw=='),
  },
});
