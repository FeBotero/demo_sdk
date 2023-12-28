import 'package:mb_demo/models/user_model.dart';

class UserInfoProvider {
  static int _idSelected = 0;
  static int _channelSelected = 1;
  static final List<UserModel> _userList = <UserModel>[];
  static final UserInfoProvider _singleton = UserInfoProvider.instance();

  factory UserInfoProvider() => _singleton;

  UserInfoProvider.instance();

  int get idSelected => _idSelected;
  int get channelSelected => _channelSelected;

  void setIdSelected(int id) {
    _idSelected = id;
  }

  void setChannelSelected(int channel) {
    _channelSelected = channel;
  }

  int getUserId(int index) {
    return _userList[index].userId;
  }

  int getChannelId(int index) {
    return _userList[index].channelId;
  }

  bool userIsPlaying(int? userId) {
    if (userId == null) return false;

    return findUser(userId)?.isPlaying ?? false;
  }

  bool userIsPlayingWithIndex(int index) {
    if (index < 0 || index >= _userList.length) return false;

    return _userList[index].isPlaying;
  }

  void setUserPlaying(int userId, bool isPlaying) {
    findUser(userId)?.isPlaying = isPlaying;
  }

  List<UserModel> getUserList() {
    var seen = <UserModel>{};
    List<UserModel> uniqueList =
        _userList.where((element) => seen.add(element)).toList();
    return uniqueList;
  }

  int getUserWinIndex(int userId) {
    UserModel? user = findUser(userId);
    if (user == null) return -1;

    return _userList.indexOf(user) + 1;
  }

  void addUser(UserModel user) {
    if (_userList.length < 4 && findUser(user.userId) == null) {
      _userList.add(user);
    }
  }

  void removeUser(int userId) {
    _userList.remove(findUser(userId));
  }

  void removeUserAt(int index) {
    if (index >= 0 && index < _userList.length) {
      _userList.removeAt(index);
    }
  }

  UserModel? findUser(int userId) {
    for (UserModel user in _userList) {
      if (user.userId == userId) return user;
    }
    return null;
  }
}
