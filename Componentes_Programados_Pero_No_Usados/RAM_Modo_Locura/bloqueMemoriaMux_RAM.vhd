LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY bloqueMemoriaMux_RAM IS
  PORT (
    tipo_acc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    e0, e1, e2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    o1, o2, o3 : IN STD_LOGIC;
    salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC
  );
END bloqueMemoriaMux_RAM;

ARCHITECTURE structural OF bloqueMemoriaMux_RAM IS

  SIGNAL i1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL i2 : STD_LOGIC;

BEGIN

  Multiplexor3a1 : ENTITY work.Mux3a1
    GENERIC MAP(
      n => 8
    )
    PORT MAP(
      e0 => e0,
      e1 => e1,
      e2 => e2,
      sel => tipo_acc,
      s => i1
    );

  i2 <= o1 OR o2 OR o3;

  RamCore : ENTITY work.ram_core
    PORT MAP(
      clk => clk,
      din => i1,
      addr => address,
      writer_enable => i2,
      dout => salida
    );

END structural; -- structural