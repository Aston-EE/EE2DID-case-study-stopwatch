--------------------------------------------------------------------------------
-- Title:        : Testbench for 7 segment display driver implementations
-- Project       : EE2IDD Practical Work
-- Author        : John A.R. Williams
-- Copyright     : 2019 Dr. J.A.R. Williams, Aston University
--------------------------------------------------------------------------------
-- Purpose       : Provides some basic checking of implementations for 7 
--               : segment displays.
--------------------------------------------------------------------------------
-- Revisions     :
-- Date       Version Author                Description
-- 2019-04-04 1.0     John A.R. Williams    Created
-- 2019-04-16 1.1     John A.R. Williams    Changed variable name to remove
--                                          hidden signal warning
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity display_testbench is
end display_testbench;
 
architecture behavior of display_testbench is

  constant clk_period   : time := 100 ns;

  signal clk: STD_LOGIC; -- signals
  signal bcd: STD_LOGIC_VECTOR(15 downto 0);
  signal segments : STD_LOGIC_VECTOR (6 downto 0);
  signal dp: STD_LOGIC; -- decimal point
  signal anodes: STD_LOGIC_VECTOR (3 downto 0);
  signal finished: boolean:=false;

  -- Function returns a string representation of a std_logic_vector
  -- for display. This is not provided in the standard IEEE libraries.
  function to_string (a : STD_LOGIC_VECTOR) return string is
    variable b    : string (1 to a'length) := (others => NUL);
    variable stri : integer                := 1;
  begin
    for i in a'range loop
      b(stri) := std_logic'image(a((i)))(2);
      stri    := stri+1;
    end loop;
    return b;
  end function;

  function fsegments(digit: std_logic_vector(3 downto 0))
    return std_logic_vector is
    variable seg: std_logic_vector(6 downto 0);
    begin
     case digit is
       -- Cathodes   GFEDCBA
       when "0000" => seg := "1000000";    
       when "0001" => seg := "1111001";
       when "0010" => seg := "0100100";
       when "0011" => seg := "0110000";
       when "0100" => seg := "0011001";
       when "0101" => seg := "0010010";
       when "0110" => seg := "0000010";
       when "0111" => seg := "1111000";
       when "1000" => seg := "0000000";
       when "1001" => seg := "0010000";
       when others => seg := "1111111"; -- all off if >9
     end case;
    return seg;
  end function;
  
  component display is
    port (
      clk: in std_logic;
      clk_en: in  STD_LOGIC; -- display clock should be <=1kHz
      bcd: in STD_LOGIC_VECTOR(15 downto 0);
      dp_on: in STD_LOGIC_VECTOR(3 downto 0) ; --dp on
      segments : out STD_LOGIC_VECTOR (6 downto 0);
      dp: out STD_LOGIC; -- decimal point
      anodes   : out STD_LOGIC_VECTOR (3 downto 0 )
      );
  end component;
  
begin

  uut: display
    port map(clk=>clk, clk_en=>'1', bcd=>bcd, dp_on=>"0000", segments=>segments,
             anodes=> anodes);
    
  clock: process -- generate clock until test_end is set to 1
  begin
    clk <= '1';
    wait for clk_period/2 ;
    clk <= '0' ;
    wait for clk_period/2;
    if finished then wait;
    end if;
  end process clock;

  stim_proc: process
    variable digit : STD_LOGIC_VECTOR( 3 downto 0);
  begin

    bcd<="0001001000110100"; --1234
    wait until rising_edge(clk);

    for I in 0 TO 3 loop -- 3 digits
      wait until rising_edge(clk);
      if anodes(0) = '0' then
        digit :=  bcd(3 downto 0);
      elsif anodes(1) = '0' then
        digit := bcd(7 downto 4);
      elsif anodes(2) = '0' then
        digit := bcd(11 downto 8);
      elsif anodes(3) = '0' then
        digit := bcd(15 downto 12);
      else
        report "No Anode grounded." severity error;
      end if;
      assert segments=fsegments(digit)
        report "Incorrect display segments " & to_string(segments)&" displayed for "&to_string(digit)& " at "& to_string(anodes)& " expected "& to_string(fsegments(digit))
--        Digit" &
--        to_string(digit) & " gave " & to_string(segments)
        severity error;
    end loop; 
        

    finished<=true;
    
    wait;
   end process stim_proc;
end behavior;
