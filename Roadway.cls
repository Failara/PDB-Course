Class City.Roadway Extends (%Persistent, %Populate) [ Abstract ]
{

Property Name As %String(MAXLEN = 120, MINLEN = 1) [ Required ];

Property LengthKm As %Numeric(MAXVAL = 200.0, MINVAL = 0.01);

Relationship City As City.City [ Cardinality = one, Inverse = Roadways ];

Storage Default
{
<Data name="RoadwayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>LengthKm</Value>
</Value>
<Value name="4">
<Value>City</Value>
</Value>
</Data>
<DataLocation>^City.RoadwayD</DataLocation>
<DefaultData>RoadwayDefaultData</DefaultData>
<IdLocation>^City.RoadwayD</IdLocation>
<IndexLocation>^City.RoadwayI</IndexLocation>
<StreamLocation>^City.RoadwayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
