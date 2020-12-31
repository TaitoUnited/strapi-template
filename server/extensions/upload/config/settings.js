var fs = require('fs');

module.exports = {
  provider: "google-cloud-storage",
  providerOptions: {
    serviceAccount: process.env.BUCKET_KEY_FILE &&
      fs.readFileSync(process.env.BUCKET_KEY_FILE, 'utf8'),
    bucketName: process.env.BUCKET_NAME,
    baseUrl: process.env.BUCKET_BASE_URL,
    basePath: process.env.BUCKET_BASE_PATH,
    publicFiles: process.env.BUCKET_PUBLIC_FILES
  }
};
