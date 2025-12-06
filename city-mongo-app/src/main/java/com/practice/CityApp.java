package com.practice;

import com.mongodb.client.*;
import com.mongodb.client.model.*;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.mongodb.client.model.Filters.*;

public class CityApp {

    private static final String CONNECTION_STRING = "mongodb://localhost:27017";
    private static final String DB_NAME = "city_practice_db";

    public static void main(String[] args) {
        Logger.getLogger("org.mongodb.driver").setLevel(Level.WARNING);

        try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            database.getCollection("cities").drop();
            database.getCollection("roadways").drop();

            insertData(database);

            printCollections(database);

            performQuery(database);

            performAggregation(database);
        }
    }

    private static void insertData(MongoDatabase db) {
        MongoCollection<Document> cities = db.getCollection("cities");
        MongoCollection<Document> roadways = db.getCollection("roadways");

        System.out.println(">>> Inserting Data...");

        Document ny = new Document("officialName", "New York")
                .append("coordinates", new Document("latitude", 40.7128).append("longitude", -74.0060));
        
        Document kyiv = new Document("officialName", "Kyiv")
                .append("coordinates", new Document("latitude", 50.4501).append("longitude", 30.5234));

        Document london = new Document("officialName", "London")
                .append("coordinates", new Document("latitude", 51.5074).append("longitude", -0.1278));

        Document sf = new Document("officialName", "San Francisco")
                .append("coordinates", new Document("latitude", 37.7749).append("longitude", -122.4194));

        cities.insertMany(Arrays.asList(ny, kyiv, london, sf));

        Document r1 = new Document("name", "Fifth Avenue")
                .append("type", "Avenue")
                .append("length", 10.0)
                .append("city_ref", "New York") 
                .append("segments", Arrays.asList(
                    new Document("seq", 1).append("start", 0).append("end", 5),
                    new Document("seq", 2).append("start", 5).append("end", 10)
                ));

        Document r2 = new Document("name", "Khreshchatyk")
                .append("type", "Street")
                .append("length", 1.2)
                .append("city_ref", "Kyiv")
                .append("segments", Arrays.asList(
                    new Document("seq", 1).append("start", 0).append("end", 1.2)
                ));

        Document r3 = new Document("name", "Oxford Street")
                .append("type", "Street")
                .append("length", 1.9)
                .append("city_ref", "London")
                .append("segments", Arrays.asList());

        Document r4 = new Document("name", "Lombard Street")
                .append("type", "Street")
                .append("length", 0.18)
                .append("city_ref", "San Francisco")
                .append("segments", Arrays.asList(
                    new Document("seq", 1).append("start", 0).append("end", 0.18)
                ));
        
        Document r5 = new Document("name", "Broadway")
                .append("type", "Avenue")
                .append("length", 33.0)
                .append("city_ref", "New York")
                .append("segments", Arrays.asList());

        roadways.insertMany(Arrays.asList(r1, r2, r3, r4, r5));
    }

    private static void printCollections(MongoDatabase db) {
        System.out.println("\n--- Printing All Documents ---");
        System.out.println("Cities:");
        for (Document doc : db.getCollection("cities").find()) {
            System.out.println(doc.toJson());
        }
        System.out.println("Roadways:");
        for (Document doc : db.getCollection("roadways").find()) {
            System.out.println(doc.toJson());
        }
    }

    private static void performQuery(MongoDatabase db) {
        System.out.println("\n--- Key-Value Query (2 Conditions) ---");
        
        MongoCollection<Document> roads = db.getCollection("roadways");
        
        Bson filter = and(
                eq("type", "Avenue"), 
                gt("length", 5.0)
        );

        for (Document doc : roads.find(filter)) {
            System.out.println("Found long avenue: " + doc.getString("name"));
        }
    }

    private static void performAggregation(MongoDatabase db) {
        System.out.println("\n--- Aggregation (4 Stages: Match, Lookup, Unwind, Group) ---");

        MongoCollection<Document> roads = db.getCollection("roadways");

        List<Bson> pipeline = Arrays.asList(
            Aggregates.match(Filters.gt("length", 0)),

            Aggregates.lookup("cities", "city_ref", "officialName", "city_data"),

            Aggregates.unwind("$city_data"),

            Aggregates.group("$city_ref", 
                Accumulators.sum("totalRoadLength", "$length"),
                Accumulators.sum("count", 1)
            ),
            
            Aggregates.sort(Sorts.descending("totalRoadLength"))
        );

        for (Document result : roads.aggregate(pipeline)) {
            System.out.println(result.toJson());
        }
    }
}