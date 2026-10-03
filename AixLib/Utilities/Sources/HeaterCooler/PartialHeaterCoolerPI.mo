within AixLib.Utilities.Sources.HeaterCooler;
partial model PartialHeaterCoolerPI
  extends AixLib.Utilities.Sources.HeaterCooler.PartialHeaterCooler;
  parameter Boolean Heater_on = true "Activates the heater" annotation(Dialog(tab = "Heater",enable=not recOrSep));
  parameter Boolean Cooler_on = true "Activates the cooler" annotation(Dialog(tab = "Cooler",enable=not recOrSep));
  parameter Real h_heater = 0 "Upper limit controller output of the heater" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Real l_heater = 0 "Lower limit controller output of the heater" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Real KR_heater = 1000 "Gain of the heating controller" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Modelica.Units.SI.Time TN_heater=1
    "Time constant of the heating controller" annotation (Dialog(
      tab="Heater",
      group="Controller",
      enable=not recOrSep));
  parameter Boolean useHeatDeliveryDynamics=false
    "Enable first-order heat-delivery dynamics"
    annotation(Dialog(tab="Heater", group="Delivery", enable=not recOrSep));
  parameter Modelica.Units.SI.Time tauHeatDelivery=1
    "First-order heat-delivery time constant"
    annotation(Dialog(tab="Heater", group="Delivery", enable=not recOrSep and useHeatDeliveryDynamics));
  parameter Real h_cooler = 0 "Upper limit controller output of the cooler"
                                                                           annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Real l_cooler = 0 "Lower limit controller output of the cooler"          annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Real KR_cooler = 1000 "Gain of the cooling controller"
                                                                  annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Modelica.Units.SI.Time TN_cooler=1
    "Time constant of the cooling controller" annotation (Dialog(
      tab="Cooler",
      group="Controller",
      enable=not recOrSep));
  parameter Boolean useCoolDeliveryDynamics=false
    "Enable first-order cooling-delivery dynamics"
    annotation(Dialog(tab="Cooler", group="Delivery", enable=not recOrSep));
  parameter Modelica.Units.SI.Time tauCoolDelivery=1
    "First-order cooling-delivery time constant"
    annotation(Dialog(tab="Cooler", group="Delivery", enable=not recOrSep and useCoolDeliveryDynamics));
  parameter Boolean recOrSep = false "Use record or seperate parameters" annotation(choices(choice =  false
        "Seperate",choice = true "Record",radioButtons = true));
  parameter AixLib.DataBase.ThermalZones.ZoneBaseRecord zoneParam = AixLib.DataBase.ThermalZones.ZoneRecordDummy()
    "Zone definition"                                                            annotation(choicesAllMatching=true,Dialog(enable=recOrSep));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Cooling if ((
    recOrSep and zoneParam.CoolerOn) or (not recOrSep and Cooler_on))
                                                                   annotation(Placement(transformation(extent={{26,-23},
            {6,-2}})));
  Controls.Continuous.PITemp
                 pITempCool(
    rangeSwitch=false,
    h=if not recOrSep then h_cooler else zoneParam.hCool,
    l=if not recOrSep then l_cooler else zoneParam.lCool,
    KR=if not recOrSep then KR_cooler else zoneParam.KRCool,
    TN=if not recOrSep then TN_cooler else zoneParam.TNCool) if ((recOrSep and
    zoneParam.CoolerOn) or (not recOrSep and Cooler_on))
    "PI control for cooler"
    annotation (Placement(transformation(extent={{-20,-10},{0,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Heating if ((
    recOrSep and zoneParam.HeaterOn) or (not recOrSep and Heater_on))
                                                                   annotation(Placement(transformation(extent={{26,22},
            {6,2}})));
  Controls.Continuous.PITemp
                 pITempHeat(
    rangeSwitch=false,
    h=if not recOrSep then h_heater else zoneParam.hHeat,
    l=if not recOrSep then l_heater else zoneParam.lHeat,
    KR=if not recOrSep then KR_heater else zoneParam.KRHeat,
    TN=if not recOrSep then TN_heater else zoneParam.TNHeat) if ((recOrSep and
    zoneParam.HeaterOn) or (not recOrSep and Heater_on))
    "PI control for heater" annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  AixLib.Utilities.Sources.HeaterCooler.HeatDeliveryFirstOrder heatDelivery(
    useDynamics=if not recOrSep then useHeatDeliveryDynamics else zoneParam.useHeatDeliveryDynamics,
    tau=if not recOrSep then tauHeatDelivery else zoneParam.tauHeatDelivery) if ((recOrSep and
    zoneParam.HeaterOn) or (not recOrSep and Heater_on))
    "Simplified emitter/heat-delivery dynamics"
    annotation (Placement(transformation(extent={{8,12},{24,28}})));
  AixLib.Utilities.Sources.HeaterCooler.HeatDeliveryFirstOrder coolDelivery(
    useDynamics=if not recOrSep then useCoolDeliveryDynamics else zoneParam.useCoolDeliveryDynamics,
    tau=if not recOrSep then tauCoolDelivery else zoneParam.tauCoolDelivery) if ((recOrSep and
    zoneParam.CoolerOn) or (not recOrSep and Cooler_on))
    "Simplified cooling-emitter/delivery dynamics"
    annotation (Placement(transformation(extent={{8,-28},{24,-12}})));
  Modelica.Blocks.Interfaces.RealOutput heatingPower(
   final quantity="HeatFlowRate",
   final unit="W") if ((recOrSep and zoneParam.HeaterOn) or (not recOrSep and
    Heater_on))    "Delivered heating power"
    annotation (Placement(transformation(extent={{80,20},{120,60}}),
        iconTransformation(extent={{80,20},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput heatingPowerRequested(
   final quantity="HeatFlowRate",
   final unit="W") if ((recOrSep and zoneParam.HeaterOn) or (not recOrSep and
    Heater_on)) "PI-controller requested heating power before emitter dynamics";
  Modelica.Blocks.Interfaces.RealOutput heatingPowerDeliveryDeficit(
   final quantity="HeatFlowRate",
   final unit="W") if ((recOrSep and zoneParam.HeaterOn) or (not recOrSep and
    Heater_on)) "Positive difference between requested and delivered heating power";
  Modelica.Blocks.Interfaces.RealOutput coolingPower(
   final quantity="HeatFlowRate",
   final unit="W") if ((recOrSep and zoneParam.CoolerOn) or (not recOrSep and
    Cooler_on))    "Power for cooling"
    annotation (Placement(transformation(extent={{80,-26},{120,14}}),
        iconTransformation(extent={{80,-26},{120,14}})));
  Modelica.Blocks.Interfaces.RealOutput coolingPowerRequested(
   final quantity="HeatFlowRate",
   final unit="W") if ((recOrSep and zoneParam.CoolerOn) or (not recOrSep and
    Cooler_on)) "PI-controller requested cooling power before delivery dynamics";
  Modelica.Blocks.Interfaces.RealOutput coolingPowerDeliveryDeficit(
   final quantity="HeatFlowRate",
   final unit="W") if ((recOrSep and zoneParam.CoolerOn) or (not recOrSep and
    Cooler_on)) "Positive magnitude difference between requested and delivered cooling power";
equation
  connect(Heating.port, heatCoolRoom) annotation (Line(
        points={{6,12},{2,12},{2,-40},{90,-40}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(pITempHeat.heatPort, heatCoolRoom) annotation (Line(
      points={{-16,11},{-16,-40},{90,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pITempCool.y, coolDelivery.u)
    annotation (Line(points={{-1,-20},{8,-20}}, color={0,0,127}));
  connect(coolDelivery.y, Cooling.Q_flow)
    annotation (Line(points={{24.8,-20},{26,-20},{26,-12.5}}, color={0,0,127}));
  connect(Cooling.port, heatCoolRoom) annotation (Line(
        points={{6,-12.5},{2.4,-12.5},{2.4,-40},{90,-40}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(pITempCool.heatPort, heatCoolRoom) annotation (Line(
      points={{-16,-11},{-16,-40},{90,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pITempHeat.y, heatDelivery.u)
    annotation (Line(points={{-1,20},{8,20}}, color={0,0,127}));
  connect(heatDelivery.y, Heating.Q_flow)
    annotation (Line(points={{24.8,20},{26,20},{26,12}}, color={0,0,127}));
  if ((recOrSep and zoneParam.HeaterOn) or (not recOrSep and Heater_on)) then
    heatingPowerRequested = pITempHeat.y;
    heatingPower = heatDelivery.y;
    heatingPowerDeliveryDeficit = max(pITempHeat.y - heatDelivery.y, 0);
  end if;
  if ((recOrSep and zoneParam.CoolerOn) or (not recOrSep and Cooler_on)) then
    coolingPowerRequested = pITempCool.y;
    coolingPower = coolDelivery.y;
    coolingPowerDeliveryDeficit = max(abs(pITempCool.y) - abs(coolDelivery.y), 0);
  end if;
  annotation (Documentation(info = "<html><h4>
  <span style=\"color:#008000\">Overview</span>
</h4>
<p>
  This is the base class of an ideal heater and/or cooler. It is used
  in full ideal heater/cooler models as an extension. It extends
  another base class and adds some basic elements.
</p>
<ul>
  <li>
    <i>March 20, 2020 by Philipp Mehrfeld:</i><br/>
    <a href=\"https://github.com/RWTH-EBC/AixLib/issues/879\">#879</a>
    Assign dummy record as default parameter for zoneParam.
  </li>
  <li>
    <i>October, 2015&#160;</i> by Moritz Lauster:<br/>
    Adapted to Annex60 and restructuring, implementing new
    functionalities
  </li>
  <li>
    <i>June, 2014&#160;</i> by Moritz Lauster:<br/>
    Added some basic documentation
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialHeaterCoolerPI;
