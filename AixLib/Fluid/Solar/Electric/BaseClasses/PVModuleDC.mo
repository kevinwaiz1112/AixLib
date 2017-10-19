within AixLib.Fluid.Solar.Electric.BaseClasses;
model PVModuleDC "PV module with temperature dependent efficiency"
  extends Electric.BaseClasses.PartialPVModuleDC;

 AixLib.Utilities.Interfaces.SolarRad_in SolarIrradationPerSquareMeter
    "Solar radiation per square meter" annotation (Placement(transformation(
          extent={{-141,-79},{-101,-39}}), iconTransformation(extent={{-140,
            -76},{-100,-36}})));

equation
  TCell=AmbientTemperature+(NoctTempCell-NoctTemp)*
  SolarIrradationPerSquareMeter.I/NoctRadiation;
  PowerPV=SolarIrradationPerSquareMeter.I*Area*EtaVar;

  annotation (
   Icon(
    coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
     Rectangle(
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      extent={{-100,100},{100,-100}}),
     Line(
      points={{-3,100},{100,0},{0,-100}},
      color={0,0,0})}),
     Documentation(info="<html>
<h4><span style=\"color: #008000\">Overview</span></h4>
<p>The <b>PVmoduleDC</b> model represents a simple PV cell. </p>
<h4><span style=\"color: #008000\">Concept</span></h4>
<p>PV moduleDC has a temperature&nbsp;dependency&nbsp;for&nbsp;efficiency.</p>
</html>",
     revisions="<html>
<ul>
<li><i>October 11, 2016 </i> by Tobias Blacha:<br/>Moved into AixLib</li>
<li><i>Februar 21, 2013  </i>by Corinna Leonhardt:<br/>Implemented</li>
</ul>
</html>"));
end PVModuleDC;
