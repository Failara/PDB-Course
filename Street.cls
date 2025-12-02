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

Query LargeSegments(MinLength As %Numeric = 0.5) As %Query(ROWSPEC = "SegmentID:%String,StartPost:%Numeric,EndPost:%Numeric,Length:%Numeric") [ SqlProc ]
{
}

ClassMethod LargeSegmentsExecute(ByRef qHandle As %Binary, MinLength As %Numeric = 0.5) As %Status
{
    Kill ^||SegQuery
    Set qHandle = ""
    Set index = 0
    
    Set sql = "SELECT ID, StartPost, EndPost, (EndPost - StartPost) As SegLen FROM City.StreetSegment WHERE (EndPost - StartPost) >= ?"
    Set stmt = ##class(%SQL.Statement).%New()
    Set sc = stmt.%Prepare(sql)
    If $$$ISERR(sc) Quit sc
    
    Set rset = stmt.%Execute(MinLength)
    While rset.%Next() {
        Set index = index + 1
        Set ^||SegQuery(index) = $LB(rset.ID, rset.StartPost, rset.EndPost, rset.SegLen)
    }
    
    Set qHandle = 0
    Quit $$$OK
}

ClassMethod LargeSegmentsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
    Set qHandle = $Order(^||SegQuery(qHandle))
    
    If qHandle = "" {
        Set Row = ""
        Set AtEnd = 1
    } Else {
        Set Row = ^||SegQuery(qHandle)
    }
    
    Quit $$$OK
}

ClassMethod LargeSegmentsClose(ByRef qHandle As %Binary) As %Status
{
    Kill ^||SegQuery
    Kill qHandle
    Quit $$$OK
}

}
