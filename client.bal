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
import ballerina/log;
import ballerinax/java.jdbc;

# CData Client connector to Jira.  
public client class Client {
    private jdbc:Client cdataConnectorToJira;
    private sql:ConnectionPool connPool;

    public isolated function init(JiraConfig configuration) returns error? {
        string jdbcUrl = generateJdbcUrl(configuration);
        log:printInfo(jdbcUrl);
        self.cdataConnectorToJira = check new (jdbcUrl);
    }

    isolated remote function getObjects(string objectName) returns stream<record{}, error> {
        string selectQuery = generateSelectAllQuery(objectName);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createObject(string objectName, map<anydata> payload) returns (string|int)?|error {
        string insertQuery = generateInsertQuery(objectName, payload);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getObject(string objectName, int recordId, string... fields) 
                                       returns record {|record{} value;|}|error? {
        string selectQuery = generateSelectQuery(objectName, recordId, fields);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateObject(string objectName, int recordId, map<anydata> payload) 
                                          returns (string|int)?|error {
        string updateQuery = generateUpdateQuery(objectName, recordId, payload);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteObject(string objectName, int recordId) returns error? {
        string deleteQuery = generateDeleteQuery(objectName, recordId);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    isolated remote function close() returns error? {
        check self.cdataConnectorToJira.close();
    }
} 
