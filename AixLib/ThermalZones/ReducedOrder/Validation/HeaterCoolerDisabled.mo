within AixLib.ThermalZones.ReducedOrder.Validation;
model HeaterCoolerDisabled
  "Disabled ideal heater/cooler must remain structurally present and output zero"

  Modelica.Blocks.Sources.Constant TSetHeat(k=295.15);
  Modelica.Blocks.Sources.Constant TSetCool(k=297.15);
  Modelica.Blocks.Sources.Constant TRoom(k=296.15);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTRoom;

  AixLib.Utilities.Sources.HeaterCooler.HeaterCoolerPI heaCoo(
    recOrSep=true,
    zoneParam=AixLib.DataBase.ThermalZones.ZoneRecordDummy(
      HeaterOn=false,
      CoolerOn=false),
    staOrDyn=true)
    "Both functions disabled through the zone record";

equation
  connect(TSetHeat.y, heaCoo.setPointHeat);
  connect(TSetCool.y, heaCoo.setPointCool);
  connect(TRoom.y, preTRoom.T);
  connect(preTRoom.port, heaCoo.heatCoolRoom);

  when time >= 1 then
    assert(abs(heaCoo.heatingPower) < 1e-8,
      "Disabled heater must report zero power.");
    assert(abs(heaCoo.coolingPower) < 1e-8,
      "Disabled cooler must report zero power.");
  end when;

  annotation (
    experiment(StopTime=10, Tolerance=1e-08),
    __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/HeaterCoolerDisabled.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
Regression test for the structurally present ideal heater/cooler path. Both
functions are disabled in the zone record; translation must still succeed and
both power outputs must stay zero.
</p>
</html>", revisions="<html><ul><li>October 3, 2026: First implementation.</li></ul></html>"));
end HeaterCoolerDisabled;
