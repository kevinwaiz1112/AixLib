within AixLib.ThermalZones.ReducedOrder.Validation;
model FiveElementsZeroNeighbour
  "FiveElements must remain structurally valid for an inert ANZ={0} placeholder"

  Modelica.Blocks.Sources.Constant TAirSet(k=293.15)
    "Fixed zone-air temperature";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTAir;

  AixLib.ThermalZones.ReducedOrder.RC.FiveElements zone(
    redeclare package Medium = AixLib.Media.Air,
    VAir=50,
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
    ANZ={0},
    hConNZ={0},
    hConNZMethod={3},
    surfaceOrientationNZ={1},
    nNZ=1,
    RNZ={{1e-5}},
    RNZRem={1e-5},
    CNZ={{1e-5}},
    otherNZIndex={1},
    thisZoneIndex=1,
    T_start=293.15)
    "Single-zone placeholder matching the TEASER export convention";

equation
  connect(TAirSet.y, preTAir.T);
  connect(preTAir.port, zone.intGainsConv);

  when time >= 1 then
    assert(abs(zone.nz[1].Q_flow) < 1e-8,
      "Zero-area neighbouring-zone placeholder must not exchange heat.");
  end when;

  annotation (
    experiment(StopTime=10, Tolerance=1e-08),
    __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/FiveElementsZeroNeighbour.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
Regression test for TEASER single-zone exports that keep the neighbouring-zone
array dimension at one and use <code>ANZ={0}</code>. The model must translate
without conditional-component errors and the placeholder port must remain
thermally inert.
</p>
</html>", revisions="<html><ul><li>October 3, 2026: First implementation.</li></ul></html>"));
end FiveElementsZeroNeighbour;
