Class City.DataLoader
{

ClassMethod LoadData()
{
    do ..ClearData()
    write "Starting data load...",!

    set city1 = ##class(City.City).%New()
    set city1.OfficialName = "New York"
    
    set coords1 = ##class(City.Coordinates).%New()
    set coords1.Latitude = 40.7128
    set coords1.Longitude = -74.0060
    set city1.Coordinates = coords1
    
    do city1.Aliases.Insert("NYC")
    do city1.Aliases.Insert("The Big Apple")
    
    set desc1 = ##class(%Stream.GlobalCharacter).%New()
    do desc1.Write("New York is the most populous city in the United States.")
    set city1.Description = desc1
    
    write city1.%Save()

    set av1 = ##class(City.Avenue).%New()
    set av1.Name = "Fifth Avenue"
    set av1.LengthKm = 10.0
    set av1.City = city1
    write av1.%Save()
    
    set st1 = ##class(City.Street).%New()
    set st1.Name = "Wall Street"
    set st1.LengthKm = 1.2
    set st1.City = city1
    write st1.%Save()

    set seg1 = ##class(City.StreetSegment).%New()
    set seg1.SequenceNo = 1
    set seg1.StartPost = 0
    set seg1.EndPost = 0.6
    set seg1.Street = st1
    write seg1.%Save()

    set city1.MainStreet = av1
    write city1.%Save()
    
    set city2 = ##class(City.City).%New()
    set city2.OfficialName = "San Francisco"
    
    set coords2 = ##class(City.Coordinates).%New()
    set coords2.Latitude = 37.7749
    set coords2.Longitude = -122.4194
    set city2.Coordinates = coords2
    
    do city2.Aliases.Insert("SF")
    
    write city2.%Save()
    
    set blvd1 = ##class(City.Boulevard).%New()
    set blvd1.Name = "Sunset Boulevard"
    set blvd1.LengthKm = 15.0
    set blvd1.City = city2
    write blvd1.%Save()
    
    set stSF = ##class(City.Street).%New()
    set stSF.Name = "Lombard Street"
    set stSF.LengthKm = 1.5
    set stSF.City = city2
    write stSF.%Save()

    set seg3 = ##class(City.StreetSegment).%New()
    set seg3.SequenceNo = 1
    set seg3.StartPost = 0
    set seg3.EndPost = 1.0
    set seg3.Street = stSF
    write seg3.%Save()

    set city2.MainStreet = stSF
    write city2.%Save()

    write !, "Data loaded successfully" ,!
}

ClassMethod ClearData()
{
    do ##class(City.StreetSegment).%DeleteExtent()
    do ##class(City.Street).%DeleteExtent()
    do ##class(City.Boulevard).%DeleteExtent()
    do ##class(City.Avenue).%DeleteExtent()
    &sql(UPDATE City.City SET MainStreet = NULL)
    do ##class(City.Roadway).%DeleteExtent()
    do ##class(City.City).%DeleteExtent()
    Kill ^CityLog
    write "Cleared old data",!
}

ClassMethod DisplayData()
{
    write "=== CITIES ===",!
    
    set rs = ##class(%ResultSet).%New()
    set sql = "SELECT ID FROM City.City"
    do rs.Prepare(sql)
    do rs.Execute()
    
    while rs.Next() {
        set id = rs.Data("ID")
        set city = ##class(City.City).%OpenId(id)
        write "City ID (Name): ", id, !
        
        if (city.Coordinates.Latitude '= "") {
            write "  Coordinates: ", city.Coordinates.Latitude, ", ", city.Coordinates.Longitude,!
        }
        
        if $IsObject(city.MainStreet) {
            write "  Main Street: ", city.MainStreet.Name,!
        }
        
        write "  Aliases: "
        for i=1:1:city.Aliases.Count() {
            write city.Aliases.GetAt(i), "; "
        }
        write !
    }
    
    write "=== STREET SEGMENTS ===",!
    set rsS = ##class(%ResultSet).%New("City.StreetSegment:AllSegments")
    do rsS.Execute()
    while rsS.Next() {
        write "Segment ", rsS.Get("ID"), " of ", rsS.Get("Name"), !
    }
}

ClassMethod TestTrigger()
{
    Write !, "=== TESTING TRIGGER ===", !
    Set city = ##class(City.City).%OpenId("New York")
    
    If $IsObject(city) {
        Set city.LastUpdated = $ZDATETIME($ZTIMESTAMP, 3)
        
        Set sc = city.%Save()
        
        If $$$ISOK(sc) {
            Write "Saved successfully.",!
            Write "Checking Global ^CityLog: ", !
            ZWrite ^CityLog
        } Else {
            Do $System.Status.DisplayError(sc)
        }
    } Else {
        Write "Could not open city 'New York'", !
    }
}

ClassMethod RunPracticeDemonstration()
{
    Do ..LoadData()
    Do ..DisplayData()
    
    Write !, "=== 1. Testing Dynamic SQL ===", !
    Do ##class(City.City).GetAliasesDynamic("New York")
    
    Write !, "=== 2. Testing Implicit Join (Roads in San Francisco) ===", !
    Set rs = ##class(%ResultSet).%New("City.Roadway:ByCityName")
    Do rs.Execute("San Francisco")
    While rs.Next() { Write rs.Get("Name"), ! }
    
    Write !, "=== 3. Testing COS Query (Large Segments > 0.8) ===", !
    Set rs = ##class(%ResultSet).%New("City.Street:LargeSegments")
    Do rs.Execute(0.8)
    While rs.Next() { Write "Segment ID: ", rs.Get("SegmentID"), " Length: ", rs.Get("Length"), ! }
    
    Write !, "=== 4. Testing Embedded SQL (Cursor) ===", !
    Do ##class(City.StreetSegment).CalculateTotalSegmentLength()
    
    Write !, "=== 5. Testing Trigger (Updating New York) ===", !
    Do ..TestTrigger()
}

}
