LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BancoReg_vhd_tst IS
END BancoReg_vhd_tst;

ARCHITECTURE BancoReg_arch OF BancoReg_vhd_tst IS
	-- constants                                                 
	-- signals                                                   
	SIGNAL AddrA : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL AddrB : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL AddrW : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL D_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL en_banco : STD_LOGIC:= '0';
	SIGNAL RegA : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RegB : STD_LOGIC_VECTOR(31 DOWNTO 0);
	COMPONENT BancoReg
		PORT (
			AddrA : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			AddrB : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			AddrW : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			clk : IN STD_LOGIC;
			D_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			en_banco : IN STD_LOGIC;
			RegA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RegB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
BEGIN
	i1 : BancoReg
	PORT MAP(
		-- list connections between master ports and signals
		AddrA => AddrA,
		AddrB => AddrB,
		AddrW => AddrW,
		clk => clk,
		D_in => D_in,
		en_banco => en_banco,
		RegA => RegA,
		RegB => RegB
	);
	--Todo bien hasta aquí

	clk <= NOT clk AFTER 10 ns;

	always: PROCESS
	BEGIN
		--Queremos observar si se puede cargar la direccion 555
		D_in <= std_logic_vector(to_unsigned(555,32));
		--Queremos cargar esta direccion en los registros 
		wait for 1 ps;

		FOR i in 0 to 31 loop 
		--Con el decodificador queremos pasar por cada uno de nuestros registros
			AddrW <= std_logic_vector(to_unsigned(i,5));
			wait for 1 ns;
			AddrA <= std_logic_vector(to_unsigned(i,5));
			wait for 1 ns;
			AddrB <= std_logic_vector(to_unsigned(i,5));
			wait for 40 ns;
			en_banco <= '1';
			wait for 40 ns;
			en_banco <= '0';
			wait for 40 ns;

		END LOOP;

		--Iterar a traves de los multiplexores 31 -> 1
		--FOR i in 0 to 31 loop 
			
		--	wait for 1 ns;

		--	wait for 10 ns;
		--END LOOP;
	
		assert RegA <= std_logic_vector(to_unsigned(555,32));
			report "No se copia bien" 
			severity failure;


	assert false report "Fin de la simulacion" severity failure;


	WAIT;
	END PROCESS always;
END BancoReg_arch;