Class City.Boulevard Extends City.Roadway
{

Property RoadType As %String(MAXLEN = 10) [ InitialExpression = "BLVD" ];

Storage Default
{
<Data name="BoulevardDefaultData">
<Subscript>"Boulevard"</Subscript>
<Value name="1">
<Value>RoadType</Value>
</Value>
</Data>
<DefaultData>BoulevardDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
