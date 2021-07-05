import ballerina/io;
import ballerina/sql;
import ballerinax/cdatat.jira as _;     // Get the CData JIRA driver
import ballerinax/java.jdbc;            // Get the JDBC client

public function main() returns error? {
    string jdbcUrl = "jdbc:cdata:jira:User=roly.hewage@gmail.com;APIToken=G81iDTagHOlI5dANv3pEE0D9;" +
        "Url=https://rolyhewage.atlassian.net;";
    jdbc:Client dbClient = check new (jdbcUrl);
    sql:ParameterizedQuery sqlQuery = `SELECT * FROM Projects`;
    stream <record {}, sql:Error> queryResult = dbClient->query(sqlQuery);
    error? e = queryResult.forEach(isolated function(record {} jobject) {
        io:println("Project details: ", jobject);
    });
}