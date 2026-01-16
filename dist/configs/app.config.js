const DEFAULT_PORT = 7501;

const appConfig = {
    /**
     * server port
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
    sourceUrl: process.env.SOURCE_URL
        ? String(process.env.SOURCE_URL).toLowerCase() === "true"
        : true,
};
export default appConfig;
