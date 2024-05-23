library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Pieces.all;

package Functions is
	type matrix is array (0 to 7, 0 to 7) of STD_LOGIC;

    -- Procedimiento para repintar la matriz de leds (fÃƒÆ’Ã‚Â­sica)
    procedure repaint (
		signal row_index: inout integer; 
		signal col_sel: out std_LOGIC_VECTOR(0 to 7);
		signal row_sel: out std_LOGIC_VECTOR(0 to 7);
		signal board: in matrix);

    function check_collision (signal board_aux: in matrix; signal board: in matrix) return boolean;

    procedure draw_piece (
        signal piece_matrix: in Piece_Array; 
        signal x_pos, y_pos: in integer;
        signal board_aux: out matrix
    );

    -- Procedimiento para cargar una pieza en el tablero principal
    procedure chargePiece (
        signal board_aux: in matrix;
        signal board: out matrix
    );

    -- Procedimiento para limpiar una pieza del tablero
    procedure clearPiece (
        signal board, board_aux: inout matrix
    );
    
    procedure clearMatAux(signal board_aux: inout matrix);

end package;

package body Functions is
	 procedure repaint (
		signal row_index: inout integer; 
		signal col_sel: out std_LOGIC_VECTOR(0 to 7);
		signal row_sel: out std_LOGIC_VECTOR(0 to 7);
		signal board: in matrix)	is
		begin
		
		  row_sel <= (others => '1');
        -- Establecer el bit correspondiente a row_index a '0'
        row_sel(row_index) <= '0';

        -- Asignar los valores de la fila seleccionada a col_sel
        for j in 0 to 7 loop
            col_sel(j) <= board(row_index, j);
        end loop;

        -- Incrementar row_index y resetearlo si alcanza el valor 8
        row_index <= row_index + 1;
        if row_index = 7 then
            row_index <= 0;
        end if;
		end procedure;

	 
		 function check_collision (signal board_aux: in matrix; signal board: in matrix) return boolean is
	 begin 
		for i in 0 to 7 loop
			for j in 0 to 7 loop
				if board_aux(i,j) = '1' then 
					if board(i,j) = '1' then
						return true;
					end if;
				end if;
			end loop;
		end loop;
		
		return false; -- No hay colisiones
	 end function;
	 
    -- Procedimiento para dibujar una pieza en la matriz auxiliar con base en las coordenadas
    procedure draw_piece (
      signal piece_matrix: in Piece_Array; 
      signal x_pos, y_pos: in integer;
      signal board_aux: out matrix
      ) is
		 begin
			  for i in 0 to 3 loop
					for j in 0 to 3 loop
						 if piece_matrix(i, j) = '1' then 
						  report "Se detecta un '1' en la pieza (" & integer'image(i) & ", " & integer'image(j) & ")" severity note;
							board_aux(y_pos + i, x_pos + j) <= '1';
						  report "Se carga un '1' (" & integer'image(y_pos + i) & ", " & integer'image(x_pos + j) & "), con pos_y = " & integer'image(y_pos) & " pos_x = " & integer'image(x_pos) severity note;
						 end if;
					end loop;
			  end loop;
    end procedure;
	 
	 -- Procedimiento para cargar una pieza en el tablero principal
	 procedure chargePiece (
	   signal board_aux: in matrix;
	   signal board: out matrix
	 ) is
	 begin
		for i in 0 to 7 loop 
			for j in 0 to 7 loop
				if (board_aux(i,j) = '1') then
					board(i,j) <= '1';
				end if;
			end loop;
		end loop;
	 end procedure;
	 
	 -- Limpiar pieza
	procedure clearPiece (signal board, board_aux: inout matrix) is begin
		for i in 0 to 7 loop
	    for j in 0 to 7 loop
				if board(i, j) = '1' and board_aux (i, j) = '1' then
					board(i, j) <= '0'; -- Limpiar pieza
				end if;
			end loop;
		end loop;
	end procedure;
	
	procedure clearMatAux(signal board_aux: inout matrix) is begin
		for i in 0 to 7 loop
	     for j in 0 to 7 loop
				if board_aux (i, j) = '1' then
					board_aux(i, j) <= '0'; -- Limpiar pieza
				end if;
			end loop;
		end loop;
	end procedure;
	
end package body;

