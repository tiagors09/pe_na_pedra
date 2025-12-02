enum UserRoles {
  adm,
  hikker,
  banned,
}

enum SwipeAction {
  ban,
  unban,
  makeAdmin,
  removeAdmin,
  none,
}

enum Difficulty {
  easy('FÁCIL'),
  moderate('MODERADO'),
  hard('DIFICIL');

  final String label;

  const Difficulty(this.label);
}

enum EditProfileMode {
  completeProfile,
  editProfile,
}
