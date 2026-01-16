/**
 * PM2 configuration for OtakluDesu.
 *
 * Start:
 *   pm2 start ecosystem.config.cjs
 */
module.exports = {
  apps: [
    {
      name: "OtakluDesu",
      script: "dist/index.js",
      env: {
        NODE_ENV: "production",
        PORT: 7501,
        SOURCE_URL: "true",
      },
    },
  ],
};
