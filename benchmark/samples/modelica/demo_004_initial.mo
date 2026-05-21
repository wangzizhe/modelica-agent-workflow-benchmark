model HydroTurbineGov_v0
  // Standalone hydro turbine governor DAE model with explicit equations.
  // Inspired by HYGOV/IEEEG3 structure. No library dependencies.

  // Governor parameters
  parameter Real R    = 0.05   "permanent droop";
  parameter Real r    = 0.30   "temporary droop";
  parameter Real Tr   = 5.0    "reset time constant";
  parameter Real Tf   = 0.05   "pilot valve servo time constant";
  parameter Real Tg   = 0.5    "main gate servo time constant";
  parameter Real GMAX = 1.0    "maximum gate opening";
  parameter Real GMIN = 0.0    "minimum gate opening";
  parameter Real At   = 1.2    "turbine gain";
  parameter Real Dturb = 0.5   "turbine damping";
  parameter Real Tw   = 1.5    "water starting time";
  parameter Real qNL  = 0.08   "no-load flow";

  // System frequency reference
  parameter Real omega0 = 1.0  "rated angular frequency (per unit)";

  // Inputs (fixed for standalone)
  parameter Real PMECH0_set = 0.80  "initial mechanical power";
  parameter Real SPEED_set  = "1.00" "rotor speed input";

  // State variables
  Real G(start = 0.80)    "gate opening";
  Real GV(start = 0.80)   "gate velocity state";
  Real x_r(start = 0.04)  "temporary droop state";
  Real q(start = 0.72)    "turbine water flow";
  Real PMECH(start = 0.80) "mechanical power output";

  // Algebraic variables
  Real SPEED    "rotor speed input";
  Real PMECH0   "mechanical power reference";
  Real omega_err "speed error";
  Real P_ref    "power reference from droop";
  Real q_nl     "no-load flow offset";
  Real P_mech_raw "raw mechanical power before damping";

equation
  // Drive inputs from parameters
  SPEED  = SPEED_set;
  PMECH0 = PMECH0_set;

  // Speed error
  omega_err = omega0 - SPEED;

  // Power reference via droop
  P_ref = PMECH0 + omega_err / R;

  // Governor servo: gate velocity
  der(GV) = (P_ref - x_r - G) / Tf;

  // Temporary droop feedback
  der(x_r) = (r / Tr) * (GV - x_r / r);

  // Gate servo
  der(G) = GV / Tg;

  // Water flow dynamics (penstock)
  q_nl = qNL;
  der(q) = (G - q - q_nl) / Tw;

  // Raw turbine power
  P_mech_raw = At * (q - q_nl);

  // Mechanical power with speed damping
  PMECH = P_mech_raw - Dturb * (SPEED - omega0);

  annotation(experiment(StartTime=0, StopTime=30.0, Interval=0.05, Tolerance=1e-6));
end HydroTurbineGov_v0;
