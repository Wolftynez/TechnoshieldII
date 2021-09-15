----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    sb_ice_lc - Timing
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
--
--  
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package lc_package is
     	
    function slv_to_integer( slv : in std_logic_vector ) return integer;

end lc_package;

package body lc_package is
    -- function to convert std_logic_vector into integer 
    function slv_to_integer (slv: in std_logic_vector ) return integer is
        variable int_val : integer;
         begin
                int_val := 0;
                for i in slv'high downto slv'low loop
                    int_val := int_val * 2;
                    if slv(i) = '1' then
                        int_val := int_val + 1;
                    end if;
                end loop;
         return int_val;
        end;
end lc_package;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
library WORK;
use WORK.vcomponent_vital.all;

entity LogicCell is
  generic ( SEQ_MODE  : bit_vector(3 downto 0) := "0000";
            C_ON      : bit := '0'; 
            LUT_INIT  : bit_vector(15 downto 0) := X"0000";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_carryin       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_clk            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_clkb           : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in0            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in1            : VitalDelayType01 := (0 ns, 0 ns);
			tipd_in2            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in3            : VitalDelayType01 := (0 ns, 0 ns);
			tipd_sr            : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_carryin_carryout : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_carryout      : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_carryout      : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_in0_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_in3_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_clk_lcout_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_clk_lcout : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_sr_lcout : VitalDelayType01 := (0.000 ns, 0.000 ns);
			-- VITAL recovery time variables
            trecovery_sr_clk_posedge_posedge : VitalDelayType := 0 ns;
            trecovery_sr_clk_negedge_posedge : VitalDelayType := 0 ns;
            -- VITAL removal time variables
            tremoval_sr_clk_posedge_posedge : VitalDelayType := 0 ns;
            tremoval_sr_clk_negedge_posedge : VitalDelayType := 0 ns;
            --- VITAL setup time
			tsetup_in0_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in0_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in1_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in1_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in2_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in2_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in3_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in3_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_sr_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_sr_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            --- VITAL hold time 
			thold_in0_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in0_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in1_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in1_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_in2_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in2_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_in3_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in3_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_sr_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_sr_clk_posedge_posedge    : VitalDelayType                   := 0 ns
			) ;
  port(
    carryout: out std_logic;
    lcout   : out std_logic;
    carryin : in  std_logic;
    clk      : in  std_logic;
    clkb     : in  std_logic;
    in0      : in  std_logic;
    in1      : in  std_logic;
    in2      : in  std_logic;
    in3      : in  std_logic;
    sr      : in  std_logic
    );
  attribute VITAL_LEVEL0 of
      LogicCell : entity is true;	
end LogicCell;

architecture LogicCell_V of LogicCell is
  attribute VITAL_LEVEL0 of
    LogicCell_V : architecture is true;

  signal g_n_d : std_logic;
  signal cbit  : std_logic_vector(20 downto 0);
  
  signal carryin_ipd : std_ulogic := 'X';
  signal clk_ipd  : std_ulogic := 'X';
  signal clkb_ipd  : std_ulogic := 'X';
  signal in0_ipd   : std_ulogic := 'X';
  signal in1_ipd : std_ulogic := 'X';
  signal in2_ipd  : std_ulogic := 'X';
  signal in3_ipd  : std_ulogic := 'X';
  signal sr_ipd : std_ulogic;   
  
  signal carryout_zd : std_ulogic := 'X';
  signal lcout_zd : std_ulogic := 'X';
	
  signal Violation : std_ulogic;
begin
  WireDelay   : block
        begin
          VitalWireDelay (carryin_ipd, carryin, tipd_carryin);
          VitalWireDelay (clk_ipd, clk, tipd_clk);
          VitalWireDelay (clkb_ipd, clkb, tipd_clkb);
          VitalWireDelay (in0_ipd, in0, tipd_in0);
		  VitalWireDelay (in1_ipd, in1, tipd_in1);
          VitalWireDelay (in2_ipd, in2, tipd_in2);
          VitalWireDelay (in3_ipd, in3, tipd_in3);
		  VitalWireDelay (sr_ipd, sr, tipd_sr);
        end block;
-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------		
  cbit <= To_StdLogicVector(C_ON & SEQ_MODE & LUT_INIT);
  g_n_d <= '0';
  
  LC : logic_cell
  port map(
     carry_out => carryout_zd,
     lc_out    => lcout_zd,
 
     carry_in  => carryin_ipd,
     clk       => clk_ipd,
     clkb      => clkb_ipd,
     in0       => in0_ipd,
     in1       => in1_ipd,
     in2       => in2_ipd,
     in3       => in3_ipd,
     prog      => g_n_d,
     purst     => g_n_d,
     s_r       => sr_ipd,
     cbit      => cbit
  );
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (clk_ipd, clkb_ipd, in0_ipd, in1_ipd, in2_ipd, in3_ipd, sr_ipd)
    variable Tviol_in0_clk_posedge    : std_ulogic := '0';
    variable Tviol_in1_clk_posedge    : std_ulogic := '0';
    variable Tviol_in2_clk_posedge    : std_ulogic := '0';
    variable Tviol_in3_clk_posedge    : std_ulogic := '0';
    variable Tviol_sr_clk_posedge    : std_ulogic := '0';

    variable Tmkr_in0_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in1_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in2_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in3_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_sr_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_in0_clk_posedge,
        TimingData     => Tmkr_in0_clk_posedge,
        TestSignal     => in0_ipd,
        TestSignalName => "in0",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in0_clk_posedge_posedge,
        SetupLow       => tsetup_in0_clk_negedge_posedge,
        HoldLow        => thold_in0_clk_negedge_posedge,
        HoldHigh       => thold_in0_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_in1_clk_posedge,
        TimingData     => Tmkr_in1_clk_posedge,
        TestSignal     => in1_ipd,
        TestSignalName => "in1",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in1_clk_posedge_posedge,
        SetupLow       => tsetup_in1_clk_negedge_posedge,
        HoldLow        => thold_in1_clk_negedge_posedge,
        HoldHigh       => thold_in1_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_in2_clk_posedge,
        TimingData     => Tmkr_in2_clk_posedge,
        TestSignal     => in2_ipd,
        TestSignalName => "in2",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in2_clk_posedge_posedge,
        SetupLow       => tsetup_in2_clk_negedge_posedge,
        HoldLow        => thold_in2_clk_negedge_posedge,
        HoldHigh       => thold_in2_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_in3_clk_posedge,
        TimingData     => Tmkr_in3_clk_posedge,
        TestSignal     => in3_ipd,
        TestSignalName => "in3",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in3_clk_posedge_posedge,
        SetupLow       => tsetup_in3_clk_negedge_posedge,
        HoldLow        => thold_in3_clk_negedge_posedge,
        HoldHigh       => thold_in3_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_sr_clk_posedge,
        TimingData     => Tmkr_sr_clk_posedge,
        TestSignal     => sr_ipd,
        TestSignalName => "sr",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_sr_clk_posedge_posedge,
        SetupLow       => tsetup_sr_clk_negedge_posedge,
        HoldLow        => thold_sr_clk_negedge_posedge,
        HoldHigh       => thold_sr_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (carryin_ipd, clk_ipd, in0_ipd, in1_ipd, in2_ipd, in3_ipd, sr_ipd, carryout_zd, lcout_zd)
    variable carryout_GlitchData : VitalGlitchDataType;
	variable lcout_GlitchData : VitalGlitchDataType;

  begin

  VitalPathDelay01 (
      OutSignal                 => carryout,
      GlitchData                => carryout_GlitchData,
      OutSignalName             => "carryout",
      OutTemp                   => carryout_zd,
      Paths                     => (0 => (carryin_ipd'last_event, tpd_carryin_carryout, true),
                                    1 => (in1_ipd'last_event, tpd_in1_carryout, true),
									2 => (in2_ipd'last_event, tpd_in2_carryout, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => lcout,
      GlitchData                => lcout_GlitchData,
      OutSignalName             => "lcout",
      OutTemp                   => lcout_zd,
      Paths                     => (0 => (in0_ipd'last_event, tpd_in0_lcout, true),
									1 => (in1_ipd'last_event, tpd_in1_lcout, true),
									2 => (in2_ipd'last_event, tpd_in2_lcout, true),
									3 => (in3_ipd'last_event, tpd_in3_lcout, true),
									4 => (clk_ipd'last_event, tpd_clk_lcout_posedge, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  end process VITALPathDelay;

end LogicCell_V;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
library WORK;
use WORK.vcomponent_vital.all;

entity LogicCell2 is
  generic ( SEQ_MODE  : bit_vector(3 downto 0) := "0000";
            C_ON      : bit := '0'; 
            LUT_INIT  : bit_vector(15 downto 0) := X"0000";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_carryin       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_clk            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in0            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in1            : VitalDelayType01 := (0 ns, 0 ns);
			tipd_in2            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in3            : VitalDelayType01 := (0 ns, 0 ns);
			tipd_sr            : VitalDelayType01 := (0 ns, 0 ns);
			tipd_ce            : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_carryin_carryout : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_carryout      : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_carryout      : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_in0_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_in3_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_clk_lcout_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_clk_lcout : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_sr_lcout : VitalDelayType01 := (0.000 ns, 0.000 ns);
			-- VITAL recovery time variables
            trecovery_sr_clk_posedge_posedge : VitalDelayType := 0 ns;
            trecovery_sr_clk_negedge_posedge : VitalDelayType := 0 ns;
            -- VITAL removal time variables
            tremoval_sr_clk_posedge_posedge : VitalDelayType := 0 ns;
            tremoval_sr_clk_negedge_posedge : VitalDelayType := 0 ns;
            --- VITAL setup time
			tsetup_in0_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_ce_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_ce_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in0_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in1_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in1_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in2_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in2_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in3_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in3_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_sr_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_sr_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            --- VITAL hold time 
			thold_ce_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_ce_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in0_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in0_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in1_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in1_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_in2_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in2_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_in3_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_in3_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_sr_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
			thold_sr_clk_posedge_posedge    : VitalDelayType                   := 0 ns
			) ;
  port(
    carryout: out std_logic;
    lcout   : out std_logic;
    carryin : in  std_logic;
    clk      : in  std_logic;
    in0      : in  std_logic;
    in1      : in  std_logic;
    in2      : in  std_logic;
    in3      : in  std_logic;
    sr      : in  std_logic;
    ce      : in  std_logic :='H'
    );
  attribute VITAL_LEVEL0 of
      LogicCell2 : entity is true;	
end LogicCell2;

architecture LogicCell2_V of LogicCell2 is
  attribute VITAL_LEVEL0 of
    LogicCell2_V : architecture is true;

  signal g_n_d : std_logic;
  signal cbit  : std_logic_vector(20 downto 0);
  
  signal carryin_ipd : std_ulogic := 'X';
  signal clk_ipd  : std_ulogic := 'X';
  signal ce_ipd  : std_ulogic := 'X';
  signal in0_ipd   : std_ulogic := 'X';
  signal in1_ipd : std_ulogic := 'X';
  signal in2_ipd  : std_ulogic := 'X';
  signal in3_ipd  : std_ulogic := 'X';
  signal sr_ipd : std_ulogic;   
  
  signal carryout_zd : std_ulogic := 'X';
  signal lcout_zd : std_ulogic := 'X';
	
  signal Violation : std_ulogic;
begin
  WireDelay   : block
        begin
          VitalWireDelay (carryin_ipd, carryin, tipd_carryin);
          VitalWireDelay (clk_ipd, clk, tipd_clk);
          VitalWireDelay (in0_ipd, in0, tipd_in0);
		  VitalWireDelay (in1_ipd, in1, tipd_in1);
          VitalWireDelay (in2_ipd, in2, tipd_in2);
          VitalWireDelay (in3_ipd, in3, tipd_in3);
		  VitalWireDelay (sr_ipd, sr, tipd_sr);
		  VitalWireDelay (ce_ipd, ce, tipd_ce);
		end block;
-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------		
  cbit <= To_StdLogicVector(C_ON & SEQ_MODE & LUT_INIT);
  g_n_d <= '0';
  
  LC : logic_cell2
  port map(
     carry_out => carryout_zd,
     lc_out    => lcout_zd,
 
     carry_in  => carryin_ipd,
     clk       => clk_ipd,
     clkb      => g_n_d,
     in0       => in0_ipd,
     in1       => in1_ipd,
     in2       => in2_ipd,
     in3       => in3_ipd,
     prog      => g_n_d,
     purst     => g_n_d,
     s_r       => sr_ipd,
     cbit      => cbit,
     ce        => ce_ipd
  );
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (clk_ipd, ce_ipd, in0_ipd, in1_ipd, in2_ipd, in3_ipd, sr_ipd)
    variable Tviol_in0_clk_posedge    : std_ulogic := '0';
    variable Tviol_in1_clk_posedge    : std_ulogic := '0';
    variable Tviol_in2_clk_posedge    : std_ulogic := '0';
    variable Tviol_in3_clk_posedge    : std_ulogic := '0';
    variable Tviol_sr_clk_posedge    : std_ulogic := '0';
	variable Tviol_ce_clk_posedge    : std_ulogic := '0';
   
    variable Tmkr_in0_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in1_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in2_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in3_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_sr_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ce_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_in0_clk_posedge,
        TimingData     => Tmkr_in0_clk_posedge,
        TestSignal     => in0_ipd,
        TestSignalName => "in0",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in0_clk_posedge_posedge,
        SetupLow       => tsetup_in0_clk_negedge_posedge,
        HoldLow        => thold_in0_clk_negedge_posedge,
        HoldHigh       => thold_in0_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_in1_clk_posedge,
        TimingData     => Tmkr_in1_clk_posedge,
        TestSignal     => in1_ipd,
        TestSignalName => "in1",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in1_clk_posedge_posedge,
        SetupLow       => tsetup_in1_clk_negedge_posedge,
        HoldLow        => thold_in1_clk_negedge_posedge,
        HoldHigh       => thold_in1_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_in2_clk_posedge,
        TimingData     => Tmkr_in2_clk_posedge,
        TestSignal     => in2_ipd,
        TestSignalName => "in2",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in2_clk_posedge_posedge,
        SetupLow       => tsetup_in2_clk_negedge_posedge,
        HoldLow        => thold_in2_clk_negedge_posedge,
        HoldHigh       => thold_in2_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_in3_clk_posedge,
        TimingData     => Tmkr_in3_clk_posedge,
        TestSignal     => in3_ipd,
        TestSignalName => "in3",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in3_clk_posedge_posedge,
        SetupLow       => tsetup_in3_clk_negedge_posedge,
        HoldLow        => thold_in3_clk_negedge_posedge,
        HoldHigh       => thold_in3_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_sr_clk_posedge,
        TimingData     => Tmkr_sr_clk_posedge,
        TestSignal     => sr_ipd,
        TestSignalName => "sr",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_sr_clk_posedge_posedge,
        SetupLow       => tsetup_sr_clk_negedge_posedge,
        HoldLow        => thold_sr_clk_negedge_posedge,
        HoldHigh       => thold_sr_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

      VitalSetupHoldCheck (
        Violation      => Tviol_ce_clk_posedge,
        TimingData     => Tmkr_ce_clk_posedge,
        TestSignal     => ce_ipd,
        TestSignalName => "ce",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_ce_clk_posedge_posedge,
        SetupLow       => tsetup_ce_clk_negedge_posedge,
        HoldLow        => thold_ce_clk_negedge_posedge,
        HoldHigh       => thold_ce_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (carryin_ipd, clk_ipd, ce_ipd, in0_ipd, in1_ipd, in2_ipd, in3_ipd, sr_ipd, carryout_zd, lcout_zd)
    variable carryout_GlitchData : VitalGlitchDataType;
	variable lcout_GlitchData : VitalGlitchDataType;

  begin

  VitalPathDelay01 (
      OutSignal                 => carryout,
      GlitchData                => carryout_GlitchData,
      OutSignalName             => "carryout",
      OutTemp                   => carryout_zd,
      Paths                     => (0 => (carryin_ipd'last_event, tpd_carryin_carryout, true),
                                    1 => (in1_ipd'last_event, tpd_in1_carryout, true),
									2 => (in2_ipd'last_event, tpd_in2_carryout, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => lcout,
      GlitchData                => lcout_GlitchData,
      OutSignalName             => "lcout",
      OutTemp                   => lcout_zd,
      Paths                     => (0 => (in0_ipd'last_event, tpd_in0_lcout, true),
									1 => (in1_ipd'last_event, tpd_in1_lcout, true),
									2 => (in2_ipd'last_event, tpd_in2_lcout, true),
									3 => (in3_ipd'last_event, tpd_in3_lcout, true),
									4 => (clk_ipd'last_event, tpd_clk_lcout_posedge, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  end process VITALPathDelay;

end LogicCell2_V;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
library WORK;
use WORK.vcomponent_vital.all;

entity LogicCell40 is
  generic ( SEQ_MODE  : bit_vector(3 downto 0) := "0000";
            C_ON      : bit := '0'; 
            LUT_INIT  : bit_vector(15 downto 0) := X"0000";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
	    tipd_carryin       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_clk            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in0            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in1            : VitalDelayType01 := (0 ns, 0 ns);
	    tipd_in2            : VitalDelayType01 := (0 ns, 0 ns);
            tipd_in3            : VitalDelayType01 := (0 ns, 0 ns);
	    tipd_sr            : VitalDelayType01 := (0 ns, 0 ns);
	    tipd_ce            : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_carryin_carryout : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_carryout      : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_carryout      : VitalDelayType01 := (0.000 ns, 0.000 ns);
	    tpd_in0_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
	    tpd_in3_lcout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
  	    
 	    tpd_in0_ltout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in1_ltout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_in2_ltout         : VitalDelayType01 := (0.000 ns, 0.000 ns);
	    tpd_in3_ltout         : VitalDelayType01 := (0.000 ns, 0.000 ns); 	
    	    
	    --  VITAL clk-to-output path delay
	    tpd_clk_lcout_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
	    tpd_clk_lcout : VitalDelayType01 := (0.000 ns, 0.000 ns);
	    tpd_sr_lcout : VitalDelayType01 := (0.000 ns, 0.000 ns);
			-- VITAL recovery time variables
            trecovery_sr_clk_posedge_posedge : VitalDelayType := 0 ns;
            trecovery_sr_clk_negedge_posedge : VitalDelayType := 0 ns;
            -- VITAL removal time variables
            tremoval_sr_clk_posedge_posedge : VitalDelayType := 0 ns;
            tremoval_sr_clk_negedge_posedge : VitalDelayType := 0 ns;
            --- VITAL setup time
	    tsetup_in0_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_ce_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_ce_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in0_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in1_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in1_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in2_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in2_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in3_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_in3_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_sr_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_sr_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
            --- VITAL hold time 
	    thold_ce_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_ce_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_in0_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_in0_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_in1_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_in1_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_in2_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_in2_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_in3_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_in3_clk_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_sr_clk_negedge_posedge    : VitalDelayType                   := 0 ns;
	    thold_sr_clk_posedge_posedge    : VitalDelayType                   := 0 ns
			) ;
  port(
    carryout: out std_logic;
    lcout   : out std_logic;
    ltout   : out std_logic;  
    carryin : in  std_logic;
    clk      : in  std_logic;
    in0      : in  std_logic;
    in1      : in  std_logic;
    in2      : in  std_logic;
    in3      : in  std_logic;
    sr      : in  std_logic;
    ce      : in  std_logic :='H'
    );
  attribute VITAL_LEVEL0 of
      LogicCell40 : entity is true;	
end LogicCell40;

architecture LogicCell40_V of LogicCell40 is
  attribute VITAL_LEVEL0 of
    LogicCell40_V : architecture is true;

  signal g_n_d : std_logic;
  signal cbit  : std_logic_vector(20 downto 0);
  
  signal carryin_ipd : std_ulogic := 'X';
  signal clk_ipd  : std_ulogic := 'X';
  signal ce_ipd  : std_ulogic := 'X';
  signal in0_ipd   : std_ulogic := 'X';
  signal in1_ipd : std_ulogic := 'X';
  signal in2_ipd  : std_ulogic := 'X';
  signal in3_ipd  : std_ulogic := 'X';
  signal sr_ipd : std_ulogic;   
  
  signal carryout_zd : std_ulogic := 'X';
  signal lcout_zd : std_ulogic := 'X';
  signal ltout_zd : std_ulogic := 'X';    
	
  signal Violation : std_ulogic;
begin
  WireDelay   : block
        begin
          VitalWireDelay (carryin_ipd, carryin, tipd_carryin);
          VitalWireDelay (clk_ipd, clk, tipd_clk);
          VitalWireDelay (in0_ipd, in0, tipd_in0);
	  VitalWireDelay (in1_ipd, in1, tipd_in1);
          VitalWireDelay (in2_ipd, in2, tipd_in2);
          VitalWireDelay (in3_ipd, in3, tipd_in3);
	  VitalWireDelay (sr_ipd, sr, tipd_sr);
	  VitalWireDelay (ce_ipd, ce, tipd_ce);
	end block;
-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------		
  cbit <= To_StdLogicVector(C_ON & SEQ_MODE & LUT_INIT);
  g_n_d <= '0';
  
  LC : logic_cell40
  port map(
     carry_out => carryout_zd,
     lc_out    => lcout_zd,
     lt_out    => ltout_zd,	

     carry_in  => carryin_ipd,
     clk       => clk_ipd,
     clkb      => g_n_d,
     in0       => in0_ipd,
     in1       => in1_ipd,
     in2       => in2_ipd,
     in3       => in3_ipd,
     prog      => g_n_d,
     purst     => g_n_d,
     s_r       => sr_ipd,
     cbit      => cbit,
     ce        => ce_ipd
  );
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (clk_ipd, ce_ipd, in0_ipd, in1_ipd, in2_ipd, in3_ipd, sr_ipd)
    variable Tviol_in0_clk_posedge    : std_ulogic := '0';
    variable Tviol_in1_clk_posedge    : std_ulogic := '0';
    variable Tviol_in2_clk_posedge    : std_ulogic := '0';
    variable Tviol_in3_clk_posedge    : std_ulogic := '0';
    variable Tviol_sr_clk_posedge     : std_ulogic := '0';
    variable Tviol_ce_clk_posedge     : std_ulogic := '0';
   
    variable Tmkr_in0_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in1_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in2_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_in3_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_sr_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_ce_clk_posedge     : VitalTimingDataType := VitalTimingDataInit;	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_in0_clk_posedge,
        TimingData     => Tmkr_in0_clk_posedge,
        TestSignal     => in0_ipd,
        TestSignalName => "in0",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in0_clk_posedge_posedge,
        SetupLow       => tsetup_in0_clk_negedge_posedge,
        HoldLow        => thold_in0_clk_negedge_posedge,
        HoldHigh       => thold_in0_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
      VitalSetupHoldCheck (
        Violation      => Tviol_in1_clk_posedge,
        TimingData     => Tmkr_in1_clk_posedge,
        TestSignal     => in1_ipd,
        TestSignalName => "in1",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in1_clk_posedge_posedge,
        SetupLow       => tsetup_in1_clk_negedge_posedge,
        HoldLow        => thold_in1_clk_negedge_posedge,
        HoldHigh       => thold_in1_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_in2_clk_posedge,
        TimingData     => Tmkr_in2_clk_posedge,
        TestSignal     => in2_ipd,
        TestSignalName => "in2",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in2_clk_posedge_posedge,
        SetupLow       => tsetup_in2_clk_negedge_posedge,
        HoldLow        => thold_in2_clk_negedge_posedge,
        HoldHigh       => thold_in2_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_in3_clk_posedge,
        TimingData     => Tmkr_in3_clk_posedge,
        TestSignal     => in3_ipd,
        TestSignalName => "in3",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_in3_clk_posedge_posedge,
        SetupLow       => tsetup_in3_clk_negedge_posedge,
        HoldLow        => thold_in3_clk_negedge_posedge,
        HoldHigh       => thold_in3_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_sr_clk_posedge,
        TimingData     => Tmkr_sr_clk_posedge,
        TestSignal     => sr_ipd,
        TestSignalName => "sr",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_sr_clk_posedge_posedge,
        SetupLow       => tsetup_sr_clk_negedge_posedge,
        HoldLow        => thold_sr_clk_negedge_posedge,
        HoldHigh       => thold_sr_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

      VitalSetupHoldCheck (
        Violation      => Tviol_ce_clk_posedge,
        TimingData     => Tmkr_ce_clk_posedge,
        TestSignal     => ce_ipd,
        TestSignalName => "ce",
        RefSignal      => clk_ipd,
        RefSignalName  => "clk",
        SetupHigh      => tsetup_ce_clk_posedge_posedge,
        SetupLow       => tsetup_ce_clk_negedge_posedge,
        HoldLow        => thold_ce_clk_negedge_posedge,
        HoldHigh       => thold_ce_clk_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/LogicCell",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (carryin_ipd, clk_ipd, ce_ipd, in0_ipd, in1_ipd, in2_ipd, in3_ipd, sr_ipd, carryout_zd, ltout_zd,lcout_zd )
    variable carryout_GlitchData : VitalGlitchDataType;
    variable ltout_GlitchData : VitalGlitchDataType;
    variable lcout_GlitchData : VitalGlitchDataType;

  begin

  VitalPathDelay01 (
      OutSignal                 => carryout,
      GlitchData                => carryout_GlitchData,
      OutSignalName             => "carryout",
      OutTemp                   => carryout_zd,
      Paths                     => (0 => (carryin_ipd'last_event, tpd_carryin_carryout, true),
                                    1 => (in1_ipd'last_event, tpd_in1_carryout, true),
									2 => (in2_ipd'last_event, tpd_in2_carryout, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  VitalPathDelay01 (
      OutSignal                 => lcout,
      GlitchData                => lcout_GlitchData,
      OutSignalName             => "lcout",
      OutTemp                   => lcout_zd,
      Paths                     => (0 => (in0_ipd'last_event, tpd_in0_lcout, true),
			  	    1 => (in1_ipd'last_event, tpd_in1_lcout, true),
				    2 => (in2_ipd'last_event, tpd_in2_lcout, true),
				    3 => (in3_ipd'last_event, tpd_in3_lcout, true),
				    4 => (clk_ipd'last_event, tpd_clk_lcout_posedge, true)
				   ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);

   -- ltout path delay section 
  VitalPathDelay01 (
      OutSignal                 => ltout,
      GlitchData                => ltout_GlitchData,
      OutSignalName             => "ltout",
      OutTemp                   => ltout_zd,
      Paths                     => (0 => (in0_ipd'last_event, tpd_in0_ltout, true),
				    1 => (in1_ipd'last_event, tpd_in1_ltout, true),
				    2 => (in2_ipd'last_event, tpd_in2_ltout, true),
				    3 => (in3_ipd'last_event, tpd_in3_ltout, true)
				   ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);       

  end process VITALPathDelay;

end LogicCell40_V;

----- CELL INV -----
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;

entity INV is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;
   
      tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)
    );
  port(
    O : out std_logic;
    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    INV : entity is true;
end INV;

architecture INV_V of INV is
  attribute VITAL_LEVEL0 of
    INV_V : architecture is true;

  signal I_ipd : std_ulogic := 'X';
begin
  WireDelay : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  VITALBehavior           : process (I_ipd)
    
      variable O_zd         : std_ulogic;
      variable O_GlitchData : VitalGlitchDataType;
    begin    
    O_zd := (not I_ipd);
    VitalPathDelay01 (
      OutSignal     => O,
      GlitchData    => O_GlitchData,
      OutSignalName => "O",
      OutTemp       => O_zd,
      Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
  end process;
end INV_V;

----- CELL AND2 -----
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;

entity AND2 is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

      tipd_A : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B : VitalDelayType01 := (0.000 ns, 0.000 ns);

      tpd_A_O : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_B_O : VitalDelayType01 := (0.000 ns, 0.000 ns)
    );
  port(
    O : out std_logic;

    A : in std_logic;
    B : in std_logic
    );
  attribute VITAL_LEVEL0 of
    AND2 : entity is true;
end AND2;
architecture AND2_V of AND2 is
  attribute VITAL_LEVEL0 of
    AND2_V : architecture is true;

  signal A_ipd : std_ulogic := 'X';
  signal B_ipd : std_ulogic := 'X';
begin
  WireDelay     : block
  begin
    VitalWireDelay (A_ipd, A, tipd_A);
    VitalWireDelay (B_ipd, B, tipd_B);
  end block;

  VITALBehavior           : process (A_ipd, B_ipd)
    variable O_zd         : std_ulogic;
    variable O_GlitchData : VitalGlitchDataType;
  begin
    O_zd := A_ipd and B_ipd;
    VitalPathDelay01 (
      OutSignal     => O,
      GlitchData    => O_GlitchData,
      OutSignalName => "O",
      OutTemp       => O_zd,
      Paths         => (0 => (A_ipd'last_event, tpd_A_O, true),
                        1 => (B_ipd'last_event, tpd_B_O, true)
						),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
  end process;
end AND2_V;

----- CELL logic_cell -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library WORK;
use WORK.vcomponent_vital.all;
entity logic_cell is
  port(
    carry_out : out std_logic;
    lc_out    : out std_logic;

    carry_in :  in std_logic;
    clk      :  in std_logic;
    clkb     :  in std_logic;
    in0      :  in std_logic;
    in1      :  in std_logic;
    in2      :  in std_logic;
    in3      :  in std_logic;
    prog     :  in std_logic;
    purst    :  in std_logic;
    s_r      :  in std_logic;
    cbit     :  in std_logic_vector(20 downto 0)
    );
end logic_cell;

architecture logic_cell_V of logic_cell is
    
    signal LUT4_outd : std_logic;
    signal rego  : std_logic;
    signal in0b1 : std_logic;
    signal in1b1 : std_logic;
    signal in2b1 : std_logic;
    signal in3b1 : std_logic;
begin
  REG : coredffr
  port map(
    q => rego,
    d => LUT4_outd,
    purst => purst,
    S_R =>s_r,
    clk => clk,
    clkb => clkb,
    cbit => cbit(17 downto 16)
  );
  ICARRY_LOGIC : carry_logic
  port map(
    cout => carry_out,

    carry_in => carry_in,
    a => in2,
    a_bar => in2b1,
    b => in1,
    b_bar => in1b1,
    vg_en => cbit(20)
  );
  Iomux : o_mux
  port map(
    O => lc_out,

    in0 => LUT4_outd,
    in1 => rego,
    cbit => cbit(19),
    prog => prog
  );
  iclut4 : clut4
  port map(
    lut4 => LUT4_outd,

    in0 => in0,
    in1 => in1,
    in2 => in2,
    in3 => in3,
    in0b => in0b1,
    in1b => in1b1,
    in2b => in2b1,
    in3b => in3b1,
    cbit => cbit(15 downto 0)
  );
  I161 : inv_hvt
  port map(
    O => in0b1,

    I => in0
  );
  I162 : inv_hvt
  port map(
    O => in1b1,

    I => in1
  );
  I163 : inv_hvt
  port map(
    O => in2b1,

    I => in2
  );
  I164 : inv_hvt
  port map(
    O => in3b1,

    I => in3
  );    
end logic_cell_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library WORK;
use WORK.vcomponent_vital.all;

entity logic_cell2 is
  port(
    carry_out : out std_logic;
    lc_out    : out std_logic;

    carry_in :  in std_logic;
    clk      :  in std_logic;
    clkb     :  in std_logic;
    in0      :  in std_logic;
    in1      :  in std_logic;
    in2      :  in std_logic;
    in3      :  in std_logic;
    prog     :  in std_logic;
    purst    :  in std_logic;
    s_r      :  in std_logic;
    cbit     :  in std_logic_vector(20 downto 0);
    ce       :  in std_logic
    );
end logic_cell2;

architecture logic_cell2_V of logic_cell2 is
    
    signal LUT4_outd : std_logic;
    signal rego  : std_logic;
    signal in0b1 : std_logic;
    signal in1b1 : std_logic;
    signal in2b1 : std_logic;
    signal in3b1 : std_logic;
begin
  REG : coredffr2
  port map(
    q => rego,
    d => LUT4_outd,
    purst => purst,
    S_R =>s_r,
    clk => clk,
    clkb => clkb,
    cbit => cbit(17 downto 16),
    ce => ce
  );
  ICARRY_LOGIC : carry_logic
  port map(
    cout => carry_out,

    carry_in => carry_in,
    a => in2,
    a_bar => in2b1,
    b => in1,
    b_bar => in1b1,
    vg_en => cbit(20)
  );
  Iomux : o_mux
  port map(
    O => lc_out,

    in0 => LUT4_outd,
    in1 => rego,
    cbit => cbit(19),
    prog => prog
  );
  iclut4 : clut4
  port map(
    lut4 => LUT4_outd,

    in0 => in0,
    in1 => in1,
    in2 => in2,
    in3 => in3,
    in0b => in0b1,
    in1b => in1b1,
    in2b => in2b1,
    in3b => in3b1,
    cbit => cbit(15 downto 0)
  );
  I161 : inv_hvt
  port map(
    O => in0b1,

    I => in0
  );
  I162 : inv_hvt
  port map(
    O => in1b1,

    I => in1
  );
  I163 : inv_hvt
  port map(
    O => in2b1,

    I => in2
  );
  I164 : inv_hvt
  port map(
    O => in3b1,

    I => in3
  );    
end logic_cell2_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library WORK;
use WORK.vcomponent_vital.all;

entity logic_cell40 is
  port(
    carry_out : out std_logic;
    lc_out    : out std_logic;
    lt_out    : out std_logic;   	

    carry_in :  in std_logic;
    clk      :  in std_logic;
    clkb     :  in std_logic;
    in0      :  in std_logic;
    in1      :  in std_logic;
    in2      :  in std_logic;
    in3      :  in std_logic;
    prog     :  in std_logic;
    purst    :  in std_logic;
    s_r      :  in std_logic;
    cbit     :  in std_logic_vector(20 downto 0);
    ce       :  in std_logic
    );
end logic_cell40;

architecture logic_cell40_V of logic_cell40 is
    
    signal LUT4_outd : std_logic;
    signal rego  : std_logic;
    signal in0b1 : std_logic;
    signal in1b1 : std_logic;
    signal in2b1 : std_logic;
    signal in3b1 : std_logic;
begin
  REG : coredffr2
  port map(
    q => rego,
    d => LUT4_outd,
    purst => purst,
    S_R =>s_r,
    clk => clk,
    clkb => clkb,
    cbit => cbit(17 downto 16),
    ce => ce
  );
  ICARRY_LOGIC : carry_logic
  port map(
    cout => carry_out,

    carry_in => carry_in,
    a => in2,
    a_bar => in2b1,
    b => in1,
    b_bar => in1b1,
    vg_en => cbit(20)
  );
  Iomux : o_mux
  port map(
    O => lc_out,

    in0 => LUT4_outd,
    in1 => rego,
    cbit => cbit(19),
    prog => prog
  );
  iclut4 : clut4
  port map(
    lut4 => LUT4_outd,

    in0 => in0,
    in1 => in1,
    in2 => in2,
    in3 => in3,
    in0b => in0b1,
    in1b => in1b1,
    in2b => in2b1,
    in3b => in3b1,
    cbit => cbit(15 downto 0)
  );
  I161 : inv_hvt
  port map(
    O => in0b1,

    I => in0
  );
  I162 : inv_hvt
  port map(
    O => in1b1,

    I => in1
  );
  I163 : inv_hvt
  port map(
    O => in2b1,

    I => in2
  );
  I164 : inv_hvt
  port map(
    O => in3b1,

    I => in3
  );    

 lt_out <= LUT4_outd;  

end logic_cell40_V;

----- CELL inv_hvt -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity inv_hvt is
  port(
    O : out std_logic;

    I : in std_logic
    );
end inv_hvt;

architecture inv_hvt_V of inv_hvt is
begin
  O <= (not TO_X01(I));
end inv_hvt_V;

----- CELL coredffr -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity coredffr is
  port(
    q       : out std_logic;

    d       : in std_logic;
    purst   : in std_logic;
    S_R     : in std_logic;
    cbit    : in std_logic_vector(1 downto 0);
    clk     : in std_logic;
    clkb    : in std_logic
    );
end coredffr;

architecture coredffr_V of coredffr is
  signal qint    : std_logic:= '0';
  signal intasr  : std_logic;
begin
  intasr <= purst or (s_r and cbit(1));
  q <= qint when (purst xor S_R xor cbit(0) xor cbit(1))='1' or (purst xor S_R xor cbit(0) xor cbit(1))='0' else
     'X';
  process(intasr,clk)
    begin
      if(rising_edge(intasr) or rising_edge(clk)) then
          if(S_R='1' and (cbit="11")) then
              qint <= '1';
          elsif((purst = '0') and S_R = '1' and (cbit="10")) then
              qint <= '0';
          elsif(purst = '1' and (S_R = '0')) then
              qint <= '0';
          elsif((purst = '0') and S_R = '1' and (cbit="00")) then
              qint <= '0';
          elsif((purst = '0') and S_R = '1' and (cbit="01")) then
              qint <= '1';
          elsif((purst = '0') and (S_R = '0')) then
              qint <= d;
          end if;
  end if;
  end process;
end coredffr_V;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity coredffr2 is
  port(
    q       : out std_logic;
    d       : in std_logic;
    purst   : in std_logic;
    S_R     : in std_logic;
    cbit    : in std_logic_vector(1 downto 0);
    clk     : in std_logic;
    clkb    : in std_logic;
    ce    :   in std_logic
    );
end coredffr2;

architecture coredffr2_V of coredffr2 is
  signal qint    : std_logic:= '0';
  signal intasr  : std_logic;
begin
  intasr <= purst or (s_r and cbit(1));
  q <= qint when (purst xor S_R xor cbit(0) xor cbit(1))='1' or (purst xor S_R xor cbit(0) xor cbit(1))='0' else
     'X';
  process(intasr,clk)
    begin
      if( (intasr'event and intasr='1')  or rising_edge(clk)) then
          if(S_R='1' and (cbit="11")) then
              qint <= '1';
          elsif((purst = '0') and S_R = '1' and (cbit="10")) then
              qint <= '0';
          elsif(purst = '1' and (S_R = '0')) then
              qint <= '0';
          elsif((purst = '0') and S_R = '1' and (cbit="00")) then
              qint <= '0';
          elsif((purst = '0') and S_R = '1' and (cbit="01")) then
              qint <= '1';
          elsif((purst = '0') and (S_R = '0') and (ce = '1' or ce = 'H') ) then
              qint <= d;
          end if;
  end if;
  end process;
end coredffr2_V;


----- CELL clut4 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use WORK.lc_package.all;

entity clut4 is
  port(
    lut4 : out std_logic;

    in0  : in std_logic;
    in1  : in std_logic;
    in2  : in std_logic;
    in3  : in std_logic;
    in0b : in std_logic;
    in1b : in std_logic;
    in2b : in std_logic;
    in3b : in std_logic;
    cbit : in std_logic_vector(15 downto 0)
    );
end clut4;

architecture clut4_V of clut4 is    
	function lut_mux( cbit_in:std_logic_vector; s1:std_logic; s0:std_logic)  return std_logic is 
	variable     d: std_logic_vector(3 downto 0);       		       
	variable  tmp1: std_logic_vector(1 downto 0); 
	begin 
		d:=cbit_in; 
		tmp1 :=TO_STDLOGICVECTOR(s1 & s0);  
		if(((s1 xor s0) = '1') or ((s1 xor s0) = '0')) then 
			return( d(slv_to_integer(tmp1)));
		elsif ( (d(0) xor d(1)) = '0' and (d(2) xor d(3)) = '0' and (d(0) xor d(2)) = '0') then 
			return d(0); 
		elsif ((s1 ='0') and (d(0) = d(1))) then 
			return d(0); 
		elsif ((s1 ='1') and (d(2) = d(3))) then 
			return d(2); 	
		elsif ((s0 ='0') and (d(0) = d(2))) then 
			return d(0); 			 
		elsif ((s0 ='1') and (d(1) = d(3))) then 
			return d(1); 			 
		else 
			return 'X'; 			 	
		end if;       
	end lut_mux;
begin    
  process(in0,in1,in2,in3,in0b,in1b,in2b,in3b,cbit)
    variable INPUTS:std_logic_vector(3 downto 0);
     variable tmp : std_logic;
      begin
	 tmp := (in0 xor in1 xor in2 xor in3);      
         INPUTS := TO_STDLOGICVECTOR(in3 &  in2 & in1 & in0);
         if ((tmp = '0' ) or (tmp = '1'))  then
	        lut4<= cbit(slv_to_integer(INPUTS));  
	  else 	       
		lut4<= lut_mux(TO_STDLOGICVECTOR(lut_mux(cbit(15 downto 12),in1,in0) &
						 lut_mux(cbit(11 downto 8),in1,in0)  &
						 lut_mux(cbit(7 downto 4),in1,in0)   & 
						 lut_mux(cbit(3 downto 0),in1,in0)),in3,in2) ;
          end if;
      end process;
end clut4_V;

------- CELL carry_logic -----
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity carry_logic is
  port(
    cout : out std_logic;

    carry_in  : in std_logic;
    a         : in std_logic;
    a_bar     : in std_logic;
    b         : in std_logic;
    b_bar     : in std_logic;
    vg_en     : in std_logic
    );
end carry_logic;

architecture carry_logic_V of carry_logic is
  signal INPUTS : std_logic_vector(2 downto 0);
begin
  INPUTS <= carry_in & a & b;
  process(vg_en,INPUTS)
    begin
      if(vg_en = '0') then
          cout <= '1';
      elsif(vg_en = '1') then
          case INPUTS is
            when "000"=>cout<= '0';
            when "001"=>cout<= '0';
            when "010"=>cout<= '0';
            when "011"=>cout<= '1';
            when "100"=>cout<= '0';
            when "101"=>cout<= '1';
            when "110"=>cout<= '1';
            when "111"=>cout<= '1';
            when others => cout <= 'X';
          end case;
      else
          cout <= 'X';
      end if;
  end process; 
end carry_logic_V;

--- CELL o_mux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity o_mux is
  port(
    O    : out std_logic;

    in0  : in std_logic;
    in1  : in std_logic;
    cbit : in std_logic;
    prog : in std_logic
    );
end o_mux;

architecture o_mux_V of o_mux is
begin
  process(in0,in1,cbit,prog)
    begin
      if(prog = '1') then
         O <= in1;
      elsif(cbit = '1') then         
         O <= in1 ;
      elsif(prog = '0' and cbit = '0') then         
             O <= in0;
      else
             O <= 'X';
      end if; 
            
  end process;
end o_mux_V;

--***************************************************************
--* clock mux buffer                                            *
--***************************************************************
----- CELL ClkMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;


entity ClkMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    ClkMux : entity is true;  
end ClkMux;

architecture ClkMux_V of ClkMux is
  attribute VITAL_LEVEL0 of
    ClkMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end ClkMux_V;

--***************************************************************
--* s_r mux buffer                                              *
--***************************************************************
----- CELL SRMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;


entity SRMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    SRMux : entity is true;  
end SRMux;

architecture SRMux_V of SRMux is
  attribute VITAL_LEVEL0 of
    SRMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end SRMux_V;

--***************************************************************
--* global to local track mux buffer                            *
--***************************************************************
----- CELL Glb2LocalMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Glb2LocalMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Glb2LocalMux : entity is true;  
end Glb2LocalMux;

architecture Glb2LocalMux_V of Glb2LocalMux is
  attribute VITAL_LEVEL0 of
    Glb2LocalMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end Glb2LocalMux_V;

--***************************************************************/
--* ce mux buffer                                              */
--***************************************************************/
----- CELL CEMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity CEMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    CEMux : entity is true;  
end CEMux;

architecture CEMux_V of CEMux is
  attribute VITAL_LEVEL0 of
    CEMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end CEMux_V;


--***************************************************************
--* DummyBuf buffer                                            *
--***************************************************************
----- CELL DummyBuf -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;


entity DummyBuf is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    DummyBuf : entity is true;  
end DummyBuf;

architecture DummyBuf_V of DummyBuf is
  attribute VITAL_LEVEL0 of
    DummyBuf_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end DummyBuf_V;


--***************************************************************/
--* span12 mux buffer                                              */
--***************************************************************/
----- CELL Span12Mux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic  
    );
  attribute VITAL_LEVEL0 of
    Span12Mux : entity is true;  
end Span12Mux;

architecture Span12Mux_V of Span12Mux is
  attribute VITAL_LEVEL0 of
    Span12Mux_V : architecture is true;

  signal I_ipd : std_logic := 'X';   
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end Span12Mux_V;

--***************************************************************/
--* span12to4 buffer                                              */
--***************************************************************/
----- CELL Sp12to4 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;


entity Sp12to4 is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Sp12to4 : entity is true;  
end Sp12to4;

architecture Sp12to4_V of Sp12to4 is
  attribute VITAL_LEVEL0 of
    Sp12to4_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end Sp12to4_V;

--***************************************************************/
--* odrv4 buffer                                              */
--***************************************************************/
----- CELL Odrv4 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Odrv4 is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Odrv4 : entity is true;  
end Odrv4;

architecture Odrv4_V of Odrv4 is
  attribute VITAL_LEVEL0 of
    Odrv4_V : architecture is true;

  signal I_ipd : std_logic := 'X';   
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Odrv4_V;

--***************************************************************/
--* odrv12 buffer                                              */
--***************************************************************/
----- CELL Odrv12 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Odrv12 is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Odrv12 : entity is true;  
end Odrv12;

architecture Odrv12_V of Odrv12 is
  attribute VITAL_LEVEL0 of
    Odrv12_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Odrv12_V;

--***************************************************************
--* local mux buffer                                            *
--***************************************************************
----- CELL LocalMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity LocalMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    LocalMux : entity is true;  
end LocalMux;

architecture LocalMux_V of LocalMux is
  attribute VITAL_LEVEL0 of
    LocalMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end LocalMux_V;

--***************************************************************
--* span4 mux buffer                                            *
--***************************************************************
----- CELL Span4Mux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux : entity is true;  
end Span4Mux;

architecture Span4Mux_V of Span4Mux is
  attribute VITAL_LEVEL0 of
    Span4Mux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_V;

--***************************************************************
--*  in mux buffer                                              *
--***************************************************************
----- CELL InMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity InMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    InMux : entity is true;  
end InMux;

architecture InMux_V of InMux is
  attribute VITAL_LEVEL0 of
    InMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end InMux_V;

--***************************************************************
--*  ioin mux buffer                                            *
--***************************************************************
----- CELL IoInMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity IoInMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    IoInMux : entity is true;   
end IoInMux;

architecture IoInMux_V of IoInMux is
  attribute VITAL_LEVEL0 of
    IoInMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end IoInMux_V;

--***************************************************************
-- Cascade Mux Buffer 
--***************************************************************
----- CELL CascadeMux-----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity CascadeMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    CascadeMux : entity is true;   
end CascadeMux;

architecture CascadeMux_V of CascadeMux is
  attribute VITAL_LEVEL0 of
    CascadeMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end CascadeMux_V;

--***************************************************************
-- Cascade Buffer 
--***************************************************************
----- CELL CascadeBuf-----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity CascadeBuf is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    CascadeBuf : entity is true;   
end CascadeBuf;

architecture CascadeBuf_V of CascadeBuf is
  attribute VITAL_LEVEL0 of
    CascadeBuf_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end CascadeBuf_V;

--***************************************************************
-- Ip In Mux Buffer
--***************************************************************
----- CELL IpInMux-----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity IpInMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    IpInMux : entity is true;   
end IpInMux;

architecture IpInMux_V of IpInMux is
  attribute VITAL_LEVEL0 of
    IpInMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end IpInMux_V;

--***************************************************************
-- Ip Out Mux Buffer
--***************************************************************
----- CELL IpInMux-----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity IpOutMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    IpOutMux : entity is true;   
end IpOutMux;

architecture IpOutMux_V of IpOutMux is
  attribute VITAL_LEVEL0 of
    IpOutMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end IpOutMux_V;

--***************************************************************
--*global to input of central mux buffer                        *
--***************************************************************
----- CELL gio2CtrlBuf -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity gio2CtrlBuf is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    gio2CtrlBuf : entity is true;  
end gio2CtrlBuf;

architecture gio2CtrlBuf_V of gio2CtrlBuf is
  attribute VITAL_LEVEL0 of
    gio2CtrlBuf_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end gio2CtrlBuf_V;

--***************************************************************
--*The central muxes buffer for global networks                 *
--***************************************************************
----- CELL GlobalMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity GlobalMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    GlobalMux : entity is true;  
end GlobalMux;

architecture GlobalMux_V of GlobalMux is
  attribute VITAL_LEVEL0 of
    GlobalMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end GlobalMux_V;

--***************************************************************
--*The quadrent muxes buffer for global networks                *
--***************************************************************
----- CELL GlobalMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity QuadClkMux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    QuadClkMux : entity is true;  
end QuadClkMux;

architecture QuadClkMux_V of QuadClkMux is
  attribute VITAL_LEVEL0 of
    QuadClkMux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end QuadClkMux_V;

--***************************************************************
--*The column clock control buffer for global networks          *
--***************************************************************
----- CELL GlobalMux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity ColCtrlBuf is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    ColCtrlBuf : entity is true;  
end ColCtrlBuf;

architecture ColCtrlBuf_V of ColCtrlBuf is
  attribute VITAL_LEVEL0 of
    ColCtrlBuf_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end ColCtrlBuf_V;

--***************************************************************
--* span4 mux buffer at IO                                      *
--***************************************************************
----- CELL IoSpan4Mux -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity IoSpan4Mux is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    IoSpan4Mux : entity is true;  
end IoSpan4Mux;

architecture IoSpan4Mux_V of IoSpan4Mux is
  attribute VITAL_LEVEL0 of
    IoSpan4Mux_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end IoSpan4Mux_V;

--***************************************************************/
--* span4 mux buffer and its stubs in vertical direction        */
--***************************************************************/
----- CELL Span4Mux_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_v : entity is true;  
end Span4Mux_v;

architecture Span4Mux_v_V of Span4Mux_v is
  attribute VITAL_LEVEL0 of
    Span4Mux_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_v_V;

----- CELL Span4Mux_s0_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s0_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s0_v : entity is true;  
end Span4Mux_s0_v;

architecture Span4Mux_s0_v_V of Span4Mux_s0_v is
  attribute VITAL_LEVEL0 of
    Span4Mux_s0_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s0_v_V;

----- CELL Span4Mux_s1_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s1_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s1_v : entity is true;  
end Span4Mux_s1_v;

architecture Span4Mux_s1_v_V of Span4Mux_s1_v is
  attribute VITAL_LEVEL0 of
    Span4Mux_s1_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s1_v_V;

----- CELL Span4Mux_s2_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s2_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s2_v : entity is true;  
end Span4Mux_s2_v;

architecture Span4Mux_s2_v_V of Span4Mux_s2_v is
  attribute VITAL_LEVEL0 of
    Span4Mux_s2_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s2_v_V;

----- CELL Span4Mux_s3_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s3_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s3_v : entity is true;  
end Span4Mux_s3_v;

architecture Span4Mux_s3_v_V of Span4Mux_s3_v is
  attribute VITAL_LEVEL0 of
    Span4Mux_s3_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s3_v_V;

--***************************************************************
--* span4 mux buffer and its stubs in horizontal direction      *
--***************************************************************
----- CELL Span4Mux_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_h : entity is true;  
end Span4Mux_h;

architecture Span4Mux_h_V of Span4Mux_h is
  attribute VITAL_LEVEL0 of
    Span4Mux_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_h_V;

----- CELL Span4Mux_s0_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s0_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s0_h : entity is true;  
end Span4Mux_s0_h;

architecture Span4Mux_s0_h_V of Span4Mux_s0_h is
  attribute VITAL_LEVEL0 of
    Span4Mux_s0_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s0_h_V;

----- CELL Span4Mux_s1_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s1_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s1_h : entity is true;  
end Span4Mux_s1_h;

architecture Span4Mux_s1_h_V of Span4Mux_s1_h is
  attribute VITAL_LEVEL0 of
    Span4Mux_s1_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';   
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s1_h_V;

----- CELL Span4Mux_s2_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s2_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s2_h : entity is true;  
end Span4Mux_s2_h;

architecture Span4Mux_s2_h_V of Span4Mux_s2_h is
  attribute VITAL_LEVEL0 of
    Span4Mux_s2_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s2_h_V;

----- CELL Span4Mux_s3_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span4Mux_s3_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span4Mux_s3_h : entity is true;  
end Span4Mux_s3_h;

architecture Span4Mux_s3_h_V of Span4Mux_s3_h is
  attribute VITAL_LEVEL0 of
    Span4Mux_s3_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span4Mux_s3_h_V;

--***************************************************************
--* span12 mux buffer and its stubs in horizontal direction      
--***************************************************************
----- CELL Span12Mux_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_h : entity is true;  
end Span12Mux_h;

architecture Span12Mux_h_V of Span12Mux_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_h_V;

----- CELL Span12Mux_s0_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s0_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s0_h : entity is true;  
end Span12Mux_s0_h;

architecture Span12Mux_s0_h_V of Span12Mux_s0_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s0_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s0_h_V;

----- CELL Span12Mux_s1_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s1_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s1_h : entity is true;  
end Span12Mux_s1_h;

architecture Span12Mux_s1_h_V of Span12Mux_s1_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s1_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s1_h_V;

----- CELL Span12Mux_s2_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s2_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s2_h : entity is true;  
end Span12Mux_s2_h;

architecture Span12Mux_s2_h_V of Span12Mux_s2_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s2_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s2_h_V;

----- CELL Span12Mux_s3_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s3_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s3_h : entity is true;  
end Span12Mux_s3_h;

architecture Span12Mux_s3_h_V of Span12Mux_s3_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s3_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s3_h_V;

----- CELL Span12Mux_s4_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s4_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s4_h : entity is true;  
end Span12Mux_s4_h;

architecture Span12Mux_s4_h_V of Span12Mux_s4_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s4_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s4_h_V;

----- CELL Span12Mux_s5_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s5_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s5_h : entity is true;  
end Span12Mux_s5_h;

architecture Span12Mux_s5_h_V of Span12Mux_s5_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s5_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s5_h_V;

----- CELL Span12Mux_s6_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s6_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s6_h : entity is true;  
end Span12Mux_s6_h;

architecture Span12Mux_s6_h_V of Span12Mux_s6_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s6_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s6_h_V;

----- CELL Span12Mux_s7_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s7_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s7_h : entity is true;  
end Span12Mux_s7_h;

architecture Span12Mux_s7_h_V of Span12Mux_s7_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s7_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s7_h_V;

----- CELL Span12Mux_s8_h -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s8_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s8_h : entity is true;  
end Span12Mux_s8_h;

architecture Span12Mux_s8_h_V of Span12Mux_s8_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s8_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s8_h_V;

----- CELL Span12Mux_s9_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s9_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s9_h : entity is true;  
end Span12Mux_s9_h;

architecture Span12Mux_s9_h_V of Span12Mux_s9_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s9_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s9_h_V;

----- CELL Span12Mux_s10_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s10_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s10_h : entity is true;  
end Span12Mux_s10_h;

architecture Span12Mux_s10_h_V of Span12Mux_s10_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s10_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s10_h_V;

----- CELL Span12Mux_s11_h -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s11_h is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s11_h : entity is true;  
end Span12Mux_s11_h;

architecture Span12Mux_s11_h_V of Span12Mux_s11_h is
  attribute VITAL_LEVEL0 of
    Span12Mux_s11_h_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s11_h_V;

--***************************************************************
-- span12 mux buffer and its stubs in vertical direction         
--***************************************************************
----- CELL Span12Mux_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_v : entity is true;  
end Span12Mux_v;

architecture Span12Mux_v_V of Span12Mux_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_v_V;

----- CELL Span12Mux_s0_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s0_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s0_v : entity is true;  
end Span12Mux_s0_v;

architecture Span12Mux_s0_v_V of Span12Mux_s0_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s0_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s0_v_V;

----- CELL Span12Mux_s1_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s1_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s1_v : entity is true;  
end Span12Mux_s1_v;

architecture Span12Mux_s1_v_V of Span12Mux_s1_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s1_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s1_v_V;

----- CELL Span12Mux_s2_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s2_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s2_v : entity is true;  
end Span12Mux_s2_v;

architecture Span12Mux_s2_v_V of Span12Mux_s2_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s2_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s2_v_V;

----- CELL Span12Mux_s3_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s3_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s3_v : entity is true;  
end Span12Mux_s3_v;

architecture Span12Mux_s3_v_V of Span12Mux_s3_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s3_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s3_v_V;

----- CELL Span12Mux_s4_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s4_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s4_v : entity is true;  
end Span12Mux_s4_v;

architecture Span12Mux_s4_v_V of Span12Mux_s4_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s4_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s4_v_V;

----- CELL Span12Mux_s5_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s5_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s5_v : entity is true;  
end Span12Mux_s5_v;

architecture Span12Mux_s5_v_V of Span12Mux_s5_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s5_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s5_v_V;

----- CELL Span12Mux_s6_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s6_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s6_v : entity is true;  
end Span12Mux_s6_v;

architecture Span12Mux_s6_v_V of Span12Mux_s6_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s6_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s6_v_V;

----- CELL Span12Mux_s7_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s7_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s7_v : entity is true;  
end Span12Mux_s7_v;

architecture Span12Mux_s7_v_V of Span12Mux_s7_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s7_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s7_v_V;

----- CELL Span12Mux_s8_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s8_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s8_v : entity is true;  
end Span12Mux_s8_v;

architecture Span12Mux_s8_v_V of Span12Mux_s8_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s8_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s8_v_V;

----- CELL Span12Mux_s9_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s9_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s9_v : entity is true;  
end Span12Mux_s9_v;

architecture Span12Mux_s9_v_V of Span12Mux_s9_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s9_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s9_v_V;

----- CELL Span12Mux_s10_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s10_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s10_v : entity is true;  
end Span12Mux_s10_v;

architecture Span12Mux_s10_v_V of Span12Mux_s10_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s10_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s10_v_V;

----- CELL Span12Mux_s11_v -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity Span12Mux_s11_v is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

    );  
  port(
    O : out std_logic;

    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    Span12Mux_s11_v : entity is true;  
end Span12Mux_s11_v;

architecture Span12Mux_s11_v_V of Span12Mux_s11_v is
  attribute VITAL_LEVEL0 of
    Span12Mux_s11_v_V : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end Span12Mux_s11_v_V;

------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity sync_clk_enable is 
generic ( 
    Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_NC : VitalDelayType01 := (0.000 ns, 0.000 ns);
    tipd_D  : VitalDelayType01 := (0.000 ns, 0.000 ns);    
	tpd_NC_Q : VitalDelayType01 := (0.000 ns, 0.000 ns);
    tpd_D_Q : VitalDelayType01 := (0.000 ns, 0.000 ns)

	  );

  port(
    Q : out std_logic;

    NC : in std_logic;
    D : in std_logic
    );
  attribute VITAL_LEVEL0 of
    sync_clk_enable : entity is true;  
end sync_clk_enable;

architecture sync_clk_enable_V of sync_clk_enable is
  attribute VITAL_LEVEL0 of
    sync_clk_enable_V : architecture is true;
signal NC_ipd : std_logic := 'X';  
signal D_ipd : std_logic := 'X';
signal Q_zd : std_logic := 'X';

begin
  WireDelay    : block
  begin
    VitalWireDelay (NC_ipd, NC, tipd_NC);
    VitalWireDelay (D_ipd, D, tipd_D);
  end block;

  VITALBehavior : process(NC_ipd,D_ipd)       
  begin        
    if (NC_ipd = '0') then
      Q_zd <= D_ipd ;
	else 
	  Q_zd <= Q_zd;
    end if;
  end process;

  process(D_ipd, NC_ipd, Q_zd)

    variable Q_GlitchData : VitalGlitchDataType;

    begin
        
      
      VitalPathDelay01 (
        OutSignal     => Q,
        GlitchData    => Q_GlitchData,
        OutSignalName => "Q",
        OutTemp       => Q_zd,
        Paths         => (0 => (D_ipd'last_event, tpd_D_Q, true),
		                  1 => (NC_ipd'last_event, tpd_NC_Q, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;

end sync_clk_enable_V;

----- CELL SB_G2TBuf-----
-- used to model clock skew, X and Y are the X and Y coordinates of logic and IO tiles. 
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;

entity SB_G2TBuf is
generic ( 
		Xon   : boolean := true;
    MsgOn : boolean := true;    

    tipd_I : VitalDelayType01 := (0.000 ns, 0.000 ns);
    
    tpd_I_O : VitalDelayType01 := (0.000 ns, 0.000 ns)

	  );
  port(
    O : out std_logic;
    I : in std_logic
    );
  attribute VITAL_LEVEL0 of
    SB_G2TBuf : entity is true;  
end SB_G2TBuf;

architecture SB_G2TBuf_arch of SB_G2TBuf is
  attribute VITAL_LEVEL0 of
    SB_G2TBuf_arch : architecture is true;

  signal I_ipd : std_logic := 'X';  
begin
  WireDelay    : block
  begin
    VitalWireDelay (I_ipd, I, tipd_I);
  end block;

  process(I_ipd)

    variable O_GlitchData : VitalGlitchDataType;
    variable O_zd         : std_logic;

    begin
        
      O_zd    := To_X01(I_ipd);
      
      VitalPathDelay01 (
        OutSignal     => O,
        GlitchData    => O_GlitchData,
        OutSignalName => "O",
        OutTemp       => O_zd,
        Paths         => (0 => (I_ipd'last_event, tpd_I_O, true)),
        Mode          => VitalTransport,
        Xon           => Xon,
        MsgOn         => MsgOn,
        MsgSeverity   => warning);

  end process;
end SB_G2TBuf_arch;

------------------------------------------------------------------------
--					ICE_IO
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
--library	work;
use	work.std_logic_SBT.all;



entity	ICE_IO is

	generic (
			NEG_TRIGGER : bit						:=	'0';
			PIN_TYPE	: bit_vector (5 downto 0)	:=	"010000";
			PULLUP		: bit						:=	'0';
			IO_STANDARD	: string					:=	"SB_LVCMOS";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_DOUT1       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_DOUT0       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_CLOCKENABLE        : VitalDelayType01 := (0 ns, 0 ns);
            tipd_LATCHINPUTVALUE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_INPUTCLK        : VitalDelayType01 := (0 ns, 0 ns);
			tipd_OUTPUTENABLE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_OUTPUTCLK       : VitalDelayType01 := (0 ns, 0 ns);
			tipd_PACKAGEPIN      : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_PACKAGEPIN_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_PACKAGEPIN_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_DOUT0_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT1_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_OUTPUTENABLE_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_LATCHINPUTVALUE_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_LATCHINPUTVALUE_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_INPUTCLK_PACKAGEPIN  : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_INPUTCLK_DIN0_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_INPUTCLK_DIN1_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--- VITAL setup time
			tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			--- VITAL hold time 
			thold_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            thold_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns
			
 			);
	port 
		(
		DOUT1 		    : in std_logic;
		DOUT0 		    : in std_logic;
		CLOCKENABLE		: in std_logic;
		LATCHINPUTVALUE	: in std_logic;
		INPUTCLK			: in std_logic;
		
		DIN1				: out std_logic;
		DIN0				: out std_logic;
		OUTPUTENABLE		: in std_logic;
		OUTPUTCLK			: in std_logic;
		PACKAGEPIN			: inout	std_logic
		); 
	attribute VITAL_LEVEL0 of
      ICE_IO : entity is true;	
end ICE_IO ;

architecture ICE_IO_V of ICE_IO is
  attribute VITAL_LEVEL0 of
    ICE_IO_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi		:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo		:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;

	
	signal DOUT1_ipd : std_ulogic := 'X';
    signal DOUT0_ipd  : std_ulogic := 'X';
    signal CLOCKENABLE_ipd  : std_ulogic := 'X';
    signal LATCHINPUTVALUE_ipd   : std_ulogic := 'X';
	signal INPUTCLK_ipd : std_ulogic := 'X';
    signal OUTPUTENABLE_ipd  : std_ulogic := 'X';
    signal OUTPUTCLK_ipd  : std_ulogic := 'X';
	signal PACKAGEPIN_ipd : std_ulogic;   --input direction
	
	signal Violation : std_ulogic;
	--signal PACKAGEPIN_zd : std_ulogic;
	signal DIN0_zd : std_ulogic;
	signal DIN1_zd : std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi		:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
	signal	pull_up	:	std_logic;
	
	signal	hold,oepin,padoen,padout,padin	:	std_logic;	
	signal INCLKE_sync , OUTCLKE_sync : std_logic; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
		  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
		  VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;
		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	pin_cbit	<=	TO_STDLOGICVECTOR	(PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
	pull_up		<=	TO_STDLOGIC	(PULLUP);
	
--	OUTPUTENABLE	<=	'H';		--	weak 1 for initial value
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;


	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);
	
	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	
	padin	<=	PACKAGEPIN_ipd;
	-----------------------------------------------------------------	
	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi		=>	sdi,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo		=>	sdo,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	padin,
				padout	=>	padout,
				padoen	=>	padoen,
				cbit	=>	pin_cbit
				);
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PACKAGEPIN_ipd)
    variable Tviol_DOUT0_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_DOUT1_OUTPUTCLK_negedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_INPUTCLK_posedge    : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_posedge   : std_ulogic := '0';
	variable Tviol_PACKAGEPIN_INPUTCLK_negedge   : std_ulogic := '0';

    variable Tmkr_DOUT0_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DOUT1_OUTPUTCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PACKAGEPIN_INPUTCLK_negedge   : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_posedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_negedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (padout, padoen, DOUT1_ipd, DOUT0_ipd, PACKAGEPIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd, DIN0_zd, DIN1_zd, OUTPUTCLK_ipd, INPUTCLK_ipd)
    variable PACKAGEPIN_GlitchData : VitalGlitchDataType;
	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
	
	variable tmp_padio : std_logic;  --PACKAGEPIN output direction

  begin
   -- padin	<=	PACKAGEPIN_ipd;
		if	(padoen='1') then
			tmp_padio	:=	'Z';
		else
			tmp_padio	:=	padout;
		end if;
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPIN,
      GlitchData                => PACKAGEPIN_GlitchData,
      OutSignalName             => "PACKAGEPIN",
      OutTemp                   => tmp_padio,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPIN, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPIN, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPIN, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPIN, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN0, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN1, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN1, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;


end	ICE_IO_V;

----------------------------------------------------------------------
--					ICE_GB_IO
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
--library	work;
use	work.std_logic_SBT.all;

entity	ICE_GB_IO is
	generic (
			NEG_TRIGGER : bit						:=	'0';
			PIN_TYPE	: bit_vector (5 downto 0)	:=	"000000";
			PULLUP		: bit						:=	'0';
			IO_STANDARD	: string					:=	"SB_LVCMOS";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_DOUT1       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_DOUT0       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_CLOCKENABLE        : VitalDelayType01 := (0 ns, 0 ns);
            tipd_LATCHINPUTVALUE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_INPUTCLK        : VitalDelayType01 := (0 ns, 0 ns);
			tipd_OUTPUTENABLE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_OUTPUTCLK       : VitalDelayType01 := (0 ns, 0 ns);
			tipd_PACKAGEPIN      : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_PACKAGEPIN_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_PACKAGEPIN_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_DOUT0_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT1_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_OUTPUTENABLE_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_LATCHINPUTVALUE_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_LATCHINPUTVALUE_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_PACKAGEPIN_GLOBALBUFFEROUTPUT : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_INPUTCLK_PACKAGEPIN  : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_INPUTCLK_DIN0_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_INPUTCLK_DIN1_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--- VITAL setup time
			tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			--- VITAL hold time 
			thold_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            thold_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns
			
 			);
			
	port	(
			PACKAGEPIN			:	inout	std_logic;
			LATCHINPUTVALUE	:	in		std_logic;
			CLOCKENABLE        :	in		std_logic;
			INPUTCLK           :	in		std_logic;
			OUTPUTCLK          :	in		std_logic;
			OUTPUTENABLE		: in std_logic	:='H';
			DOUT1             :	in		std_logic;
			DOUT0             :	in		std_logic;
			DIN1              :	out		std_logic;
			DIN0              :	out		std_logic;
			GLOBALBUFFEROUTPUT:	out		std_logic
			);
	attribute VITAL_LEVEL0 of
      ICE_GB_IO : entity is true;	
end ICE_GB_IO;

architecture ICE_GB_IO_V of ICE_GB_IO is
  attribute VITAL_LEVEL0 of
    ICE_GB_IO_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi		:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo		:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;
	
	signal DOUT1_ipd : std_ulogic := 'X';
    signal DOUT0_ipd  : std_ulogic := 'X';
    signal CLOCKENABLE_ipd  : std_ulogic := 'X';
    signal LATCHINPUTVALUE_ipd   : std_ulogic := 'X';
	signal INPUTCLK_ipd : std_ulogic := 'X';
    signal OUTPUTENABLE_ipd  : std_ulogic := 'X';
    signal OUTPUTCLK_ipd  : std_ulogic := 'X';
	signal PACKAGEPIN_ipd : std_ulogic;   --input direction
	
	signal Violation : std_ulogic;
	--signal PACKAGEPIN_zd : std_ulogic;
	signal DIN0_zd : std_ulogic;
	signal DIN1_zd : std_ulogic;
	signal GLOBALBUFFEROUTPUT_zd : std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi		:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
	signal	pull_up	:	std_logic;
	
	signal	hold,oepin,padoen,padout,padin	:	std_logic;	
	signal INCLKE_sync, OUTCLKE_sync  : std_logic; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
		  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
		  VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;
		

		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	pin_cbit	<=	TO_STDLOGICVECTOR	(PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
	pull_up		<=	TO_STDLOGIC	(PULLUP);
--	OUTPUTENABLE	<=	'H';		--	weak 1 for initial value
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;

	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);

	
	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	padin	<=	PACKAGEPIN_ipd;
	GLOBALBUFFEROUTPUT_zd	<=	padin;
-----------------------------------------------------------------	

	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi		=>	sdi,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo		=>	sdo,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	padin,
				padout	=>	padout,
				padoen	=>	padoen,
				cbit	=>	pin_cbit
				);

-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PACKAGEPIN_ipd)
    variable Tviol_DOUT0_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_DOUT1_OUTPUTCLK_negedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_INPUTCLK_posedge    : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_posedge   : std_ulogic := '0';
	variable Tviol_PACKAGEPIN_INPUTCLK_negedge   : std_ulogic := '0';

    variable Tmkr_DOUT0_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DOUT1_OUTPUTCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PACKAGEPIN_INPUTCLK_negedge   : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_posedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_negedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_GB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (padout, padoen, DOUT1_ipd, DOUT0_ipd, PACKAGEPIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd, DIN0_zd, DIN1_zd, GLOBALBUFFEROUTPUT_zd)
    variable PACKAGEPIN_GlitchData : VitalGlitchDataType;
	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
	variable GLOBALBUFFEROUTPUT_GlitchData : VitalGlitchDataType;
	
	variable tmp_padio : std_logic;  --PACKAGEPIN output direction

  begin
    
		if	(padoen='1') then
			tmp_padio	:=	'Z';
		else
			tmp_padio	:=	padout;
		end if;
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPIN,
      GlitchData                => PACKAGEPIN_GlitchData,
      OutSignalName             => "PACKAGEPIN",
      OutTemp                   => tmp_padio,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPIN, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPIN, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPIN, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPIN, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN0, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN1, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN1, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => GLOBALBUFFEROUTPUT,
      GlitchData                => GLOBALBUFFEROUTPUT_GlitchData,
      OutSignalName             => "GLOBALBUFFEROUTPUT",
      OutTemp                   => GLOBALBUFFEROUTPUT_zd,
      Paths                     => (0 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_GLOBALBUFFEROUTPUT, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;
end	ICE_GB_IO_V;

-----------------------------------------------------------------
--					ICE_GB
-----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
--library	work;
use	work.std_logic_SBT.all;

entity	ICE_GB	is
generic	(----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_USERSIGNALTOGLOBALBUFFER       : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_USERSIGNALTOGLOBALBUFFER_GLOBALBUFFEROUTPUT : VitalDelayType01 := (0.000 ns, 0.000 ns)
            );
port	(
		GLOBALBUFFEROUTPUT			:	out	std_logic;
		USERSIGNALTOGLOBALBUFFER	:	in	std_logic
		);
attribute VITAL_LEVEL0 of
      ICE_GB : entity is true;
end	ICE_GB;

architecture ICE_GB_V of ICE_GB is
  attribute VITAL_LEVEL0 of
    ICE_GB_V : architecture is true;
	
  signal USERSIGNALTOGLOBALBUFFER_ipd   : std_ulogic := 'X';
  signal GLOBALBUFFEROUTPUT_zd : std_ulogic;
  
begin
  WireDelay   : block
        begin
          VitalWireDelay (USERSIGNALTOGLOBALBUFFER_ipd, USERSIGNALTOGLOBALBUFFER, tipd_USERSIGNALTOGLOBALBUFFER);
        end block;
--------------------------------------------------
--function part
-------------------------------------------------
	GLOBALBUFFEROUTPUT_zd	<=	USERSIGNALTOGLOBALBUFFER_ipd;
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------	
	 VITALPathDelay          : process (USERSIGNALTOGLOBALBUFFER_ipd, GLOBALBUFFEROUTPUT_zd)
 --   variable O_zd         : std_ulogic;
    variable O_GlitchData : VitalGlitchDataType;
  begin
    VitalPathDelay01 (
      OutSignal                 => GLOBALBUFFEROUTPUT,
      GlitchData                => O_GlitchData,
      OutSignalName             => "GLOBALBUFFEROUTPUT",
      OutTemp                   => GLOBALBUFFEROUTPUT_zd,
      Paths                     => (0 => (USERSIGNALTOGLOBALBUFFER_ipd'last_event, tpd_USERSIGNALTOGLOBALBUFFER_GLOBALBUFFEROUTPUT, true)
 									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;
end ICE_GB_V;

-----------------------------------------------------------
--				ICE_IO_DS
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
--library	work;
use	work.std_logic_SBT.all;

entity	ICE_IO_DS is
	generic	(
			NEG_TRIGGER : bit						:=	'0';
			PIN_TYPE	: bit_vector (5 downto 0)	:=	"000000";
--			PULLUP		: bit						:=	'0';
			IO_STANDARD	: string					:=	"SB_LVDS_OUTPUT";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_DOUT1       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_DOUT0       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_CLOCKENABLE        : VitalDelayType01 := (0 ns, 0 ns);
            tipd_LATCHINPUTVALUE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_INPUTCLK        : VitalDelayType01 := (0 ns, 0 ns);
			tipd_OUTPUTENABLE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_OUTPUTCLK       : VitalDelayType01 := (0 ns, 0 ns);
			tipd_PACKAGEPIN      : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_PACKAGEPIN_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_PACKAGEPIN_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_DOUT0_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT1_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_OUTPUTENABLE_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_LATCHINPUTVALUE_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_LATCHINPUTVALUE_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT0_PACKAGEPINB : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT1_PACKAGEPINB : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTENABLE_PACKAGEPINB : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_INPUTCLK_PACKAGEPIN  : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_INPUTCLK_PACKAGEPINB  : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_INPUTCLK_DIN0_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_INPUTCLK_DIN1_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPINB : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPINB_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPINB_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--- VITAL setup time
			tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			--- VITAL hold time 
			thold_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            thold_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns
			
			);
			
	port	(
			PACKAGEPIN			:	inout	std_logic;
			LATCHINPUTVALUE	:	in		std_logic;
			CLOCKENABLE        :	in		std_logic;
			INPUTCLK           :	in		std_logic;
			OUTPUTCLK          :	in		std_logic;
			OUTPUTENABLE		: in std_logic	:='H';
			DOUT1             :	in		std_logic;
			DOUT0             :	in		std_logic;
			DIN1              :	out		std_logic;
			DIN0              :	out		std_logic;
			PACKAGEPINB	    :	inout	std_logic	-- User's package pin - 'PAD' output  
			);
	attribute VITAL_LEVEL0 of
      ICE_IO_DS : entity is true;	
end ICE_IO_DS;

architecture ICE_IO_DS_V of ICE_IO_DS is
  attribute VITAL_LEVEL0 of
    ICE_IO_DS_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi		:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo		:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;
	
	signal DOUT1_ipd : std_ulogic := 'X';
    signal DOUT0_ipd  : std_ulogic := 'X';
    signal CLOCKENABLE_ipd  : std_ulogic := 'X';
    signal LATCHINPUTVALUE_ipd   : std_ulogic := 'X';
	signal INPUTCLK_ipd : std_ulogic := 'X';
    signal OUTPUTENABLE_ipd  : std_ulogic := 'X';
    signal OUTPUTCLK_ipd  : std_ulogic := 'X';
	signal PACKAGEPIN_ipd : std_ulogic;   --input direction
	
	signal Violation : std_ulogic;
	--signal PACKAGEPIN_zd : std_ulogic;
	signal DIN0_zd : std_ulogic;
	signal DIN1_zd : std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi		:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
	signal	pull_up	:	std_logic;
	
	signal	hold,oepin,padoen,padout,padin	:	std_logic;	
	signal INCLKE_sync, OUTCLKE_sync : std_logic ; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
		  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
		  VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;
		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	
	pin_cbit	<=	TO_STDLOGICVECTOR	(PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
--	pull_up		<=	TO_STDLOGIC	(PULLUP);
	
--	OUTPUTENABLE	<=	'H';		--	weak 1 for initial value
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;
	
	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);
	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	
	padin	<=	PACKAGEPIN_ipd;
-----------------------------------------------------------------	

	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi		=>	sdi,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo		=>	sdo,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	padin,
				padout	=>	padout,
				padoen	=>	padoen,
				cbit	=>	pin_cbit
				);
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PACKAGEPIN_ipd)
    variable Tviol_DOUT0_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_DOUT1_OUTPUTCLK_negedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_INPUTCLK_posedge    : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_posedge   : std_ulogic := '0';
	variable Tviol_PACKAGEPIN_INPUTCLK_negedge   : std_ulogic := '0';

    variable Tmkr_DOUT0_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DOUT1_OUTPUTCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PACKAGEPIN_INPUTCLK_negedge   : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_posedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_negedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO_DS",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (padout, padoen, DOUT1_ipd, DOUT0_ipd, PACKAGEPIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd, DIN0_zd, DIN1_zd, OUTPUTCLK_ipd, INPUTCLK_ipd)
    variable PACKAGEPIN_GlitchData : VitalGlitchDataType;
	variable PACKAGEPINB_GlitchData : VitalGlitchDataType;
	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
	
	variable tmp_padio : std_logic;  --PACKAGEPIN output direction
	variable tmp_padio_b : std_logic;  --PACKAGEPIN output direction

  begin
 		if	(padoen='1') then
			tmp_padio	:=	'Z';
			tmp_padio_b	:=	'Z';
		else
			tmp_padio	:=	padout;
			tmp_padio_b	:=	not padout;
		end if;
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPIN,
      GlitchData                => PACKAGEPIN_GlitchData,
      OutSignalName             => "PACKAGEPIN",
      OutTemp                   => tmp_padio,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPIN, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPIN, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPIN, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPIN, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPINB,
      GlitchData                => PACKAGEPINB_GlitchData,
      OutSignalName             => "PACKAGEPINB",
      OutTemp                   => tmp_padio_b,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPINB, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPINB, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPINB, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPINB, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN0, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN1, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN1, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;
  
end	ICE_IO_DS_V;

--============================================================================
-- ICE_CARRY_IN_MUX 
--============================================================================

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;

entity ICE_CARRY_IN_MUX is
generic(C_INIT:bit_vector(1 downto 0) := "00";
        ----------------------------------------------------------------------------------
			--VITAL PARAMETER
		---------------------------------------------------------------------------------
		Xon   : boolean := true;
        MsgOn : boolean := false;
        tipd_carryinitin :VitalDelayType01:= (0.0 ns, 0.0 ns);  
        tpd_carryinitin_carryinitout :VitalDelayType01:= (0.0 ns, 0.0 ns));
    port ( 
	  carryinitout  : out  std_logic;
	  carryinitin  : in  std_logic   );
    attribute VITAL_LEVEL0 of
      ICE_CARRY_IN_MUX : entity is true;
end ICE_CARRY_IN_MUX; 
 
architecture ICE_CARRY_IN_MUX_V of ICE_CARRY_IN_MUX is
  attribute VITAL_LEVEL0 of
    ICE_CARRY_IN_MUX_V : architecture is true;
	
signal select_bits :std_logic_vector(1 downto 0);
signal carryinitin_ipd : std_ulogic := 'X';
signal carryinitout_zd : std_ulogic := 'X';

begin
  WireDelay     : block
  begin
    VitalWireDelay (carryinitin_ipd, carryinitin, tipd_carryinitin);
  end block;
-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------	
process(select_bits,carryinitin_ipd)
	begin 
	  case select_bits is
	     when "00"=>carryinitout_zd<='0';
	     when "01"=>carryinitout_zd<='1';
	     when "10"=>carryinitout_zd<=carryinitin_ipd;
	     when "11"=>carryinitout_zd<=carryinitin_ipd;
	     when others =>carryinitout_zd<='0';
	  end case;
	    
   end process;
   select_bits <= TO_STDLOGICVECTOR(C_INIT);
-------------------------------------------------------------------
--VITAL path delay
------------------------------------------------------------------
VITALPathDelay           : process (carryinitin_ipd, carryinitout_zd)
    
      variable O_GlitchData : VitalGlitchDataType;
    begin    
    VitalPathDelay01 (
      OutSignal     => carryinitout,
      GlitchData    => O_GlitchData,
      OutSignalName => "carryinitout",
      OutTemp       => carryinitout_zd,
      Paths         => (0 => (carryinitin_ipd'last_event, tpd_carryinitin_carryinitout, true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
  end process; 
end ICE_CARRY_IN_MUX_V;

-- ICE_IO / ICE_GB_IO breakup sub components models 
-------------------------------------------------------------------------
--				IO_PAD 
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;

entity IO_PAD is
	generic	( 
	
		PULLUP          : bit                                           :=      '0';
		IO_STANDARD     : string                                        :=      "SB_LVCMOS";
		----------------------------------------------------------------------------------
	        --VITAL PARAMETER
	         ---------------------------------------------------------------------------------
		TimingChecksOn  : boolean := true;
              	Xon   		: boolean := true;
                MsgOn 		: boolean := false; 
		--- VITAL port delay
		tipd_PACKAGEPIN 	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_DIN            	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_OE              	: VitalDelayType01 := (0 ns, 0 ns);
	  	--- VITAL path delay
	        tpd_PACKAGEPIN_DOUT 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
	        tpd_DIN_PACKAGEPIN 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
           	tpd_OE_PACKAGEPIN 	: VitalDelayType01 := (0.000 ns, 0.000 ns)
		); 	    	
	port
        	(
		PACKAGEPIN              : inout std_logic; 
		DOUT               	: out std_logic;
		DIN               	: in std_logic;
		OE 	             	: in std_logic
		); 

        attribute VITAL_LEVEL0 of IO_PAD  : entity is true;

end IO_PAD;

architecture IO_PAD_V of IO_PAD is 

	attribute VITAL_LEVEL0 of IO_PAD_V : architecture is true;
		--
		signal DIN_ipd 		: std_ulogic := 'X';
		signal OE_ipd  		: std_ulogic := 'X';
	        signal PACKAGEPIN_ipd 	: std_ulogic;   --input direction
		-- 
        	signal DOUT_zd		: std_ulogic;
		signal PACKAGEPIN_zd    : std_ulogic; 
 		--
        	signal Violation 	: std_ulogic;
		signal	pull_up		: std_logic;
-------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
		VitalWireDelay (DIN_ipd, DIN, tipd_DIN);
	        VitalWireDelay (OE_ipd, OE, tipd_OE);
		VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
        	pull_up         <=      TO_STDLOGIC (PULLUP);

	PADPROCESS  : process (OE_ipd, PACKAGEPIN_ipd,DIN_ipd)
	begin
        	if  ( OE_ipd ='1') then
                	PACKAGEPIN_zd     <=      'Z';
       	        else
               		PACKAGEPIN_zd     <=      DIN_ipd;
                end if;
        end process;
	 		DOUT_zd 	<=	PACKAGEPIN_ipd; 	
------------------------------------------------------------------------------------	
-- PATH DELAY 
------------------------------------------------------------------------------------
	VITALPathDelay          : process ( PACKAGEPIN_ipd,DIN_ipd,OE_ipd, DOUT_zd,PACKAGEPIN_zd) 
		variable PACKAGEPIN_GlitchData 	: VitalGlitchDataType;
		variable DOUT_GlitchData 	: VitalGlitchDataType;
  	begin 
	  VitalPathDelay01 (
		OutSignal                 => PACKAGEPIN,
	      	GlitchData                => PACKAGEPIN_GlitchData,
	      	OutSignalName             => "PACKAGEPIN",
	      	OutTemp                   => PACKAGEPIN_zd,
	      	Paths                     => ( 0 => (DIN_ipd'last_event, tpd_DIN_PACKAGEPIN, true),
	                                       1 => (OE_ipd'last_event, tpd_OE_PACKAGEPIN, true)
                                             ),
	      	Mode                      => VitalTransport,
	      	Xon                       => Xon,
	      	MsgOn                     => MsgOn,
	      	MsgSeverity               => warning);
	
	VitalPathDelay01 (
		OutSignal                 => DOUT,
      		GlitchData                => DOUT_GlitchData,
      		OutSignalName             => "DOUT",
      		OutTemp                   => DOUT_zd,
      		Paths                     => ( 0 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DOUT, true)
                                              ),
      		Mode                      => VitalTransport,
      		Xon                       => Xon,
      		MsgOn                     => MsgOn,
      		MsgSeverity               => warning);
	end process VITALPathDelay;

end IO_PAD_V; 

-------------------------------------------------------------------------
--				IO_PAD_OD (Open Drain Pad) 
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;

entity IO_PAD_OD is
	generic	( 
		----------  No PULLUP, IO_STANDARD properties for open drain pads  -------- 
		--PULLUP          : bit                                           :=      '0';
		--IO_STANDARD     : string                                        :=      "SB_LVCMOS";
		----------------------------------------------------------------------------------
	        --VITAL PARAMETER
	         ---------------------------------------------------------------------------------
		TimingChecksOn  : boolean := true;
              	Xon   		: boolean := true;
                MsgOn 		: boolean := false; 
		--- VITAL port delay
		tipd_PACKAGEPIN 	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_DIN            	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_OE              	: VitalDelayType01 := (0 ns, 0 ns);
	  	--- VITAL path delay
	        tpd_PACKAGEPIN_DOUT 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
	        tpd_DIN_PACKAGEPIN 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
           	tpd_OE_PACKAGEPIN 	: VitalDelayType01 := (0.000 ns, 0.000 ns)
		); 	    	
	port
        	(
		PACKAGEPIN              : inout std_logic; 
		DOUT               	: out std_logic;
		DIN               	: in std_logic;
		OE 	             	: in std_logic
		); 

        attribute VITAL_LEVEL0 of IO_PAD_OD  : entity is true;

end IO_PAD_OD;

architecture IO_PAD_OD_V of IO_PAD_OD is 

	attribute VITAL_LEVEL0 of IO_PAD_OD_V : architecture is true;
		--
		signal DIN_ipd 		: std_ulogic := 'X';
		signal OE_ipd  		: std_ulogic := 'X';
	        signal PACKAGEPIN_ipd 	: std_ulogic;   --input direction
		-- 
        	signal DOUT_zd		: std_ulogic;
		signal PACKAGEPIN_zd    : std_ulogic; 
 		--
        	signal Violation 	: std_ulogic;
-------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
		VitalWireDelay (DIN_ipd, DIN, tipd_DIN);
	        VitalWireDelay (OE_ipd, OE, tipd_OE);
		VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------

	PADPROCESS  : process (OE_ipd, PACKAGEPIN_ipd,DIN_ipd)
	begin
        	if  ( (OE_ipd ='0') and (DIN_ipd ='0')  ) then
                	PACKAGEPIN_zd     <=      '0';
       	        else
               		PACKAGEPIN_zd     <=      'Z';
                end if;
        end process;
	 		DOUT_zd 	<=	PACKAGEPIN_ipd; 	
------------------------------------------------------------------------------------	
-- PATH DELAY 
------------------------------------------------------------------------------------
	VITALPathDelay          : process ( PACKAGEPIN_ipd,DIN_ipd,OE_ipd, DOUT_zd,PACKAGEPIN_zd) 
		variable PACKAGEPIN_GlitchData 	: VitalGlitchDataType;
		variable DOUT_GlitchData 	: VitalGlitchDataType;
  	begin 
	  VitalPathDelay01 (
		OutSignal                 => PACKAGEPIN,
	      	GlitchData                => PACKAGEPIN_GlitchData,
	      	OutSignalName             => "PACKAGEPIN",
	      	OutTemp                   => PACKAGEPIN_zd,
	      	Paths                     => ( 0 => (DIN_ipd'last_event, tpd_DIN_PACKAGEPIN, true),
	                                       1 => (OE_ipd'last_event, tpd_OE_PACKAGEPIN, true)
                                             ),
	      	Mode                      => VitalTransport,
	      	Xon                       => Xon,
	      	MsgOn                     => MsgOn,
	      	MsgSeverity               => warning);
	
	VitalPathDelay01 (
		OutSignal                 => DOUT,
      		GlitchData                => DOUT_GlitchData,
      		OutSignalName             => "DOUT",
      		OutTemp                   => DOUT_zd,
      		Paths                     => ( 0 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DOUT, true)
                                              ),
      		Mode                      => VitalTransport,
      		Xon                       => Xon,
      		MsgOn                     => MsgOn,
      		MsgSeverity               => warning);
	end process VITALPathDelay;

end IO_PAD_OD_V; 


----------------------------------------------------------------------------------
--					PRE_IO
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;

entity PRE_IO is

	generic (
		NEG_TRIGGER 	: bit						:=	'0';
		PIN_TYPE	: bit_vector (5 downto 0)	:=	"010000";
		----------------------------------------------------------------------------------
		--VITAL PARAMETER
		---------------------------------------------------------------------------------
		TimingChecksOn  : boolean := true;
		Xon   		: boolean := true;
	        MsgOn 		: boolean := false;
		-- VITAL port delay
	        tipd_CLOCKENABLE        		: VitalDelayType01 := (0 ns, 0 ns);
	        tipd_INPUTCLK        			: VitalDelayType01 := (0 ns, 0 ns);
	        tipd_OUTPUTCLK       			: VitalDelayType01 := (0 ns, 0 ns);
        	tipd_LATCHINPUTVALUE       		: VitalDelayType01 := (0 ns, 0 ns);	        
		tipd_DOUT0       			: VitalDelayType01 := (0 ns, 0 ns);
		tipd_DOUT1       			: VitalDelayType01 := (0 ns, 0 ns);	
		tipd_OUTPUTENABLE			: VitalDelayType01 := (0 ns, 0 ns);
		tipd_PADIN       			: VitalDelayType01 := (0 ns, 0 ns);
	         --- VITAL path delay
          	tpd_PADIN_DIN0 				: VitalDelayType01 := (0.000 ns, 0.000 ns);
 	        tpd_DOUT0_PADOUT			: VitalDelayType01 := (0.000 ns, 0.000 ns);
           	tpd_OUTPUTENABLE_PADOEN  		: VitalDelayType01 := (0.000 ns, 0.000 ns);
       		tpd_LATCHINPUTVALUE_DIN0 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		--  VITAL clk-to-output path delay
		tpd_INPUTCLK_DIN0_posedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
       		tpd_INPUTCLK_DIN1_negedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_OUTPUTCLK_PADOUT_posedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_OUTPUTCLK_PADOUT_negedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_OUTPUTCLK_PADOEN_posedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		--- VITAL setup time
		tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    	: VitalDelayType := 0 ns;
	        tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    	: VitalDelayType := 0 ns;
	        tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   	: VitalDelayType := 0 ns;
       		tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   	: VitalDelayType := 0 ns;

       		tsetup_PADIN_INPUTCLK_negedge_posedge 		: VitalDelayType := 0 ns;
	        tsetup_PADIN_INPUTCLK_posedge_posedge 		: VitalDelayType := 0 ns;
	        tsetup_PADIN_INPUTCLK_posedge_negedge 		: VitalDelayType := 0 ns;
	        tsetup_PADIN_INPUTCLK_negedge_negedge 		: VitalDelayType := 0 ns;

		tsetup_DOUT0_OUTPUTCLK_negedge_posedge   	: VitalDelayType := 0 ns;
           	tsetup_DOUT0_OUTPUTCLK_posedge_posedge   	: VitalDelayType := 0 ns;
		tsetup_DOUT1_OUTPUTCLK_negedge_negedge   	: VitalDelayType := 0 ns;
           	tsetup_DOUT1_OUTPUTCLK_posedge_negedge   	: VitalDelayType := 0 ns;

		tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType := 0 ns;
	        tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType := 0 ns;
		--- VITAL hold time
		thold_CLOCKENABLE_INPUTCLK_negedge_posedge     : VitalDelayType := 0 ns;
                thold_CLOCKENABLE_INPUTCLK_posedge_posedge     : VitalDelayType := 0 ns;
                thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge    : VitalDelayType := 0 ns;
                thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge    : VitalDelayType := 0 ns;

                thold_PADIN_INPUTCLK_negedge_posedge           : VitalDelayType := 0 ns;
                thold_PADIN_INPUTCLK_posedge_posedge           : VitalDelayType := 0 ns;
                thold_PADIN_INPUTCLK_posedge_negedge           : VitalDelayType := 0 ns;
                thold_PADIN_INPUTCLK_negedge_negedge           : VitalDelayType := 0 ns;

                thold_DOUT0_OUTPUTCLK_negedge_posedge          : VitalDelayType := 0 ns;
                thold_DOUT0_OUTPUTCLK_posedge_posedge          : VitalDelayType := 0 ns;
                thold_DOUT1_OUTPUTCLK_negedge_negedge          : VitalDelayType := 0 ns;
                thold_DOUT1_OUTPUTCLK_posedge_negedge          : VitalDelayType := 0 ns;

                thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType := 0 ns;
                thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType := 0 ns
		);
	port 
		(
		CLOCKENABLE		: in std_logic;
		INPUTCLK		: in std_logic;
		OUTPUTCLK		: in std_logic;
		LATCHINPUTVALUE		: in std_logic;
		DOUT0 		    	: in std_logic;
		DOUT1 		    	: in std_logic;
		OUTPUTENABLE		: in std_logic;
		PADIN			: in std_logic; 
		DIN0			: out std_logic;
		DIN1			: out std_logic;
		PADOEN			: out std_logic; 
		PADOUT			: out std_logic		
		); 

	attribute VITAL_LEVEL0 of PRE_IO : entity is true;	

end PRE_IO ;


architecture PRE_IO_V of PRE_IO is

  attribute VITAL_LEVEL0 of PRE_IO_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi	:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo	:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;

	
	signal CLOCKENABLE_ipd  : std_ulogic := 'X';
	signal INPUTCLK_ipd : std_ulogic := 'X';
	signal OUTPUTCLK_ipd  : std_ulogic := 'X';
	signal LATCHINPUTVALUE_ipd   : std_ulogic := 'X';
	signal DOUT0_ipd  : std_ulogic := 'X';
	signal DOUT1_ipd : std_ulogic := 'X';
	signal OUTPUTENABLE_ipd  : std_ulogic := 'X';
	signal PADIN_ipd : std_ulogic;  
	
	signal DIN0_zd : std_ulogic;
	signal DIN1_zd : std_ulogic;
	signal PADOUT_zd : std_ulogic; 
	signal PADOEN_zd : std_ulogic; 

	signal Violation : std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi	:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
	
	signal	hold,oepin   : std_logic; 
	signal INCLKE_sync,OUTCLKE_sync : std_logic; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
	  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
	  VitalWireDelay (PADIN_ipd, PADIN, tipd_PADIN);
        end block;
		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	pin_cbit	<=	TO_STDLOGICVECTOR	(PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
	
--	OUTPUTENABLE	<=	'H';		--	weak 1 for initial value
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;

	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);

	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	
	-----------------------------------------------------------------	
	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi	=>	sdi,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo	=>	sdo,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	PADIN_ipd,
				padout	=>	PADOUT_zd,
				padoen	=>	PADOEN_zd,
				cbit	=>	pin_cbit
				);
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PADIN_ipd)
  	variable Tviol_DOUT0_OUTPUTCLK_posedge 		: std_ulogic := '0';
	variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge 	: std_ulogic := '0';
	variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge 	: std_ulogic := '0';
	variable Tviol_DOUT1_OUTPUTCLK_negedge 		: std_ulogic := '0';
	variable Tviol_CLOCKENABLE_INPUTCLK_posedge    	: std_ulogic := '0';
	variable Tviol_PADIN_INPUTCLK_posedge   	: std_ulogic := '0';
	variable Tviol_PADIN_INPUTCLK_negedge   	: std_ulogic := '0';

	variable Tmkr_DOUT0_OUTPUTCLK_posedge 		: VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge 	: VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge 	: VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_DOUT1_OUTPUTCLK_negedge 		: VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    	: VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PADIN_INPUTCLK_posedge   		: VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PADIN_INPUTCLK_negedge   		: VitalTimingDataType := VitalTimingDataInit;
	
  begin
    if (TimingChecksOn) then

	VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

	VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

	VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

	VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);

	  
	VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		

       VitalSetupHoldCheck (
        Violation      => Tviol_PADIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PADIN_INPUTCLK_posedge,
        TestSignal     => PADIN_ipd,
        TestSignalName => "PADIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PADIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PADIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PADIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PADIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_PADIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PADIN_INPUTCLK_negedge,
        TestSignal     => PADIN_ipd,
        TestSignalName => "PADIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PADIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PADIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PADIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PADIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PRE_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
-----------------------------------------------------------------
--VITAL Path Delay  
------------------------------------------------------------------
       VITALPathDelay  : process ( PADOUT_zd, PADOEN_zd, DIN0_zd,DIN1_zd , DOUT0_ipd, DOUT1_ipd, PADIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd,OUTPUTCLK_ipd, INPUTCLK_ipd )

	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
        variable PADOUT_GlitchData : VitalGlitchDataType;
	variable PADOEN_GlitchData : VitalGlitchDataType;

  begin
  
      VitalPathDelay01 (
      OutSignal                 => PADOUT,
      GlitchData                => PADOUT_GlitchData,
      OutSignalName             => "PADOUT",
      OutTemp                   => PADOUT_zd,
      Paths                     => ( 0 => (DOUT0_ipd'last_event, tpd_DOUT0_PADOUT, true),
				     1 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PADOUT_posedge, true),
				     2 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PADOUT_negedge, true)
				   ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);

      VitalPathDelay01 (
      OutSignal                 => PADOEN,
      GlitchData                => PADOEN_GlitchData,
      OutSignalName             => "PADOEN",
      OutTemp                   => PADOEN_zd,
      Paths                     => ( 0 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PADOEN, true),
                                     1 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PADOEN_posedge, true)
                                   ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
      VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => ( 0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
				     1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
				     2 => (PADIN_ipd'last_event, tpd_PADIN_DIN0, true)
				   ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
      VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => ( 0 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true)
				   ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;

end	PRE_IO_V;

----------------------------------------------------------------------------
--					PRE_IO_GBUF
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
use	work.std_logic_SBT.all;

entity	PRE_IO_GBUF is
	generic	(
		----------------------------------------------------------------------------------
		--VITAL PARAMETER
		---------------------------------------------------------------------------------
		TimingChecksOn  : boolean := true;
		Xon   : boolean := true;
	        MsgOn : boolean := false;
		--- VITAL path delay
		tipd_PADSIGNALTOGLOBALBUFFER       : VitalDelayType01 := (0 ns, 0 ns);
 	        --- VITAL path delay
               tpd_PADSIGNALTOGLOBALBUFFER_GLOBALBUFFEROUTPUT : VitalDelayType01 := (0.000 ns, 0.000 ns)
         	);
	port	(
		GLOBALBUFFEROUTPUT	:	out	std_logic;
		PADSIGNALTOGLOBALBUFFER	:	in	std_logic
		);

	attribute VITAL_LEVEL0 of  PRE_IO_GBUF  : entity is true;

end	PRE_IO_GBUF;


architecture PRE_IO_GBUF_V of PRE_IO_GBUF  is

  attribute VITAL_LEVEL0 of    PRE_IO_GBUF_V : architecture is true;
	
  signal PADSIGNALTOGLOBALBUFFER_ipd    : std_ulogic := 'X';
  signal GLOBALBUFFEROUTPUT_zd		: std_ulogic;
  
begin
  WireDelay   : block
        begin
         VitalWireDelay (PADSIGNALTOGLOBALBUFFER_ipd, PADSIGNALTOGLOBALBUFFER, tipd_PADSIGNALTOGLOBALBUFFER);
        end block;
-----------------------------------------------
-- BEHAVIOUR Section 
------------------------------------------------

	GLOBALBUFFEROUTPUT_zd	<=	PADSIGNALTOGLOBALBUFFER_ipd;

---------------------------------------------------------
-- VITAL Path Delay 
----------------------------------------------------------	
  VITALPathDelay          : process (PADSIGNALTOGLOBALBUFFER_ipd, GLOBALBUFFEROUTPUT_zd)
    variable O_GlitchData : VitalGlitchDataType;
	  begin
	    VitalPathDelay01 (
	      OutSignal                 => GLOBALBUFFEROUTPUT,
	      GlitchData                => O_GlitchData,
	      OutSignalName             => "GLOBALBUFFEROUTPUT",
	      OutTemp                   => GLOBALBUFFEROUTPUT_zd,
	      Paths                     => ( 0 => (PADSIGNALTOGLOBALBUFFER_ipd'last_event, tpd_PADSIGNALTOGLOBALBUFFER_GLOBALBUFFEROUTPUT, true)  ),
	      Mode                      => VitalTransport,
	      Xon                       => Xon,
	      MsgOn                     => MsgOn,
	      MsgSeverity               => warning);
     end process VITALPathDelay;

end PRE_IO_GBUF_V;

----- PLL40 Split Components

---------------------------------------------------------------------------
----			 PLL40		  				---
---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;
use work.all; 

entity PLL40  is 
	
	generic ( 
		----------------------------------------------------------------------------------
                --VITAL PARAMETER
                ---------------------------------------------------------------------------------
                TimingChecksOn  	: boolean := true;
                Xon   			: boolean := true;
	        MsgOn 			: boolean := false;
			--- VITAL input port delay 		   
                thold_SDI_SCLK_negedge_posedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_posedge_posedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_negedge_negedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_posedge_negedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_negedge_posedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_posedge_posedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_negedge_negedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_posedge_negedge:VitalDelayType :=0 ns; 
				tpd_SCLK_SDO_negedge          	: VitalDelayType01 := (0 ns, 0 ns);				
                tipd_PLLIN	       : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_EXTFEEDBACK        : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_DYNAMICDELAY       : VitalDelayArrayType01(7 downto 0)  := (others => (0 ns, 0 ns));
            	tipd_BYPASS             : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_RESETB             : VitalDelayType01 := (0 ns, 0 ns);
                tipd_SDI        	: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_SCLK           	: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_LATCHINPUTVALUE   	: VitalDelayType01 := (0 ns, 0 ns);
		-- VITAL Path Delay 	
            	tpd_PLLIN_PLLOUTCORE           	: VitalDelayType01 := (0 ns, 0 ns);
            	tpd_PLLIN_PLLOUTGLOBAL          	: VitalDelayType01 := (0 ns, 0 ns);
	         -- Entity Parameters 	
		 FEEDBACK_PATH 			: string 		 :="SIMPLE";   -- SIMPLE/DELAY/PHASE_AND_DELAY/EXTERNAL 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 		 :="FIXED";    -- FIXED/DYNAMIC  
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 		 :="FIXED";    -- FIXED/DYNAMIC 
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00";      -- 00 (div by 4)/ 01 (div by 7)/11 (div by 5)   	 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT			: string 		 :="GENCLK"; 

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			: bit_vector(2 downto 0) := "000";  
		 FILTER_RANGE 			: bit_vector(2 downto 0) := "000";
		 		
 		 ENABLE_ICEGATE		        : bit 			 :='0';
		 TEST_MODE			: bit 			 :='0';  
		 EXTERNAL_DIVIDE_FACTOR         : integer 		 := 1      -- Required for PLL Config Wizard.  
	);
	port (
                PLLIN			: in std_logic;           -- PLL ref clock, driven by PAD.  
                PLLOUTCORE	     	: out std_logic;          -- PLL output to core logic through local routings. 
                PLLOUTGLOBAL            : out std_logic;   	  -- PLL output to dedicated global clock network
                EXTFEEDBACK             : in std_logic;  	  -- FB driven by core logic
                DYNAMICDELAY            : in std_logic_vector(7 downto 0);  -- driven by core logic
                LOCK                    : out std_logic;	  -- PLL Lock signal output  
                BYPASS                  : in std_logic; 	  -- REFCLK passed to PLLOUT when bypass is '1'.Driven by core logic
                RESETB                  : in std_logic; 	  -- Active low reset,Driven by core logic
                SDI                     : in std_logic;		  -- Test Input. Driven by core logic. 
                SDO                     : out std_logic; 	  -- Test output to RB Logic Tile.
                SCLK                    : in std_logic;	          -- Test Clk input.Driven by core logic. 
                LATCHINPUTVALUE         : in std_logic 		  -- iCEGate signal
	);

       attribute VITAL_LEVEL0 of PLL40 : entity is true;

end PLL40; 

architecture PLL40_V of PLL40 is 

	attribute VITAL_LEVEL0 of PLL40_V  : architecture is true;

 component Sbt_DS_PLL40  is
 
	generic ( 
		 FEEDBACK_PATH 			: string 	:="SIMPLE"; 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 	:="FIXED"; 
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 	:="FIXED";
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00"; 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 	:="GENCLK"; 
		 PLLOUT_SELECT_PORTB            : string        :="GENCLK";

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			:bit_vector(2 downto 0)  := "000";  
		 FILTER_RANGE 			:bit_vector(2 downto 0)  := "000";
		 TEST_MODE         :bit        :='0'; 		
 		ENABLE_ICEGATE_PORTA             :bit 			:='0';
		ENABLE_ICEGATE_PORTB            :bit 			:='0' 
	);
	port	(
		CORE_REF_CLK	: in    std_logic:='0';
		EXTFEEDBACK 	: in    std_logic;
		DYNAMICDELAY	: in    std_logic_vector(7 downto 0); 
		BYPASS 		: in	std_logic;
		RESETB	 	: in 	std_logic;
		PLLOUT1 	: out  	std_logic;
		PLLOUT2		: out 	std_logic ; 
		LOCK		: out 	std_logic ;
        PACKAGEPIN : in  std_logic :='0';
        PLL_SCK     :in std_logic;
        PLL_SDI     :in std_logic;
        PLL_SDO     :out std_logic 
	); 
end component;	
 component SbtSPLL40  is
 
	generic ( 
		 FEEDBACK_PATH 			: string 	:="SIMPLE"; 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 	:="FIXED"; 
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 	:="FIXED";
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00"; 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 	:="GENCLK"; 
		 PLLOUT_SELECT_PORTB            : string        :="GENCLK";

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			:bit_vector(2 downto 0)  := "000";  
		 FILTER_RANGE 			:bit_vector(2 downto 0)  := "000";
		 		
 		ENABLE_ICEGATE_PORTA             :bit 			:='0';
		ENABLE_ICEGATE_PORTB            :bit 			:='0' 
	);
	port	(
		REFERENCECLK	: in    std_logic;
		EXTFEEDBACK 	: in    std_logic;
		DYNAMICDELAY	: in    std_logic_vector(7 downto 0); 
		BYPASS 		: in	std_logic;
		RESETB	 	: in 	std_logic;
		PLLOUT1 	: out  	std_logic;
		PLLOUT2		: out 	std_logic ; 
		LOCK		: out 	std_logic  
	); 
end component;

  -- Vital Wire Delay Signals   	
  signal PLLIN_ipd 	: std_ulogic := 'X';
  signal EXTFEEDBACK_ipd  	: std_ulogic := 'X';
  signal DYNAMICDELAY_ipd  	: std_logic_vector(7 downto 0) := (others =>'X');
  signal BYPASS_ipd   		: std_ulogic := 'X';
  signal RESETB_ipd 		: std_ulogic := 'X';
  signal SDI_ipd  		: std_ulogic := 'X';
  signal SCLK_ipd  		: std_ulogic := 'X';
  signal LATCHINPUTVALUE_ipd  	: std_ulogic := 'X';

 -- Vital output logic signals
 signal PLLOUTCORE_zd : std_ulogic;
 signal PLLOUTGLOBAL_zd : std_ulogic;
 signal LOCK_zd : std_ulogic;
 signal SDO_zd : std_ulogic;
 signal Violation : std_ulogic;

 -- Functional Signals 
 signal not_resetb  		 : std_logic; 
 signal SPLLOUT1net, SPLLOUT2net : std_logic; 
 signal PLLOUTCORE_temp 	 : std_logic; 
 signal PLLOUTGLOBAL_temp 	 : std_logic; 

begin 

 WireDelay   : block
 begin
          VitalWireDelay (PLLIN_ipd, PLLIN, tipd_PLLIN);
          VitalWireDelay (EXTFEEDBACK_ipd,  EXTFEEDBACK, tipd_EXTFEEDBACK);
	  DYNAMIC_DELAY : for i in 7 downto 0 generate 
	          VitalWireDelay (DYNAMICDELAY_ipd(i),DYNAMICDELAY(i),tipd_DYNAMICDELAY(i));
	  end generate DYNAMIC_DELAY; 
          VitalWireDelay (BYPASS_ipd,BYPASS, tipd_BYPASS);
          VitalWireDelay (RESETB_ipd,RESETB, tipd_RESETB);
          VitalWireDelay (SDI_ipd, SDI, tipd_SDI);
          VitalWireDelay (SCLK_ipd, SCLK, tipd_SCLK);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
 end block;

 ------ Behavioral Section   
 not_resetb <= not(RESETB_ipd);  
 D: if(TEST_MODE='1') generate
 instSbtSPLL : Sbt_DS_PLL40
 generic map 	( 
		FEEDBACK_PATH 			=> FEEDBACK_PATH,
		DELAY_ADJUSTMENT_MODE_RELATIVE 	=> DELAY_ADJUSTMENT_MODE_RELATIVE,
		DELAY_ADJUSTMENT_MODE_FEEDBACK 	=> DELAY_ADJUSTMENT_MODE_FEEDBACK,
		SHIFTREG_DIV_MODE 		=> SHIFTREG_DIV_MODE,
		FDA_RELATIVE 			=> FDA_RELATIVE,
		FDA_FEEDBACK 			=> FDA_FEEDBACK,
		PLLOUT_SELECT_PORTA 		=> PLLOUT_SELECT,
		PLLOUT_SELECT_PORTB 		=> "GENCLK",
		DIVR 				=> DIVR,
		DIVF 				=> DIVF,
		DIVQ 				=> DIVQ,
		FILTER_RANGE 			=> FILTER_RANGE,
 		ENABLE_ICEGATE_PORTA             =>'0',
        	TEST_MODE          => TEST_MODE,
		ENABLE_ICEGATE_PORTB            =>'0' 
	     	)
 port map    	(
                CORE_REF_CLK 			=>open,
                EXTFEEDBACK 			=> EXTFEEDBACK_ipd,
                DYNAMICDELAY 			=> DYNAMICDELAY_ipd,
                BYPASS 				=> BYPASS_ipd,
                RESETB 				=> not_resetb ,
                PLLOUT1 			=> SPLLOUT1net,
                PLLOUT2 			=> SPLLOUT2net,
                LOCK 				=> LOCK,
                PACKAGEPIN =>PLLIN_ipd,
                PLL_SCK =>      SCLK_ipd,
                PLL_SDI =>      SDI_ipd,
                PLL_SDO =>      SDO_zd
		);
end generate D;	
S: if(TEST_MODE='0') generate
 instSbtSPLL : SbtSPLL40 
 generic map 	( 
		FEEDBACK_PATH 			=> FEEDBACK_PATH,
		DELAY_ADJUSTMENT_MODE_RELATIVE 	=> DELAY_ADJUSTMENT_MODE_RELATIVE,
		DELAY_ADJUSTMENT_MODE_FEEDBACK 	=> DELAY_ADJUSTMENT_MODE_FEEDBACK,
		SHIFTREG_DIV_MODE 		=> SHIFTREG_DIV_MODE,
		FDA_RELATIVE 			=> FDA_RELATIVE,
		FDA_FEEDBACK 			=> FDA_FEEDBACK,
		PLLOUT_SELECT_PORTA 		=> PLLOUT_SELECT,
		PLLOUT_SELECT_PORTB 		=> "GENCLK",
		DIVR 				=> DIVR,
		DIVF 				=> DIVF,
		DIVQ 				=> DIVQ,
		FILTER_RANGE 			=> FILTER_RANGE,
 		ENABLE_ICEGATE_PORTA            =>'0',
		ENABLE_ICEGATE_PORTB            =>'0' 
	     	)
 port map    	(
                REFERENCECLK 			=> PLLIN_ipd,
                EXTFEEDBACK 			=> EXTFEEDBACK_ipd,
                DYNAMICDELAY 			=> DYNAMICDELAY_ipd,
                BYPASS 				=> BYPASS_ipd,
                RESETB 				=> not_resetb ,
                PLLOUT1 			=> SPLLOUT1net,
                PLLOUT2 			=> SPLLOUT2net,
                LOCK 				=> LOCK
		);
 end generate S;	


 process(PLLOUTCORE_temp, SPLLOUT1net)  
 begin 
	if(ENABLE_ICEGATE = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTCORE_temp <= PLLOUTCORE_temp ; 
	else 
		PLLOUTCORE_temp <= SPLLOUT1net; 
	end if;
 end process; 


 process(PLLOUTGLOBAL_temp, SPLLOUT1net)  
 begin 
	if(ENABLE_ICEGATE = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTGLOBAL_temp <= PLLOUTGLOBAL_temp ; 
	else 
		PLLOUTGLOBAL_temp <= SPLLOUT1net; 
	end if; 
 end process; 

 PLLOUTCORE_zd 	<= PLLOUTCORE_temp; 
 PLLOUTGLOBAL_zd 	<= PLLOUTGLOBAL_temp;  

 VITALTimingCheck:process(SCLK_ipd,SDI_ipd)
     variable Tviol_SDI_SCLK_posedge       	: std_ulogic := '0';
     variable Tmkr_SDI_SCLK_posedge       	: VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SDI_SCLK_negedge       	: std_ulogic := '0';
     variable Tmkr_SDI_SCLK_negedge       	: VitalTimingDataType := VitalTimingDataInit;
 begin
 if(TimingChecksOn) then
           VitalSetupHoldCheck (
        Violation      => Tviol_SDI_SCLK_posedge,
        TimingData     => Tmkr_SDI_SCLK_posedge,
        TestSignal     => SDI_ipd,
        TestSignalName => "SDI",
        TestDelay      => 0 ns,
        RefSignal      => SCLK_ipd,
        RefSignalName  => "SCLK",
        RefDelay       => 0 ns,
        SetupHigh      => tsetup_SDI_SCLK_posedge_posedge,
        SetupLow       => tsetup_SDI_SCLK_negedge_posedge,
        HoldLow        => thold_SDI_SCLK_posedge_posedge,
        HoldHigh       => thold_SDI_SCLK_negedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PLL40",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);

           VitalSetupHoldCheck (
        Violation      => Tviol_SDI_SCLK_negedge,
        TimingData     => Tmkr_SDI_SCLK_negedge,
        TestSignal     => SDI_ipd,
        TestSignalName => "SDI",
        TestDelay      => 0 ns,
        RefSignal      => SCLK_ipd,
        RefSignalName  => "SCLK",
        RefDelay       => 0 ns,
        SetupHigh      => tsetup_SDI_SCLK_posedge_negedge,
        SetupLow       => tsetup_SDI_SCLK_negedge_negedge,
        HoldLow        => thold_SDI_SCLK_posedge_negedge,
        HoldHigh       => thold_SDI_SCLK_negedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PLL40",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
end if;
end process VITALTimingCheck; 
 ---------------------------- 
 -- Vital Path delay  
 ---------------------------
  VITALPathDelay          : process (PLLOUTCORE_zd, PLLOUTGLOBAL_zd, PLLIN_ipd,SCLK_ipd,SDO_zd )
  	variable PLLOUTCORE_GlitchData 	 : VitalGlitchDataType;
	variable PLLOUTCORE_sig : std_ulogic := 'X';
	variable PLLOUTGLOBAL_GlitchData : VitalGlitchDataType;
	variable PLLOUTGLOBAL_sig : std_ulogic := 'X';
	variable SDO_GlitchData : VitalGlitchDataType;
	variable SDO_sig : std_ulogic := 'X';
	variable LOCK_zd		 : VitalGlitchDataType;

  begin 	
	  PLLOUTCORE_sig:=PLLOUTCORE_zd;
  PLLOUTGLOBAL_sig:=PLLOUTGLOBAL_zd;
  SDO_sig:=SDO_zd;
  VitalPathDelay01 (
      OutSignal                 => PLLOUTCORE,
      GlitchData                => PLLOUTCORE_GlitchData,
      OutSignalName             => "PLLOUTCORE",
      OutTemp                   => PLLOUTCORE_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTCORE,true)
							),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
      VitalPathDelay01 (
      OutSignal                 => PLLOUTGLOBAL,
      GlitchData                => PLLOUTGLOBAL_GlitchData,
      OutSignalName             => "PLLOUTGLOBAL",
      OutTemp                   => PLLOUTGLOBAL_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTGLOBAL, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	        VitalPathDelay01 (
      OutSignal                 => SDO,
      GlitchData                => SDO_GlitchData,
      OutSignalName             => "SDO",
      OutTemp                   => SDO_sig,
      Paths                     => (0 => (SCLK_ipd'last_event, tpd_SCLK_SDO_negedge, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;	

end PLL40_V; 


---------------------------------------------------------------------------
----			 PLL40_2	  				---	
---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;
use work.all; 


entity PLL40_2  is 
	
	generic ( 
		----------------------------------------------------------------------------------
                --VITAL PARAMETER
                ---------------------------------------------------------------------------------
                TimingChecksOn  	: boolean := true;
                Xon   			: boolean := true;
	        MsgOn 			: boolean := false;	 
                thold_SDI_SCLK_negedge_posedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_posedge_posedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_negedge_negedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_posedge_negedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_negedge_posedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_posedge_posedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_negedge_negedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_posedge_negedge:VitalDelayType :=0 ns; 
		tpd_SCLK_SDO_negedge          	: VitalDelayType01 := (0 ns, 0 ns);	
                --- VITAL input port delay 
                tipd_PLLIN  	        : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_EXTFEEDBACK        : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_DYNAMICDELAY       : VitalDelayArrayType01(7 downto 0)  := (others => (0 ns, 0 ns));
            	tipd_BYPASS             : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_RESETB             : VitalDelayType01 := (0 ns, 0 ns);
                tipd_SDI        	: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_SCLK           	: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_LATCHINPUTVALUE   	: VitalDelayType01 := (0 ns, 0 ns);
		-- VITAL Path Delay 	
            	tpd_PLLIN_PLLOUTCOREA           	: VitalDelayType01 := (0 ns, 0 ns);
            	tpd_PLLIN_PLLOUTGLOBALA          	: VitalDelayType01 := (0 ns, 0 ns);

            	tpd_PLLIN_PLLOUTCOREB           	: VitalDelayType01 := (0 ns, 0 ns);
            	tpd_PLLIN_PLLOUTGLOBALB          	: VitalDelayType01 := (0 ns, 0 ns);
	         -- Entity Parameters 	
		 FEEDBACK_PATH 			: string 		 :="SIMPLE";   -- SIMPLE/DELAY/PHASE_AND_DELAY/EXTERNAL 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 		 :="FIXED";    -- FIXED/DYNAMIC  
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 		 :="FIXED";    -- FIXED/DYNAMIC 
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00";      -- 00 (div by 4)/ 01 (div by 7)/11 (div by 5)   	 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTB		: string 		 :="GENCLK"; 

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			: bit_vector(2 downto 0) := "000";  
		 FILTER_RANGE 			: bit_vector(2 downto 0) := "000";
		 		
 		 ENABLE_ICEGATE_PORTA	        : bit 			 :='0';
 		 ENABLE_ICEGATE_PORTB	        : bit 			 :='0';
		 TEST_MODE			: bit 			 :='0';  
		 EXTERNAL_DIVIDE_FACTOR         : integer 		 := 1      -- Required for PLL Config Wizard.  
	);
	port (
                PLLIN			: in std_logic;           -- PLL ref clock, driven by PAD.  
                PLLOUTCOREA	     	: out std_logic;          -- PLLA output to core logic through local routings. 
                PLLOUTGLOBALA           : out std_logic;   	  -- PLLA output to dedicated global clock network
                PLLOUTCOREB	     	: out std_logic;          -- PLLB output to core logic through local routings. 
                PLLOUTGLOBALB           : out std_logic;   	  -- PLLB output to dedicated global clock network
                EXTFEEDBACK             : in std_logic;  	  -- FB driven by core logic
                DYNAMICDELAY            : in std_logic_vector(7 downto 0);  -- driven by core logic
                LOCK                    : out std_logic;	  -- PLL Lock signal output  
                BYPASS                  : in std_logic; 	  -- REFCLK passed to PLLOUT when bypass is '1'.Driven by core logic
                RESETB                  : in std_logic; 	  -- Active low reset,Driven by core logic
                SDI                     : in std_logic;		  -- Test Input. Driven by core logic. 
                SDO                     : out std_logic; 	  -- Test output to RB Logic Tile.
                SCLK                    : in std_logic;	          -- Test Clk input.Driven by core logic. 
                LATCHINPUTVALUE         : in std_logic 		  -- iCEGate signal
	);

       attribute VITAL_LEVEL0 of PLL40_2 : entity is true;

end PLL40_2; 

architecture PLL40_2_V of PLL40_2 is 

	attribute VITAL_LEVEL0 of PLL40_2_V  : architecture is true;


 component SbtSPLL40  is
 
	generic ( 
		 FEEDBACK_PATH 			: string 	:="SIMPLE"; 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 	:="FIXED"; 
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 	:="FIXED";
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00";		 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 	:="GENCLK"; 
		 PLLOUT_SELECT_PORTB            : string        :="GENCLK"; 

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			:bit_vector(2 downto 0)  := "000";  
		 FILTER_RANGE 			:bit_vector(2 downto 0)  := "000";
		 		
 		ENABLE_ICEGATE_PORTA             :bit 			:='0';
		ENABLE_ICEGATE_PORTB            :bit 			:='0' 
	);
	port	(
		REFERENCECLK	: in    std_logic;
		EXTFEEDBACK 	: in    std_logic;
		DYNAMICDELAY	: in    std_logic_vector(7 downto 0); 
		BYPASS 		: in	std_logic;
		RESETB	 	: in 	std_logic;
		PLLOUT1 	: out  	std_logic;
		PLLOUT2		: out 	std_logic ; 
		LOCK		: out 	std_logic  
	); 
end component;

component Sbt_DS_PLL40  is
 
	generic ( 
		 FEEDBACK_PATH 			: string 	:="SIMPLE"; 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 	:="FIXED"; 
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 	:="FIXED";
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00"; 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 	:="GENCLK"; 
		 PLLOUT_SELECT_PORTB            : string        :="GENCLK";

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			:bit_vector(2 downto 0)  := "000";  
		 FILTER_RANGE 			:bit_vector(2 downto 0)  := "000";
		 TEST_MODE         :bit        :='0'; 		
 		ENABLE_ICEGATE_PORTA             :bit 			:='0';
		ENABLE_ICEGATE_PORTB            :bit 			:='0' 
	);
	port	(
		CORE_REF_CLK	: in    std_logic:='0';
		EXTFEEDBACK 	: in    std_logic;
		DYNAMICDELAY	: in    std_logic_vector(7 downto 0); 
		BYPASS 		: in	std_logic;
		RESETB	 	: in 	std_logic;
		PLLOUT1 	: out  	std_logic;
		PLLOUT2		: out 	std_logic ; 
		LOCK		: out 	std_logic ;
        PACKAGEPIN : in  std_logic :='0';
        PLL_SCK     :in std_logic;
        PLL_SDI     :in std_logic;
        PLL_SDO     :out std_logic 
	); 
end component;	
  -- Vital Wire Delay Signals   	
  signal PLLIN_ipd 	: std_ulogic := 'X';
  signal EXTFEEDBACK_ipd  	: std_ulogic := 'X';
  signal DYNAMICDELAY_ipd  	: std_logic_vector(7 downto 0) := (others =>'X');
  signal BYPASS_ipd   		: std_ulogic := 'X';
  signal RESETB_ipd 		: std_ulogic := 'X';
  signal SDI_ipd  		: std_ulogic := 'X';
  signal SCLK_ipd  		: std_ulogic := 'X';
  signal LATCHINPUTVALUE_ipd  	: std_ulogic := 'X';

 -- Vital output logic signals
 signal PLLOUTCOREA_zd : std_ulogic;
 signal PLLOUTGLOBALA_zd : std_ulogic;
 signal PLLOUTCOREB_zd : std_ulogic;
 signal PLLOUTGLOBALB_zd : std_ulogic;
 signal LOCK_zd : std_ulogic;
 signal SDO_zd : std_ulogic;
 signal Violation : std_ulogic;

 -- Functional signals 
 signal not_resetb  		 : std_logic; 
 signal SPLLOUT1net, SPLLOUT2net : std_logic; 
 signal PLLOUTCOREA_temp 	 : std_logic; 
 signal PLLOUTGLOBALA_temp 	 : std_logic; 
 signal PLLOUTCOREB_temp 	 : std_logic; 
 signal PLLOUTGLOBALB_temp 	 : std_logic; 


begin 

 WireDelay   : block
 begin
          VitalWireDelay (PLLIN_ipd, PLLIN, tipd_PLLIN);
          VitalWireDelay (EXTFEEDBACK_ipd,  EXTFEEDBACK, tipd_EXTFEEDBACK);
	  DYNAMIC_DELAY : for i in 7 downto 0 generate 
	          VitalWireDelay (DYNAMICDELAY_ipd(i),DYNAMICDELAY(i),tipd_DYNAMICDELAY(i));
	  end generate DYNAMIC_DELAY; 
          VitalWireDelay (BYPASS_ipd,BYPASS, tipd_BYPASS);
          VitalWireDelay (RESETB_ipd,RESETB, tipd_RESETB);
          VitalWireDelay (SDI_ipd, SDI, tipd_SDI);
          VitalWireDelay (SCLK_ipd, SCLK, tipd_SCLK);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
 end block;

 ------ Behavioral Section   
 not_resetb <= not(RESETB_ipd);  
 
 D: if(TEST_MODE='1') generate
 instSbtSPLL : Sbt_DS_PLL40
 generic map 	( 
		FEEDBACK_PATH 			=> FEEDBACK_PATH,
		DELAY_ADJUSTMENT_MODE_RELATIVE 	=> DELAY_ADJUSTMENT_MODE_RELATIVE,
		DELAY_ADJUSTMENT_MODE_FEEDBACK 	=> DELAY_ADJUSTMENT_MODE_FEEDBACK,
		SHIFTREG_DIV_MODE 		=> SHIFTREG_DIV_MODE,
		FDA_RELATIVE 			=> FDA_RELATIVE,
		FDA_FEEDBACK 			=> FDA_FEEDBACK,
		PLLOUT_SELECT_PORTA 		=> "GENCLK",
		PLLOUT_SELECT_PORTB 		=> PLLOUT_SELECT_PORTB, 
		DIVR 				=> DIVR,
		DIVF 				=> DIVF,
		DIVQ 				=> DIVQ,
		FILTER_RANGE 			=> FILTER_RANGE,
 		ENABLE_ICEGATE_PORTA             =>'0',
		ENABLE_ICEGATE_PORTB            =>'0' ,
        TEST_MODE          => TEST_MODE
	     	)
 port map    	(
                CORE_REF_CLK 			=>open,
                EXTFEEDBACK 			=> EXTFEEDBACK_ipd,
                DYNAMICDELAY 			=> DYNAMICDELAY_ipd,
                BYPASS 				=> BYPASS_ipd,
                RESETB 				=> not_resetb ,
                PLLOUT1 			=> SPLLOUT1net,
                PLLOUT2 			=> SPLLOUT2net,
                LOCK 				=> LOCK,
                PACKAGEPIN 			=> PLLIN_ipd,
                PLL_SCK 			=> SCLK_ipd,
                PLL_SDI 			=> SDI_ipd,
                PLL_SDO 			=> SDO_zd
		);
end generate D;	
 
 S: if(TEST_MODE='0') generate
instSbtSPLL : SbtSPLL40 
 generic map 	( 
		FEEDBACK_PATH 			=> FEEDBACK_PATH,
		DELAY_ADJUSTMENT_MODE_RELATIVE 	=> DELAY_ADJUSTMENT_MODE_RELATIVE,
		DELAY_ADJUSTMENT_MODE_FEEDBACK 	=> DELAY_ADJUSTMENT_MODE_FEEDBACK,
		SHIFTREG_DIV_MODE 		=> SHIFTREG_DIV_MODE,
		FDA_RELATIVE 			=> FDA_RELATIVE,
		FDA_FEEDBACK 			=> FDA_FEEDBACK,
		PLLOUT_SELECT_PORTA 		=> "GENCLK",
		PLLOUT_SELECT_PORTB 		=> PLLOUT_SELECT_PORTB, 
		DIVR 				=> DIVR,
		DIVF 				=> DIVF,
		DIVQ 				=> DIVQ,
		FILTER_RANGE 			=> FILTER_RANGE,
 		ENABLE_ICEGATE_PORTA             =>'0',
		ENABLE_ICEGATE_PORTB            =>'0' 
	     	)
 port map    	(
                REFERENCECLK 			=> PLLIN_ipd,
                EXTFEEDBACK 			=> EXTFEEDBACK_ipd,
                DYNAMICDELAY 			=> DYNAMICDELAY_ipd,
                BYPASS 				=> BYPASS_ipd,
                RESETB 				=> not_resetb ,
                PLLOUT1 			=> SPLLOUT1net,
                PLLOUT2 			=> SPLLOUT2net,
                LOCK 				=> LOCK
		);
end generate S;

  -- PLLA
 process( PLLOUTCOREA_temp, PLLIN )  
 begin 
	if(ENABLE_ICEGATE_PORTA = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTCOREA_temp <= PLLOUTCOREA_temp ; 
	else 
		PLLOUTCOREA_temp <= PLLIN; 
	end if;
 end process; 


 process( PLLOUTGLOBALA_temp, PLLIN )  
 begin 
	if(ENABLE_ICEGATE_PORTA = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTGLOBALA_temp <= PLLOUTGLOBALA_temp ; 
	else 
		PLLOUTGLOBALA_temp <= PLLIN; 
	end if; 
 end process; 

 PLLOUTCOREA_zd 	<= PLLOUTCOREA_temp; 
 PLLOUTGLOBALA_zd 	<= PLLOUTGLOBALA_temp;  

 --PLLB
 process( PLLOUTCOREB_temp, SPLLOUT2net )  
 begin 
	if(ENABLE_ICEGATE_PORTB = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTCOREB_temp <= PLLOUTCOREB_temp ; 
	else 
		PLLOUTCOREB_temp <= SPLLOUT2net; 
	end if;
 end process; 


 process( PLLOUTGLOBALB_temp, SPLLOUT2net )  
 begin 
	if(ENABLE_ICEGATE_PORTB = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTGLOBALB_temp <= PLLOUTGLOBALB_temp ; 
	else 
		PLLOUTGLOBALB_temp <= SPLLOUT2net; 
	end if; 
 end process; 

 PLLOUTCOREB_zd 	<= PLLOUTCOREB_temp; 
 PLLOUTGLOBALB_zd 	<= PLLOUTGLOBALB_temp;  
 
 VITALTimingCheck:process(SCLK_ipd,SDI_ipd)
     variable Tviol_SDI_SCLK_posedge       	: std_ulogic := '0';
     variable Tmkr_SDI_SCLK_posedge       	: VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SDI_SCLK_negedge       	: std_ulogic := '0';
     variable Tmkr_SDI_SCLK_negedge       	: VitalTimingDataType := VitalTimingDataInit;
 begin
 if(TimingChecksOn) then
           VitalSetupHoldCheck (
        Violation      => Tviol_SDI_SCLK_posedge,
        TimingData     => Tmkr_SDI_SCLK_posedge,
        TestSignal     => SDI_ipd,
        TestSignalName => "SDI",
        TestDelay      => 0 ns,
        RefSignal      => SCLK_ipd,
        RefSignalName  => "SCLK",
        RefDelay       => 0 ns,
        SetupHigh      => tsetup_SDI_SCLK_posedge_posedge,
        SetupLow       => tsetup_SDI_SCLK_negedge_posedge,
        HoldLow        => thold_SDI_SCLK_posedge_posedge,
        HoldHigh       => thold_SDI_SCLK_negedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PLL40",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);

           VitalSetupHoldCheck (
        Violation      => Tviol_SDI_SCLK_negedge,
        TimingData     => Tmkr_SDI_SCLK_negedge,
        TestSignal     => SDI_ipd,
        TestSignalName => "SDI",
        TestDelay      => 0 ns,
        RefSignal      => SCLK_ipd,
        RefSignalName  => "SCLK",
        RefDelay       => 0 ns,
        SetupHigh      => tsetup_SDI_SCLK_posedge_negedge,
        SetupLow       => tsetup_SDI_SCLK_negedge_negedge,
        HoldLow        => thold_SDI_SCLK_posedge_negedge,
        HoldHigh       => thold_SDI_SCLK_negedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PLL40",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
end if;
end process VITALTimingCheck; 
 ---------------------------- 
 -- Vital Path delay  
 ---------------------------
  VITALPathDelay          : process (PLLOUTCOREA_zd, PLLOUTGLOBALA_zd,PLLOUTCOREB_zd, PLLOUTGLOBALB_zd,PLLIN_ipd,SCLK_ipd,SDO_zd )
  	variable PLLOUTCOREA_GlitchData 	: VitalGlitchDataType;
	variable PLLOUTGLOBALA_GlitchData 	: VitalGlitchDataType;
  	variable PLLOUTCOREB_GlitchData 	: VitalGlitchDataType;
	variable PLLOUTGLOBALB_GlitchData 	: VitalGlitchDataType; 
	  	variable PLLOUTCORE_GlitchData 	 : VitalGlitchDataType;
	variable PLLOUTCOREA_sig : std_ulogic := 'X';
	variable PLLOUTGLOBALA_sig : std_ulogic := 'X';	
		variable PLLOUTCOREB_sig : std_ulogic := 'X';
	variable PLLOUTGLOBALB_sig : std_ulogic := 'X';
	variable SDO_GlitchData : VitalGlitchDataType;
	variable SDO_sig : std_ulogic := 'X';
	variable LOCK_zd		 	: VitalGlitchDataType;

  begin 
	  PLLOUTCOREA_sig:=PLLOUTCOREA_zd; 
	   PLLOUTCOREB_sig:=PLLOUTCOREB_zd;
  PLLOUTGLOBALA_sig:=PLLOUTGLOBALA_zd; 
  PLLOUTGLOBALB_sig:=PLLOUTGLOBALB_zd;
  SDO_sig:=SDO_zd;
  VitalPathDelay01 (
      OutSignal                 => PLLOUTCOREA,
      GlitchData                => PLLOUTCOREA_GlitchData,
      OutSignalName             => "PLLOUTCOREA",
      OutTemp                   => PLLOUTCOREA_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTCOREA,true) ),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  VitalPathDelay01 (
      OutSignal                 => PLLOUTGLOBALA,
      GlitchData                => PLLOUTGLOBALA_GlitchData,
      OutSignalName             => "PLLOUTGLOBALA",
      OutTemp                   => PLLOUTGLOBALA_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTGLOBALA, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);

  VitalPathDelay01 (
      OutSignal                 => PLLOUTCOREB,
      GlitchData                => PLLOUTCOREB_GlitchData,
      OutSignalName             => "PLLOUTCOREB",
      OutTemp                   => PLLOUTCOREB_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTCOREB,true)
							),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  VitalPathDelay01 (
      OutSignal                 => PLLOUTGLOBALB,
      GlitchData                => PLLOUTGLOBALB_GlitchData,
      OutSignalName             => "PLLOUTGLOBALB",
      OutTemp                   => PLLOUTGLOBALB_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTGLOBALB, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
 VitalPathDelay01 (
      OutSignal                 => SDO,
      GlitchData                => SDO_GlitchData,
      OutSignalName             => "SDO",
      OutTemp                   => SDO_sig,
      Paths                     => (0 => (SCLK_ipd'last_event, tpd_SCLK_SDO_negedge, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;	

end PLL40_2_V; 


---------------------------------------------------------------------------
----			 PLL40_2F 				---	
---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;
use work.all; 



entity PLL40_2F  is 
	
	generic ( 
		----------------------------------------------------------------------------------
                --VITAL PARAMETER
                ---------------------------------------------------------------------------------
                TimingChecksOn  	: boolean := true;
                Xon   			: boolean := true;
	        MsgOn 			: boolean := false;	
                thold_SDI_SCLK_negedge_posedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_posedge_posedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_negedge_negedge:VitalDelayType :=0 ns;
                thold_SDI_SCLK_posedge_negedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_negedge_posedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_posedge_posedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_negedge_negedge:VitalDelayType :=0 ns;
                tsetup_SDI_SCLK_posedge_negedge:VitalDelayType :=0 ns; 
		tpd_SCLK_SDO_negedge          	: VitalDelayType01 := (0 ns, 0 ns);	
                --- VITAL input port delay 
                tipd_PLLIN       : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_EXTFEEDBACK        : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_DYNAMICDELAY       : VitalDelayArrayType01(7 downto 0)  := (others => (0 ns, 0 ns));
            	tipd_BYPASS             : VitalDelayType01 := (0 ns, 0 ns);
            	tipd_RESETB             : VitalDelayType01 := (0 ns, 0 ns);
                tipd_SDI        	: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_SCLK           	: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_LATCHINPUTVALUE   	: VitalDelayType01 := (0 ns, 0 ns);
		-- VITAL Path Delay 	
            	tpd_PLLIN_PLLOUTCOREA           	: VitalDelayType01 := (0 ns, 0 ns);
            	tpd_PLLIN_PLLOUTGLOBALA          	: VitalDelayType01 := (0 ns, 0 ns);
            	tpd_PLLIN_PLLOUTCOREB           	: VitalDelayType01 := (0 ns, 0 ns);
            	tpd_PLLIN_PLLOUTGLOBALB          	: VitalDelayType01 := (0 ns, 0 ns);
	         -- Entity Parameters 	
		 FEEDBACK_PATH 			: string 		 :="SIMPLE";   -- SIMPLE/DELAY/PHASE_AND_DELAY/EXTERNAL 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 		 :="FIXED";    -- FIXED/DYNAMIC  
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 		 :="FIXED";    -- FIXED/DYNAMIC 
		 SHIFTREG_DIV_MODE		:  bit_vector(1 downto 0) := "00";      -- 00 (div by 4)/ 01 (div by 7)/11 (div by 5)   	 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 		 :="GENCLK"; 
		 PLLOUT_SELECT_PORTB		: string 		 :="GENCLK"; 

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			: bit_vector(2 downto 0) := "000";  
		 FILTER_RANGE 			: bit_vector(2 downto 0) := "000";
		 		
 		 ENABLE_ICEGATE_PORTA	        : bit 			 :='0';
 		 ENABLE_ICEGATE_PORTB	        : bit 			 :='0';
		 TEST_MODE			: bit 			 :='0';  
		 EXTERNAL_DIVIDE_FACTOR         : integer 		 := 1      -- Required for PLL Config Wizard.  
	);
	port (
                PLLIN			: in std_logic;           -- PLL ref clock, driven by PAD.  
                PLLOUTCOREA	     	: out std_logic;          -- PLLA output to core logic through local routings. 
                PLLOUTGLOBALA           : out std_logic;   	  -- PLLA output to dedicated global clock network
                PLLOUTCOREB	     	: out std_logic;          -- PLLB output to core logic through local routings. 
                PLLOUTGLOBALB           : out std_logic;   	  -- PLLB output to dedicated global clock network
                EXTFEEDBACK             : in std_logic;  	  -- FB driven by core logic
                DYNAMICDELAY            : in std_logic_vector(7 downto 0);  -- driven by core logic
                LOCK                    : out std_logic;	  -- PLL Lock signal output  
                BYPASS                  : in std_logic; 	  -- REFCLK passed to PLLOUT when bypass is '1'.Driven by core logic
                RESETB                  : in std_logic; 	  -- Active low reset,Driven by core logic
                SDI                     : in std_logic;		  -- Test Input. Driven by core logic. 
                SDO                     : out std_logic; 	  -- Test output to RB Logic Tile.
                SCLK                    : in std_logic;	          -- Test Clk input.Driven by core logic. 
                LATCHINPUTVALUE         : in std_logic 		  -- iCEGate signal
	);

       attribute VITAL_LEVEL0 of PLL40_2F : entity is true;

end PLL40_2F; 

architecture PLL40_2F_V of PLL40_2F is 

	attribute VITAL_LEVEL0 of PLL40_2F_V  : architecture is true;
 component Sbt_DS_PLL40  is
 
	generic ( 
		 FEEDBACK_PATH 			: string 	:="SIMPLE"; 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 	:="FIXED"; 
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 	:="FIXED";
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00"; 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 	:="GENCLK"; 
		 PLLOUT_SELECT_PORTB            : string        :="GENCLK";

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			:bit_vector(2 downto 0)  := "000";  
		 FILTER_RANGE 			:bit_vector(2 downto 0)  := "000";
		 TEST_MODE         :bit        :='0'; 		
 		ENABLE_ICEGATE_PORTA             :bit 			:='0';
		ENABLE_ICEGATE_PORTB            :bit 			:='0' 
	);
	port	(
		CORE_REF_CLK	: in    std_logic:='0';
		EXTFEEDBACK 	: in    std_logic;
		DYNAMICDELAY	: in    std_logic_vector(7 downto 0); 
		BYPASS 		: in	std_logic;
		RESETB	 	: in 	std_logic;
		PLLOUT1 	: out  	std_logic;
		PLLOUT2		: out 	std_logic ; 
		LOCK		: out 	std_logic ;
        	PACKAGEPIN : in  std_logic :='0';
        	PLL_SCK     :in std_logic;
        	PLL_SDI     :in std_logic;
        	PLL_SDO     :out std_logic 
	); 
end component;	

component SbtSPLL40  is
 
	generic ( 
		 FEEDBACK_PATH 			: string 	:="SIMPLE"; 
		 DELAY_ADJUSTMENT_MODE_FEEDBACK	: string 	:="FIXED"; 
		 DELAY_ADJUSTMENT_MODE_RELATIVE : string 	:="FIXED";
		 SHIFTREG_DIV_MODE		: bit_vector(1 downto 0) := "00"; 
		 FDA_FEEDBACK			: bit_vector(3 downto 0) :="0000";
		 FDA_RELATIVE			: bit_vector(3 downto 0) := "0000";
		 PLLOUT_SELECT_PORTA		: string 	:="GENCLK"; 
		 PLLOUT_SELECT_PORTB            : string        :="GENCLK"; 

		 DIVR				: bit_vector(3 downto 0) := "0000";
		 DIVF  				: bit_vector(6 downto 0) := "0000000";
		 DIVQ	   			:bit_vector(2 downto 0)  := "000";  
		 FILTER_RANGE 			:bit_vector(2 downto 0)  := "000";
		 		
 		ENABLE_ICEGATE_PORTA             :bit 			:='0';
		ENABLE_ICEGATE_PORTB            :bit 			:='0' 
	);
	port	(
		REFERENCECLK	: in    std_logic;
		EXTFEEDBACK 	: in    std_logic;
		DYNAMICDELAY	: in    std_logic_vector(7 downto 0); 
		BYPASS 		: in	std_logic;
		RESETB	 	: in 	std_logic;
		PLLOUT1 	: out  	std_logic;
		PLLOUT2		: out 	std_logic ; 
		LOCK		: out 	std_logic  
	); 
end component;

  -- Vital Wire Delay Signals   	
  signal PLLIN_ipd 		: std_ulogic := 'X';
  signal EXTFEEDBACK_ipd  	: std_ulogic := 'X';
  signal DYNAMICDELAY_ipd  	: std_logic_vector(7 downto 0) := (others =>'X');
  signal BYPASS_ipd   		: std_ulogic := 'X';
  signal RESETB_ipd 		: std_ulogic := 'X';
  signal SDI_ipd  		: std_ulogic := 'X';
  signal SCLK_ipd  		: std_ulogic := 'X';
  signal LATCHINPUTVALUE_ipd  	: std_ulogic := 'X';

 -- Vital output logic signals
 signal PLLOUTCOREA_zd : std_ulogic;
 signal PLLOUTGLOBALA_zd : std_ulogic;
 signal PLLOUTCOREB_zd : std_ulogic;
 signal PLLOUTGLOBALB_zd : std_ulogic;
 signal LOCK_zd : std_ulogic;
 signal SDO_zd : std_ulogic;
 signal Violation : std_ulogic;

 -- Functional signals 
 signal not_resetb  		 : std_logic; 
 signal SPLLOUT1net, SPLLOUT2net : std_logic; 
 signal PLLOUTCOREA_temp 	 : std_logic; 
 signal PLLOUTGLOBALA_temp 	 : std_logic; 
 signal PLLOUTCOREB_temp 	 : std_logic; 
 signal PLLOUTGLOBALB_temp 	 : std_logic; 


begin 

 WireDelay   : block
 begin
          VitalWireDelay (PLLIN_ipd, PLLIN, tipd_PLLIN);
          VitalWireDelay (EXTFEEDBACK_ipd,  EXTFEEDBACK, tipd_EXTFEEDBACK);
	  DYNAMIC_DELAY : for i in 7 downto 0 generate 
	          VitalWireDelay (DYNAMICDELAY_ipd(i),DYNAMICDELAY(i),tipd_DYNAMICDELAY(i));
	  end generate DYNAMIC_DELAY; 
          VitalWireDelay (BYPASS_ipd,BYPASS, tipd_BYPASS);
          VitalWireDelay (RESETB_ipd,RESETB, tipd_RESETB);
          VitalWireDelay (SDI_ipd, SDI, tipd_SDI);
          VitalWireDelay (SCLK_ipd, SCLK, tipd_SCLK);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
 end block;

 ------ Behavioral Section   
 not_resetb <= not(RESETB_ipd);  
 
 D: if(TEST_MODE='1') generate
 instSbtSPLL : Sbt_DS_PLL40
 generic map 	( 
		FEEDBACK_PATH 			=> FEEDBACK_PATH,
		DELAY_ADJUSTMENT_MODE_RELATIVE 	=> DELAY_ADJUSTMENT_MODE_RELATIVE,
		DELAY_ADJUSTMENT_MODE_FEEDBACK 	=> DELAY_ADJUSTMENT_MODE_FEEDBACK,
		SHIFTREG_DIV_MODE 		=> SHIFTREG_DIV_MODE,
		FDA_RELATIVE 			=> FDA_RELATIVE,
		FDA_FEEDBACK 			=> FDA_FEEDBACK,
		PLLOUT_SELECT_PORTA 		=> PLLOUT_SELECT_PORTA,
		PLLOUT_SELECT_PORTB 		=> PLLOUT_SELECT_PORTB, 
		DIVR 				=> DIVR,
		DIVF 				=> DIVF,
		DIVQ 				=> DIVQ,
		FILTER_RANGE 			=> FILTER_RANGE,
 		ENABLE_ICEGATE_PORTA             =>'0',
		ENABLE_ICEGATE_PORTB            =>'0' ,
	        TEST_MODE          		=> TEST_MODE
	     	)
 port map    	(
                CORE_REF_CLK 			=>open,
                EXTFEEDBACK 			=> EXTFEEDBACK_ipd,
                DYNAMICDELAY 			=> DYNAMICDELAY_ipd,
                BYPASS 				=> BYPASS_ipd,
                RESETB 				=> not_resetb ,
                PLLOUT1 			=> SPLLOUT1net,
                PLLOUT2 			=> SPLLOUT2net,
                LOCK 				=> LOCK,
                PACKAGEPIN 			=> PLLIN_ipd,
                PLL_SCK 			=> SCLK_ipd,
                PLL_SDI 			=> SDI_ipd,
                PLL_SDO 			=> SDO_zd
		);
end generate D;	
 
S: if(TEST_MODE='0') generate
instSbtSPLL : SbtSPLL40 
 generic map 	( 
		FEEDBACK_PATH 			=> FEEDBACK_PATH,
		DELAY_ADJUSTMENT_MODE_RELATIVE 	=> DELAY_ADJUSTMENT_MODE_RELATIVE,
		DELAY_ADJUSTMENT_MODE_FEEDBACK 	=> DELAY_ADJUSTMENT_MODE_FEEDBACK,
		SHIFTREG_DIV_MODE 		=> SHIFTREG_DIV_MODE,
		FDA_RELATIVE 			=> FDA_RELATIVE,
		FDA_FEEDBACK 			=> FDA_FEEDBACK,
		PLLOUT_SELECT_PORTA 		=> PLLOUT_SELECT_PORTA,
		PLLOUT_SELECT_PORTB 		=> PLLOUT_SELECT_PORTB, 
		DIVR 				=> DIVR,
		DIVF 				=> DIVF,
		DIVQ 				=> DIVQ,
		FILTER_RANGE 			=> FILTER_RANGE,
 		ENABLE_ICEGATE_PORTA            =>'0',
		ENABLE_ICEGATE_PORTB            =>'0' 
	     	)
 port map    	(
                REFERENCECLK 			=> PLLIN_ipd,
                EXTFEEDBACK 			=> EXTFEEDBACK_ipd,
                DYNAMICDELAY 			=> DYNAMICDELAY_ipd,
                BYPASS 				=> BYPASS_ipd,
                RESETB 				=> not_resetb ,
                PLLOUT1 			=> SPLLOUT1net,
                PLLOUT2 			=> SPLLOUT2net,
                LOCK 				=> LOCK
		);
end generate S;	

  -- PLLA
 process(PLLOUTCOREA_temp, SPLLOUT1net)  
 begin 
	if(ENABLE_ICEGATE_PORTA = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTCOREA_temp <= PLLOUTCOREA_temp ; 
	else 
		PLLOUTCOREA_temp <= SPLLOUT1net; 
	end if;
 end process; 


 process(PLLOUTGLOBALA_temp, SPLLOUT1net)  
 begin 
	if(ENABLE_ICEGATE_PORTA = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTGLOBALA_temp <= PLLOUTGLOBALA_temp ; 
	else 
		PLLOUTGLOBALA_temp <= SPLLOUT1net; 
	end if; 
 end process; 

 PLLOUTCOREA_zd 	<= PLLOUTCOREA_temp; 
 PLLOUTGLOBALA_zd 	<= PLLOUTGLOBALA_temp;  

 --PLLB

 process(PLLOUTCOREB_temp, SPLLOUT2net)  
 begin 
	if(ENABLE_ICEGATE_PORTB = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTCOREB_temp <= PLLOUTCOREB_temp ; 
	else 
		PLLOUTCOREB_temp <= SPLLOUT2net; 
	end if;
 end process; 


 process(PLLOUTGLOBALB_temp, SPLLOUT2net)  
 begin 
	if(ENABLE_ICEGATE_PORTB = '1' and LATCHINPUTVALUE_ipd ='1') then 
		PLLOUTGLOBALB_temp <= PLLOUTGLOBALB_temp ; 
	else 
		PLLOUTGLOBALB_temp <= SPLLOUT2net; 
	end if; 
 end process; 

 PLLOUTCOREB_zd 	<= PLLOUTCOREB_temp; 
 PLLOUTGLOBALB_zd 	<= PLLOUTGLOBALB_temp;  

  VITALTimingCheck:process(SCLK_ipd,SDI_ipd)
     variable Tviol_SDI_SCLK_posedge       	: std_ulogic := '0';
     variable Tmkr_SDI_SCLK_posedge       	: VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_SDI_SCLK_negedge       	: std_ulogic := '0';
     variable Tmkr_SDI_SCLK_negedge       	: VitalTimingDataType := VitalTimingDataInit;
 begin
 if(TimingChecksOn) then
           VitalSetupHoldCheck (
        Violation      => Tviol_SDI_SCLK_posedge,
        TimingData     => Tmkr_SDI_SCLK_posedge,
        TestSignal     => SDI_ipd,
        TestSignalName => "SDI",
        TestDelay      => 0 ns,
        RefSignal      => SCLK_ipd,
        RefSignalName  => "SCLK",
        RefDelay       => 0 ns,
        SetupHigh      => tsetup_SDI_SCLK_posedge_posedge,
        SetupLow       => tsetup_SDI_SCLK_negedge_posedge,
        HoldLow        => thold_SDI_SCLK_posedge_posedge,
        HoldHigh       => thold_SDI_SCLK_negedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PLL40",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);

           VitalSetupHoldCheck (
        Violation      => Tviol_SDI_SCLK_negedge,
        TimingData     => Tmkr_SDI_SCLK_negedge,
        TestSignal     => SDI_ipd,
        TestSignalName => "SDI",
        TestDelay      => 0 ns,
        RefSignal      => SCLK_ipd,
        RefSignalName  => "SCLK",
        RefDelay       => 0 ns,
        SetupHigh      => tsetup_SDI_SCLK_posedge_negedge,
        SetupLow       => tsetup_SDI_SCLK_negedge_negedge,
        HoldLow        => thold_SDI_SCLK_posedge_negedge,
        HoldHigh       => thold_SDI_SCLK_negedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/PLL40",
        Xon            => Xon,
        MsgOn          => MsgOn,
        MsgSeverity    => warning);
end if;
end process VITALTimingCheck;
 ---------------------------- 
 -- Vital Path delay  
 ---------------------------
 VITALPathDelay          : process (PLLOUTCOREA_zd, PLLOUTGLOBALA_zd,PLLOUTCOREB_zd, PLLOUTGLOBALB_zd,PLLIN_ipd,SCLK_ipd,SDO_zd)	   
   	variable PLLOUTCORE_GlitchData 	 : VitalGlitchDataType;
	variable PLLOUTCOREA_sig : std_ulogic := 'X';  
		variable PLLOUTCOREB_sig : std_ulogic := 'X';
	variable PLLOUTGLOBALA_sig : std_ulogic := 'X';
		variable PLLOUTGLOBALB_sig : std_ulogic := 'X';
	variable SDO_GlitchData : VitalGlitchDataType;
	variable SDO_sig : std_ulogic := 'X';
  	variable PLLOUTCOREA_GlitchData 	: VitalGlitchDataType;
	variable PLLOUTGLOBALA_GlitchData 	: VitalGlitchDataType;
  	variable PLLOUTCOREB_GlitchData 	: VitalGlitchDataType;
	variable PLLOUTGLOBALB_GlitchData 	: VitalGlitchDataType;
	variable LOCK_zd		 	: VitalGlitchDataType;

  begin
	  PLLOUTCOREA_sig:=PLLOUTCOREA_zd; 
	   PLLOUTCOREB_sig:=PLLOUTCOREB_zd;
  PLLOUTGLOBALA_sig:=PLLOUTGLOBALA_zd; 
  PLLOUTGLOBALB_sig:=PLLOUTGLOBALB_zd;
  SDO_sig:=SDO_zd;
  VitalPathDelay01 (
      OutSignal                 => PLLOUTCOREA,
      GlitchData                => PLLOUTCOREA_GlitchData,
      OutSignalName             => "PLLOUTCOREA",
      OutTemp                   => PLLOUTCOREA_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTCOREA,true)
							),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  VitalPathDelay01 (
      OutSignal                 => PLLOUTGLOBALA,
      GlitchData                => PLLOUTGLOBALA_GlitchData,
      OutSignalName             => "PLLOUTGLOBALA",
      OutTemp                   => PLLOUTGLOBALA_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTGLOBALA, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);

  VitalPathDelay01 (
      OutSignal                 => PLLOUTCOREB,
      GlitchData                => PLLOUTCOREB_GlitchData,
      OutSignalName             => "PLLOUTCOREB",
      OutTemp                   => PLLOUTCOREB_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTCOREB,true)
							),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
  VitalPathDelay01 (
      OutSignal                 => PLLOUTGLOBALB,
      GlitchData                => PLLOUTGLOBALB_GlitchData,
      OutSignalName             => "PLLOUTGLOBALB",
      OutTemp                   => PLLOUTGLOBALB_sig,
      Paths                     => (0 => (PLLIN_ipd'last_event, tpd_PLLIN_PLLOUTGLOBALB, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);	 
	        VitalPathDelay01 (
      OutSignal                 => SDO,
      GlitchData                => SDO_GlitchData,
      OutSignalName             => "SDO",
      OutTemp                   => SDO_sig,
      Paths                     => (0 => (SCLK_ipd'last_event, tpd_SCLK_SDO_negedge, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
 end process VITALPathDelay;	

end PLL40_2F_V; -- PLL40_2F_V

--------------------------------------------------------------------------
--					ICE_IO_DLY			--
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
library work;
use work.std_logic_SBT.all; 

entity	ICE_IO_DLY is

	generic (
		NEG_TRIGGER 	: bit				:= '0';
		PIN_TYPE	: bit_vector (5 downto 0)	:= "000000";
		PULLUP		: bit				:= '0';
		IO_STANDARD	: string			:= "SB_LVCMOS";
		INDELAY_VAL	: bit_vector (5 downto 0) 	:= "000000";
		OUTDELAY_VAL 	: bit_vector (5 downto 0) 	:= "000000";
		-------------------------------------------------------------------------------
		--VITAL PARAMETER
		--------------------------------------------------------------------------------
		TimingChecksOn  				: boolean 		:= true;
		Xon   						: boolean 		:= true;
	        MsgOn 						: boolean 		:= false;
		--- VITAL path delay
		tipd_DOUT1       				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_DOUT0       				: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_CLOCKENABLE        			: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_LATCHINPUTVALUE    			: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_INPUTCLK        				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_OUTPUTENABLE       			: VitalDelayType01 := (0 ns, 0 ns);
            	tipd_OUTPUTCLK       				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_PACKAGEPIN      				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_CRSEL      				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_SCLK 	     				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_SDI 	     				: VitalDelayType01 := (0 ns, 0 ns);

            	--- VITAL path delay
            	tpd_PACKAGEPIN_DIN0 				: VitalDelayType01 := (0.000 ns, 0.000 ns);
            	tpd_PACKAGEPIN_DIN1 				: VitalDelayType01 := (0.000 ns, 0.000 ns);
            	tpd_DOUT0_PACKAGEPIN 				: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_DOUT1_PACKAGEPIN 				: VitalDelayType01 := (0.000 ns, 0.000 ns);
            	tpd_OUTPUTENABLE_PACKAGEPIN 			: VitalDelayType01 := (0.000 ns, 0.000 ns);
            	tpd_LATCHINPUTVALUE_DIN0 			: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_LATCHINPUTVALUE_DIN1 			: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_INPUTCLK_PACKAGEPIN  			: VitalDelayType01 := (0.000 ns, 0.000 ns);
		--  VITAL clk-to-output path delay
		tpd_INPUTCLK_DIN0_posedge 			: VitalDelayType01 := (0.000 ns, 0.000 ns);
            	tpd_INPUTCLK_DIN1_negedge 			: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_OUTPUTCLK_PACKAGEPIN  			: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_OUTPUTCLK_PACKAGEPIN_posedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_OUTPUTCLK_PACKAGEPIN_negedge 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		tpd_SCLK_SDO_posedge		 		: VitalDelayType01 := (0.000 ns, 0.000 ns);
		--- VITAL setup time
		tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    	: VitalDelayType                   := 0 ns;
	        tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    	: VitalDelayType                   := 0 ns;
            	tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge 	: VitalDelayType                   := 0 ns;
            	tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge 	: VitalDelayType                   := 0 ns;
            	tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge 	: VitalDelayType                   := 0 ns;
            	tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge 	: VitalDelayType                   := 0 ns;
            	tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   	: VitalDelayType                   := 0 ns;
            	tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   	: VitalDelayType                   := 0 ns;
		tsetup_DOUT0_OUTPUTCLK_negedge_posedge   	: VitalDelayType                   := 0 ns;
            	tsetup_DOUT0_OUTPUTCLK_posedge_posedge   	: VitalDelayType                   := 0 ns;
		tsetup_DOUT1_OUTPUTCLK_negedge_negedge   	: VitalDelayType                   := 0 ns;
            	tsetup_DOUT1_OUTPUTCLK_posedge_negedge   	: VitalDelayType                   := 0 ns;
		tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            	tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
		--- VITAL hold time 
		thold_CLOCKENABLE_INPUTCLK_negedge_posedge    	: VitalDelayType                   := 0 ns;
            	thold_CLOCKENABLE_INPUTCLK_posedge_posedge    	: VitalDelayType                   := 0 ns;
            	thold_PACKAGEPIN_INPUTCLK_negedge_posedge 	: VitalDelayType                   := 0 ns;
            	thold_PACKAGEPIN_INPUTCLK_posedge_posedge 	: VitalDelayType                   := 0 ns;
            	thold_PACKAGEPIN_INPUTCLK_posedge_negedge 	: VitalDelayType                   := 0 ns;
            	thold_PACKAGEPIN_INPUTCLK_negedge_negedge 	: VitalDelayType                   := 0 ns;
            	thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge   	: VitalDelayType                   := 0 ns;
            	thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge   	: VitalDelayType                   := 0 ns;
		thold_DOUT0_OUTPUTCLK_negedge_posedge   	: VitalDelayType                   := 0 ns;
            	thold_DOUT0_OUTPUTCLK_posedge_posedge   	: VitalDelayType                   := 0 ns;
		thold_DOUT1_OUTPUTCLK_negedge_negedge   	: VitalDelayType                   := 0 ns;
            	thold_DOUT1_OUTPUTCLK_posedge_negedge   	: VitalDelayType                   := 0 ns;
		thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   	: VitalDelayType                   := 0 ns;
            	thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   	: VitalDelayType                   := 0 ns
			
 		);
	port 
		(
		PACKAGEPIN		: inout	std_logic;
		CLOCKENABLE		: in std_logic;
		INPUTCLK		: in std_logic;
		OUTPUTCLK		: in std_logic;
		LATCHINPUTVALUE		: in std_logic;
		DIN1			: out std_logic;
		DIN0			: out std_logic;
		OUTPUTENABLE		: in std_logic :='H';
		DOUT1 		    	: in std_logic;
		DOUT0 		    	: in std_logic;
		CRSEL			: in 	std_logic;  
		SCLK			: in 	std_logic; 	
		SDI			: in 	std_logic; 	
		SDO			: out 	std_logic 
		); 

	attribute VITAL_LEVEL0 of ICE_IO_DLY : entity is true;	

end ICE_IO_DLY ;

architecture ICE_IO_DLY_V of ICE_IO_DLY is
  attribute VITAL_LEVEL0 of  ICE_IO_DLY_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi	:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo	:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;

	component inoutdly64  
	generic ( 
		 INDELAY  		: bit_vector(5 downto 0)	:="000000"; 
		 OUTDELAY 		: bit_vector(5 downto 0) 	:="000000"  		 
	);
	port (
		sclk			: in 	std_logic := 'X';
		serialreg_rst   	: in  	std_logic := '1' ; 				 
		sdi 			: in    std_logic := 'X' ; 
		c_r_sel 		: in	std_logic := 'X' ;
		in_datain 		: in 	std_logic;
		out_datain 		: in  	std_logic;
		delay_direction		: in 	std_logic ; 
		delayed_dataout 	: out 	std_logic ; 
		sdo			: out 	std_logic := 'Z' 
	); 
	end component; 	


	
	signal DOUT1_ipd 		: std_ulogic := 'X';
    	signal DOUT0_ipd  		: std_ulogic := 'X';
    	signal CLOCKENABLE_ipd  	: std_ulogic := 'X';
    	signal LATCHINPUTVALUE_ipd   	: std_ulogic := 'X';
	signal INPUTCLK_ipd 		: std_ulogic := 'X';
    	signal OUTPUTENABLE_ipd  	: std_ulogic := 'X';
    	signal OUTPUTCLK_ipd  		: std_ulogic := 'X';
	signal PACKAGEPIN_ipd 		: std_ulogic;   --input direction
	signal CRSEL_ipd		: std_ulogic := 'X';
	signal SCLK_ipd			: std_ulogic := 'X';
	signal SDI_ipd			: std_ulogic := 'X'; 
	
	signal Violation 	: std_ulogic;
	--signal PACKAGEPIN_zd : std_ulogic;
	signal DIN0_zd 		: std_ulogic;
	signal DIN1_zd		: std_ulogic;
	signal SDO_zd 		: std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo_preio	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi_preio	:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
	signal	pull_up	:	std_logic;
	
	signal	hold,oepin,padoen,padout,padin	:	std_logic;	
	signal  padinout_delayed 		: 	std_logic; 
	signal INCLKE_sync, OUTCLKE_sync : std_logic; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
	  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
	  VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
	  VitalWireDelay (CRSEL_ipd, CRSEL, tipd_CRSEL);
	  VitalWireDelay (SCLK_ipd, SCLK, tipd_SCLK);
	  VitalWireDelay (SDI_ipd, SDI, tipd_SDI);
        end block;
		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	pin_cbit	<=	TO_STDLOGICVECTOR (PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
	pull_up		<=	TO_STDLOGIC	(PULLUP);
	
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;
	
	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);
	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	
	padin	<=	PACKAGEPIN_ipd;
	-----------------------------------------------------------------	
	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi	=>	sdi_preio,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo	=>	sdo_preio,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	padinout_delayed,
				padout	=>	padout,
				padoen	=>	padoen,
				cbit	=>	pin_cbit
				);

	inoutdly64_i  	:	 inoutdly64 
	generic map  ( 
		 INDELAY  		=> INDELAY_VAL ,  
		 OUTDELAY 		=> OUTDELAY_VAL
	)
	port map (
		-- dynamic delay test ,shiftreg logics disabled --
		sclk			=> open, 
		serialreg_rst   	=> open, 
		sdi 			=> open,  
		c_r_sel 		=> open, 
		in_datain 		=> padin,
		out_datain 		=> padout, 
		delay_direction		=> padoen,   
		delayed_dataout 	=> padinout_delayed, 
		sdo			=> open 
	); 
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PACKAGEPIN_ipd,CRSEL_ipd, SCLK_ipd,SDI_ipd)
    variable Tviol_DOUT0_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_DOUT1_OUTPUTCLK_negedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_INPUTCLK_posedge    : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_posedge   : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_negedge   : std_ulogic := '0';

    variable Tmkr_DOUT0_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DOUT1_OUTPUTCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_negedge   : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_posedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_negedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/ICE_IO_DLY",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (padinout_delayed, padin, padout, padoen, DOUT1_ipd, DOUT0_ipd, PACKAGEPIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd, DIN0_zd, DIN1_zd, OUTPUTCLK_ipd, INPUTCLK_ipd,SCLK_ipd)
    variable PACKAGEPIN_GlitchData : VitalGlitchDataType;
	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
	variable SDO_GlitchData : VitalGlitchDataType;
	
	variable tmp_padio : std_logic;  --PACKAGEPIN output direction

  begin
   -- padin	<=	PACKAGEPIN_ipd;
		if	(padoen='1') then
			tmp_padio	:=	'Z';
		else
			tmp_padio	:=	padinout_delayed;
		end if;
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPIN,
      GlitchData                => PACKAGEPIN_GlitchData,
      OutSignalName             => "PACKAGEPIN",
      OutTemp                   => tmp_padio,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPIN, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPIN, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPIN, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPIN, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN0, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN1, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN1, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);


	VitalPathDelay01 (
      OutSignal                 => SDO,
      GlitchData                => SDO_GlitchData,
      OutSignalName             => "SDO",
      OutTemp                   => SDO_zd,
      Paths                     => (0 => (SCLK_ipd'last_event, tpd_SCLK_SDO_posedge, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);

  end process VITALPathDelay;


end	ICE_IO_DLY_V;


---- iCE5LP 
------------------------------------------------------------------------
--					ICE_IO_OD
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
--library	work;
use	work.std_logic_SBT.all;



entity	ICE_IO_OD is

	generic (
			NEG_TRIGGER : bit						:=	'0';
			PIN_TYPE	: bit_vector (5 downto 0)	:=	"010000";
		--	PULLUP		: bit						:=	'0';
		--	IO_STANDARD	: string					:=	"SB_LVCMOS";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_DOUT1       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_DOUT0       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_CLOCKENABLE        : VitalDelayType01 := (0 ns, 0 ns);
            tipd_LATCHINPUTVALUE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_INPUTCLK        : VitalDelayType01 := (0 ns, 0 ns);
			tipd_OUTPUTENABLE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_OUTPUTCLK       : VitalDelayType01 := (0 ns, 0 ns);
			tipd_PACKAGEPIN      : VitalDelayType01 := (0 ns, 0 ns);
            --- VITAL path delay
            tpd_PACKAGEPIN_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_PACKAGEPIN_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_DOUT0_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT1_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_OUTPUTENABLE_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_LATCHINPUTVALUE_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_LATCHINPUTVALUE_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_INPUTCLK_PACKAGEPIN  : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_INPUTCLK_DIN0_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_INPUTCLK_DIN1_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--- VITAL setup time
			tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			--- VITAL hold time 
			thold_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            thold_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns
			
 			);
	port 
		(
		DOUT1 		    : in std_logic;
		DOUT0 		    : in std_logic;
		CLOCKENABLE		: in std_logic;
		LATCHINPUTVALUE	: in std_logic;
		INPUTCLK			: in std_logic;
		
		DIN1				: out std_logic;
		DIN0				: out std_logic;
		OUTPUTENABLE		: in std_logic;
		OUTPUTCLK			: in std_logic;
		PACKAGEPIN			: inout	std_logic
		); 
	attribute VITAL_LEVEL0 of
      ICE_IO_OD : entity is true;	
end ICE_IO_OD ;

architecture ICE_IO_OD_V of ICE_IO_OD is
  attribute VITAL_LEVEL0 of
    ICE_IO_OD_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi		:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo		:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;

	
	signal DOUT1_ipd : std_ulogic := 'X';
    signal DOUT0_ipd  : std_ulogic := 'X';
    signal CLOCKENABLE_ipd  : std_ulogic := 'X';
    signal LATCHINPUTVALUE_ipd   : std_ulogic := 'X';
	signal INPUTCLK_ipd : std_ulogic := 'X';
    signal OUTPUTENABLE_ipd  : std_ulogic := 'X';
    signal OUTPUTCLK_ipd  : std_ulogic := 'X';
	signal PACKAGEPIN_ipd : std_ulogic;   --input direction
	
	signal Violation : std_ulogic;
	--signal PACKAGEPIN_zd : std_ulogic;
	signal DIN0_zd : std_ulogic;
	signal DIN1_zd : std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi		:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
--	signal	pull_up	:	std_logic;
	
	signal	hold,oepin,padoen,padout,padin	:	std_logic;	
	signal INCLKE_sync , OUTCLKE_sync : std_logic; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
		  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
		  VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;
		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	pin_cbit	<=	TO_STDLOGICVECTOR	(PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
--	pull_up		<=	TO_STDLOGIC	(PULLUP);
	
--	OUTPUTENABLE	<=	'H';		--	weak 1 for initial value
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;


	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);
	
	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	
	padin	<=	PACKAGEPIN_ipd;
	-----------------------------------------------------------------	
	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi		=>	sdi,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo		=>	sdo,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	padin,
				padout	=>	padout,
				padoen	=>	padoen,
				cbit	=>	pin_cbit
				);
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PACKAGEPIN_ipd)
    variable Tviol_DOUT0_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_DOUT1_OUTPUTCLK_negedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_INPUTCLK_posedge    : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_posedge   : std_ulogic := '0';
	variable Tviol_PACKAGEPIN_INPUTCLK_negedge   : std_ulogic := '0';

    variable Tmkr_DOUT0_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DOUT1_OUTPUTCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PACKAGEPIN_INPUTCLK_negedge   : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_posedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_negedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (padout, padoen, DOUT1_ipd, DOUT0_ipd, PACKAGEPIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd, DIN0_zd, DIN1_zd, OUTPUTCLK_ipd, INPUTCLK_ipd)
    variable PACKAGEPIN_GlitchData : VitalGlitchDataType;
	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
	
	variable tmp_padio : std_logic;  --PACKAGEPIN output direction

  begin
   -- padin	<=	PACKAGEPIN_ipd;
		-- open drain IO -- 
		if	((padoen='0')and (padout='0')) then
			tmp_padio	:=	'0';
		else
			tmp_padio	:=	'Z';
		end if;
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPIN,
      GlitchData                => PACKAGEPIN_GlitchData,
      OutSignalName             => "PACKAGEPIN",
      OutTemp                   => tmp_padio,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPIN, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPIN, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPIN, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPIN, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN0, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN1, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN1, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;


end	ICE_IO_OD_V;
-------------------------------------------------
---     	ICE_IR500_DRV 		-------
-----------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all; 
USE IEEE.numeric_std.ALL;
entity  ICE_IR500_DRV  is
Generic 
(
    TimingChecksOn  : boolean := true;
    Xon   : boolean := true;					   
    MsgOn : boolean := false;
  		tpd_IRPWM_IRLED1 : VitalDelayType01 := (0 ns, 0 ns);
 		tpd_IRLEDEN_IRLED1 : VitalDelayType01 := (0 ns, 0 ns);
 		tpd_IRPWM2_IRLED2 : VitalDelayType01 := (0 ns, 0 ns);
 		tpd_IRLEDEN2_IRLED2 : VitalDelayType01 := (0 ns, 0 ns);

  		CURRENT_MODE :string := "0b0";
 		IR500_CURRENT :string := "0b000000000000";

  		tipd_CURREN 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
 		tipd_IRLEDEN 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
 		tipd_IRLEDEN2 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
 		tipd_IRPWM 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
 		tipd_IRPWM2 	: VitalDelayType01 := (0.000 ns, 0.000 ns)
);
port (
        CURREN : in std_logic;
		 IRLEDEN : in std_logic;
		 IRLEDEN2 : in std_logic;
		 IRPWM : in std_logic;
		 IRPWM2 : in std_logic;
        IRLED1 : out std_logic;
		 IRLED2 : out std_logic
	);	 
attribute VITAL_LEVEL0 of
    ICE_IR500_DRV  : entity is true;
end ICE_IR500_DRV;

architecture ICE_IR500_DRV_CORE_V of ICE_IR500_DRV is
  attribute VITAL_LEVEL0 of
    ICE_IR500_DRV_CORE_V: architecture is true;

    		signal  CURREN_ipd	: std_ulogic :='X' ;
 		signal  IRLEDEN_ipd	: std_ulogic :='X' ;
 		signal  IRLEDEN2_ipd	: std_ulogic :='X' ;
 		signal  IRPWM_ipd	: std_ulogic :='X' ;
 		signal  IRPWM2_ipd	: std_ulogic :='X' ;

		signal IRLED1_sig: std_ulogic     := 'X';
  		signal IRLED2_sig: std_ulogic     := 'X';
	component ICE_IR500_DRV_CORE
     generic (
				CURRENT_MODE :string := "0b0";
 		IR500_CURRENT :string := "0b000000000000"
	);
		port ( 
		CURREN : in std_logic;
		 IRLEDEN : in std_logic;
		 IRLEDEN2 : in std_logic;
		 IRPWM : in std_logic;
		 IRPWM2 : in std_logic;
		IRLED1 : out std_logic;
		 IRLED2 : out std_logic
	                	);
	end component;

    begin
    WireDelay:block
    begin
		VitalWireDelay (CURREN_ipd, CURREN, tipd_CURREN);
 		VitalWireDelay (IRLEDEN_ipd, IRLEDEN, tipd_IRLEDEN);
 		VitalWireDelay (IRLEDEN2_ipd, IRLEDEN2, tipd_IRLEDEN2);
 		VitalWireDelay (IRPWM_ipd, IRPWM, tipd_IRPWM);
 		VitalWireDelay (IRPWM2_ipd, IRPWM2, tipd_IRPWM2);

    end block;
		INST: ICE_IR500_DRV_CORE
		generic map (
				CURRENT_MODE =>  CURRENT_MODE ,
 		IR500_CURRENT =>  IR500_CURRENT
		)
		port map (
		CURREN =>  CURREN_ipd   ,
		 IRLEDEN =>  IRLEDEN_ipd   ,
		 IRLEDEN2 =>  IRLEDEN2_ipd   ,
		 IRPWM =>  IRPWM_ipd   ,
		 IRPWM2 =>  IRPWM2_ipd   ,
       	 IRLED1 =>  IRLED1_sig   ,
		  IRLED2 =>  IRLED2_sig   
		);
VITALPathDelay   : process ( IRLED1_sig, CURREN_ipd, IRLEDEN_ipd, IRLEDEN2_ipd, IRPWM_ipd, IRPWM2_ipd, IRLED2_sig)
variable IRLED1_GlitchData : VitalGlitchDataType;
 variable IRLED1_zd: std_logic :='X';
 variable IRLED2_GlitchData : VitalGlitchDataType;
 variable IRLED2_zd: std_logic :='X';
begin
IRLED1_zd := IRLED1_sig;
 IRLED2_zd := IRLED2_sig;

     VitalPathDelay01 (
	      OutSignal     => IRLED2,
	      GlitchData    => IRLED2_GlitchData,
	      OutSignalName => "IRLED2",
	      OutTemp       => IRLED2_zd,
	      Paths         => (0 => (IRPWM2_ipd'last_event, tpd_IRPWM2_IRLED2, true),
 1 => (IRLEDEN2_ipd'last_event, tpd_IRLEDEN2_IRLED2, true)
),
	      Mode          => OnEvent,
	      Xon           => Xon,
	      MsgOn         => MsgOn,
	      MsgSeverity   => warning);
      VitalPathDelay01 (
	      OutSignal     => IRLED1,
	      GlitchData    => IRLED1_GlitchData,
	      OutSignalName => "IRLED1",
	      OutTemp       => IRLED1_zd,
	      Paths         => (0 => (IRPWM_ipd'last_event, tpd_IRPWM_IRLED1, true),
 1 => (IRLEDEN_ipd'last_event, tpd_IRLEDEN_IRLED1, true)
),
	      Mode          => OnEvent,
	      Xon           => Xon,
	      MsgOn         => MsgOn,
	      MsgSeverity   => warning);
 end process VITALPathDelay;
end  ICE_IR500_DRV_CORE_V;		

------------------------------------------------------------------------
--					ICE_IO_I3C
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
--library	work;
use	work.std_logic_SBT.all;



entity	ICE_IO_I3C is

	generic (
			NEG_TRIGGER : bit						:=	'0';
			PIN_TYPE	: bit_vector (5 downto 0)	:=	"010000";
			PULLUP		: bit						:=	'0';
			WEAK_PULLUP	: bit 						:=  '0'; 
			IO_STANDARD	: string					:=	"SB_LVCMOS";
			----------------------------------------------------------------------------------
			--VITAL PARAMETER
			---------------------------------------------------------------------------------
			TimingChecksOn  : boolean := true;
			Xon   : boolean := true;
            MsgOn : boolean := false;
			--- VITAL path delay
			tipd_DOUT1       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_DOUT0       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_CLOCKENABLE        : VitalDelayType01 := (0 ns, 0 ns);
            tipd_LATCHINPUTVALUE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_INPUTCLK        : VitalDelayType01 := (0 ns, 0 ns);
			tipd_OUTPUTENABLE       : VitalDelayType01 := (0 ns, 0 ns);
            tipd_OUTPUTCLK       : VitalDelayType01 := (0 ns, 0 ns);
			tipd_PACKAGEPIN      : VitalDelayType01 := (0 ns, 0 ns);
			tipd_PUENB     		 : VitalDelayType01 := (0 ns, 0 ns);
			tipd_WEAKPUENB	     : VitalDelayType01 := (0 ns, 0 ns);			
            --- VITAL path delay
            tpd_PACKAGEPIN_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_PACKAGEPIN_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_DOUT0_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_DOUT1_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_OUTPUTENABLE_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_LATCHINPUTVALUE_DIN0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_LATCHINPUTVALUE_DIN1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_INPUTCLK_PACKAGEPIN  : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--  VITAL clk-to-output path delay
			tpd_INPUTCLK_DIN0_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
            tpd_INPUTCLK_DIN1_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_posedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			tpd_OUTPUTCLK_PACKAGEPIN_negedge : VitalDelayType01 := (0.000 ns, 0.000 ns);
			--- VITAL setup time
			tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			tsetup_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            tsetup_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			--- VITAL hold time 
			thold_CLOCKENABLE_INPUTCLK_negedge_posedge    : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_INPUTCLK_posedge_posedge    : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_posedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_posedge_negedge : VitalDelayType                   := 0 ns;
            thold_PACKAGEPIN_INPUTCLK_negedge_negedge : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT0_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_DOUT0_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns;
			thold_DOUT1_OUTPUTCLK_negedge_negedge   : VitalDelayType                   := 0 ns;
            thold_DOUT1_OUTPUTCLK_posedge_negedge   : VitalDelayType                   := 0 ns;
			thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge   : VitalDelayType                   := 0 ns;
            thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge   : VitalDelayType                   := 0 ns
			
 			);
	port 
		(
		DOUT1 		    : in std_logic;
		DOUT0 		    : in std_logic;
		CLOCKENABLE		: in std_logic;
		LATCHINPUTVALUE	: in std_logic;
		INPUTCLK			: in std_logic;
		
		DIN1				: out std_logic;
		DIN0				: out std_logic;
		OUTPUTENABLE		: in std_logic;
		OUTPUTCLK			: in std_logic;	 
		PUENB				: in std_logic; 
		WEAKPUENB			: in std_logic;		
		PACKAGEPIN			: inout	std_logic
		); 
	attribute VITAL_LEVEL0 of
      ICE_IO_I3C : entity is true;	
end ICE_IO_I3C ;

architecture ICE_IO_I3C_V of ICE_IO_I3C is
  attribute VITAL_LEVEL0 of
    ICE_IO_I3C_V : architecture is true;

	component	preio_physical
	port	(
			hold	:	in 	std_logic;
			rstio	:	in	std_logic;
			bs_en	:	in	std_logic;
			shift	:	in	std_logic;
			tclk	:	in	std_logic;
			inclk	:	in	std_logic;
			outclk	:	in	std_logic;
			update	:	in	std_logic;
			oepin	:	in	std_logic;
			sdi		:	in	std_logic;
			mode	:	in	std_logic;
			hiz_b	:	in	std_logic;
			sdo		:	out	std_logic;
			dout1	:	out	std_logic;
			dout0	:	out	std_logic;
			ddr1	:	in	std_logic;
			ddr0	:	in	std_logic;
			padin	:	in	std_logic;
			padout	:	out	std_logic;
			padoen	:	out	std_logic;
			cbit	:	in	std_logic_vector	(5 downto 0)
			);
	end component;

	
	signal DOUT1_ipd : std_ulogic := 'X';
    signal DOUT0_ipd  : std_ulogic := 'X';
    signal CLOCKENABLE_ipd  : std_ulogic := 'X';
    signal LATCHINPUTVALUE_ipd   : std_ulogic := 'X';
	signal INPUTCLK_ipd : std_ulogic := 'X';
    signal OUTPUTENABLE_ipd  : std_ulogic := 'X';
    signal OUTPUTCLK_ipd  : std_ulogic := 'X';
	signal PACKAGEPIN_ipd : std_ulogic;   --input direction
	signal PUENB_ipd		: std_logic; 
	signal WEAKPUENB_ipd	: std_logic; 
	
	signal Violation : std_ulogic;
	--signal PACKAGEPIN_zd : std_ulogic;
	signal DIN0_zd : std_ulogic;
	signal DIN1_zd : std_ulogic;
------------------------------------------------------------------------------------------------------------------------------------------------	
	signal	inclk_n, outclk_n, inclk, outclk,sdo	:	std_logic;
	
	signal	bs_en	:	std_logic	:='0';	--Boundary scan enable           
	signal	shift	:	std_logic	:='0';	--Boundary scan shift            
	signal	tclk	:	std_logic	:='0';	--Boundary scan clock            
	signal	update	:	std_logic	:='0';	--Boundary scan update           
	signal	sdi		:	std_logic	:='0';	--Boundary scan serial data in   
	signal	mode	:	std_logic	:='0';	--Boundary scan mode             
	signal	hiz_b	:	std_logic	:='1';	--Boundary scan Tristate control 
	
	signal	pin_cbit:	std_logic_vector(5 downto 0);
	signal	neg_trig:	std_logic;
	signal	pull_up	:	std_logic;
	
	signal	hold,oepin,padoen,padout,padin	:	std_logic;	
	signal INCLKE_sync , OUTCLKE_sync : std_logic; 
----------------------------------------------------------------------------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
          VitalWireDelay (DOUT1_ipd, DOUT1, tipd_DOUT1);
          VitalWireDelay (DOUT0_ipd, DOUT0, tipd_DOUT0);
          VitalWireDelay (CLOCKENABLE_ipd, CLOCKENABLE, tipd_CLOCKENABLE);
          VitalWireDelay (LATCHINPUTVALUE_ipd, LATCHINPUTVALUE, tipd_LATCHINPUTVALUE);
		  VitalWireDelay (INPUTCLK_ipd, INPUTCLK, tipd_INPUTCLK);
          VitalWireDelay (OUTPUTENABLE_ipd, OUTPUTENABLE, tipd_OUTPUTENABLE);
          VitalWireDelay (OUTPUTCLK_ipd, OUTPUTCLK, tipd_OUTPUTCLK);
		  VitalWireDelay (PUENB_ipd, PUENB, tipd_PUENB);
		  VitalWireDelay (WEAKPUENB_ipd, WEAKPUENB, tipd_WEAKPUENB);
		  VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;
		

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
	pin_cbit	<=	TO_STDLOGICVECTOR	(PIN_TYPE);
	neg_trig	<=	TO_STDLOGIC	(NEG_TRIGGER);
	pull_up		<=	TO_STDLOGIC	(PULLUP);
	
--	OUTPUTENABLE	<=	'H';		--	weak 1 for initial value
	inclk_n	<= 	INPUTCLK_ipd xor neg_trig;
	outclk_n	<=	OUTPUTCLK_ipd xor neg_trig;
--	inclk	<=	inclk_n and CLOCKENABLE_ipd;
--	outclk	<=	outclk_n and CLOCKENABLE_ipd;


	process(inclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(inclk_n ='0') then 
			INCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			INCLKE_sync <= INCLKE_sync;
		end if ; 
	end process; 

	process(outclk_n , CLOCKENABLE_ipd) is 
	begin 
		if(outclk_n ='0') then 
			OUTCLKE_sync  <= CLOCKENABLE_ipd; 
		else 
			OUTCLKE_sync <= OUTCLKE_sync;
		end if ; 
	end process; 

	inclk <= (inclk_n and INCLKE_sync);
	outclk <= (outclk_n and OUTCLKE_sync);
	
	hold	<=	LATCHINPUTVALUE_ipd;
	oepin	<=	OUTPUTENABLE_ipd;
	
	padin	<=	PACKAGEPIN_ipd;
	-----------------------------------------------------------------	
	preio_physical_i	:	preio_physical
	port map	(
				hold	=>	hold,
				rstio	=>	'0',
				bs_en	=>	bs_en,
				shift	=>	shift,
				tclk	=>	tclk,
				inclk	=>	inclk,
				outclk	=>	outclk,
				update	=>	update,
				oepin	=>	oepin,
				sdi		=>	sdi,
				mode	=>	mode,
				hiz_b	=>	hiz_b,
				sdo		=>	sdo,
				dout1	=>	DIN1_zd,
				dout0	=>	DIN0_zd,
				ddr1	=>	DOUT1,
				ddr0	=>	DOUT0,
				padin	=>	padin,
				padout	=>	padout,
				padoen	=>	padoen,
				cbit	=>	pin_cbit
				);
-------------------------------------------------------------------
--VITAL timing check
------------------------------------------------------------------
  VITALTimingCheck : process (DOUT1_ipd, DOUT0_ipd, CLOCKENABLE_ipd, LATCHINPUTVALUE_ipd, INPUTCLK_ipd, OUTPUTENABLE_ipd, OUTPUTCLK_ipd, PACKAGEPIN_ipd)
    variable Tviol_DOUT0_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_OUTPUTENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_OUTPUTCLK_posedge : std_ulogic := '0';
    variable Tviol_DOUT1_OUTPUTCLK_negedge : std_ulogic := '0';
    variable Tviol_CLOCKENABLE_INPUTCLK_posedge    : std_ulogic := '0';
    variable Tviol_PACKAGEPIN_INPUTCLK_posedge   : std_ulogic := '0';
	variable Tviol_PACKAGEPIN_INPUTCLK_negedge   : std_ulogic := '0';

    variable Tmkr_DOUT0_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_OUTPUTCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_DOUT1_OUTPUTCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_CLOCKENABLE_INPUTCLK_posedge    : VitalTimingDataType := VitalTimingDataInit;
    variable Tmkr_PACKAGEPIN_INPUTCLK_posedge   : VitalTimingDataType := VitalTimingDataInit;
	variable Tmkr_PACKAGEPIN_INPUTCLK_negedge   : VitalTimingDataType := VitalTimingDataInit;
	
	
  begin
    
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation      => Tviol_DOUT0_OUTPUTCLK_posedge,
        TimingData     => Tmkr_DOUT0_OUTPUTCLK_posedge,
        TestSignal     => DOUT0_ipd,
        TestSignalName => "DOUT0",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT0_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_DOUT0_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_DOUT0_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  
	  VitalSetupHoldCheck (
        Violation      => Tviol_OUTPUTENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_OUTPUTENABLE_OUTPUTCLK_posedge,
        TestSignal     => OUTPUTENABLE_ipd,
        TestSignalName => "OUTPUTENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_OUTPUTENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_OUTPUTENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_OUTPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_OUTPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_OUTPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_OUTPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_DOUT1_OUTPUTCLK_negedge,
        TimingData     => Tmkr_DOUT1_OUTPUTCLK_negedge,
        TestSignal     => DOUT1_ipd,
        TestSignalName => "DOUT1",
        RefSignal      => OUTPUTCLK_ipd,
        RefSignalName  => "OUTPUTCLK",
        SetupHigh      => tsetup_DOUT1_OUTPUTCLK_negedge_negedge,
        SetupLow       => tsetup_DOUT1_OUTPUTCLK_posedge_negedge,
        HoldLow        => thold_DOUT1_OUTPUTCLK_negedge_negedge,
        HoldHigh       => thold_DOUT1_OUTPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
      VitalSetupHoldCheck (
        Violation      => Tviol_CLOCKENABLE_INPUTCLK_posedge,
        TimingData     => Tmkr_CLOCKENABLE_INPUTCLK_posedge,
        TestSignal     => CLOCKENABLE_ipd,
        TestSignalName => "CLOCKENABLE",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_CLOCKENABLE_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldLow        => thold_CLOCKENABLE_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_CLOCKENABLE_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_posedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_posedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_posedge_posedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_posedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_posedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
		
	  VitalSetupHoldCheck (
        Violation      => Tviol_PACKAGEPIN_INPUTCLK_negedge,
        TimingData     => Tmkr_PACKAGEPIN_INPUTCLK_negedge,
        TestSignal     => PACKAGEPIN_ipd,
        TestSignalName => "PACKAGEPIN",
        RefSignal      => INPUTCLK_ipd,
        RefSignalName  => "INPUTCLK",
        SetupHigh      => tsetup_PACKAGEPIN_INPUTCLK_negedge_negedge,
        SetupLow       => tsetup_PACKAGEPIN_INPUTCLK_posedge_negedge,
        HoldLow        => thold_PACKAGEPIN_INPUTCLK_negedge_negedge,
        HoldHigh       => thold_PACKAGEPIN_INPUTCLK_posedge_negedge,
        CheckEnabled   => true,
        RefTransition  => 'R',
        HeaderMsg      => "/SB_IO",
        Xon            => Xon,
        MsgOn          => true,
        MsgSeverity    => warning);
     
    end if;
end process VITALTimingCheck;
--path delay
  VITALPathDelay          : process (padout, padoen, DOUT1_ipd, DOUT0_ipd, PACKAGEPIN_ipd, CLOCKENABLE_ipd, OUTPUTENABLE_ipd, LATCHINPUTVALUE_ipd, DIN0_zd, DIN1_zd, OUTPUTCLK_ipd, INPUTCLK_ipd)
    variable PACKAGEPIN_GlitchData : VitalGlitchDataType;
	variable DIN0_GlitchData : VitalGlitchDataType;
	variable DIN1_GlitchData : VitalGlitchDataType;
	
	variable tmp_padio : std_logic;  --PACKAGEPIN output direction

  begin
   -- padin	<=	PACKAGEPIN_ipd;
		if	(padoen='1') then
			tmp_padio	:=	'Z';
		else
			tmp_padio	:=	padout;
		end if;
  VitalPathDelay01 (
      OutSignal                 => PACKAGEPIN,
      GlitchData                => PACKAGEPIN_GlitchData,
      OutSignalName             => "PACKAGEPIN",
      OutTemp                   => tmp_padio,
      Paths                     => (0 => (DOUT0_ipd'last_event, tpd_DOUT0_PACKAGEPIN, true),
                                    1 => (DOUT1_ipd'last_event, tpd_DOUT1_PACKAGEPIN, true),
									2 => (OUTPUTENABLE_ipd'last_event, tpd_OUTPUTENABLE_PACKAGEPIN, true),
									3 => (OUTPUTCLK_ipd'last_event, tpd_OUTPUTCLK_PACKAGEPIN, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN0,
      GlitchData                => DIN0_GlitchData,
      OutSignalName             => "DIN0",
      OutTemp                   => DIN0_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN0, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN0_posedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN0, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
	  
	VitalPathDelay01 (
      OutSignal                 => DIN1,
      GlitchData                => DIN1_GlitchData,
      OutSignalName             => "DIN1",
      OutTemp                   => DIN1_zd,
      Paths                     => (0 => (LATCHINPUTVALUE_ipd'last_event, tpd_LATCHINPUTVALUE_DIN1, true),
									1 => (INPUTCLK_ipd'last_event, tpd_INPUTCLK_DIN1_negedge, true),
									2 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DIN1, true)
									),
      Mode                      => VitalTransport,
      Xon                       => Xon,
      MsgOn                     => MsgOn,
      MsgSeverity               => warning);
  end process VITALPathDelay;

end	ICE_IO_I3C_V;

-------------------------------------------------------------------------
--				IO_PAD_I3C 
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.Vital_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.std_logic_SBT.all;

entity IO_PAD_I3C is
	generic	( 
	
		PULLUP          : bit                                           :=      '0';
		WEAK_PULLUP     : bit                                           :=      '0';
		IO_STANDARD     : string                                        :=      "SB_LVCMOS";
		----------------------------------------------------------------------------------
	        --VITAL PARAMETER
	         ---------------------------------------------------------------------------------
		TimingChecksOn  : boolean := true;
              	Xon   		: boolean := true;
                MsgOn 		: boolean := false; 
		--- VITAL port delay
		tipd_PACKAGEPIN 	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_DIN            	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_OE              	: VitalDelayType01 := (0 ns, 0 ns);
		tipd_PUENB				: VitalDelayType01 := (0 ns, 0 ns);
		tipd_WEAKPUENB				: VitalDelayType01 := (0 ns, 0 ns);
	  	--- VITAL path delay
	        tpd_PACKAGEPIN_DOUT 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
	        tpd_DIN_PACKAGEPIN 	: VitalDelayType01 := (0.000 ns, 0.000 ns);
           	tpd_OE_PACKAGEPIN 	: VitalDelayType01 := (0.000 ns, 0.000 ns)
		); 	    	
	port
        	(
		PACKAGEPIN              : inout std_logic; 
		DOUT               	: out std_logic;
		DIN               	: in std_logic;
		OE 	             	: in std_logic;
		PUENB				: in std_logic; 
		WEAKPUENB			: in std_logic 
		); 

        attribute VITAL_LEVEL0 of IO_PAD_I3C  : entity is true;

end IO_PAD_I3C;

architecture IO_PAD_I3C_V of IO_PAD_I3C is 

	attribute VITAL_LEVEL0 of IO_PAD_I3C_V : architecture is true;
		--
		signal DIN_ipd 		: std_ulogic := 'X';
		signal OE_ipd  		: std_ulogic := 'X';
		signal PUENB_ipd  		: std_ulogic := 'X';
		signal WEAKPUENB_ipd  		: std_ulogic := 'X';
	        signal PACKAGEPIN_ipd 	: std_ulogic;   --input direction
		-- 
        	signal DOUT_zd		: std_ulogic;
		signal PACKAGEPIN_zd    : std_ulogic; 
 		--
        	signal Violation 	: std_ulogic;
		signal	pull_up		: std_logic;
		signal	weak_pull_up	: std_logic;		
		signal  net200 :	std_logic;
		signal	PACKAGEPIN_node :	std_logic;

-------------------------------------------------------------------------------	
begin
      WireDelay   : block
        begin
		VitalWireDelay (DIN_ipd, DIN, tipd_DIN);
		VitalWireDelay (OE_ipd, OE, tipd_OE);
		VitalWireDelay (PUENB_ipd, PUENB, tipd_PUENB);
		VitalWireDelay (WEAKPUENB_ipd, WEAKPUENB, tipd_WEAKPUENB);
		VitalWireDelay (PACKAGEPIN_ipd, PACKAGEPIN, tipd_PACKAGEPIN);
        end block;

-------------------------------------------------------------------------------
-- BEHAVIOR SECTION
-------------------------------------------------------------------------------
        	pull_up         <=      TO_STDLOGIC (PULLUP);
        	weak_pull_up         <=      TO_STDLOGIC (WEAK_PULLUP);

			net200 <= not(((not(PUENB) and pull_up)  or ((not(WEAKPUENB) and weak_pull_up))));

	PADPROCESS  : process (OE_ipd, PACKAGEPIN_ipd,DIN_ipd)
	begin
        	if  ( OE_ipd ='1') then
                	PACKAGEPIN_zd     <=      'Z';
       	        else
               		PACKAGEPIN_zd     <=      DIN_ipd;
                end if;
        end process;
		
	PADPROCESS_0:	process (net200, PACKAGEPIN_ipd)
	begin
		if(net200='1') then
			PACKAGEPIN_node <= PACKAGEPIN_ipd;
		else 
			PACKAGEPIN_node <= 'H';
		end if;
	end process;
		
	 		DOUT_zd 	<=	PACKAGEPIN_node; 	
			
-----------------------------------------------------------------------------------	
-- PATH DELAY 
------------------------------------------------------------------------------------
	VITALPathDelay          : process ( PACKAGEPIN_ipd,DIN_ipd,OE_ipd, DOUT_zd,PACKAGEPIN_zd) 
		variable PACKAGEPIN_GlitchData 	: VitalGlitchDataType;
		variable DOUT_GlitchData 	: VitalGlitchDataType;
  	begin 
	  VitalPathDelay01 (
		OutSignal                 => PACKAGEPIN,
	      	GlitchData                => PACKAGEPIN_GlitchData,
	      	OutSignalName             => "PACKAGEPIN",
	      	OutTemp                   => PACKAGEPIN_zd,
	      	Paths                     => ( 0 => (DIN_ipd'last_event, tpd_DIN_PACKAGEPIN, true),
	                                       1 => (OE_ipd'last_event, tpd_OE_PACKAGEPIN, true)
                                             ),
	      	Mode                      => VitalTransport,
	      	Xon                       => Xon,
	      	MsgOn                     => MsgOn,
	      	MsgSeverity               => warning);
	
	VitalPathDelay01 (
		OutSignal                 => DOUT,
      		GlitchData                => DOUT_GlitchData,
      		OutSignalName             => "DOUT",
      		OutTemp                   => DOUT_zd,
      		Paths                     => ( 0 => (PACKAGEPIN_ipd'last_event, tpd_PACKAGEPIN_DOUT, true)
                                              ),
      		Mode                      => VitalTransport,
      		Xon                       => Xon,
      		MsgOn                     => MsgOn,
      		MsgSeverity               => warning);
	end process VITALPathDelay;

end IO_PAD_I3C_V ;

