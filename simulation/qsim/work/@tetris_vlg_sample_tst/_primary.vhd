library verilog;
use verilog.vl_types.all;
entity Tetris_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        left_btn        : in     vl_logic;
        reset           : in     vl_logic;
        right_btn       : in     vl_logic;
        rotate_btn      : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Tetris_vlg_sample_tst;
