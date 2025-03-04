// This is a guided tour for the moonbit language.
//
// This application is about a chess board, and how to represent it in moonbit language.
//
// Board is a double dimension array of BoardPlace
// cols:  0 1 2 3 4 5 6 7
// row 0: R N B Q K B N R
// row 1: P P P P P P P P
// row 2: . . . . . . . .
// row 3: . . . . . . . .
// row 4: . . . . . . . .
// row 5: . . . . . . . .
// row 6: p p p p p p p p
// row 7: r n b q k b n r
//
// The upper case letters represent the white pieces,
// whereas the lower case letters represent the black pieces.
// The pieces are: Pawn (P or p), Rook (R or r), Knight (N or n),
// Bishop (B or b), Queen (Q or q), King (K or k).
// The dots represent empty places.

// =================================================================================================
// 1: Enum types:
// =================================================================================================
/// This is documentation for the Color enum data type.
/// This is the color of the pieces in a chess game.
pub enum Color {
    White
    Black
} derive(Show, Eq) // 2: This is how you derive a trait (automatically) for a type.

/// This is documentation for the Piece enum.
/// It represents the different pieces in a chess game.
pub enum Piece {
    Pawn
    Rook
    Knight
    Bishop
    Queen
    King
} derive(Show, Eq)

// =================================================================================================
// 3: Type aliases: defining a new name for an existing type.
// =================================================================================================
/// This is the representation of a place on a chess board.
/// It can be empty (None) or contain a piece with a color: Some((Piece, Color)).
pub typealias BoardPlace = Option[(Piece, Color)]

// =================================================================================================
// 4: Pattern matching
// =================================================================================================
pub fn new_place_from_char(pieceChar: Char) -> BoardPlace {
  match pieceChar {
    'P' => Some((Piece::Pawn, Color::White))
    'R' => Some((Piece::Rook, Color::White))
    'N' => Some((Piece::Knight, Color::White))
    'B' => Some((Piece::Bishop, Color::White))
    'Q' => Some((Piece::Queen, Color::White))
    'K' => Some((Piece::King, Color::White))
    'p' => Some((Piece::Pawn, Color::Black))
    'r' => Some((Piece::Rook, Color::Black))
    'n' => Some((Piece::Knight, Color::Black))
    'b' => Some((Piece::Bishop, Color::Black))
    'q' => Some((Piece::Queen, Color::Black))
    'k' => Some((Piece::King, Color::Black))
    _ => None
  }
}

// =================================================================================================
// 5: Struct types (Row and Board types)
// =================================================================================================

// There are NO class definitions, only structs and traits.
/// This is a struct that represents a row in the board
pub struct Row {
  // Array type definition:
  priv cols: Array[BoardPlace] // information hiding: private fields
} derive(Show, Eq)


// =================================================================================================
// 6: Operator overloading
// =================================================================================================
// This special method name "op_get" is used to overload the [] operator.
// Then, you can call "row[0]" to get the first element of the row (if row: Row)
pub fn op_get(self:Row, index: Int) -> BoardPlace {
  self.cols[index]
}

pub fn op_set(self: Row, index: Int, value: BoardPlace) -> Unit {
  self.cols[index] = value;
}

pub fn Row::empty_row() -> Row {
  { cols: Array::make(8, None) }
}

// iterative way of defining a new row from a string
// pub fn Row::new_row_from_string!(rowStr: String) -> Row {
//   assert_eq!(rowStr.length(), 8)
//   let cols = []
//   // for loops in moonbit
//   for i in 0..=7 {
//     cols.push(new_place_from_char(rowStr[i]))
//   }
//   { cols: cols }
// }

// =================================================================================================
// 7: Functional programming
// =================================================================================================

// This is a more functional way of defining a new row from a string
pub fn Row::new_row_from_string!(rowStr: String) -> Row {
  assert_eq!(rowStr.length(), 8)
  { cols: rowStr.to_array().map(new_place_from_char) }
}

/// This is a struct that represents the board grid
pub struct Board {
  priv grid: Array[Row]
}

// This is how you provide the operation overloading for the [] operator in the Board type.
pub fn Board::op_get(self:Board, index: Int) -> Row {
  self.grid[index]
}

pub fn Board::op_set(self: Board, index: Int, value: Row) -> Unit {
  self.grid[index] = value;
}

// I cannot overload operation op_get with different number of parameters:
// fn Board::op_get(self:Board, index: Int) -> Array[BoardPlace] {
//   self.grid[index]
// }
// Instead, I can define a method with a different name.
// This is also an example of pairs (tuples) in moonbit: "position" is a tuple of two integers
// fn Board::op_get(self:Board, position:(Int,Int)) -> BoardPlace {
//   self.grid[position.0][position.1] // And how to access a tuple element
// }
// fn op_set(self: Board, position: (Int, Int), value: BoardPlace) -> Unit {
//   self.grid[position.0][position.1] = value;
// }

/// Initialize the board with 8x8 empty places
fn Board::initialize!() -> Board {
  let grid: Array[Row] = []
  grid.push(Row::new_row_from_string!("RNBQKBNR"))
  grid.push(Row::new_row_from_string!("PPPPPPPP"))
  for i in 2..=5 {
    grid.push(Row::empty_row())
  }
  grid.push(Row::new_row_from_string!("pppppppp"))
  grid.push(Row::new_row_from_string!("rnbqkbnr"))
  { grid: grid }
}

// =================================================================================================
// 8: New type definition: defining a new type based on an existing type.
// =================================================================================================
/// This is a new type that represents a turn in a chess game.
pub type Turn Color

/// This is a struct that represents the board state
pub struct BoardState {
  priv board: Board
  priv turn: Turn
}

// Defining methods for a struct type
// This is how you define a method in moonbit:
// fn <name>(self: <type>, <parameters>) -> <return type> { <body> }
// And then you can call: <object>.<name>(<parameters>)
pub fn get_board_row(self: BoardState, row: Int) -> Row {
  self.board[row] // This is what you can do by implementing the op_get method for Board
}

pub fn get_board_place(self: BoardState, row: Int, col: Int) -> BoardPlace {
  self.board[row][col] // Second indexing is what you can do by implementing the op_get method for Row
}

pub fn get_turn(self: BoardState) -> Turn {
  self.turn
}

// Alternative syntax for methods. Use namespaced functions.
pub fn BoardState::initialSetup!() -> BoardState {
  { board: Board::initialize!(), turn: Turn(Color::White) }
}


// =================================================================================================
// 9: Traits: defining a set of methods that can be implemented by different types.
// =================================================================================================
// This is how you define a trait in moonbit. As it is open it can be extended.
/// This trait defines a draw method that returns a string representation of the object.
/// It is used to draw the different objects in the chess game to a String.
/// (although it could be in another format or different resource, like a file or screen).
pub(open) trait Drawable {
  draw(Self) -> String
}

pub(open) trait Paintable {
  paint(Self) -> Unit
}

// This is how you extend and combine traits in moonbit language.
pub trait DrawableAndPaintable : Drawable + Paintable {}

// Implement a trait for a type: Drawable for BoardState
pub impl Drawable for BoardState with draw(self: BoardState) -> String {
  let turnStr = self.get_turn().draw()
  let mut boardString = "";
  for row in 0..=7 {
    let rowStr = self.get_board_row(row).draw()
    boardString += rowStr + "\n";
  }
  turnStr + boardString
}

/// Implement the Drawable trait for Turn
pub impl Drawable for Turn with draw(self: Turn) -> String {
  if self is Turn(White) {
    "White's turn:\n"
  } else {
    "Black's turn:\n"
  }
}

/// Implement Drawable for BoardPlace
pub impl Drawable for BoardPlace with draw(self: BoardPlace) -> String {
  match self {
    Some((Piece::Pawn, Color::White)) => "P"
    Some((Piece::Rook, Color::White)) => "R"
    Some((Piece::Knight, Color::White)) => "N"
    Some((Piece::Bishop, Color::White)) => "B"
    Some((Piece::Queen, Color::White)) => "Q"
    Some((Piece::King, Color::White)) => "K"
    Some((Piece::Pawn, Color::Black)) => "p"
    Some((Piece::Rook, Color::Black)) => "r"
    Some((Piece::Knight, Color::Black)) => "n"
    Some((Piece::Bishop, Color::Black)) => "b"
    Some((Piece::Queen, Color::Black)) => "q"
    Some((Piece::King, Color::Black)) => "k"
    None => "."
  }
}

/// Implement Drawable for Row
impl Drawable for Row with draw(self: Row) -> String {
  let mut rowStr = ""
  for col in 0..=7 {
    let place: BoardPlace = self[col]
    rowStr += place.draw()
  }
  rowStr
}

impl Paintable for Row with paint(self: Row) -> Unit {
  println("Row: " + self.draw())
}

// =================================================================================================
// 10: Tests ! Everywhere !!!
// =================================================================================================

test "create a white row from string" {
  let my_row: Row = Row::new_row_from_string!("RNBQKBNR")

  assert_eq!(my_row[0], Some((Piece::Rook, Color::White)))
  assert_eq!(my_row[1], Some((Piece::Knight, Color::White)))
  assert_eq!(my_row[2], Some((Piece::Bishop, Color::White)))
  assert_eq!(my_row[3], Some((Piece::Queen, Color::White)))
  assert_eq!(my_row[4], Some((Piece::King, Color::White)))
  assert_eq!(my_row[5], Some((Piece::Bishop, Color::White)))
  assert_eq!(my_row[6], Some((Piece::Knight, Color::White)))
  assert_eq!(my_row[7], Some((Piece::Rook, Color::White)))
}

test "create a black row from string" {
  let my_row: Row = Row::new_row_from_string!("rnbqkbnr")

  assert_eq!(my_row[0], Some((Piece::Rook, Color::Black)))
  assert_eq!(my_row[1], Some((Piece::Knight, Color::Black)))
  assert_eq!(my_row[2], Some((Piece::Bishop, Color::Black)))
  assert_eq!(my_row[3], Some((Piece::Queen, Color::Black)))
  assert_eq!(my_row[4], Some((Piece::King, Color::Black)))
  assert_eq!(my_row[5], Some((Piece::Bishop, Color::Black)))
  assert_eq!(my_row[6], Some((Piece::Knight, Color::Black)))
  assert_eq!(my_row[7], Some((Piece::Rook, Color::Black)))
}

test "Create an empty row from string" {
  let my_row: Row = Row::new_row_from_string!("........")
  assert_eq!(my_row, Row::empty_row())
}
