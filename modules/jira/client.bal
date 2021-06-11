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
import ballerina/io;
import ballerinax/java.jdbc;
import cdata as cdata;

# CData Client connector to Jira.  
public client class Client {
    private jdbc:Client cdataConnectorToJira;
    private sql:ConnectionPool connPool;

    public isolated function init(JiraConfig configuration) returns error? {
        string jdbcUrl = generateJdbcUrl(configuration);
        self.cdataConnectorToJira = check new (jdbcUrl);
    }

    // Generic Objects

    isolated remote function getObjects(string objectName) returns stream<record{}, error> {
        string selectQuery = cdata:generateSelectAllQuery(objectName);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createObject(string objectName, map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(objectName, payload);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getObject(string objectName, int recordId, string... fields) 
                                       returns record {|record{} value;|}|error? {
        string selectQuery = cdata:generateSelectQuery(objectName, recordId, fields);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateObject(string objectName, int recordId, map<anydata> payload) 
                                          returns (string|int)?|error {
        string updateQuery = cdata:generateUpdateQuery(objectName, recordId, payload);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteObject(string objectName, int recordId) returns error? {
        string deleteQuery = cdata:generateDeleteQuery(objectName, recordId);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Generic Conditional Objects

    isolated remote function getConditionalObjects(string objectName, cdata:WhereCondition[]? whereConditions = ()) 
                                                   returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(objectName, whereConditions);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function getConditionalObject(string objectName, string[] fields, 
                                                  cdata:WhereCondition[]? whereConditions = ()) 
                                                  returns record {|record{} value;|}|error? {
        string selectQuery = cdata:generateConditionalSelectQuery(objectName, fields, whereConditions);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateConditionalObject(string objectName, map<anydata> payload, 
                                                     cdata:WhereCondition[] whereConditions) 
                                                     returns (string|int)?|error {
        string updateQuery = cdata:generateConditionalUpdateQuery(objectName, payload, whereConditions);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteConditionalObject(string objectName, cdata:WhereCondition[] whereConditions) 
                                                     returns error? {
        string deleteQuery = cdata:generateConditionalDeleteQuery(objectName, whereConditions);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Projects

    isolated remote function getProjects() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(PROJECTS);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createProject(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(PROJECTS, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getProjectById(int projectId, string... fields) returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECTS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateProjectById(int projectId, map<anydata> payload) returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectId,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(PROJECTS, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function updateProjectByKey(string projectKey, map<anydata> payload) returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Key",
            value: projectKey,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(PROJECTS, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteProjectById(int projectId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(PROJECTS, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    isolated remote function deleteProjectByKey(string projectKey) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Key",
            value: projectKey,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(PROJECTS, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    isolated remote function close() returns error? {
        check self.cdataConnectorToJira.close();
    }
} 
