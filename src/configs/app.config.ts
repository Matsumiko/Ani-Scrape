const DEFAULT_PORT = 7501;

const appConfig: IAppConfig = {
  /**
   * server port (can be overridden via env: PORT)
   */
  PORT: Number(process.env.PORT ?? DEFAULT_PORT),

  /**
   * ngilangin properti sourceUrl di response
   *
   * jika true:
   *  {
   *    {...props}
   *    sourceUrl: "..."
   *  }
   *
   * jika false:
   *  {
   *    {...props}
   *  }
   */
  // can be overridden via env: SOURCE_URL ("true" | "false")
  sourceUrl: process.env.SOURCE_URL
    ? String(process.env.SOURCE_URL).toLowerCase() === "true"
    : true,
};

export default appConfig;
