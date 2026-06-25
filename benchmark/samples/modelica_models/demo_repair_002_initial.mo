model ExciterAVR_v0
  // Standalone exciter + AVR DAE model with explicit equations.
  // Inspired by IEEE Type-II excitation system structure.
  // No library dependencies; all state and algebraic variables written explicitly.

  // Exciter parameters
  parameter Real KA   = 200.0  "voltage regulator gain";
  parameter Real TA   = 0.06   "voltage regulator time constant";
  parameter Real KE   = 1.0    "exciter constant";
  parameter Real TE   = 0.46   "exciter time constant";
  parameter Real KF   = 0.08   "stabilizing feedback gain";
  parameter Real TF1  = 1.0    "feedback time constant 1";
  parameter Real TF2  = 0.04   "feedback time constant 2";
  parameter Real TR   = 0.02   "voltage measurement time constant";
  parameter Real VRMAX =  7.3  "maximum regulator output";
  parameter Real VRMIN = -7.3  "minimum regulator output";

  // Saturation parameters
  parameter Real SE1  = "0.0039" "saturation at E1";
  parameter Real SE2  = 0.0274 "saturation at E2";
  parameter Real E1   = 3.1    "saturation breakpoint 1";
  parameter Real E2   = 4.18   "saturation breakpoint 2";

  // Reference / input
  parameter Real VREF = 1.05   "reference voltage setpoint";
  parameter Real ETERM_set = 1.02 "terminal voltage (input)";

  // State variables
  Real VR(start = 1.20)    "voltage regulator state";
  Real EFD(start = 1.50)   "field voltage output";
  Real RF(start = 0.08)    "feedback filter state";
  Real VM(start = 1.02)    "measured terminal voltage";

  // Algebraic variables
  Real ETERM    "terminal voltage input";
  Real VERR     "voltage error signal";
  Real SE_EFD   "exciter saturation value";

equation
  // Drive input from parameter
  ETERM = ETERM_set;

  // Voltage measurement lag
  der(VM) = (ETERM - VM) / TR;

  // Voltage error
  VERR = VREF - VM - (KF / TF1) * RF;

  // Exciter saturation (piecewise linear approximation)
  SE_EFD = SE1 + (SE2 - SE1) / (E2 - E1) * (EFD - E1);

  // Voltage regulator
  der(VR) = (KA * VERR - VR) / TA;

  // Exciter dynamics
  der(EFD) = (VR - (KE + SE_EFD) * EFD) / TE;

  // Feedback filter
  der(RF) = (KF / TF1 * der(EFD) - RF) / TF2;

  annotation(experiment(StartTime=0, StopTime=5.0, Interval=0.005, Tolerance=1e-6));
end ExciterAVR_v0;
