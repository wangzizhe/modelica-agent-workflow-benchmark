model SyncMachineSimplified_v0
  // Simplified synchronous machine DAE model (standalone, no library deps).
  // Inspired by GENROE structure; all port/outer dependencies removed.
  // Equations written explicitly for standalone workflow validation.

  // Time constants
  parameter Real Tpd0  = "5.0" "d-axis transient open-circuit time constant";
  parameter Real Tpq0  = 1.5   "q-axis transient open-circuit time constant";
  parameter Real Tppd0 = 0.05  "d-axis sub-transient open-circuit time constant";
  parameter Real Tppq0 = 0.09  "q-axis sub-transient open-circuit time constant";

  // Reactances
  parameter Real Xd   = 1.81  "d-axis synchronous reactance";
  parameter Real Xpd  = 0.30  "d-axis transient reactance";
  parameter Real Xppd = 0.23  "d-axis sub-transient reactance";
  parameter Real Xq   = 1.76  "q-axis synchronous reactance";
  parameter Real Xpq  = 0.65  "q-axis transient reactance";
  parameter Real Xppq = 0.25  "q-axis sub-transient reactance";
  parameter Real Xl   = 0.15  "leakage reactance";
  parameter Real R_a  = 0.005 "armature resistance";

  // Derived constants
  parameter Real K3d = (Xppd - Xl) / (Xpd - Xl);
  parameter Real K4d = (Xpd - Xppd) / (Xpd - Xl);
  parameter Real K3q = (Xppq - Xl) / (Xpq - Xl);
  parameter Real K4q = (Xpq - Xppq) / (Xpq - Xl);

  // Inputs (fixed for standalone simulation)
  parameter Real EFD_set  = 1.45 "field voltage";
  parameter Real id_set   = 0.12 "d-axis current";
  parameter Real iq_set   = 0.85 "q-axis current";

  // State variables
  Real Epq(start = 1.20)  "q-axis transient EMF";
  Real Epd(start = 0.05)  "d-axis transient EMF";
  Real PSIkd(start = 0.90) "d-axis damper flux linkage";
  Real PSIkq(start = 0.02) "q-axis damper flux linkage";

  // Algebraic variables
  Real PSIppd  "d-axis sub-transient flux";
  Real PSIppq  "q-axis sub-transient flux";
  Real PSIpp   "air-gap sub-transient flux magnitude";
  Real PSId    "d-axis stator flux";
  Real PSIq    "q-axis stator flux";
  Real XadIfd  "d-axis magnetizing current";
  Real XaqIlq  "q-axis magnetizing current";
  Real EFD     "field voltage (driven by parameter)";
  Real id      "d-axis current (driven by parameter)";
  Real iq      "q-axis current (driven by parameter)";

equation
  // Drive inputs from parameters
  EFD = EFD_set;
  id  = id_set;
  iq  = iq_set;

  // Differential equations
  der(Epq) = (1 / Tpd0) * (EFD - XadIfd);
  der(Epd) = (1 / Tpq0) * (-XaqIlq);
  der(PSIkd) = (1 / Tppd0) * (Epq - PSIkd - (Xpd - Xl) * id);
  der(PSIkq) = (1 / Tppq0) * (Epd - PSIkq + (Xpq - Xl) * iq);

  // Sub-transient flux linkages
  PSIppd = Epq * K3d + PSIkd * K4d;
  PSIppq = Epd * K3q + PSIkq * K4q;
  PSIpp  = sqrt(PSIppd * PSIppd + PSIppq * PSIppq);

  // Stator flux linkages
  PSId = PSIppd - Xppd * id;
  PSIq = -PSIppq - Xppq * iq;

  // Magnetizing currents
  XadIfd = Epq + id * (Xd - Xpd);
  XaqIlq = -Epd + iq * (Xq - Xpq);

  annotation(experiment(StartTime=0, StopTime=10.0, Interval=0.01, Tolerance=1e-6));
end SyncMachineSimplified_v0;
