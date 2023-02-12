import 'package:ngos/src/scoped-model/user_scoped_model.dart';
import 'package:ngos/src/scoped-model/user_scoped_model.dart';

import 'ngo_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with NGOModel, UserModel {
  void fetchAll() {
    donate();
    fetchUserInfos();
  }

  void logout() {}
  
  @override
  void fetchUserInfos() {}
}
