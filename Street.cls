Class City.Street Extends City.Roadway
{

Property RoadType As %String(MAXLEN = 10) [ InitialExpression = "ST" ];

Relationship Segments As City.StreetSegment [ Cardinality = children, Inverse = Street ];

Storage Default
{
<Data name="StreetDefaultData">
<Subscript>"Street"</Subscript>
<Value name="1">
<Value>RoadType</Value>
</Value>
</Data>
<DefaultData>StreetDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
