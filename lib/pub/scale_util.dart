class ScaleUtil {
  ScaleUtil._();
  static ScaleUtil? _instance;

  static ScaleUtil getInstance() {
    _instance ??= ScaleUtil._();
    return _instance!;
  }

  factory ScaleUtil() => getInstance();
  double scale = 1;
  double? fontScale;
}

extension ScaleUtilEx on num {
  double get s => ScaleUtil().scale * this;
  double get fs => (ScaleUtil().fontScale ?? ScaleUtil().scale) * this;
}
