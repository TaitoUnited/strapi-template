const { isIP } = require('net');
const { readSecret } = require('./utils.js');

module.exports = ({ env }) => {
  const host = env('DATABASE_HOST', '127.0.0.1');
  const sslEnabled = env.bool('DATABASE_SSL_ENABLED', false);

  return {
    connection: {
      client: 'postgres',
      connection: {
        host,
        port: env.int('DATABASE_PORT', 5432),
        database: env('DATABASE_NAME', 'strapi'),
        user: env('DATABASE_USER', 'strapi'),
        password: readSecret(env('DATABASE_PASSWORD_FILE'), null),
        schema: env('DATABASE_SCHEMA', 'public'),
        // Skip hostname check if SSL is enabled but HOST is IP or proxy
        ssl: sslEnabled && (isIP(host) || host.indexOf('.') === -1)
          ? {
              checkServerIdentity: () => undefined,
            }
          : sslEnabled,
      },
      options: {
        pool: {
          min: env.int('DATABASE_POOL_MIN'),
          max: env.int('DATABASE_POOL_MAX'),
        },
      },
      debug: false,
    },
  };
};
