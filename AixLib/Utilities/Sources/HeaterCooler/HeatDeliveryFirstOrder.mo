within AixLib.Utilities.Sources.HeaterCooler;
block HeatDeliveryFirstOrder
  "Optional first-order heat-delivery dynamics for simplified ROM emitters"

  parameter Boolean useDynamics=false
    "If false, requested thermal power is delivered without additional emitter dynamics";
  parameter Modelica.Units.SI.Time tau(min=Modelica.Constants.small)=1
    "Heat-delivery time constant when useDynamics=true";

  parameter Modelica.Units.SI.HeatFlowRate y_start=0
    "Initial delivered power when dynamics is enabled";

  Modelica.Blocks.Interfaces.RealInput u(
    final quantity="HeatFlowRate",
    final unit="W")
    "Requested heating or cooling power";

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="HeatFlowRate",
    final unit="W",
    start=y_start)
    "Delivered heating or cooling power";

initial equation
  if useDynamics then
    y = y_start;
  end if;

equation
  if useDynamics then
    tau*der(y) = u - y;
  else
    y = u;
  end if;

  annotation (Documentation(info="<html>
<p>
This block adds an optional first-order thermal-delivery lag between the PI
controller request and the heat flow applied to the reduced-order thermal zone.
It is intended for simplified emitter scenarios (radiator-like to
surface-heating-like) without introducing a hydraulic generation system.
</p>
<p>
With <code>useDynamics=false</code> the block is algebraic and reproduces the
legacy ideal delivery.
</p>
</html>"));
end HeatDeliveryFirstOrder;
