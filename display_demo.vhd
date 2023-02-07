-- A three process finite state machine design in VHDL as per Xilinx
-- recommendations

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_demo is
  port (
    clk: in std_logic; -- system clock
    dp: out STD_LOGIC;   -- decimal points
    seg: out STD_LOGIC_VECTOR(6 downto 0); -- display segments
    an: out STD_LOGIC_VECTOR(3 downto 0) -- display anodes
    );
end display_demo;

architecture structural of display_demo is
  component clk_prescaler
    generic ( n: integer );
    port (
      clk: in std_logic;      -- system clock in
      clk_div: out std_logic  -- output scaled clock enable
      );
  end component;

  
  component display
    port (
      clk: in STD_LOGIC;
      clk_en: in  STD_LOGIC; -- refresh clock enable should be <=1kHz
      bcd: in STD_LOGIC_VECTOR(15 downto 0);
      dp_on: in STD_LOGIC_VECTOR(3 downto 0) ; --dp on
      segments : out STD_LOGIC_VECTOR (6 downto 0);
      dp: out STD_LOGIC; -- decimal point
      anodes   : out STD_LOGIC_VECTOR (3 downto 0)
      );
  end component;

  signal  bcd: STD_LOGIC_VECTOR(15 downto 0);
  signal clk_1kHz: std_logic;
begin
  clk1: clk_prescaler-- 1kHz clock gen
    generic map (n => 100000) 
    port map (clk => clk, clk_div => clk_1kHz);
  disp: display port map (
    clk => clk, clk_en => clk_1kHz, bcd => "0001001000110100",dp_on => "0100",
    segments => seg, dp => dp, anodes => an);
end structural;
