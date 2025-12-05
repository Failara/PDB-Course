Class City.SOAP.Service Extends %SOAP.WebService
{

Parameter SERVICENAME = "CityService";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

Method CreateCity(name As %String) As %String [ WebMethod ]
{
        If ##class(City.City).%ExistsId(name) Quit "Exists"
        Set obj = ##class(City.City).%New()
        Set obj.OfficialName = name
        Do obj.%Save()
        Quit "Created"
}

}
