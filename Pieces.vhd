-- Tetris_Pieces.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Pieces is
    type Piece_Array is array (0 to 3, 0 to 3) of std_logic;

    constant PIECE_I : Piece_Array := (
        ( '1', '1', '1', '1' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );

    constant PIECE_O : Piece_Array := (
        ( '1', '1', '0', '0' ),
        ( '1', '1', '0', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );

    constant PIECE_T : Piece_Array := (
        ( '0', '1', '0', '0' ),
        ( '1', '1', '1', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );

    constant PIECE_L : Piece_Array := (
        ( '0', '0', '1', '0' ),
        ( '1', '1', '1', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );

    constant PIECE_J : Piece_Array := (
        ( '1', '0', '0', '0' ),
        ( '1', '1', '1', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );

    constant PIECE_Z : Piece_Array := (
        ( '1', '1', '0', '0' ),
        ( '0', '1', '1', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );

    constant PIECE_S : Piece_Array := (
        ( '0', '1', '1', '0' ),
        ( '1', '1', '0', '0' ),
        ( '0', '0', '0', '0' ),
        ( '0', '0', '0', '0' )
    );
end Pieces;
