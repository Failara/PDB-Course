Class City.Street Extends (City.Roadway)
{
Property RoadType As %String(MAXLEN=10) [ InitialExpression = {"ST"} ];
Relationship Segments As City.StreetSegment [ Cardinality = children, Inverse = Street ];
}
