within AixLib.ThermalZones.ReducedOrder.Validation;
model InterzonalBidirectional2C
  "Check heat-flow reversal of a passive 3R2C interzonal wall"

  parameter Modelica.Units.SI.ThermalResistance R1=0.02
    "Resistance from zone 1 to C1";
  parameter Modelica.Units.SI.ThermalResistance R3=0.03
    "Resistance between C1 and C2";
  parameter Modelica.Units.SI.ThermalResistance R2=0.02
    "Resistance from C2 to zone 2";
  parameter Modelica.Units.SI.HeatCapacity C1=1e5 "First wall capacity";
  parameter Modelica.Units.SI.HeatCapacity C2=1e5 "Second wall capacity";

  Modelica.Blocks.Sources.TimeTable TZone1(table=[0,299.15; 43199,299.15;
        43200,293.15; 86400,293.15])
    "Zone 1: 26 degC first, then 20 degC"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Modelica.Blocks.Sources.TimeTable TZone2(table=[0,293.15; 43199,293.15;
        43200,299.15; 86400,299.15])
    "Zone 2: 20 degC first, then 26 degC"
    annotation (Placement(transformation(extent={{90,40},{70,60}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preT1
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preT2
    annotation (Placement(transformation(extent={{60,20},{40,40}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor senQ1
    "Positive from zone 1 into the wall"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor senQ2
    "Positive from the wall into zone 2"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  AixLib.ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWallContainer wallZone1(
    n=2,
    RExt={R1,R3},
    RExtRem=R2,
    CExt={C1,C2},
    T_start=296.15,
    pass_through=false)
    "Owning side: VDI 6007 3R2C topology R1-C1-R3-C2-R2"
    annotation (Placement(transformation(extent={{-18,-10},{2,10}},
        origin={0,30})));

  AixLib.ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWallContainer wallZone2(
    n=2,
    RExt={R2,R3},
    RExtRem=R1,
    CExt={C2,C1},
    T_start=296.15,
    pass_through=true)
    "Non-owning side, equivalent to FiveElements pass-through"
    annotation (Placement(transformation(extent={{8,-10},{28,10}},
        origin={0,30})));

  Modelica.Units.SI.Energy EWall
    "Stored thermal energy relative to 0 K (only derivative is evaluated)";
  Modelica.Units.SI.HeatFlowRate energyBalanceResidual
    "senQ1 - senQ2 - der(EWall), should be close to zero";

equation
  connect(TZone1.y, preT1.T) annotation (Line(points={{-69,50},{-54,50},{-54,42}},
        color={0,0,127}));
  connect(TZone2.y, preT2.T) annotation (Line(points={{69,50},{54,50},{54,42}},
        color={0,0,127}));
  connect(preT1.port, senQ1.port_a) annotation (Line(points={{-40,30},{-30,30}},
        color={191,0,0}));
  connect(senQ1.port_b, wallZone1.port_a) annotation (Line(points={{-10,30},{-18,30}},
        color={191,0,0}));
  connect(wallZone1.port_b, wallZone2.port_b) annotation (Line(points={{2,30},{28,30}},
        color={191,0,0}));
  connect(wallZone2.port_a, senQ2.port_a) annotation (Line(points={{8,30},{10,30}},
        color={191,0,0}));
  connect(senQ2.port_b, preT2.port) annotation (Line(points={{30,30},{40,30}},
        color={191,0,0}));

  EWall = C1*wallZone1.extWallRC.thermCapExt[1].T
        + C2*wallZone1.extWallRC.thermCapExt[2].T;
  energyBalanceResidual = senQ1.Q_flow - senQ2.Q_flow - der(EWall);

  when time >= 36000 then
    assert(senQ1.Q_flow > 0,
      "Before the temperature switch, heat must flow from zone 1 to zone 2.");
    assert(senQ2.Q_flow > 0,
      "Before the temperature switch, heat must leave the wall towards zone 2.");
  end when;

  when time >= 82800 then
    assert(senQ1.Q_flow < 0,
      "After the temperature switch and transient, heat must flow from zone 2 to zone 1.");
    assert(senQ2.Q_flow < 0,
      "After the temperature switch and transient, heat must enter the wall from zone 2.");
    assert(abs(energyBalanceResidual) < 1e-3,
      "Interzonal wall energy balance residual is larger than 1e-3 W.");
  end when;

  annotation (
    experiment(StopTime=86400, Tolerance=1e-08),
    __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/InterzonalBidirectional2C.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This validation model drives a passive two-capacity interzonal wall with
26/20&nbsp;&deg;C for the first 12 hours and 20/26&nbsp;&deg;C for the second
12 hours. The RC topology is fixed throughout the simulation. The first side owns the
3R2C network and the second side is configured as a pass-through, matching the
ownership scheme used by <code>FiveElements</code>. A successful run demonstrates
that the heat flow reverses solely through the sign of the temperature
difference and that no RC/topology switch is required.
</p>
<p>
The topology corresponds to the VDI 6007 3R2C wall representation used by
TEASER for <code>bidirectional_2c</code>:
R1-C1-R3-C2-R2.
</p>
</html>", revisions="<html>
<ul><li>September 29, 2026: First implementation for bidirectional interzonal
3R2C validation.</li></ul>
</html>"));
end InterzonalBidirectional2C;
