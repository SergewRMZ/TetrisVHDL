LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.Pieces.ALL;
USE work.Functions.ALL;
ENTITY Tetris IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		right_btn : IN STD_LOGIC;
		left_btn : IN STD_LOGIC;
		rotate_btn : IN STD_LOGIC;
		-- Salidas
		row_sel : OUT STD_LOGIC_VECTOR(0 TO 7);
		col_sel : OUT STD_LOGIC_VECTOR (0 TO 7);
		clk_desp : OUT STD_LOGIC
	);
END Tetris;

ARCHITECTURE Juego OF Tetris IS
	SIGNAL board : matrix;
	SIGNAL board_aux : matrix;

	-- State Machines
	TYPE State_Type IS (INIT, FALLING, SOLVE_COLLISION, GAME_OVER, NEXTFIGURE);
	SIGNAL state : State_Type := INIT;

	TYPE Action_State_Type IS (ESPERA, CLEAR, DRAW, CHARGE, DETECT_COLLISION);
	SIGNAL state_piece : Action_State_Type := ESPERA;

	-- Matriz de Leds
	SIGNAL row_index : INTEGER := 0;

	-- Pieces
	SIGNAL current_piece : Piece_Array;
	SIGNAL next_piece : Piece_Array;

	-- Clock Signals
	SIGNAL shift_clock : STD_LOGIC := '0';
	SIGNAL init_complete : BOOLEAN := false;
	-- Señales de debouncer
	SIGNAL right_debounced : STD_LOGIC := '0';
	SIGNAL left_debounced : STD_LOGIC := '0';

	---------------------------------------------------------------------------------
	-- COMPONENTES
	COMPONENT Debouncer IS
		PORT (
			clk : IN STD_LOGIC;
			input_signal : IN STD_LOGIC;
			debounced_output : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT Divider IS
		PORT (
			clk : IN STD_LOGIC;
			clk_divider : OUT STD_LOGIC
		);
	END COMPONENT;

	---------------------------------------------------------------------------------
	-- VARIABLES COPMPARTIDAS
	SHARED VARIABLE figure_y : INTEGER RANGE 0 TO 8 := 0;
	SHARED VARIABLE figure_x : INTEGER range -2 TO 8 := 0;
	---------------------------------------------------------------------------------

	---------------------------------------------------------------------------------
	----- INICIO DE LA ARQUITECTURA

BEGIN
	frecuency_divider : Divider PORT MAP(clk => clk, clk_divider => shift_clock);

	JUEGO_TETRIS : PROCESS (reset, clk, shift_clock)
		VARIABLE isCollision : BOOLEAN := false;
	BEGIN
		IF reset = '1' THEN
			REPORT "INICIANDO JUEGO";
			row_sel <= "11111111";
			FOR i IN 0 TO 7 LOOP
				FOR j IN 0 TO 7 LOOP
					board(i, j) <= '0';
					board_aux(i, j) <= '0';
				END LOOP;
			END LOOP;

			figure_x := 0;
			figure_y := 0;

			-- Cargar pieza inicial
			current_piece <= PIECE_I;

			-- Dibujar la pieza inicial en el tablero (por ejemplo, en la fila 0, columna 3)
			draw_piece(current_piece, figure_x, figure_y, board_aux);
			chargePiece(board_aux, board);

		ELSIF rising_edge(clk) THEN
			IF right_btn = '1' THEN
				IF figure_x < 7 THEN
				  figure_x := figure_x + 1; 
				  REPORT "Derecha -> X = " & INTEGER'IMAGE(figure_x);
				END IF;
			END IF;
			
			IF left_btn = '1' THEN 
			  IF figure_x > -2 THEN
			   figure_x := figure_x - 1;
			   REPORT "Izquierda <- X = " & INTEGER'IMAGE(figure_x);
			  END IF;
			END IF;
			
			repaint(row_index, col_sel, row_sel, board);

		ELSIF rising_edge(shift_clock) THEN
			CASE state IS
				WHEN INIT =>
					state <= FALLING;

				WHEN FALLING =>
					CASE state_piece IS
						WHEN ESPERA =>
							state_piece <= CLEAR;

						WHEN CLEAR =>
							clearPiece(board, board_aux);
							clearMatAux(board_aux);
							state_piece <= DRAW;

						WHEN DRAW =>
							IF figure_y < 7 THEN
								figure_y := figure_y + 1;
								REPORT "Estado Draw con Y = " & INTEGER'IMAGE(figure_Y);
								draw_piece(current_piece, figure_x, figure_y, board_aux);
								state_piece <= DETECT_COLLISION;
							END IF;
						WHEN DETECT_COLLISION =>
							isCollision := check_collision(board_aux, board);
							IF NOT isCollision THEN
								state_piece <= CHARGE;

							ELSE
								REPORT "COLLISION DETECTADA" SEVERITY note;
								state <= SOLVE_COLLISION;
								state_piece <= CLEAR;
							END IF;

						WHEN CHARGE =>
							chargePiece(board_aux, board);
							-- La pieza ha llegado al fin
							IF figure_y = 7 THEN
								state <= NEXTFIGURE;
								state_piece <= CLEAR;

							ELSE
								state_piece <= ESPERA;
							END IF;

					END CASE;

				WHEN NEXTFIGURE =>
					CASE state_piece IS
						WHEN CLEAR =>
							clearMatAux(board_aux);
							figure_y := 0;
							figure_x := 0;
							current_piece <= PIECE_I;
							state_piece <= DRAW;

						WHEN DRAW =>
							draw_piece(current_piece, figure_x, figure_y, board_aux);
							state_piece <= DETECT_COLLISION;
							state <= FALLING;

						WHEN OTHERS => NULL;
					END CASE;

				WHEN SOLVE_COLLISION =>
					CASE state_piece IS
						WHEN CLEAR =>
							figure_y := figure_y - 1; -- Retroceder la pieza
							REPORT "Retrocede al último estado: figure_x=" & INTEGER'IMAGE(figure_x) & ", figure_y=" & INTEGER'IMAGE(figure_y) SEVERITY note;
							clearMatAux(board_aux);
							state_piece <= DRAW;

						WHEN DRAW =>
							draw_piece(current_piece, figure_x, figure_y, board_aux);
							state_piece <= CHARGE;

						WHEN CHARGE =>
							chargePiece(board_aux, board);
							state <= NEXTFIGURE;
							state_piece <= CLEAR;

						WHEN OTHERS => NULL;

					END CASE;
				WHEN OTHERS => NULL;
			END CASE;


		END IF;
	END PROCESS;
	
	clk_desp <= shift_clock;

	END ARCHITECTURE Juego;