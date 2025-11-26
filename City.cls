Class City.City Extends (%Persistent, %Populate)
{

Property OfficialName As %String(MAXLEN = 80, MINLEN = 2) [ Required ];

Property MainStreet As City.Roadway;

Property Coordinates As City.Coordinates;

Property Aliases As list Of %String(MAXLEN = 50);

Property Landmarks As array Of %String(MAXLEN = 80);

Property Description As %Stream.GlobalCharacter;

Relationship Roadways As City.Roadway [ Cardinality = many, Inverse = City ];

Index NameIdx On OfficialName [ Unique ];

Storage Default
{
<Data name="CityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OfficialName</Value>
</Value>
<Value name="3">
<Value>MainStreet</Value>
</Value>
<Value name="4">
<Value>Coordinates</Value>
</Value>
<Value name="5">
<Value>Aliases</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
</Data>
<Data name="Landmarks">
<Attribute>Landmarks</Attribute>
<Structure>subnode</Structure>
<Subscript>"Landmarks"</Subscript>
</Data>
<DataLocation>^City.CityD</DataLocation>
<DefaultData>CityDefaultData</DefaultData>
<IdLocation>^City.CityD</IdLocation>
<IndexLocation>^City.CityI</IndexLocation>
<StreamLocation>^City.CityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
