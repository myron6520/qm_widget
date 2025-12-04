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

  double Function(num) getFsFunc =
      (val) => (ScaleUtil().fontScale ?? ScaleUtil().scale) * val;
}

extension ScaleUtilEx on num {
  double get s => ScaleUtil().scale * this;
  double get fs => ScaleUtil().getFsFunc(this);
}
