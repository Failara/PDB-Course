Class City.Tests Extends %UnitTest.TestCase
{

Method OnBeforeAllTests() As %Status
{
    Do ##class(City.DataLoader).ClearData()
    Quit $$$OK
}

Method TestCreateObject()
{
    Set street = ##class(City.Street).%New()
    Set street.Name = "Main St"
    Set street.LengthKm = 5.5
    
    Do $$$AssertStatusOK(street.%Save(), "Street Saved Successfully")
    
    Set expectedDesc = "Main St (5.5 km)"
    Do $$$AssertEquals(street.FullDescription, expectedDesc, "Computed property FullDescription is correct")
    
    Do ##class(City.Street).%DeleteId(street.%Id())
}

Method TestConstraints()
{
    Set invalidCity = ##class(City.City).%New()
    Do $$$AssertStatusNotOK(invalidCity.%Save(), "Should fail because OfficialName is required")
    
    Set c1 = ##class(City.City).%New()
    Set c1.OfficialName = "Uniqueville"
    Do $$$AssertStatusOK(c1.%Save(), "First unique city saved")
    
    Set c2 = ##class(City.City).%New()
    Set c2.OfficialName = "Uniqueville" 
    Do $$$AssertStatusNotOK(c2.%Save(), "Should fail because OfficialName must be unique")
    
    Set road = ##class(City.Avenue).%New()
    Set road.Name = "Long Ave"
    Set road.LengthKm = 500.0 
    Do $$$AssertStatusNotOK(road.%Save(), "Should fail because LengthKm exceeds MAXVAL")
}

Method TestParentChildDelete()
{
    Set street = ##class(City.Street).%New()
    Set street.Name = "Parent Street"
    Set street.LengthKm = 1
    Do street.%Save()
    Set streetId = street.%Id()
    
    Set seg = ##class(City.StreetSegment).%New()
    Set seg.SequenceNo = 1
    Set seg.Street = street
    Do seg.%Save()
    Set segId = seg.%Id()
    
    Do $$$AssertTrue(##class(City.StreetSegment).%ExistsId(segId), "Child segment created")
    
    Do ##class(City.Street).%DeleteId(streetId)
    
    Do $$$AssertFalse(##class(City.StreetSegment).%ExistsId(segId), "Child segment should be deleted when parent is deleted")
}

Method TestDeleteObject()
{
    Set city = ##class(City.City).%New()
    Set city.OfficialName = "Temporary City"
    Do city.%Save()
    Set id = city.%Id()
    
    Do $$$AssertTrue(##class(City.City).%ExistsId(id), "City exists before delete")
    
    Do ##class(City.City).%DeleteId(id)
    
    Do $$$AssertFalse(##class(City.City).%ExistsId(id), "City should not exist after delete")
}

}
