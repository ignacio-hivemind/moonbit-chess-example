fn main {
  try {
    let boardState = @lib.BoardState::initialSetup!();
    println("The initial board is:");
    println(boardState.draw());
  } catch {
    _ => println("Could not initialize board")
  }
}
