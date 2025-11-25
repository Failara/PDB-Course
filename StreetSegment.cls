Class City.StreetSegment Extends (%Persistent, %Populate)
{
Property SequenceNo As %Integer(MINVAL=1);
Property StartPost As %Numeric;
Property EndPost As %Numeric;
Relationship Street As City.Street [ Cardinality = parent, Inverse = Segments, Required ];
Index StreetSeq On (Street, SequenceNo) [ Unique ];
}
