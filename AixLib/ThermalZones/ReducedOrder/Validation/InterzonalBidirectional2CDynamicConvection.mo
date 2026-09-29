within AixLib.ThermalZones.ReducedOrder.Validation;
model InterzonalBidirectional2CDynamicConvection
  "FiveElements validation with bidirectional 3R2C conduction and dynamic floor/ceiling convection"

  parameter Modelica.Units.SI.Area A=20 "Interzonal slab area";
  parameter Modelica.Units.SI.ThermalResistance R1=0.02
    "Resistance from lower-zone ceiling surface to C1";
  parameter Modelica.Units.SI.ThermalResistance R3=0.03
    "Resistance between C1 and C2";
  parameter Modelica.Units.SI.ThermalResistance R2=0.02
    "Resistance from C2 to upper-zone floor surface";
  parameter Modelica.Units.SI.HeatCapacity C1=1e5 "First slab capacity";
  parameter Modelica.Units.SI.HeatCapacity C2=1e5 "Second slab capacity";

  Modelica.Blocks.Sources.TimeTable TLowerSet(
    table=[0,299.15; 43199,299.15; 43200,293.15; 86400,293.15])
    "Lower zone: 26 degC first, then 20 degC";
  Modelica.Blocks.Sources.TimeTable TUpperSet(
    table=[0,293.15; 43199,293.15; 43200,299.15; 86400,299.15])
    "Upper zone: 20 degC first, then 26 degC";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTLower;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTUpper;
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor senQ
    "Positive heat flow from the lower zone towards the upper zone";

  AixLib.ThermalZones.ReducedOrder.RC.FiveElements lowerZone(
    redeclare package Medium = AixLib.Media.Air,
    VAir=0,
    hRad=5,
    nOrientations=1,
    AWin={0},
    ATransparent={0},
    hConWin=2.5,
    RWin=1,
    gWin=0,
    ratioWinConRad=0,
    AExt={0},
    hConExt=2.5,
    nExt=1,
    RExt={1},
    RExtRem=1,
    CExt={1},
    AInt=0,
    hConInt=2.5,
    nInt=1,
    RInt={1},
    CInt={1},
    AFloor=0,
    hConFloor=2.5,
    nFloor=1,
    RFloor={1},
    RFloorRem=1,
    CFloor={1},
    ARoof=0,
    hConRoof=2.5,
    nRoof=1,
    RRoof={1},
    RRoofRem=1,
    CRoof={1},
    nNZs=1,
    ANZ={A},
    hConNZ={1.7},
    hConNZMethod={2},
    surfaceOrientationNZ={3},
    dTConNZSmall=0.1,
    nNZ=2,
    RNZ={{R1,R3}},
    RNZRem={R2},
    CNZ={{C1,C2}},
    otherNZIndex={2},
    thisZoneIndex=1,
    T_start=296.15)
    "Lower zone; its interzonal surface is a ceiling facing down and owns the 3R2C slab";

  AixLib.ThermalZones.ReducedOrder.RC.FiveElements upperZone(
    redeclare package Medium = AixLib.Media.Air,
    VAir=0,
    hRad=5,
    nOrientations=1,
    AWin={0},
    ATransparent={0},
    hConWin=2.5,
    RWin=1,
    gWin=0,
    ratioWinConRad=0,
    AExt={0},
    hConExt=2.5,
    nExt=1,
    RExt={1},
    RExtRem=1,
    CExt={1},
    AInt=0,
    hConInt=2.5,
    nInt=1,
    RInt={1},
    CInt={1},
    AFloor=0,
    hConFloor=2.5,
    nFloor=1,
    RFloor={1},
    RFloorRem=1,
    CFloor={1},
    ARoof=0,
    hConRoof=2.5,
    nRoof=1,
    RRoof={1},
    RRoofRem=1,
    CRoof={1},
    nNZs=1,
    ANZ={A},
    hConNZ={1.7},
    hConNZMethod={2},
    surfaceOrientationNZ={2},
    dTConNZSmall=0.1,
    nNZ=2,
    RNZ={{R2,R3}},
    RNZRem={R1},
    CNZ={{C2,C1}},
    otherNZIndex={1},
    thisZoneIndex=2,
    T_start=296.15)
    "Upper zone; its interzonal surface is a floor facing up and is a pass-through for the slab RC chain";

  Modelica.Units.SI.HeatFlowRate QInterzonal=senQ.Q_flow
    "Positive from lower to upper zone";
  Modelica.Units.SI.CoefficientOfHeatTransfer hConLower=lowerZone.hConNZActual[1]
    "Actual lower-zone ceiling convection coefficient";
  Modelica.Units.SI.CoefficientOfHeatTransfer hConUpper=upperZone.hConNZActual[1]
    "Actual upper-zone floor convection coefficient";
  Modelica.Units.SI.Temperature TLowerAir=lowerZone.TAir;
  Modelica.Units.SI.Temperature TUpperAir=upperZone.TAir;
  Modelica.Units.SI.Temperature TLowerSurface=lowerZone.nzRC[1].port_a.T;
  Modelica.Units.SI.Temperature TUpperSurface=upperZone.nzRC[1].port_a.T;
  Modelica.Units.SI.Temperature TCap1=lowerZone.nzRC[1].extWallRC.thermCapExt[1].T;
  Modelica.Units.SI.Temperature TCap2=lowerZone.nzRC[1].extWallRC.thermCapExt[2].T;
  Modelica.Units.SI.Energy EWall=C1*TCap1 + C2*TCap2;
  Modelica.Units.SI.HeatFlowRate QFromLowerAir=-preTLower.port.Q_flow
    "Positive when the lower air node injects heat into the slab path";
  Modelica.Units.SI.HeatFlowRate QIntoUpperAir=preTUpper.port.Q_flow
    "Positive when heat leaves the slab path into the upper prescribed air node";
  Modelica.Units.SI.HeatFlowRate energyBalanceResidual=
    QFromLowerAir - QIntoUpperAir - der(EWall)
    "Energy residual of the physical 3R2C slab including both dynamic convection films";

equation
  connect(TLowerSet.y, preTLower.T);
  connect(TUpperSet.y, preTUpper.T);
  connect(preTLower.port, lowerZone.intGainsConv);
  connect(preTUpper.port, upperZone.intGainsConv);
  connect(lowerZone.nz[1], senQ.port_a);
  connect(senQ.port_b, upperZone.nz[1]);

  when time >= 36000 then
    assert(QInterzonal > 0,
      "Before the switch, heat must flow from the warm lower zone to the cool upper zone.");
    assert(hConLower > 1.7 and hConUpper > 1.7,
      "Upward heat transfer should activate the stronger natural-convection branch on both slab faces.");
  end when;

  when time >= 82800 then
    assert(QInterzonal < 0,
      "After the switch and transient, heat must flow from the warm upper zone to the cool lower zone.");
    assert(hConLower < 1.7 and hConUpper < 1.7,
      "Downward heat transfer should activate the weaker natural-convection branch on both slab faces.");
    assert(abs(energyBalanceResidual) < 1e-3,
      "Dynamic interzonal 3R2C slab energy balance residual is larger than 1e-3 W.");
  end when;

  annotation (
    experiment(StopTime=86400, Interval=60, Tolerance=1e-08),
    __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/InterzonalBidirectional2CDynamicConvection.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the complete interzonal path inside
<code>RC.FiveElements</code>. The lower zone sees the shared slab as a ceiling
(surface facing down), the upper zone as a floor (surface facing up). Both
surfaces use the smooth Bernd Glueck natural-convection correlation provided by
<code>AixLib.Utilities.HeatTransfer.HeatConvInside</code>.
</p>
<p>
At 12 h, the prescribed zone temperatures switch from 26/20 degC to 20/26 degC.
The 3R2C conduction topology remains unchanged. The test checks heat-flow
reversal, the expected change from the stronger upward to the weaker downward
convection branch, and the slab energy balance.
</p>
</html>", revisions="<html><ul><li>September 29, 2026: First implementation.</li></ul></html>"));
end InterzonalBidirectional2CDynamicConvection;
