import pymongo
from pymongo import MongoClient
import pprint

client = MongoClient("mongodb://admin:password@localhost:27017/")

# Create/Select Database 'CityDB'
db = client["CityDB"]

db.cities.drop()
db.roadways.drop()

cities_data = [
    {
        "_id": "New York",
        "Coordinates": {"Latitude": 40.7128, "Longitude": -74.0060},
        "Aliases": ["NYC", "The Big Apple"],
        "Landmarks": {"Statue": "Statue of Liberty", "Park": "Central Park"}
    },
    {
        "_id": "San Francisco",
        "Coordinates": {"Latitude": 37.7749, "Longitude": -122.4194},
        "Aliases": ["SF", "Frisco"],
        "Landmarks": {"Bridge": "Golden Gate", "Island": "Alcatraz"}
    },
    {
        "_id": "Kyiv",
        "Coordinates": {"Latitude": 50.4501, "Longitude": 30.5234},
        "Aliases": ["Kiev", "The City of Domes"],
        "Landmarks": {"Cathedral": "Saint Sophia", "Gate": "Golden Gate"}
    },
    {
        "_id": "London",
        "Coordinates": {"Latitude": 51.5074, "Longitude": -0.1278},
        "Aliases": ["The Smoke"],
        "Landmarks": {"Tower": "Big Ben", "Eye": "London Eye"}
    }
]

roadways_data = [
    {
        "Name": "Fifth Avenue",
        "Type": "Avenue",
        "LengthKm": 10.0,
        "CityID": "New York",
    },
    {
        "Name": "Wall Street",
        "Type": "Street",
        "LengthKm": 1.2,
        "CityID": "New York",
        "Segments": [
            {"SequenceNo": 1, "StartPost": 0.0, "EndPost": 0.6},
            {"SequenceNo": 2, "StartPost": 0.6, "EndPost": 1.2}
        ]
    },
    {
        "Name": "Sunset Boulevard",
        "Type": "Boulevard",
        "LengthKm": 15.0,
        "CityID": "San Francisco"
    },
    {
        "Name": "Lombard Street",
        "Type": "Street",
        "LengthKm": 1.5,
        "CityID": "San Francisco",
        "Segments": [
            {"SequenceNo": 1, "StartPost": 0.0, "EndPost": 0.4}
        ]
    },
    {
        "Name": "Khreshchatyk",
        "Type": "Street",
        "LengthKm": 1.3,
        "CityID": "Kyiv",
        "Segments": [
            {"SequenceNo": 1, "StartPost": 0.0, "EndPost": 1.3}
        ]
    },
    {
        "Name": "Peremohy Avenue",
        "Type": "Avenue",
        "LengthKm": 11.5,
        "CityID": "Kyiv"
    },
    {
        "Name": "Abbey Road",
        "Type": "Street",
        "LengthKm": 2.1,
        "CityID": "London",
        "Segments": []
    }
]

db.cities.insert_many(cities_data)
print("Inserted cities...")
db.roadways.insert_many(roadways_data)
print("Inserted roadways...")
print("-" * 50)
print(">>> ALL CITIES:")
for city in db.cities.find():
    pprint.pprint(city)

print("\n>>> ALL ROADWAYS:")
for road in db.roadways.find():
    pprint.pprint(road)
print("-" * 50)

print(">>> QUERY: Streets in Kyiv:")
query = {
    "Type": "Street",
    "CityID": "Kyiv"
}

cursor = db.roadways.find(query)
for doc in cursor:
    pprint.pprint(doc)
print("-" * 50)

print(">>> AGGREGATION: Total Road Length per City:")

pipeline = [
    {
        "$match": {
            "LengthKm": {"$gt": 0.5}
        }
    },
    {
        "$lookup": {
            "from": "cities",
            "localField": "CityID",
            "foreignField": "_id",
            "as": "CityDetails"
        }
    },
    {
        "$unwind": "$CityDetails"
    },
    {
        "$group": {
            "_id": "$CityID",
            "TotalLength": {"$sum": "$LengthKm"},
            "RoadCount": {"$sum": 1},
            "PrimaryAlias": {"$first": {"$arrayElemAt": ["$CityDetails.Aliases", 0]}}
        }
    },
    {
        "$sort": {"TotalLength": -1}
    }
]

agg_results = db.roadways.aggregate(pipeline)

for result in agg_results:
    pprint.pprint(result)

client.close()
