class AuditActor {
  const AuditActor({
    required this.userId,
    required this.userName,
  });

  final int userId;
  final String userName;
}

class AuditContext {
  AuditContext._();

  static AuditActor? currentActor;

  static void setActor({
    required int userId,
    required String userName,
  }) {
    currentActor = AuditActor(userId: userId, userName: userName);
  }

  static void clear() {
    currentActor = null;
  }
}
