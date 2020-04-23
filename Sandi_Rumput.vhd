LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SANDI_RUMPUT IS
GENERIC
	(
		DASH_TIME		: INTEGER := 15;--DASH TIME
		DOT_TIME			: INTEGER := 10;--DOT TIME
		SPACE_SIGN		: INTEGER := 2; --SPACE AFTER SIGN
		SPACE_ALPHABET	: INTEGER := 5; --SPACE AFTER ALPHABET
		SPACE_STRING	: INTEGER := 20; --SPACE
		MAXC				: INTEGER := 8 --MAXIMUM CHAR
	);
PORT
	(
		CLOCK		: IN STD_LOGIC;
		SR			: IN STD_LOGIC := '1';
		STR		: IN STRING(1 TO MAXC) := "HAI IVAN";
		IDLE		: OUT STD_LOGIC := '1';
		OUTPUT	: OUT STD_LOGIC := '0'
	);
END SANDI_RUMPUT;


ARCHITECTURE SANDI OF SANDI_RUMPUT IS

	SIGNAL   M		: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL   TICKS : INTEGER := 0; -- M COUNTER
	SIGNAL	N		: INTEGER := 1; -- CHAR INDEX
	SIGNAL	T		: INTEGER := 0; -- TIMER WRITER

	PROCEDURE PROCESS_1(	SIGNAL COUNT	: INOUT INTEGER;
								SIGNAL O			: OUT STD_LOGIC;
								SIGNAL TIMER	: INOUT INTEGER;
								CONSTANT TH		: IN INTEGER;
								CONSTANT TL		: IN INTEGER;
								CONSTANT SPACE : IN BOOLEAN)IS
	BEGIN
		IF(TIMER <= 0)THEN
			TIMER <= TH + TL + 1;
		ELSE
			TIMER <= TIMER - 1;
			IF(TIMER > TL + 1)THEN
				O <= '1';
			ELSIF(TIMER > 1)THEN
				O <= '0';
			ELSE
				COUNT <= COUNT - 1;
			END IF;
		END IF;
	END PROCEDURE;
	
	PROCEDURE PROCESS_2(	SIGNAL COUNT	: INOUT INTEGER;
								SIGNAL O			: OUT STD_LOGIC;
								SIGNAL TIMER	: INOUT INTEGER;
								CONSTANT T		: IN INTEGER)IS
	BEGIN
		IF(TIMER <= 0)THEN
			TIMER <= T + 1;
		ELSE
			O <= '0';
			TIMER <= TIMER - 1;
			IF(TIMER = 1) THEN
				COUNT <= -1;
			END IF;
		END IF;
	END PROCEDURE;
	
	PROCEDURE CONVERTER(	CONSTANT CH		: IN 	CHARACTER;
								SIGNAL CODE		: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
								SIGNAL COUNT	: OUT INTEGER) IS
	BEGIN
		IF(CH = 'A' OR CH = 'a') THEN 
			CODE <= "00001";
			COUNT <= 2;
		ELSIF(CH = 'B' OR CH = 'b') THEN 
			CODE <= "01000";
			COUNT <= 4;
		ELSIF(CH = 'C' OR CH = 'c') THEN
			CODE <= "01010";
			COUNT <= 4;
		ELSIF(CH = 'D' OR CH = 'd') THEN
			CODE <= "00100";
			COUNT <= 3;
		ELSIF(CH = 'E' OR CH = 'e') THEN
			CODE <= "00000";
			COUNT <= 1;
		ELSIF(CH = 'F' OR CH = 'f') THEN
			CODE <= "00010";
			COUNT <= 4;
		ELSIF(CH = 'G' OR CH = 'g') THEN
			CODE <= "00110";
			COUNT <= 3;
		ELSIF(CH = 'H' OR CH = 'h') THEN
			CODE <= "00000";
			COUNT <= 4;
		ELSIF(CH = 'I' OR CH = 'i') THEN
			CODE <= "00000";
			COUNT <= 2;
		ELSIF(CH = 'J' OR CH = 'j') THEN
			CODE <= "00111";
			COUNT <= 4;
		ELSIF(CH = 'K' OR CH = 'k') THEN
			CODE <= "00101";
			COUNT <= 3;
		ELSIF(CH = 'L' OR CH = 'l') THEN
			CODE <= "00100";
			COUNT <= 4;
		ELSIF(CH = 'M' OR CH = 'm') THEN
			CODE <= "00011";
			COUNT <= 2;
		ELSIF(CH = 'N' OR CH = 'n') THEN
			CODE <= "00010";
			COUNT <= 2;
		ELSIF(CH = 'O' OR CH = 'o') THEN
			CODE <= "00111";
			COUNT <= 3;
		ELSIF(CH = 'P' OR CH = 'p') THEN
			CODE <= "00110";
			COUNT <= 4;
		ELSIF(CH = 'Q' OR CH = 'q') THEN
			CODE <= "01101";
			COUNT <= 4;
		ELSIF(CH = 'R' OR CH = 'r') THEN
			CODE <= "00010";
			COUNT <= 3;
		ELSIF(CH = 'S' OR CH = 's') THEN
			CODE <= "00000";
			COUNT <= 3;
		ELSIF(CH = 'T' OR CH = 't') THEN
			CODE <= "00001";
			COUNT <= 1;
		ELSIF(CH = 'U' OR CH = 'u') THEN
			CODE <= "00001";
			COUNT <= 3;
		ELSIF(CH = 'V' OR CH = 'v') THEN
			CODE <= "00001";
			COUNT <= 4;
		ELSIF(CH = 'W' OR CH = 'w') THEN
			CODE <= "00011";
			COUNT <= 3;
		ELSIF(CH = 'X' OR CH = 'x') THEN
			CODE <= "01001";
			COUNT <= 4;
		ELSIF(CH = 'Y' OR CH = 'y') THEN
			CODE <= "01011";
			COUNT <= 4;
		ELSIF(CH = 'Z' OR CH = 'z') THEN
			CODE <= "01100";
			COUNT <= 4;
		ELSIF(CH = ' ') THEN
			COUNT <= 10;
		ELSIF(CH = '0') THEN
			CODE <= "11111";
			COUNT <= 5;
		ELSIF(CH = '1') THEN
			CODE <= "01111";
			COUNT <= 5;
		ELSIF(CH = '2') THEN
			CODE <= "00111";
			COUNT <= 5;
		ELSIF(CH = '3') THEN
			CODE <= "00011";
			COUNT <= 5;
		ELSIF(CH = '4') THEN
			CODE <= "00001";
			COUNT <= 5;
		ELSIF(CH = '5') THEN
			CODE <= "00000";
			COUNT <= 5;
		ELSIF(CH = '6') THEN
			CODE <= "10000";
			COUNT <= 5;
		ELSIF(CH = '7') THEN
			CODE <= "11000";
			COUNT <= 5;
		ELSIF(CH = '8') THEN
			CODE <= "11100";
			COUNT <= 5;
		ELSIF(CH = '9') THEN
			CODE <= "11110";
			COUNT <= 5;
		ELSE 
			COUNT <= -1;
		END IF;		
	END PROCEDURE;
	

	
BEGIN

	PROCESS(CLOCK, SR)
	
	BEGIN
		IF (SR = '1') THEN
			TICKS <= -1;
			N		<= 1;
			IDLE	<= '0';
			T <= 0;
		ELSIF RISING_EDGE(CLOCK) THEN
			IF(N > MAXC) THEN
				IDLE <= '1';
			ELSIF(TICKS = 10) THEN -- SPASI
				PROCESS_2(TICKS, OUTPUT, T, SPACE_STRING);
			ELSIF(TICKS > 0) THEN -- NORMAL
				IF(M(TICKS-1) = '0') THEN --DOT
					PROCESS_1(TICKS, OUTPUT, T, DOT_TIME,SPACE_SIGN, FALSE);
				ELSE -- DASH
					PROCESS_1(TICKS, OUTPUT, T, DASH_TIME,SPACE_SIGN, FALSE);
				END IF;
			ELSIF(TICKS = 0) THEN -- SPASI SEHABIS HURUF
				PROCESS_2(TICKS, OUTPUT, T, SPACE_ALPHABET);
			ELSE
				CONVERTER(STR(N), M, TICKS);
				N <= N + 1;
			END IF;
		END IF;
	END PROCESS;

END SANDI;
