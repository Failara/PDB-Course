Class City.Roadway Extends (%Persistent, %Populate) [ Abstract ]
{
/// Name of the roadway (required, length 1..120)
Property Name As %String(MINLEN=1, MAXLEN=120) [ Required ];

/// Total length in kilometers (0.01..200.0)
Property LengthKm As %Numeric(MINVAL=0.01, MAXVAL=200.0);

/// Owning City (one) inverse of City's Roadways (many)
Relationship City As City.City [ Cardinality = one, Inverse = Roadways ];

}
