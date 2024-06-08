LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.Pieces.ALL;

PACKAGE Functions IS
	TYPE matrix IS ARRAY (0 TO 7, 0 TO 7) OF STD_LOGIC;


	PROCEDURE repaint (
		SIGNAL row_index : INOUT INTEGER;
		SIGNAL col_sel : OUT STD_LOGIC_VECTOR(0 TO 7);
		SIGNAL row_sel : OUT STD_LOGIC_VECTOR(0 TO 7);
		SIGNAL board : IN matrix);

	FUNCTION check_collision (SIGNAL board_aux : IN matrix; SIGNAL board : IN matrix) RETURN BOOLEAN;

	PROCEDURE draw_piece (
		SIGNAL piece_matrix : IN Piece_Array;
		VARIABLE x_pos, y_pos : INOUT INTEGER;
		SIGNAL board_aux : OUT matrix
	);

	-- Procedimiento para cargar una pieza en el tablero principal
	PROCEDURE chargePiece (
		SIGNAL board_aux : IN matrix;
		SIGNAL board : OUT matrix
	);

	-- Procedimiento para limpiar una pieza del tablero
	PROCEDURE clearPiece (
		SIGNAL board, board_aux : INOUT matrix
	);

	PROCEDURE clearMatAux(SIGNAL board_aux : INOUT matrix);
	
  FUNCTION canMoveRight (
        piece_matrix: IN Piece_Array;
        x_pos: IN INTEGER;
        y_pos: IN INTEGER;
        board: IN matrix
    ) RETURN BOOLEAN;
	FUNCTION rotateLeft (piece_matrix : IN Piece_Array) RETURN Piece_Array;
	FUNCTION rotateRight (piece_matrix : IN Piece_Array) RETURN Piece_Array;
	PROCEDURE verifyLines (SIGNAL board: INOUT matrix; SIGNAL lines: INOUT INTEGER);
   
		END PACKAGE;

-----------------------------------------------------------------------------------------------------------

		PACKAGE BODY Functions IS
			PROCEDURE repaint (
				SIGNAL row_index : INOUT INTEGER;
				SIGNAL col_sel : OUT STD_LOGIC_VECTOR(0 TO 7);
				SIGNAL row_sel : OUT STD_LOGIC_VECTOR(0 TO 7);
				SIGNAL board : IN matrix) IS
			BEGIN

				row_sel <= (OTHERS => '1');
				row_sel(row_index) <= '0';

				-- Asignar los valores de la fila seleccionada a col_sel
				FOR j IN 0 TO 7 LOOP
					col_sel(j) <= board(row_index, j);
				END LOOP;

				-- Incrementar row_index y resetearlo si alcanza el valor 8
				row_index <= row_index + 1;
				IF row_index = 7 THEN
					row_index <= 0;
				END IF;
			END PROCEDURE;
			FUNCTION check_collision (SIGNAL board_aux : IN matrix; SIGNAL board : IN matrix) RETURN BOOLEAN IS
			BEGIN
				FOR i IN 0 TO 7 LOOP
					FOR j IN 0 TO 7 LOOP
						IF board_aux(i, j) = '1' THEN
							IF board(i, j) = '1' THEN
								RETURN true;
							END IF;
						END IF;
					END LOOP;
				END LOOP;

				RETURN false; -- No hay colisiones
			END FUNCTION;

			-- Procedimiento para dibujar una pieza en la matriz auxiliar con base en las coordenadas
			PROCEDURE draw_piece (
				SIGNAL piece_matrix : IN Piece_Array;
				VARIABLE x_pos, y_pos : INOUT INTEGER;
				SIGNAL board_aux : OUT matrix
			) IS
			BEGIN
				FOR i IN 0 TO 3 LOOP
					FOR j IN 0 TO 3 LOOP
						IF piece_matrix(i, j) = '1' THEN

							IF ((x_pos + j >= 0 AND x_pos + j < 8) AND (y_pos + i >= 0 AND y_pos + i < 8)) THEN
								board_aux(y_pos + i, x_pos + j) <= '1';
								
							ELSE 
								REPORT "SALE DE LOS LIMITES, VERIFICAR DE QUE LADO SE SOBRE SALE";
								
								IF (x_pos + j < 0) THEN
									REPORT "PIEZA SE SALE DEL BORDE IZQUIERDO";
									x_pos := x_pos + 1;
								ELSIF (x_pos + j > 7) THEN
									REPORT "PIEZA SE SALE DEL BORDE DERECHO";
									x_pos := x_pos - 1;
								END IF;
								
							END IF;

						END IF;
					END LOOP;
				END LOOP;

			END PROCEDURE;

			-- Procedimiento para cargar una pieza en el tablero principal
			PROCEDURE chargePiece (
				SIGNAL board_aux : IN matrix;
				SIGNAL board : OUT matrix
			) IS
			BEGIN
				FOR i IN 0 TO 7 LOOP
					FOR j IN 0 TO 7 LOOP
						IF (board_aux(i, j) = '1') THEN
							board(i, j) <= '1';
						END IF;
					END LOOP;
				END LOOP;
			END PROCEDURE;

			-- Limpiar pieza
			PROCEDURE clearPiece (SIGNAL board, board_aux : INOUT matrix) IS BEGIN
				FOR i IN 0 TO 7 LOOP
					FOR j IN 0 TO 7 LOOP
						IF board(i, j) = '1' AND board_aux (i, j) = '1' THEN
							board(i, j) <= '0'; -- Limpiar pieza
						END IF;
					END LOOP;
				END LOOP;
			END PROCEDURE;

			PROCEDURE clearMatAux(SIGNAL board_aux : INOUT matrix) IS BEGIN
				FOR i IN 0 TO 7 LOOP
					FOR j IN 0 TO 7 LOOP
						IF board_aux (i, j) = '1' THEN
							board_aux(i, j) <= '0'; -- Limpiar pieza
						END IF;
					END LOOP;
				END LOOP;
			END PROCEDURE;

			FUNCTION canMoveRight (
			   piece_matrix: IN Piece_Array; 
			   x_pos: IN INTEGER; 
			   y_pos: IN INTEGER; 
			   board: IN matrix) RETURN BOOLEAN is
				 VARIABLE new_x_pos: INTEGER := x_pos + 1; 
			BEGIN

				 FOR i IN 0 TO 3 LOOP
					  FOR j IN 0 TO 3 LOOP
							IF piece_matrix(i, j) = '1' THEN
								 IF (new_x_pos + j > 7) THEN
									  RETURN FALSE;
								 END IF;
							END IF;
					  END LOOP;
				 END LOOP;

				 -- Verificar colisiones con otras piezas en el tablero al moverse hacia la derecha
				 FOR i IN 0 TO 3 LOOP
					  FOR j IN 0 TO 3 LOOP
							IF piece_matrix(i, j) = '1' THEN
								 IF board(y_pos + i, new_x_pos + j) = '1' THEN
									  RETURN FALSE;
								 END IF;
							END IF;
					  END LOOP;
				 END LOOP;
        
          REPORT ("Puede moverse a la derecha");
				 RETURN TRUE; 
			END FUNCTION;


			FUNCTION rotateLeft (piece_matrix : IN Piece_Array) RETURN Piece_Array is
				VARIABLE rotated: Piece_Array;	
			BEGIN
				FOR i in 0 to 3 LOOP
					for j in 0 to 3 loop
						rotated(i, j) := piece_matrix(j, 3-i);	
					end loop;
				end loop;

				RETURN rotated;
			END FUNCTION;
			
			FUNCTION rotateRight (piece_matrix : IN Piece_Array) RETURN Piece_Array is
				VARIABLE rotated: Piece_Array;	
			BEGIN
				FOR i in 0 to 3 LOOP
					for j in 0 to 3 loop
						rotated(i, j) := piece_matrix(3-j, i);	
					end loop;
				end loop;

				RETURN rotated;
			END FUNCTION;
			
			PROCEDURE verifyLines (SIGNAL board: INOUT matrix; SIGNAL lines: INOUT INTEGER) IS
        VARIABLE fila: STD_LOGIC_VECTOR(0 TO 7);
      BEGIN      
          FOR i IN 0 TO 7 LOOP
          FOR j IN 0 TO 7 LOOP
            fila(j) := board(i, j);
          END LOOP;
          
          IF fila = "11111111" THEN
            REPORT "Fila " & INTEGER'IMAGE(i) & " COMPLETA";
            lines <= lines + 1;
            
            
            FOR j IN 0 TO 7 LOOP
                board(i, j) <= '0';
            END LOOP;

            FOR k IN i DOWNTO 1 LOOP
                FOR j IN 0 TO 7 LOOP
                    REPORT "Eliminando fila";
                    board(k, j) <= board(k-1, j);
                END LOOP;
            END LOOP;

            FOR j IN 0 TO 7 LOOP
                board(0, j) <= '0';
            END LOOP;
          END IF;
      END LOOP;
  END PROCEDURE;

			END PACKAGE BODY;
