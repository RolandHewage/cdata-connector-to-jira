import ballerina/io;
import ballerina/sql;
import ballerinax/cdata.jira as _;  // Get the driver
import ballerinax/java.jdbc;  // Get the client

public function main() returns error? {
    jdbc:Options options = {
        datasourceName: "cdata.jdbc.jira.JIRADriver"
    };
    jdbc:Client dbClient = check new ("jdbc:cdata:jira:User=roly.hewage@gmail.com;APIToken=G81iDTagHOlI5dANv3pEE0D9;" +
        "Url=https://rolyhewage.atlassian.net;", options = options);
    sql:ParameterizedQuery sqlQuery = `SELECT * FROM Projects`;
    stream <record {}, sql:Error> queryResult = dbClient->query(sqlQuery);
    error? e = queryResult.forEach(isolated function(record {} jobject) {
        io:println("Project details: ", jobject);
    });
}