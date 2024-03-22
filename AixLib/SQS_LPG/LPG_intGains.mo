within AixLib.SQS_LPG;
model LPG_intGains
  "Reading LPG internal Gains Data and transfer the absolute values"
  parameter Boolean use_LPG_internal_gains_people=false;
  parameter Boolean use_LPG_internal_gains_machines=false;
  parameter Boolean use_LPG_internal_gains_light=false;
  Modelica.Blocks.Sources.BooleanExpression LPG_internal_gains_people(y=
        use_LPG_internal_gains_people)
    annotation (Placement(transformation(extent={{-78,70},{-62,86}})));
  Modelica.Blocks.Routing.BooleanReplicator booleanReplicator
    annotation (Placement(transformation(extent={{-46,72},{-36,84}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{8,72},{22,86}})));
  Modelica.Blocks.Interfaces.RealInput u_people annotation (Placement(
        transformation(extent={{-122,50},{-90,82}}), iconTransformation(extent={
            {-122,50},{-90,82}})));
  Modelica.Blocks.Interfaces.RealOutput int_gains_people annotation (Placement(
        transformation(extent={{98,68},{120,90}}), iconTransformation(extent={{98,
            68},{120,90}})));
  Modelica.Blocks.Sources.BooleanExpression LPG_internal_gains_machines(y=
        use_LPG_internal_gains_machines)
    annotation (Placement(transformation(extent={{-78,-2},{-62,14}})));
  Modelica.Blocks.Routing.BooleanReplicator booleanReplicator1
    annotation (Placement(transformation(extent={{-46,0},{-36,12}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{8,0},{22,14}})));
  Modelica.Blocks.Interfaces.RealInput u_machines annotation (Placement(
        transformation(extent={{-124,-30},{-92,2}}), iconTransformation(extent={
            {-116,36},{-90,62}})));
  Modelica.Blocks.Interfaces.RealOutput int_gains_machines annotation (
      Placement(transformation(extent={{98,-4},{120,18}}), iconTransformation(
          extent={{98,52},{120,74}})));
  Modelica.Blocks.Sources.BooleanExpression LPG_internal_gains_light(y=
        use_LPG_internal_gains_light)
    annotation (Placement(transformation(extent={{-78,-74},{-62,-58}})));
  Modelica.Blocks.Routing.BooleanReplicator booleanReplicator2
    annotation (Placement(transformation(extent={{-46,-72},{-36,-60}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{8,-72},{22,-58}})));
  Modelica.Blocks.Interfaces.RealInput u_light annotation (Placement(
        transformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-90,-104}), iconTransformation(extent={{-116,36},{-90,62}})));
  Modelica.Blocks.Interfaces.RealOutput int_gains_light annotation (Placement(
        transformation(extent={{98,-76},{120,-54}}), iconTransformation(extent={
            {98,52},{120,74}})));
  Modelica.Blocks.Math.Gain gain(k=1000)
    annotation (Placement(transformation(extent={{-42,-26},{-28,-12}})));
  Modelica.Blocks.Math.Gain gain1(k=1000)
    annotation (Placement(transformation(extent={{-38,-94},{-24,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable tableInternalGains(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="Internals",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://AixLib/SQS_LPG/InternalGains_standard.txt"),
    columns=2:4)
    "Profiles for internal gains"
    annotation (Placement(transformation(extent={{88,24},{72,40}})));

equation
  connect(switch1.y, int_gains_people)
    annotation (Line(points={{22.7,79},{109,79}}, color={0,0,127}));
  connect(booleanReplicator1.y[1], switch2.u2)
    annotation (Line(points={{-35.5,6},{-35.5,7},{6.6,7}}, color={255,0,255}));
  connect(booleanReplicator2.y[1], switch3.u2) annotation (Line(points={{-35.5,-66},
          {-35.5,-65},{6.6,-65}}, color={255,0,255}));
  connect(u_machines, gain.u) annotation (Line(points={{-108,-14},{-48,-14},{-48,
          -19},{-43.4,-19}}, color={0,0,127}));
  connect(switch2.y, int_gains_machines) annotation (Line(points={{22.7,7},{65.85,
          7},{65.85,7},{109,7}}, color={0,0,127}));
  connect(u_light, gain1.u) annotation (Line(points={{-90,-104},{-90,-84},{-44,
          -84},{-44,-87},{-39.4,-87}},
                 color={0,0,127}));
  connect(switch3.y, int_gains_light)
    annotation (Line(points={{22.7,-65},{109,-65}}, color={0,0,127}));
  connect(LPG_internal_gains_machines.y, booleanReplicator1.u)
    annotation (Line(points={{-61.2,6},{-47,6}}, color={255,0,255}));
  connect(LPG_internal_gains_people.y, booleanReplicator.u)
    annotation (Line(points={{-61.2,78},{-47,78}}, color={255,0,255}));
  connect(LPG_internal_gains_light.y, booleanReplicator2.u)
    annotation (Line(points={{-61.2,-66},{-47,-66}}, color={255,0,255}));
  connect(booleanReplicator.y[1], switch1.u2) annotation (Line(points={{-35.5,78},
          {-35.5,79},{6.6,79}}, color={255,0,255}));
  connect(u_people, switch1.u1) annotation (Line(points={{-106,66},{-84,66},{
          -84,90},{6.6,90},{6.6,84.6}}, color={0,0,127}));
  connect(tableInternalGains.y[1], switch1.u3)
    annotation (Line(points={{71.2,32},{6.6,32},{6.6,73.4}}, color={0,0,127}));
  connect(gain.y, switch2.u1) annotation (Line(points={{-27.3,-19},{-27.3,-20},
          {-24,-20},{-24,12.6},{6.6,12.6}}, color={0,0,127}));
  connect(tableInternalGains.y[2], switch2.u3)
    annotation (Line(points={{71.2,32},{6.6,32},{6.6,1.4}}, color={0,0,127}));
  connect(gain1.y, switch3.u1) annotation (Line(points={{-23.3,-87},{-23.3,-88},
          {-20,-88},{-20,-59.4},{6.6,-59.4}}, color={0,0,127}));
  connect(tableInternalGains.y[3], switch3.u3) annotation (Line(points={{71.2,
          32},{4,32},{4,6},{2,6},{2,-70.6},{6.6,-70.6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LPG_intGains;
