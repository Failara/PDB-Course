Class City.REST.Broker Extends %CSP.REST
{

XData UrlMap
{
<Routes>
    <Route Url="/cities" Method="GET" Call="GetAll"/>
    <Route Url="/city/:id" Method="GET" Call="GetOne"/>
    <Route Url="/city" Method="POST" Call="Create"/>
    <Route Url="/city/:id" Method="PUT" Call="Update"/>
    <Route Url="/city/:id" Method="DELETE" Call="Delete"/>
</Routes>
}

ClassMethod GetAll() As %Status
{
    Set array = []
    Set sql = "SELECT OfficialName, Coordinates_Latitude, Coordinates_Longitude FROM City.City"
    Set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
    While rs.%Next() {
        Set obj = {}
        Set obj.Name = rs.OfficialName
        Set obj.Lat = rs."Coordinates_Latitude"
        Set obj.Lon = rs."Coordinates_Longitude"
        Do array.%Push(obj)
    }
    Write array.%ToJSON()
    Quit $$$OK
}

ClassMethod GetOne(id As %String) As %Status
{
    Set id = $ZCONVERT(id,"I","URL")
    If '##class(City.City).%ExistsId(id) { Set %response.Status="404 Not Found" Quit $$$OK }
    
    Set obj = ##class(City.City).%OpenId(id)
    Do obj.%JSONExport()
    Quit $$$OK
}

ClassMethod Create() As %Status
{
    // Parse JSON from body
    Set data = {}.%FromJSON(%request.Content)
    
    Set city = ##class(City.City).%New()
    Set city.OfficialName = data.OfficialName
    
    Set city.Coordinates = ##class(City.Coordinates).%New()
    Set city.Coordinates.Latitude = data.Latitude
    Set city.Coordinates.Longitude = data.Longitude
    
    Set sc = city.%Save()
    If $$$ISERR(sc) { Set %response.Status="400 Bad Request" Write $System.Status.GetErrorText(sc) }
    Else { Write {"status":"created"}.%ToJSON() }
    Quit $$$OK
}

ClassMethod Delete(id As %String) As %Status
{
    Set id = $ZCONVERT(id,"I","URL")
    If ##class(City.City).%DeleteId(id) { Write {"status":"deleted"}.%ToJSON() }
    Else { Set %response.Status="404 Not Found" }
    Quit $$$OK
}

// Just an empty stub for Update to satisfy the compiler/requirements

ClassMethod Update(id As %String) As %Status
{
    Quit $$$OK
}

}
