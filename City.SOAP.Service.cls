Class City.SOAP.Service Extends %SOAP.WebService
{

Parameter SERVICENAME = "CityService";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

Method CreateCity(name As %String, lat As %Numeric, lon As %Numeric) As %String [ WebMethod ]
{
    If ##class(City.City).%ExistsId(name) Quit "Error: City exists"
    
    Set obj = ##class(City.City).%New()
    Set obj.OfficialName = name
    
    Set obj.Coordinates = ##class(City.Coordinates).%New()
    Set obj.Coordinates.Latitude = lat
    Set obj.Coordinates.Longitude = lon
    
    Do obj.%Save()
    Quit "Created"
}

Method GetCity(name As %String) As City.City [ WebMethod ]
{
    If ##class(City.City).%ExistsId(name) {
        Quit ##class(City.City).%OpenId(name)
    }
    Quit ""
}

Method UpdateCity(name As %String, lat As %Numeric, lon As %Numeric) As %String [ WebMethod ]
{
    If '##class(City.City).%ExistsId(name) Quit "Error: Not Found"
    
    Set obj = ##class(City.City).%OpenId(name)
    
    If '$IsObject(obj.Coordinates) { Set obj.Coordinates = ##class(City.Coordinates).%New() }
    Set obj.Coordinates.Latitude = lat
    Set obj.Coordinates.Longitude = lon
    
    Do obj.%Save()
    Quit "Updated"
}

Method DeleteCity(name As %String) As %String [ WebMethod ]
{
    If '##class(City.City).%ExistsId(name) Quit "Error: Not Found"
    
    Do ##class(City.City).%DeleteId(name)
    Quit "Deleted"
}

}
