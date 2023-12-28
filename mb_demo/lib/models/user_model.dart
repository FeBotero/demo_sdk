class UserModel {
  int userId;
  int channelId;
  bool isPlaying;

  UserModel(
      {required this.userId, required this.channelId, this.isPlaying = false});
}
