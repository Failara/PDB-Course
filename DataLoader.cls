Class City.DataLoader
{

ClassMethod LoadData() As %Status
{
    set status = $$$OK
    
    try {
        // Delete existing data
        do ..ClearData()
        
        // Create Cities
        set city1 = ##class(City.City).%New()
        set city1.OfficialName = "New York"
        do city1.Aliases.Insert("NYC")
        do city1.Aliases.Insert("The Big Apple")
        do city1.Aliases.Insert("Gotham")
        do city1.Landmarks.SetAt("Statue of Liberty", "Liberty")
        do city1.Landmarks.SetAt("Central Park", "Park")
        do city1.Landmarks.SetAt("Empire State Building", "Empire")
        set desc1 = ##class(%Stream.GlobalCharacter).%New()
        do desc1.Write("New York City is the most populous city in the United States. ")
        do desc1.Write("Known for its iconic skyline, diverse culture, and as a global hub for finance, arts, and entertainment.")
        set city1.Description = desc1
        set status = city1.%Save()
        quit:$$$ISERR(status)
        
        set city2 = ##class(City.City).%New()
        set city2.OfficialName = "San Francisco"
        do city2.Aliases.Insert("SF")
        do city2.Aliases.Insert("The City by the Bay")
        do city2.Aliases.Insert("Frisco")
        do city2.Landmarks.SetAt("Golden Gate Bridge", "Bridge")
        do city2.Landmarks.SetAt("Alcatraz Island", "Alcatraz")
        do city2.Landmarks.SetAt("Fisherman's Wharf", "Wharf")
        set desc2 = ##class(%Stream.GlobalCharacter).%New()
        do desc2.Write("San Francisco is a cultural and financial center in Northern California. ")
        do desc2.Write("Famous for its steep hills, Victorian architecture, cable cars, and fog.")
        set city2.Description = desc2
        set status = city2.%Save()
        quit:$$$ISERR(status)
        
        // Create Avenues for New York
        set avenue1 = ##class(City.Avenue).%New()
        set avenue1.Name = "Fifth Avenue"
        set avenue1.LengthKm = 10.5
        set avenue1.City = city1
        set status = avenue1.%Save()
        quit:$$$ISERR(status)
        
        set avenue2 = ##class(City.Avenue).%New()
        set avenue2.Name = "Park Avenue"
        set avenue2.LengthKm = 8.3
        set avenue2.City = city1
        set status = avenue2.%Save()
        quit:$$$ISERR(status)
        
        // Create Boulevards for San Francisco
        set blvd1 = ##class(City.Boulevard).%New()
        set blvd1.Name = "Sunset Boulevard"
        set blvd1.LengthKm = 15.7
        set blvd1.City = city2
        set status = blvd1.%Save()
        quit:$$$ISERR(status)
        
        set blvd2 = ##class(City.Boulevard).%New()
        set blvd2.Name = "Mission Boulevard"
        set blvd2.LengthKm = 12.4
        set blvd2.City = city2
        set status = blvd2.%Save()
        quit:$$$ISERR(status)
        
        // Create Streets for New York
        set street1 = ##class(City.Street).%New()
        set street1.Name = "Wall Street"
        set street1.LengthKm = 1.2
        set street1.City = city1
        set status = street1.%Save()
        quit:$$$ISERR(status)
        
        // Create StreetSegments for Wall Street
        set segment1 = ##class(City.StreetSegment).%New()
        set segment1.SequenceNo = 1
        set segment1.StartPost = 1
        set segment1.EndPost = 50
        set segment1.Street = street1
        set status = segment1.%Save()
        quit:$$$ISERR(status)
        
        set segment2 = ##class(City.StreetSegment).%New()
        set segment2.SequenceNo = 2
        set segment2.StartPost = 51
        set segment2.EndPost = 100
        set segment2.Street = street1
        set status = segment2.%Save()
        quit:$$$ISERR(status)
        
        set street2 = ##class(City.Street).%New()
        set street2.Name = "Broadway"
        set street2.LengthKm = 21.0
        set street2.City = city1
        set status = street2.%Save()
        quit:$$$ISERR(status)
        
        // Create StreetSegments for Broadway
        set segment3 = ##class(City.StreetSegment).%New()
        set segment3.SequenceNo = 1
        set segment3.StartPost = 1
        set segment3.EndPost = 100
        set segment3.Street = street2
        set status = segment3.%Save()
        quit:$$$ISERR(status)
        
        set segment4 = ##class(City.StreetSegment).%New()
        set segment4.SequenceNo = 2
        set segment4.StartPost = 101
        set segment4.EndPost = 200
        set segment4.Street = street2
        set status = segment4.%Save()
        quit:$$$ISERR(status)
        
        write !, "Data loaded successfully!"
        write !, "Created 2 Cities: ", city1.OfficialName, " and ", city2.OfficialName
        write !, "Created 2 Avenues, 2 Boulevards, 2 Streets"
        write !, "Created 4 StreetSegments"
        
    } catch ex {
        set status = ex.AsStatus()
        write !, "Error: ", $System.Status.GetErrorText(status)
    }
    
    quit status
}

ClassMethod ClearData() As %Status
{
    set status = $$$OK
    
    try {
        // Delete in correct order due to relationships
        do ##class(City.StreetSegment).%DeleteExtent()
        do ##class(City.Street).%DeleteExtent()
        do ##class(City.Boulevard).%DeleteExtent()
        do ##class(City.Avenue).%DeleteExtent()
        do ##class(City.Roadway).%DeleteExtent()
        do ##class(City.City).%DeleteExtent()
        
        write !, "Existing data cleared."
    } catch ex {
        set status = ex.AsStatus()
    }
    
    quit status
}

ClassMethod DisplayData() As %Status
{
    set status = $$$OK
    
    write !, "=== CITIES ==="
    set rs = ##class(%ResultSet).%New("City.City:Extent")
    do rs.Execute()
    while rs.Next() {
        set city = ##class(City.City).%OpenId(rs.Data("ID"))
        write !, "City: ", city.OfficialName
        write !, "  Aliases: "
        for i=1:1:city.Aliases.Count() {
            write city.Aliases.GetAt(i), " "
        }
        write !, "  Landmarks: "
        set key = ""
        for {
            set landmark = city.Landmarks.GetNext(.key)
            quit:key=""
            write key, "=", landmark, " "
        }
        write !
    }
    
    write !, "=== ROADWAYS ==="
    set rs = ##class(%ResultSet).%New("City.Roadway:Extent")
    do rs.Execute()
    while rs.Next() {
        set roadway = ##class(City.Roadway).%OpenId(rs.Data("ID"))
        write !, $ClassName(roadway), ": ", roadway.Name
        write " (", roadway.LengthKm, " km)"
        if roadway.City '= "" {
            write " in ", roadway.City.OfficialName
        }
    }
    
    write !, !, "=== STREET SEGMENTS ==="
    set rs = ##class(%ResultSet).%New("City.StreetSegment:Extent")
    do rs.Execute()
    while rs.Next() {
        set segment = ##class(City.StreetSegment).%OpenId(rs.Data("ID"))
        write !, "Segment ", segment.SequenceNo
        write " of ", segment.Street.Name
        write ": Posts ", segment.StartPost, "-", segment.EndPost
    }
    write !
    
    quit status
}

}
