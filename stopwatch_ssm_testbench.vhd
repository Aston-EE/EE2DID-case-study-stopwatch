library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity stopwatch_ssm_testbench is
end stopwatch_ssm_testbench;
 
architecture behavior of stopwatch_ssm_testbench is

  constant clk_period   : time := 100 ns;
  constant clear_period : time := 10 ns;

  signal clk,clear,finished: std_logic; -- signals
  signal stim: std_logic_vector(2 downto 0); -- stimulus signals
  signal resp: std_logic_vector(2 downto 0); -- response signals

  -- Function returns a string representation of a std_logic_vector
  -- for display. This is not provided in the standard IEEE libraries.
  function to_string (a : std_logic_vector) return string is
    variable b    : string (1 to a'length) := (others => NUL);
    variable stri : integer                := 1;
  begin
    for i in a'range loop
      b(stri) := std_logic'image(a((i)))(2);
      stri    := stri+1;
    end loop;
    return b;
  end function;

  -- Procedure sets stimulus, waits 1 clock period and checks response
  -- used to check Moore model behaviour in the testbench.
  procedure check_response(
    signal stim_v: out std_logic_vector(2 downto 0);
    stim:  in std_logic_vector(2 downto 0);
    signal resp_v:  in std_logic_vector(2 downto 0);
    resp:  in std_logic_vector(2 downto 0)
    ) is
  begin
    stim_v <= stim;
    wait for clk_period;
    assert resp_v = resp
      report "Stimulus: " & to_string(stim)
        & ". Expected " & to_string(resp)
        & " but got " & to_string(resp_v);
  end check_response;

  component stopwatch_ssm
    port (
      clk          : in  std_logic;
      ss, lap, rst : in  std_logic; -- start/stop,lap,reset inputs
      timer_reset, timer_pause, timer_latch   : out std_logic -- outputs
      );
  end component;

begin
  -- connect unti under test to appropriate response and stimulus signals
  uut: stopwatch_ssm port map (
    clk => clk,
    ss => stim(2),
    lap => stim(1),
    rst => stim(0),
    timer_reset => resp(2),
    timer_pause => resp(1),
    timer_latch => resp(0)
    );
    
  clock: process -- generate clock until test_end is set to 1
  begin
    while finished/='1' loop
      clk <= '1';
      wait for clk_period/2 ;
      clk <= '0' ;
      wait for clk_period/2;
    end loop;
    wait;
  end process clock;

  reset: process -- sets initial local reset signal - not used in this case
  begin
    clear <= '0';
    wait for clear_period;
    clear <= '1';
    wait;
  end process reset;

  stim_proc: process
  begin
    finished<='0';
    wait for clk_period/2; -- Signal changes offset from clock edges
    -- input order ss,lap,rst
    -- output order reset,pause,latch
    -- as per stopwatch_ssm port map
   check_response(stim,"000",resp,"010");
    -- complete testing all transitions here
    -- ...

    finished<='1';
    wait;
   end process stim_proc;
end behavior;
