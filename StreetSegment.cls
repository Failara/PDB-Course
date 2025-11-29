Class City.StreetSegment Extends (%Persistent, %Populate)
{

Property SequenceNo As %Integer(MINVAL = 1, POPSPEC = "Integer(1,100)");

Property StartPost As %Numeric(POPSPEC = "Float(0,10)");

Property EndPost As %Numeric(POPSPEC = "Float(10,20)");

Relationship Street As City.Street [ Cardinality = parent, Inverse = Segments, Required ];

Index StreetSeq On (Street, SequenceNo) [ Unique ];

}
