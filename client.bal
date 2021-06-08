// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/sql;
import ballerinax/java.jdbc;

# CData Client connector to Jira.  
public client class Client {
    private jdbc:Client cdataConnectorToJira;
    private sql:ConnectionPool connPool;

    public isolated function init(Configuration configuration) returns sql:Error? {
        self.cdataConnectorToJira = check new ("jdbc:cdata:jira:User=" + configuration.basicAuth.hostBasicAuth.user + 
                ";APIToken=" + configuration.basicAuth.hostBasicAuth?.apiToken.toString() + 
                ";Url=" + configuration.basicAuth.url);
        // if (configuration?.poolingEnabled == true) {
        //     self.connPool = {
        //         maxOpenConnections: configuration?.maxOpenConnections ?: 15,
        //         maxConnectionLifeTime: configuration?.maxConnectionLifeTime ?: 1800,
        //         minIdleConnections: configuration?.minIdleConnections ?: 15
        //     };
        //     self.cdataConnectorToJira = check new ("jdbc:cdata:jira:User=" + configuration.user + 
        //         ";APIToken=" + configuration.apiToken + ";Url=" + configuration.url, 
        //         connectionPool = self.connPool);
        // } else {
        //     self.cdataConnectorToJira = check new ("jdbc:salesforce:User=" + configuration.user + 
        //         ";APIToken=" + configuration.apiToken + ";Security Token=" + configuration.url);
        // }
    }

    isolated remote function getObjects(string objectName) returns stream<record{}, error> {
        string selectQuery = generateSelectAllQuery(objectName);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createObject(string objectName, map<anydata> payload) returns (string|int)?|sql:Error {
        string insertQuery = generateInsertQuery(objectName, payload);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getObject(string objectName, int objectId, string... fields) 
                                       returns record {|record{} value;|}|error? {
        string selectQuery = generateSelectQuery(objectName, objectId, fields);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateObject(string objectName, int objectId, map<anydata> payload) 
                                          returns (string|int)?|sql:Error {
        string updateQuery = generateUpdateQuery(objectName, objectId, payload);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteObject(string objectName, int objectId) returns sql:Error? {
        string deleteQuery = generateDeleteQuery(objectName, objectId);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // isolated remote function batchInsertAccounts(Account[] accounts) returns string[]|sql:Error {
    //     sql:ParameterizedQuery[] insertQueries =
    //         from var data in accounts
    //             select  `INSERT INTO Account (Name, Type, AccountNumber, Industry, Description)
    //                     VALUES (${data.Name}, ${data?.Type},
    //                     ${data?.AccountNumber}, ${data?.Industry}, ${data?.Description})`;

    //     sql:ExecutionResult[] batchResults = check self.cdataConnectorToSalesforce->batchExecute(insertQueries);
    //     string[] generatedIds = [];
    //     foreach var batchResult in batchResults {
    //         generatedIds.push(<string> batchResult.lastInsertId);
    //     }
    //     return generatedIds;
    // }

    // isolated remote function batchUpdateAccounts(Account[] accounts) returns string[]|sql:Error {
    //     sql:ParameterizedQuery[] updateQueries =
    //         from var data in accounts
    //             select `UPDATE Account SET name = ${data.Name} WHERE id = ${data.Id}`;

    //     sql:ExecutionResult[] batchResults = check self.cdataConnectorToSalesforce->batchExecute(updateQueries);
    //     string[] generatedIds = [];
    //     foreach var batchResult in batchResults {
    //         generatedIds.push(<string> batchResult.lastInsertId);
    //     }
    //     return generatedIds;
    // }

    // isolated remote function batchDeleteAccounts(string[] accountIds) returns sql:Error? {
    //     sql:ParameterizedQuery[] deleteQueries =
    //         from var data in accountIds
    //             select `DELETE FROM Account WHERE id = ${data}`;
    //     sql:ExecutionResult[] batchResults = check self.cdataConnectorToSalesforce->batchExecute(deleteQueries);
    //     return;
    // }

    // isolated remote function getUserInformation() returns stream<record{}, sql:Error>|sql:Error? {
    //     sql:ProcedureCallResult retCall = check self.cdataConnectorToSalesforce->call("{CALL GetUserInformation()}");
    //     stream<record{}, sql:Error>? result = retCall.queryResult;
    //     if (!(result is ())) {
    //         stream<record{}, sql:Error> userStream = <stream<record{}, sql:Error>> result;
    //         return userStream;
    //     } 
    //     checkpanic retCall.close();
    //     return;
    // }

    isolated remote function close() returns sql:Error? {
        check self.cdataConnectorToJira.close();
    }
} 
