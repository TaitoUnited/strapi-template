var fs = require('fs');

module.exports = ({ env }) => ({
  defaultConnection: 'default',
  connections: {
    default: {
      connector: 'bookshelf',
      settings: {
        client: 'postgres',
        host: env('DATABASE_HOST'),
        port: env.int('DATABASE_PORT', 5432),
        database: env('DATABASE_NAME'),
        username: env('DATABASE_USER'),
        password: process.env.DATABASE_PASSWORD_FILE &&
          fs.readFileSync(process.env.DATABASE_PASSWORD_FILE, 'utf8'),
        ssl: env.bool('DATABASE_SSL_ENABLED', false),
      },
      options: {
        pool: {
          min: parseInt(process.env.DATABASE_POOL_MIN),
          max: parseInt(process.env.DATABASE_POOL_MAX),
        },
      },
    },
  },
});
