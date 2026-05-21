model ThermalZone_v0
  // Multi-zone thermal model with explicit heat balance equations.
  // No library dependencies. Represents a 3-zone building thermal network.

  // Thermal capacitances [J/K]
  parameter Real C1 = 2.5e6  "zone 1 thermal capacitance";
  parameter Real C2 = 1.8e6  "zone 2 thermal capacitance";
  parameter Real C3 = 1.2e6  "zone 3 thermal capacitance";
  parameter Real Cw = 5.0e6  "wall thermal capacitance";

  // Thermal conductances [W/K]
  parameter Real H12  = 150.0  "conductance zone1 to zone2";
  parameter Real H13  = 80.0   "conductance zone1 to zone3";
  parameter Real H23  = 120.0  "conductance zone2 to zone3";
  parameter Real H1w  = 200.0  "conductance zone1 to wall";
  parameter Real H2w  = 180.0  "conductance zone2 to wall";
  parameter Real Hwamb = 50.0  "conductance wall to ambient";

  // Internal heat gains [W]
  parameter Real Q1 = 2000.0  "internal gain zone 1";
  parameter Real Q2 = 1500.0  "internal gain zone 2";
  parameter Real Q3 = 800.0   "internal gain zone 3";

  // Ambient temperature [K]
  parameter Real T_amb = 268.15  "ambient temperature (−5 °C)";

  // State variables
  Real T1(start = 293.15)  "temperature zone 1";
  Real T2(start = 291.15)  "temperature zone 2";
  Real T3(start = "290.15") "temperature zone 3";
  Real Tw(start = 280.15)  "wall temperature";

  // Algebraic variables
  Real Phi1  "net heat flux into zone 1";
  Real Phi2  "net heat flux into zone 2";
  Real Phi3  "net heat flux into zone 3";
  Real PhiW  "net heat flux into wall";

equation
  // Heat flux balances
  Phi1 = Q1 - H12*(T1 - T2) - H13*(T1 - T3) - H1w*(T1 - Tw);
  Phi2 = Q2 + H12*(T1 - T2) - H23*(T2 - T3) - H2w*(T2 - Tw);
  Phi3 = Q3 + H13*(T1 - T3) + H23*(T2 - T3);
  PhiW = H1w*(T1 - Tw) + H2w*(T2 - Tw) - Hwamb*(Tw - T_amb);

  // Thermal dynamics
  der(T1) = Phi1 / C1;
  der(T2) = Phi2 / C2;
  der(T3) = Phi3 / C3;
  der(Tw) = PhiW / Cw;

  annotation(experiment(StartTime=0, StopTime=86400, Interval=60, Tolerance=1e-6));
end ThermalZone_v0;
