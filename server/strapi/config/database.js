const { readSecret } = require('./utils.js');

module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', '127.0.0.1'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'strapi'),
      user: env('DATABASE_USER', 'strapi'),
      password: readSecret(env('DATABASE_PASSWORD_FILE'), null),
      schema: env('DATABASE_SCHEMA', 'public'),
      ssl: env.bool('DATABASE_SSL_ENABLED', false),
    },
    options: {
      pool: {
        min: env.int('DATABASE_POOL_MIN'),
        max: env.int('DATABASE_POOL_MAX'),
      },
    },
    debug: false,
  },
});
