const { readSecret } = require('./utils.js');

module.exports = ({ env }) => ({
  host: env('API_BINDADDR', '0.0.0.0'),
  port: env.int('API_PORT', 8080),
  url: env('COMMON_URL'),
  app: {
    keys: readSecret(env('APP_KEYS_FILE'), 'iH0QvHQrzMRbFfKMZOcFdg== f468bMKsoS6M4QgWBbZtMA== t0gU70HcaZxJJcGpFhhTsw== RIwJ22xaE5Xwvk/Nbu0kdw==').split(' ')
  },
});
