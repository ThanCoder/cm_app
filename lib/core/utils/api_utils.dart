class ApiUtils {
  static String getProxyUrl(String url) {
    return 'https://express-forward-proxy.vercel.app?url=$url';
  }
}
