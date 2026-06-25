model WorkflowV02_TuneRLDemo
  parameter Real resistance(min=0.5, max=5.0) = 1.0;
  parameter Real sourceVoltage = 10.0;
  parameter Real inductance = 0.5;
  Real current(start=0.0, fixed=true);
equation
  inductance * der(current) + resistance * current = sourceVoltage;
  annotation(experiment(StartTime=0, StopTime=0.6, Interval=0.01, Tolerance=1e-6));
end WorkflowV02_TuneRLDemo;
