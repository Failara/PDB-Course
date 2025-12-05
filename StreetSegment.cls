Class City.StreetSegment Extends (%Persistent, %Populate, %XML.Adaptor, %JSON.Adaptor)
{

Property SequenceNo As %Integer(MINVAL = 1, POPSPEC = "Integer(1,100)");

Property StartPost As %Numeric(POPSPEC = "Float(0,10)");

Property EndPost As %Numeric(POPSPEC = "Float(10,20)");

Relationship Street As City.Street [ Cardinality = parent, Inverse = Segments, Required ];

Index StreetSeq On (Street, SequenceNo) [ Unique ];

Query AllSegments() As %SQLQuery
{
    SELECT ID, Street->Name, StartPost, EndPost FROM City.StreetSegment
}

ClassMethod UpdateEndPost(id As %String, newEnd As %Numeric) As %Status
{
    &sql(UPDATE City.StreetSegment SET EndPost = :newEnd WHERE ID = :id)
    
    If SQLCODE = 0 { Quit $$$OK }
    Quit $$$ERROR($$$GeneralError, "SQL Error: " _ SQLCODE)
}

ClassMethod CalculateTotalSegmentLength()
{
    Set total = 0
    
    &sql(DECLARE SegCursor CURSOR FOR 
         SELECT StartPost, EndPost INTO :start, :end 
         FROM City.StreetSegment)
         
    &sql(OPEN SegCursor)
    
    For {
        &sql(FETCH SegCursor)
        Quit:(SQLCODE '= 0)
        
        Set len = end - start
        Set total = total + len
    }
    
    &sql(CLOSE SegCursor)
    
    Write "Total length of all segments calculated via Cursor: ", total, !
}

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
