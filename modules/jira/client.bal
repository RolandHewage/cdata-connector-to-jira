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

    // Project Components

    isolated remote function getProjectComponents() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(PROJECT_COMPONENTS);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createProjectComponent(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(PROJECT_COMPONENTS, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getProjectComponentById(int projectComponentId, string... fields) 
                                                     returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectComponentId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECT_COMPONENTS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function getProjectComponentByProjectId(int projectId, string... fields) 
                                                            returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "ProjectId",
            value: projectId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECT_COMPONENTS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function getProjectComponentByProjectKey(string projectKey, string... fields) 
                                                             returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "ProjectKey",
            value: projectKey,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECT_COMPONENTS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateProjectComponentById(int projectComponentId, map<anydata> payload) 
                                                        returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectComponentId,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(PROJECT_COMPONENTS, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteProjectComponentById(int projectComponentId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectComponentId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(PROJECT_COMPONENTS, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Project Versions

    isolated remote function getProjectVersions() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(PROJECT_VERSIONS);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createProjectVersion(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(PROJECT_VERSIONS, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getProjectVersionById(int projectVersionId, string... fields) 
                                                   returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectVersionId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECT_VERSIONS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function getProjectVersionByProjectId(int projectId, string... fields) 
                                                          returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "ProjectId",
            value: projectId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECT_VERSIONS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function getProjectVersionByProjectKey(string projectKey, string... fields) 
                                                           returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "ProjectKey",
            value: projectKey,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(PROJECT_VERSIONS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateProjectVersionById(int projectVersionId, map<anydata> payload) 
                                                      returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectVersionId,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(PROJECT_VERSIONS, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteProjectVersionById(int projectVersionId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: projectVersionId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(PROJECT_VERSIONS, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Issue Types

    isolated remote function getIssueTypes() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(ISSUE_TYPES);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createIssueType(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(ISSUE_TYPES, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getIssueTypeById(string issueTypeId, string... fields) 
                                              returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: issueTypeId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(ISSUE_TYPES, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateIssueTypeById(string issueTypeId, map<anydata> payload) 
                                                 returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: issueTypeId,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(ISSUE_TYPES, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteIssueTypeById(string issueTypeId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: issueTypeId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(ISSUE_TYPES, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Roles

    isolated remote function getRoles() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(ROLES);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    // Project roles aren't editable in Jira Software Free. Upgrade for advanced team configuration.
    isolated remote function createRole(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(ROLES, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getRoleById(int roleId, string... fields) 
                                         returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: roleId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(ROLES, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    // Project roles aren't editable in Jira Software Free. Upgrade for advanced team configuration.
    isolated remote function updateRoleById(int roleId, map<anydata> payload) 
                                            returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: roleId,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(ROLES, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    // Project roles aren't editable in Jira Software Free. Upgrade for advanced team configuration.
    isolated remote function deleteRoleById(int roleId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: roleId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(ROLES, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Boards

    isolated remote function getBoards() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(BOARDS);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    // API doesnt provide much information about how to obtain the required parameter `FilterId`
    isolated remote function createBoard(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(BOARDS, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getBoardById(int boardId, string... fields) 
                                          returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: boardId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(BOARDS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function getBoard(string[] fields, cdata:WhereCondition[]? whereConditions = ()) 
                                      returns record {|record{} value;|}|error? {
        string selectQuery = cdata:generateConditionalSelectQuery(BOARDS, fields, whereConditions);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function deleteBoardById(int boardId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: boardId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(BOARDS, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    // Sprints

    isolated remote function getSprints() returns stream<record{}, error> {
        string selectQuery = cdata:generateConditionalSelectAllQuery(SPRINTS);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream;
    }

    isolated remote function createSprint(map<anydata> payload) returns (string|int)?|error {
        string insertQuery = cdata:generateInsertQuery(SPRINTS, payload);
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getSprintById(int sprintId, string... fields) 
                                           returns record {|record{} value;|}|error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: sprintId,
            operator: "="
        };
        string selectQuery = cdata:generateConditionalSelectQuery(SPRINTS, fields, [whereCondition]);
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataConnectorToJira->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function updateSprintById(int sprintId, map<anydata> payload) 
                                              returns (string|int)?|error {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: sprintId,
            operator: "="
        };
        string updateQuery = cdata:generateConditionalUpdateQuery(SPRINTS, payload, [whereCondition]);
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteSprintById(int sprintId) returns error? {
        cdata:WhereCondition whereCondition = {
            'key: "Id",
            value: sprintId,
            operator: "="
        };
        string deleteQuery = cdata:generateConditionalDeleteQuery(SPRINTS, [whereCondition]);
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataConnectorToJira->execute(deleteQuery);
        return;
    }

    isolated remote function close() returns error? {
        check self.cdataConnectorToJira.close();
    }
} 
