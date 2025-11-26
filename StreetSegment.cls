Class City.StreetSegment Extends (%Persistent, %Populate)
{

Property SequenceNo As %Integer(MINVAL = 1);

Property StartPost As %Numeric;

Property EndPost As %Numeric;

Relationship Street As City.Street [ Cardinality = parent, Inverse = Segments, Required ];

Index StreetSeq On (Street, SequenceNo) [ Unique ];

Storage Default
{
<Data name="StreetSegmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SequenceNo</Value>
</Value>
<Value name="3">
<Value>StartPost</Value>
</Value>
<Value name="4">
<Value>EndPost</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("City.Street.Segments")</DataLocation>
<DefaultData>StreetSegmentDefaultData</DefaultData>
<IdLocation>^City.StreetC("Segments")</IdLocation>
<IndexLocation>^City.StreetSegmentI</IndexLocation>
<StreamLocation>^City.StreetSegmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
