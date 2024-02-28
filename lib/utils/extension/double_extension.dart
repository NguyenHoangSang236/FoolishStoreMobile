import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/cupertino.dart';

extension SpaceWidget on double {
  Widget get horizontalSpace => SizedBox(width: width);
  Widget get verticalSpace => SizedBox(height: height);
}
