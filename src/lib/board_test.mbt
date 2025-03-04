test "initial state of board" {
  let state = BoardState::initialSetup!()

  println("The initial board state is:")
  println(state.draw())

  let row0Expected: Row = Row::new_row_from_string!("RNBQKBNR")
  if state.get_board_row(0) != row0Expected {
    checkRowFailure!("The row 0 is not correctly configured",
                     state.get_board_row(0),
                     row0Expected)
  }
  let whitePawnRow: Bool = checkPieceRow(@lib.Pawn, state.get_board_row(1), @lib.White)
  if not(whitePawnRow) {
    fail!("The white pawns are not correctly configured.")
  }
  let row7Expected = Row::new_row_from_string!("rnbqkbnr")
  if state.get_board_row(7) != row7Expected {
    checkRowFailure!("The row 7 is not correctly configured",
                     state.get_board_row(7),
                     row7Expected)
  }
  for row in 2..=5 {
    let expected: Row = Row::empty_row()
    let actual: Row = state.get_board_row(row)
    if actual != expected {
      checkRowFailure!("The row " + row.to_string() + " does not contain empty spaces.",
                       actual,
                       expected)
    }
  }
  let blackPawnRow: Bool = checkPieceRow(@lib.Pawn, state.get_board_row(6), @lib.Black)
  if not(blackPawnRow) {
    fail!("The black pawns are not correctly configured.")
  }
  println("The initial board state is correct.")
}

fn checkRowFailure(message: String, actual: Row, expected: Row) -> Unit!Failure {
  fail!("\n" + message + "\n" +
        "Actual: " + actual.to_string() +
        "\nExpected: " + expected.to_string()
  )
}

fn checkPieceRow(piece: Piece, row: Row, color: Color) -> Bool {
  let mut result: Bool = true
  for col in 0..=7 {
    if row[col] != Some((piece, color)) {
      result = false
      break
    }
  }
  result
}
