Class City.Avenue Extends City.Roadway
{

Property RoadType As %String(MAXLEN = 10) [ InitialExpression = "AV" ];

Query SelectAll() As %SQLQuery
{
    SELECT Name, LengthKm FROM City.Avenue
}

Storage Default
{
<Data name="AvenueDefaultData">
<Subscript>"Avenue"</Subscript>
<Value name="1">
<Value>RoadType</Value>
</Value>
</Data>
<DefaultData>AvenueDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
