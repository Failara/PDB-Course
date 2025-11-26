Class City.Coordinates Extends %SerialObject
{

Property Latitude As %Numeric(SCALE = 6);

Property Longitude As %Numeric(SCALE = 6);

Storage Default
{
<Data name="CoordinatesState">
<Value name="1">
<Value>Latitude</Value>
</Value>
<Value name="2">
<Value>Longitude</Value>
</Value>
</Data>
<State>CoordinatesState</State>
<StreamLocation>^City.CoordinatesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
