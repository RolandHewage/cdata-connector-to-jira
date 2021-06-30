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
// import ballerinax/java.jdbc;
import cdata;

# CData Client connector to Jira.  
public client class Client {
    private cdata:Client cdataClient;
    private sql:ConnectionPool connPool;

    public isolated function init(JiraConfig configuration) returns error? {
        string jdbcUrl = generateJdbcUrl(configuration);
        self.cdataClient = check new (jdbcUrl);
    }

    // Projects

    isolated remote function getProjects() returns stream<Projects, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Projects`;
        io:println(selectQuery);
        stream<Projects, error> resultStream = self.cdataClient->query(selectQuery, Projects);
        return resultStream;
    }

    isolated remote function createProject(Projects projects) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Projects (Key, Name, Description, AssigneeType, 
                                              ProjectCategoryId, ProjectTypeKey, LeadAccountId)
                                              VALUES (${projects?.Key}, ${projects?.Name}, 
                                              ${projects?.Description}, ${projects?.AssigneeType},
                                              ${projects?.ProjectCategoryId}, ${projects?.ProjectTypeKey},
                                              ${projects?.LeadAccountId})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getProjectById(int projectId) returns record {|Projects value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Projects WHERE Id = ${projectId}`;
        io:println(selectQuery);
        stream<Projects, error> resultStream = self.cdataClient->query(selectQuery, Projects);
        return resultStream.next();
    }

    isolated remote function updateProjectById(Projects projects) returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE Projects SET Key = ${projects?.Key}, 
                                              Name = ${projects?.Name}, 
                                              Description = ${projects?.Description}, 
                                              AssigneeType = ${projects?.AssigneeType}, 
                                              ProjectCategoryId = ${projects?.ProjectCategoryId}, 
                                              ProjectTypeKey = ${projects?.ProjectTypeKey}, 
                                              LeadAccountId = ${projects?.LeadAccountId} 
                                              WHERE Id = ${projects?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function updateProjectByKey(Projects projects) returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE Projects SET Name = ${projects?.Name}, 
                                              Description = ${projects?.Description}, 
                                              AssigneeType = ${projects?.AssigneeType}, 
                                              ProjectCategoryId = ${projects?.ProjectCategoryId}, 
                                              ProjectTypeKey = ${projects?.ProjectTypeKey}, 
                                              LeadAccountId = ${projects?.LeadAccountId} 
                                              WHERE Key = ${projects?.Key}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteProjectById(int projectId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Projects WHERE Id = ${projectId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    isolated remote function deleteProjectByKey(string projectKey) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Projects WHERE Key = ${projectKey}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Project Components

    isolated remote function getProjectComponents() returns stream<ProjectComponents, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectComponents`;
        io:println(selectQuery);
        stream<ProjectComponents, error> resultStream = self.cdataClient->query(selectQuery, ProjectComponents);
        return resultStream;
    }

    isolated remote function createProjectComponent(ProjectComponents projectComponents) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO ProjectComponents (ProjectKey, Name, Description, 
                                              LeadKey, AssigneeType)
                                              VALUES (${projectComponents?.ProjectKey}, ${projectComponents?.Name}, 
                                              ${projectComponents?.Description}, ${projectComponents?.LeadKey},
                                              ${projectComponents?.AssigneeType})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getProjectComponentById(int projectComponentId) 
                                                     returns record {|ProjectComponents value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectComponents WHERE Id = ${projectComponentId}`;
        io:println(selectQuery);
        stream<ProjectComponents, error> resultStream = self.cdataClient->query(selectQuery, ProjectComponents);
        return resultStream.next();
    }

    isolated remote function getProjectComponentByProjectId(int projectId) 
                                                            returns record {|ProjectComponents value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectComponents WHERE ProjectId = ${projectId}`;
        io:println(selectQuery);
        stream<ProjectComponents, error> resultStream = self.cdataClient->query(selectQuery, ProjectComponents);
        return resultStream.next();
    }

    isolated remote function getProjectComponentByProjectKey(string projectKey) 
                                                             returns record {|ProjectComponents value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectComponents WHERE ProjectKey = ${projectKey}`;
        io:println(selectQuery);
        stream<ProjectComponents, error> resultStream = self.cdataClient->query(selectQuery, ProjectComponents);
        return resultStream.next();
    }

    isolated remote function updateProjectComponentById(ProjectComponents projectComponents) 
                                                        returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE ProjectComponents 
                                              SET ProjectKey = ${projectComponents?.ProjectKey}, 
                                              Name = ${projectComponents?.Name}, 
                                              Description = ${projectComponents?.Description}, 
                                              LeadKey = ${projectComponents?.LeadKey},
                                              AssigneeType = ${projectComponents?.AssigneeType}
                                              WHERE Id = ${projectComponents?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteProjectComponentById(int projectComponentId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM ProjectComponents WHERE Id = ${projectComponentId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Project Versions

    isolated remote function getProjectVersions() returns stream<ProjectVersions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectVersions`;
        io:println(selectQuery);
        stream<ProjectVersions, error> resultStream = self.cdataClient->query(selectQuery, ProjectVersions);
        return resultStream;
    }    

    isolated remote function createProjectVersion(ProjectVersions projectVersions) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO ProjectVersions (ProjectId, ProjectKey, Name, Description, 
                                              Released, ReleaseDate, StartDate, Archived)
                                              VALUES (${projectVersions?.ProjectId}, ${projectVersions?.ProjectKey}, 
                                              ${projectVersions?.Name}, ${projectVersions?.Description}, 
                                              ${projectVersions?.Released}, ${projectVersions?.ReleaseDate}, 
                                              ${projectVersions?.StartDate}, ${projectVersions?.Archived})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getProjectVersionById(int projectVersionId) 
                                                   returns record {|ProjectVersions value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectVersions WHERE Id = ${projectVersionId}`;
        io:println(selectQuery);
        stream<ProjectVersions, error> resultStream = self.cdataClient->query(selectQuery, ProjectVersions);
        return resultStream.next();
    }

    isolated remote function getProjectVersionByProjectId(int projectId) 
                                                          returns record {|ProjectVersions value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectVersions WHERE ProjectId = ${projectId}`;
        io:println(selectQuery);
        stream<ProjectVersions, error> resultStream = self.cdataClient->query(selectQuery, ProjectVersions);
        return resultStream.next();
    }

    isolated remote function getProjectVersionByProjectKey(string projectKey) 
                                                           returns record {|ProjectVersions value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectVersions WHERE ProjectKey = ${projectKey}`;
        io:println(selectQuery);
        stream<ProjectVersions, error> resultStream = self.cdataClient->query(selectQuery, ProjectVersions);
        return resultStream.next();
    }

    isolated remote function updateProjectVersionById(ProjectVersions projectVersions) 
                                                      returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE ProjectVersions 
                                              SET ProjectId = ${projectVersions?.ProjectId}, 
                                              ProjectKey = ${projectVersions?.ProjectKey}, 
                                              Name = ${projectVersions?.Name}, 
                                              Description = ${projectVersions?.Description}, 
                                              Released = ${projectVersions?.Released},
                                              ReleaseDate = ${projectVersions?.ReleaseDate},
                                              StartDate = ${projectVersions?.StartDate},
                                              UserStartDate = ${projectVersions?.UserStartDate},
                                              UserReleaseDate = ${projectVersions?.UserReleaseDate},
                                              Archived = ${projectVersions?.Archived}
                                              WHERE Id = ${projectVersions?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteProjectVersionById(int projectVersionId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM ProjectVersions WHERE Id = ${projectVersionId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Issue Types

    isolated remote function getIssueTypes() returns stream<IssueTypes, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueTypes`;
        io:println(selectQuery);
        stream<IssueTypes, error> resultStream = self.cdataClient->query(selectQuery, IssueTypes);
        return resultStream;
    }

    isolated remote function createIssueType(IssueTypes issueTypes) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO IssueTypes (Name, Description, Subtask)
                                              VALUES (${issueTypes?.Name}, ${issueTypes?.Description}, 
                                              ${issueTypes?.Subtask})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getIssueTypeById(string issueTypeId) 
                                              returns record {|IssueTypes value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueTypes WHERE Id = ${issueTypeId}`;
        io:println(selectQuery);
        stream<IssueTypes, error> resultStream = self.cdataClient->query(selectQuery, IssueTypes);
        return resultStream.next();
    }

    isolated remote function updateIssueTypeById(IssueTypes issueTypes) 
                                                 returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE IssueTypes SET Name = ${issueTypes?.Name}, 
                                              Description = ${issueTypes?.Description}, 
                                              Subtask = ${issueTypes?.Subtask}
                                              WHERE Id = ${issueTypes?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteIssueTypeById(string issueTypeId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM IssueTypes WHERE Id = ${issueTypeId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Roles

    isolated remote function getRoles() returns stream<Roles, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Roles`;
        io:println(selectQuery);
        stream<Roles, error> resultStream = self.cdataClient->query(selectQuery, Roles);
        return resultStream;
    }

    // Project roles aren't editable in Jira Software Free. Upgrade for advanced team configuration.
    isolated remote function createRole(Roles roles) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Roles (Name, Description, Actors, Scope, IsAdmin, IsDefault)
                                              VALUES (${roles?.Name}, ${roles?.Description}, ${roles?.Actors}, 
                                              ${roles?.Scope}, ${roles?.IsAdmin}, ${roles?.IsDefault})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getRoleById(int roleId) 
                                         returns record {|Roles value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Roles WHERE Id = ${roleId}`;
        io:println(selectQuery);
        stream<Roles, error> resultStream = self.cdataClient->query(selectQuery, Roles);
        return resultStream.next();
    }

    // Project roles aren't editable in Jira Software Free. Upgrade for advanced team configuration.
    isolated remote function updateRoleById(Roles roles) 
                                            returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE Roles SET Name = ${roles?.Name}, 
                                              Description = ${roles?.Description}, 
                                              Actors = ${roles?.Actors}, Scope = ${roles?.Scope}, 
                                              IsAdmin = ${roles?.IsAdmin}, IsDefault = ${roles?.IsDefault}
                                              WHERE Id = ${roles?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    // Project roles aren't editable in Jira Software Free. Upgrade for advanced team configuration.
    isolated remote function deleteRoleById(int roleId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Roles WHERE Id = ${roleId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Boards

    isolated remote function getBoards() returns stream<Boards, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Boards`;
        io:println(selectQuery);
        stream<Boards, error> resultStream = self.cdataClient->query(selectQuery, Boards);
        return resultStream;
    }

    // API doesnt provide much information about how to obtain the required parameter `FilterId`
    isolated remote function createBoard(Boards boards) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Boards (Name, Type)
                                              VALUES (${boards?.Name}, ${boards?.Type})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getBoardById(int boardId) returns record {|Boards value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Boards WHERE Id = ${boardId}`;
        io:println(selectQuery);
        stream<Boards, error> resultStream = self.cdataClient->query(selectQuery, Boards);
        return resultStream.next();
    }

    isolated remote function getBoard(string projectKeyOrId) returns record {|record{} value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Boards WHERE ProjectKeyOrId = ${projectKeyOrId}`;
        io:println(selectQuery);
        stream<record{}, error> resultStream = self.cdataClient->query(selectQuery);
        return resultStream.next();
    }

    isolated remote function deleteBoardById(int boardId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Boards WHERE Id = ${boardId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Sprints

    isolated remote function getSprints() returns stream<Sprints, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Sprints`;
        io:println(selectQuery);
        stream<Sprints, error> resultStream = self.cdataClient->query(selectQuery, Sprints);
        return resultStream;
    }

    isolated remote function createSprint(Sprints sprints) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Sprints (Name, State, Goal, OriginBoardId, StartDate, 
                                              EndDate)
                                              VALUES (${sprints?.Name}, ${sprints?.State}, ${sprints?.Goal}, 
                                              ${sprints?.OriginBoardId}, ${sprints?.StartDate}, ${sprints?.EndDate})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getSprintById(int sprintId) 
                                           returns record {|Sprints value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Sprints WHERE Id = ${sprintId}`;
        io:println(selectQuery);
        stream<Sprints, error> resultStream = self.cdataClient->query(selectQuery, Sprints);
        return resultStream.next();
    }

    isolated remote function updateSprintById(Sprints sprints) returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE Sprints SET Name = ${sprints?.Name}, 
                                              State = ${sprints?.State}, 
                                              Goal = ${sprints?.Goal}, OriginBoardId = ${sprints?.OriginBoardId}, 
                                              StartDate = ${sprints?.StartDate}, EndDate = ${sprints?.EndDate}
                                              WHERE Id = ${sprints?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteSprintById(int sprintId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Sprints WHERE Id = ${sprintId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    isolated remote function close() returns error? {
        check self.cdataClient.close();
    }
} 
