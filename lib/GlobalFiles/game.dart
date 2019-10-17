class Game {
  final String name;
  final Duration timeWhite;
  final Duration timeBlack;
  final Duration incrementWhite;
  final Duration incrementBlack;

  const Game(
      {this.name,
      this.timeWhite,
      this.timeBlack,
      this.incrementWhite,
      this.incrementBlack});
}
