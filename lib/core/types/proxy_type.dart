enum ProxyType {
  none,
  forwardProxy,
  proxy;

  String get lable {
    return switch (this) {
      none => 'None',
      forwardProxy => 'Forward Proxy',
      proxy => 'Proxy',
    };
  }

  static ProxyType fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .none);
  }
}
