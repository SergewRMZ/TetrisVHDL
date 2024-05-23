library verilog;
use verilog.vl_types.all;
entity Tetris is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        right_btn       : in     vl_logic;
        left_btn        : in     vl_logic;
        rotate_btn      : in     vl_logic;
        row_sel         : out    vl_logic_vector(0 to 7);
        col_sel         : out    vl_logic_vector(0 to 7);
        clk_desp        : out    vl_logic
    );
end Tetris;
