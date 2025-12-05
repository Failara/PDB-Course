Class City.Roadway Extends (%Persistent, %Populate, %XML.Adaptor, %JSON.Adaptor) [ Abstract ]
{

Property Name As %String(MAXLEN = 120, MINLEN = 1, POPSPEC = "Street()") [ Required ];

Property LengthKm As %Numeric(MAXVAL = 200.0, MINVAL = 0.01, POPSPEC = "Float(0.1, 50)");

Relationship City As City.City [ Cardinality = one, Inverse = Roadways ];

Property FullDescription As %String [ Calculated, SqlComputeCode = { set {FullDescription} = {Name} _ " (" _ {LengthKm} _ " km)" }, SqlComputed ];

Method FullDescriptionGet() As %String
{
    Quit ..Name _ " (" _ ..LengthKm _ " km)"
}

Query ByCityName(CityName As %String) As %SQLQuery(CONTAINID = 1)
{
    SELECT Name, LengthKm, FullDescription
    FROM City.Roadway
    WHERE City->OfficialName = :CityName
}

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
