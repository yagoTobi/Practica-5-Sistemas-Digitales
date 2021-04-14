LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--Todo esto se puede ver mas en detalle en la diapo 70 de las transparencias
ENTITY InmGen IS
    GENERIC (
        g_data_width : INTEGER := 32
    );
    PORT (
        ir_out : IN STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0);
        mask_b0 : IN STD_LOGIC;
        tipo_inst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        inm : OUT STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0)
    );
END InmGen;

ARCHITECTURE rtl OF InmGen IS
    --Declaracion de constantes, el cual depende del ir_out 
    SUBTYPE tipo_inst_t IS STD_LOGIC_VECTOR(2 DOWNTO 0);
    CONSTANT TYPE_I : tipo_inst_t := "000";
    CONSTANT TYPE_S : tipo_inst_t := "001";
    CONSTANT TYPE_B : tipo_inst_t := "010";
    CONSTANT TYPE_U : tipo_inst_t := "011";
    CONSTANT TYPE_J : tipo_inst_t := "100";

    SIGNAL inm_i : STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0);
    SIGNAL inm_s : STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0);
    SIGNAL inm_b : STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0);
    SIGNAL inm_u : STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0);
    SIGNAL inm_j : STD_LOGIC_VECTOR(g_data_width - 1 DOWNTO 0);

BEGIN

    --Constructor I ir_out
    inm_i(31 DOWNTO 11) <= (OTHERS => ir_out(31));
    inm_i(10 DOWNTO 5) <= ir_out(30 DOWNTO 25);
    inm_i(4 DOWNTO 1) <= ir_out(24 DOWNTO 21);
    inm_i(0) <= ir_out(20);

    --Constructor S ir_out 
    inm_s(31 DOWNTO 11) <= (OTHERS => ir_out(31));
    inm_s(10 DOWNTO 5) <= ir_out(30 DOWNTO 25);
    inm_s(4 DOWNTO 1) <= ir_out(11 DOWNTO 8);
    inm_s(0) <= ir_out(7);

    --Constructor B ir_out 
    inm_b(31 DOWNTO 12) <= (OTHERS => ir_out(31));
    inm_b(11) <= ir_out(7);
    inm_b(10 DOWNTO 5) <= ir_out(30 DOWNTO 25);
    inm_b(4) <= '0';

    --Constructor U ir_out
    inm_u(31) <= ir_out(31);
    inm_u(30 DOWNTO 20) <= ir_out(30 DOWNTO 20);
    inm_u(19 DOWNTO 12) <= ir_out(19 DOWNTO 12);
    inm_u(11 DOWNTO 0) <= (OTHERS => '0');

    --Constructor J ir_out 
    inm_j(31 DOWNTO 20) <= (OTHERS => ir_out(31));
    inm_j(19 DOWNTO 12) <= ir_out(19 DOWNTO 12);
    inm_j(12 DOWNTO 11) <= (OTHERS => ir_out(20));
    inm_j(10 DOWNTO 5) <= ir_out(30 DOWNTO 25);
    inm_j(4 DOWNTO 1) <= ir_out(24 DOWNTO 21);
    inm_j(0) <= '0';

    --Pasar al inm el inmediato generado dependiendo del tipo de instruccion 
    WITH tipo_inst SELECT inm <=
        inm_i WHEN TYPE_I,
        inm_s WHEN TYPE_S,
        inm_b WHEN TYPE_B,
        inm_u WHEN TYPE_U,
        inm_j WHEN TYPE_J,
        (OTHERS => '0') WHEN OTHERS;

END rtl; -- rtl