library verilog;
use verilog.vl_types.all;
entity Tetris_vlg_check_tst is
    port(
        clk_desp        : in     vl_logic;
        col_sel         : in     vl_logic_vector(0 to 7);
        row_sel         : in     vl_logic_vector(0 to 7);
        sampler_rx      : in     vl_logic
    );
end Tetris_vlg_check_tst;
