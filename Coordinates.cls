Class City.Coordinates Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property Latitude As %Numeric(SCALE = 6);

Property Longitude As %Numeric(SCALE = 6);

/// TASK: COS Based Query (Required because Serial objects don't have SQL tables)
Query ListAll() As %Query(ROWSPEC = "CityName:%String,Latitude:%Numeric,Longitude:%Numeric") [ SqlProc ]
{
}

ClassMethod ListAllExecute(ByRef qHandle As %Binary) As %Status
{
    // Initialize iterator for City.City global
    Set qHandle = "" 
    Quit $$$OK
}

ClassMethod ListAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
    Set Row = ""
    Set id = qHandle
    
    // Iterate to the next City ID (which is the Name string now)
    Set id = $Order(^City.CityD(id))
    
    If (id '= "") {
        Set city = ##class(City.City).%OpenId(id)
        If $IsObject(city) && $IsObject(city.Coordinates) {
            Set Row = $LB(city.OfficialName, city.Coordinates.Latitude, city.Coordinates.Longitude)
        } Else {
            // Skip or return empty for this row
            Set Row = $LB(id, 0, 0)
        }
        Set qHandle = id
    } Else {
        Set AtEnd = 1
    }
    
    Quit $$$OK
}

ClassMethod ListAllClose(ByRef qHandle As %Binary) As %Status
{
    Kill qHandle
    Quit $$$OK
}

Storage Default
{
<Data name="CoordinatesState">
<Value name="1">
<Value>Latitude</Value>
</Value>
<Value name="2">
<Value>Longitude</Value>
</Value>
</Data>
<State>CoordinatesState</State>
<StreamLocation>^City.CoordinatesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
