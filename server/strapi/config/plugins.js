const { readSecret } = require('./utils.js');

module.exports = ({ env }) => ({
  'users-permissions': {
    config: {
      jwtSecret: readSecret(env('JWT_SECRET_FILE'), null),
      jwt: {
        expiresIn: '7d',
      },
    }
  },
  upload: {
    config: {
      provider: 'aws-s3',
      providerOptions: {
        accessKeyId: readSecret(env('BUCKET_KEY_ID_FILE'), null),
        secretAccessKey: readSecret(env('BUCKET_KEY_SECRET_FILE'), null),
        region: env('BUCKET_REGION'),
        endpoint: env('BUCKET_ENDPOINT'), 
        params: {
          Bucket: env('BUCKET_BUCKET'),
        },
      },
      actionOptions: {
        upload: {},
        uploadStream: {},
        delete: {},
      },
    },
  },
});
