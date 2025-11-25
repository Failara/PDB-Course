Class City.City Extends (%Persistent, %Populate)
{

Property OfficialName As %String(MINLEN=2, MAXLEN=80) [ Required ];

Property MainStreet As City.Roadway;

Property Aliases As list Of %String(MAXLEN=50);

Property Landmarks As array Of %String(MAXLEN=80);

Property Description As %Stream.GlobalCharacter;

Relationship Roadways As City.Roadway [ Cardinality = many, Inverse = City ];

Index NameIdx On (OfficialName) [ Unique ];

}
