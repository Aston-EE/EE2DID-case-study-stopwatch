-- testbench for stopwatch timer entity
-- Copyright 2017-2023 Aston University
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity timer_testbench is
end timer_testbench;
 
architecture behaviour of timer_testbench is

  constant clk_period   : time := 100 ns;
  constant clk_timer_period    : time := 500 ns;

  component timer
  port (
    cen: in std_logic; -- enable at slow tick frequency
    clk: in std_logic; -- master clock
    reset,pause,latch: in std_logic; -- reset count
    bcd: out std_logic_vector (15 downto 0) -- output count to be displayed
    );
  end component;

  signal reset,pause,latch,clk,timer_clk,finished: std_logic := '0';
  signal count: std_logic_vector (15 downto 0);


  
begin
  uut: timer port map (
    cen => timer_clk,
    clk => clk,
    reset => reset,
    pause => pause,
    latch => latch,
    bcd => count    
    );
  
  clk1: process -- generate clock until test_end is set to 1
  begin
    while finished/='1' loop
      clk <= '1';
      wait for clk_period/2 ;
      clk <= '0' ;
      wait for clk_period/2;
    end loop;
    wait;
  end process clk1;

  clk2: process -- generate clock until test_end is set to 1
  begin
    while finished/='1' loop
      timer_clk <= '0';
      wait for clk_timer_period/2 ;
      timer_clk <= '1' ;
      wait for clk_period;
      timer_clk <= '0';
      wait for clk_timer_period/2-clk_period;
    end loop;
    wait;
  end process clk2;
  
  -- control signals reset,pause,latch
  stim_proc: process
  begin
    finished<='0';
    pause <= '1';
    latch <='1';
    reset<='1';  wait for clk_period*2; reset<='0';
    pause<='0';
    wait for clk_period*15;
    pause<='1';
    wait for clk_period*15;
    reset<='1';  wait for clk_period*2; reset<='0';
    pause<='0';
    wait for clk_period*15;
    latch<='0';
    wait for clk_period*15;
    latch<='1';    
    wait for clk_period*15;
    latch<='0';
    wait for clk_period*15;
    pause<='1';
    wait for clk_period*15;
   
    finished<='1';
    wait;
   end process stim_proc;
end behaviour;
