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

    isolated remote function getSprintById(int sprintId) returns record {|Sprints value;|}|error? {
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

    // Issues

    isolated remote function getIssues() returns stream<Issues, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Issues`;
        io:println(selectQuery);
        stream<Issues, error> resultStream = self.cdataClient->query(selectQuery, Issues);
        return resultStream;
    }

    isolated remote function getIssuesByJql(string jqlQuery) returns stream<Issues, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Issues WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<Issues, error> resultStream = self.cdataClient->query(selectQuery, Issues);
        return resultStream;
    }

    isolated remote function createIssue(Issues issues) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Issues (IssueTypeId, ProjectId, ProjectKey, ParentId, 
                                              PriorityId, RemainingEstimate, OriginalEstimate, AssigneeName, 
                                              Description, Summary, ReporterName, DueDate, Labels, Environment, 
                                              SecurityLevel, FixVersionsAggregate, ComponentsAggregate, 
                                              IssueLinksAggregate, AffectedVersionsAggregate, AssigneeAccountId)
                                              VALUES (${issues?.IssueTypeId}, ${issues?.ProjectId}, 
                                              ${issues?.ProjectKey}, ${issues?.ParentId}, ${issues?.PriorityId}, 
                                              ${issues?.RemainingEstimate}, ${issues?.OriginalEstimate}, 
                                              ${issues?.AssigneeName}, ${issues?.Description}, ${issues?.Summary},
                                              ${issues?.ReporterName}, ${issues?.DueDate}, ${issues?.Labels}, 
                                              ${issues?.Environment}, ${issues?.SecurityLevel}, 
                                              ${issues?.FixVersionsAggregate}, ${issues?.ComponentsAggregate}, 
                                              ${issues?.IssueLinksAggregate}, ${issues?.AffectedVersionsAggregate},
                                              ${issues?.AssigneeAccountId})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getIssueById(int issueId) returns record {|Issues value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Issues WHERE Id = ${issueId}`;
        io:println(selectQuery);
        stream<Issues, error> resultStream = self.cdataClient->query(selectQuery, Issues);
        return resultStream.next();
    }

    isolated remote function updateIssueById(Issues issues) returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE Issues SET
                                              Description = ${issues?.Description}, Summary = ${issues?.Summary},
                                              Labels = ${issues?.Labels}
                                              WHERE Id = ${issues?.Id}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteIssueById(int issueId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Issues WHERE Id = ${issueId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }

    // Comments

    isolated remote function getComments() returns stream<Comments, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Comments`;
        io:println(selectQuery);
        stream<Comments, error> resultStream = self.cdataClient->query(selectQuery, Comments);
        return resultStream;
    }

    isolated remote function createComment(Comments comments) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Comments (IssueId, IssueKey, Body, VisibilityType, 
                                              VisibilityValue)
                                              VALUES (${comments?.IssueId}, ${comments?.IssueKey}, 
                                              ${comments?.Body}, ${comments?.VisibilityType}, 
                                              ${comments?.VisibilityValue})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getCommentsByIssueId(int issueId) returns stream<Comments, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Comments WHERE IssueId = ${issueId}`;
        io:println(selectQuery);
        stream<Comments, error> resultStream = self.cdataClient->query(selectQuery, Comments);
        return resultStream;
    }

    isolated remote function updateCommentByIssueId(Comments comments) returns (string|int)?|error {
        sql:ParameterizedQuery updateQuery = `UPDATE Comments SET Body = ${comments?.Body}
                                              WHERE Id = ${comments?.Id} AND IssueId = ${comments?.IssueId}`;
        io:println(updateQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(updateQuery);
        return result.lastInsertId;
    }

    isolated remote function deleteCommentByIssueId(int commentId, int issueId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Comments WHERE Id = ${commentId} AND IssueId = ${issueId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }    

    // Users

    isolated remote function getUsers() returns stream<Users, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Users`;
        io:println(selectQuery);
        stream<Users, error> resultStream = self.cdataClient->query(selectQuery, Users);
        return resultStream;
    }

    isolated remote function getUsersOfAllGroups() returns stream<Users, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Users WHERE GroupName IN (SELECT Name FROM Groups)`;
        io:println(selectQuery);
        stream<Users, error> resultStream = self.cdataClient->query(selectQuery, Users);
        return resultStream;
    }

    isolated remote function getUsersOfGroup(string groupName) returns stream<Users, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Users WHERE GroupName = ${groupName}`;
        io:println(selectQuery);
        stream<Users, error> resultStream = self.cdataClient->query(selectQuery, Users);
        return resultStream;
    }

    // Attachments

    isolated remote function getAttachments() returns stream<Attachments, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Attachments`;
        io:println(selectQuery);
        stream<Attachments, error> resultStream = self.cdataClient->query(selectQuery, Attachments);
        return resultStream;
    }

    isolated remote function uploadAttachmentToIssueByFilePath(string filePath, string issueKey) 
                                                               returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Attachments (FilePath, IssueKey)
                                              VALUES (${filePath}, ${issueKey})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function uploadAttachmentToIssueByEncodedContent(string contentEncoded, string name, 
                                                                     string issueKey) returns (string|int)?|error {
        sql:ParameterizedQuery insertQuery = `INSERT INTO Attachments (ContentEncoded, Name, IssueKey)
                                              VALUES (${contentEncoded}, ${name}, ${issueKey})`;
        io:println(insertQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(insertQuery);
        return result.lastInsertId;
    }

    isolated remote function getAttachmentById(int attachmentId) returns record {|Attachments value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Attachments WHERE Id = ${attachmentId}`;
        io:println(selectQuery);
        stream<Attachments, error> resultStream = self.cdataClient->query(selectQuery, Attachments);
        return resultStream.next();
    }

    isolated remote function getAttachmentsByIssueId(int issueId) returns stream<Attachments, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Attachments WHERE IssueId = ${issueId}`;
        io:println(selectQuery);
        stream<Attachments, error> resultStream = self.cdataClient->query(selectQuery, Attachments);
        return resultStream;
    }

    isolated remote function getAttachmentsByJql(string jqlQuery) returns stream<Attachments, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Attachments WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<Attachments, error> resultStream = self.cdataClient->query(selectQuery, Attachments);
        return resultStream;
    }

    isolated remote function deleteAttachmentById(int attachmentId) returns error? {
        sql:ParameterizedQuery deleteQuery = `DELETE FROM Attachments WHERE Id = ${attachmentId}`;
        io:println(deleteQuery);
        sql:ExecutionResult result = check self.cdataClient->execute(deleteQuery);
        return;
    }  

    /// Views

    // AdvancedSettings

    isolated remote function getAdvancedSettings() returns stream<AdvancedSettings, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM AdvancedSettings`;
        io:println(selectQuery);
        stream<AdvancedSettings, error> resultStream = self.cdataClient->query(selectQuery, AdvancedSettings);
        return resultStream;
    }

    // ApplicationRoles

    isolated remote function getApplicationRoles() returns stream<ApplicationRoles, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ApplicationRoles`;
        io:println(selectQuery);
        stream<ApplicationRoles, error> resultStream = self.cdataClient->query(selectQuery, ApplicationRoles);
        return resultStream;
    }

    // Audit

    // Audit logs aren't available for this site as all of its Jira Cloud products are on Free plans.
    isolated remote function getAudit(string filter) returns stream<Audit, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Audit WHERE Filter = ${filter}`;
        io:println(selectQuery);
        stream<Audit, error> resultStream = self.cdataClient->query(selectQuery, Audit);
        return resultStream;
    }

    // BoardIssues

    isolated remote function getBoardIssues(int boardId) returns stream<BoardIssues, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM BoardIssues WHERE BoardId = ${boardId}`;
        io:println(selectQuery);
        stream<BoardIssues, error> resultStream = self.cdataClient->query(selectQuery, BoardIssues);
        return resultStream;
    }

    // BoardSprints

    isolated remote function getBoardSprints(int boardId) returns stream<BoardSprints, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM BoardSprints WHERE BoardId = ${boardId}`;
        io:println(selectQuery);
        stream<BoardSprints, error> resultStream = self.cdataClient->query(selectQuery, BoardSprints);
        return resultStream;
    }

    isolated remote function getSprintsOfAllBoards() returns stream<BoardSprints, error> {
        // Boards of type 'kanban' do not support sprints, so you can retrieve all the sprints faster using this query 
        sql:ParameterizedQuery selectQuery = `SELECT * FROM BoardSprints WHERE BoardId IN (SELECT Id FROM Boards 
                                              WHERE Type != 'kanban')`;
        io:println(selectQuery);
        stream<BoardSprints, error> resultStream = self.cdataClient->query(selectQuery, BoardSprints);
        return resultStream;
    }

    // Configuration

    isolated remote function getConfiguration() returns stream<Configuration, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Configuration`;
        io:println(selectQuery);
        stream<Configuration, error> resultStream = self.cdataClient->query(selectQuery, Configuration);
        return resultStream;
    }

    // Dashboards

    isolated remote function getDashboards() returns stream<Dashboards, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Dashboards`;
        io:println(selectQuery);
        stream<Dashboards, error> resultStream = self.cdataClient->query(selectQuery, Dashboards);
        return resultStream;
    }

    isolated remote function getDashboardsByFilter(string filter) returns stream<Dashboards, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Dashboards WHERE Filter = ${filter}`;
        io:println(selectQuery);
        stream<Dashboards, error> resultStream = self.cdataClient->query(selectQuery, Dashboards);
        return resultStream;
    }

    isolated remote function getDashboardById(string dashboardId) returns record {|Dashboards value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Dashboards WHERE Id = ${dashboardId}`;
        io:println(selectQuery);
        stream<Dashboards, error> resultStream = self.cdataClient->query(selectQuery, Dashboards);
        return resultStream.next();
    }

    // Epics

    isolated remote function getEpics() returns stream<Epics, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Epics`;
        io:println(selectQuery);
        stream<Epics, error> resultStream = self.cdataClient->query(selectQuery, Epics);
        return resultStream;
    }

    isolated remote function getEpicsOfBoard(int boardId) returns stream<Epics, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Epics WHERE BoardId = ${boardId}`;
        io:println(selectQuery);
        stream<Epics, error> resultStream = self.cdataClient->query(selectQuery, Epics);
        return resultStream;
    }

    // The request contains a next-gen issue. This operation cant add next-gen issues to epics. To add a next-gen issue 
    // to an epic, use the Edit issue operation and set the parent property (i.e., `"parent":{"key":"PROJ-123"}` 
    // where `PROJ-123` has an issue type at level one of the issue type hierarchy).
    isolated remote function getEpicById(int epicId) returns record {|Epics value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Epics WHERE Id = ${epicId}`;
        io:println(selectQuery);
        stream<Epics, error> resultStream = self.cdataClient->query(selectQuery, Epics);
        return resultStream.next();
    }

    // The request contains a next-gen issue. This operation cant add next-gen issues to epics. To add a next-gen issue 
    // to an epic, use the Edit issue operation and set the parent property (i.e., `"parent":{"key":"PROJ-123"}` 
    // where `PROJ-123` has an issue type at level one of the issue type hierarchy).
    isolated remote function getEpicByKey(string epicKey) returns record {|Epics value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Epics WHERE Key = ${epicKey}`;
        io:println(selectQuery);
        stream<Epics, error> resultStream = self.cdataClient->query(selectQuery, Epics);
        return resultStream.next();
    }

    // FavouriteFilters

    isolated remote function getFavouriteFilters() returns stream<FavouriteFilters, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM FavouriteFilters`;
        io:println(selectQuery);
        stream<FavouriteFilters, error> resultStream = self.cdataClient->query(selectQuery, FavouriteFilters);
        return resultStream;
    }

    // Fields

    isolated remote function getFields() returns stream<Fields, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Fields`;
        io:println(selectQuery);
        stream<Fields, error> resultStream = self.cdataClient->query(selectQuery, Fields);
        return resultStream;
    }

    // Filters

    isolated remote function getFilters() returns stream<Filters, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Filters`;
        io:println(selectQuery);
        stream<Filters, error> resultStream = self.cdataClient->query(selectQuery, Filters);
        return resultStream;
    }

    isolated remote function getFilterById(string filterId) returns record {|Filters value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Filters WHERE Id = ${filterId}`;
        io:println(selectQuery);
        stream<Filters, error> resultStream = self.cdataClient->query(selectQuery, Filters);
        return resultStream.next();
    }

    // Groups

    isolated remote function getGroups() returns stream<Groups, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Groups`;
        io:println(selectQuery);
        stream<Groups, error> resultStream = self.cdataClient->query(selectQuery, Groups);
        return resultStream;
    }

    // IssueAffectedVersions

    isolated remote function getIssueAffectedVersions() returns stream<IssueAffectedVersions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueAffectedVersions`;
        io:println(selectQuery);
        stream<IssueAffectedVersions, error> resultStream = self.cdataClient->query(selectQuery, IssueAffectedVersions);
        return resultStream;
    }

    isolated remote function getIssueAffectedVersionsByJql(string jqlQuery) 
                                                           returns stream<IssueAffectedVersions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueAffectedVersions WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<IssueAffectedVersions, error> resultStream = self.cdataClient->query(selectQuery, IssueAffectedVersions);
        return resultStream;
    }

    // IssueChangelogs

    isolated remote function getIssueChangelogs() returns stream<IssueChangelogs, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueChangelogs`;
        io:println(selectQuery);
        stream<IssueChangelogs, error> resultStream = self.cdataClient->query(selectQuery, IssueChangelogs);
        return resultStream;
    }

    // IssueComponents

    isolated remote function getIssueComponents() returns stream<IssueComponents, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueComponents`;
        io:println(selectQuery);
        stream<IssueComponents, error> resultStream = self.cdataClient->query(selectQuery, IssueComponents);
        return resultStream;
    }

    isolated remote function getIssueComponentsByJql(string jqlQuery) returns stream<IssueComponents, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueComponents WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<IssueComponents, error> resultStream = self.cdataClient->query(selectQuery, IssueComponents);
        return resultStream;
    }

    // IssueCustomFieldOptions

    isolated remote function getIssueCustomFieldOptions(int customFieldId) 
                                                        returns stream<IssueCustomFieldOptions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueCustomFieldOptions 
                                              WHERE CustomFieldId = ${customFieldId}`;
        io:println(selectQuery);
        stream<IssueCustomFieldOptions, error> resultStream = self.cdataClient->query(selectQuery, 
            IssueCustomFieldOptions);
        return resultStream;
    }

    // IssueCustomFields

    isolated remote function getIssueCustomFields() returns stream<IssueCustomFields, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueCustomFields`;
        io:println(selectQuery);
        stream<IssueCustomFields, error> resultStream = self.cdataClient->query(selectQuery, IssueCustomFields);
        return resultStream;
    }

    // IssueFixVersions

    isolated remote function getIssueFixVersions() returns stream<IssueFixVersions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueFixVersions`;
        io:println(selectQuery);
        stream<IssueFixVersions, error> resultStream = self.cdataClient->query(selectQuery, IssueFixVersions);
        return resultStream;
    }

    isolated remote function getIssueFixVersionsByJql(string jqlQuery) returns stream<IssueFixVersions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueFixVersions WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<IssueFixVersions, error> resultStream = self.cdataClient->query(selectQuery, IssueFixVersions);
        return resultStream;
    }

    // IssueLinks

    isolated remote function getIssueLinks() returns stream<IssueLinks, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueLinks`;
        io:println(selectQuery);
        stream<IssueLinks, error> resultStream = self.cdataClient->query(selectQuery, IssueLinks);
        return resultStream;
    }

    isolated remote function getIssueLinksByJql(string jqlQuery) returns stream<IssueLinks, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueLinks WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<IssueLinks, error> resultStream = self.cdataClient->query(selectQuery, IssueLinks);
        return resultStream;
    }

    // IssueLinkTypes

    isolated remote function getIssueLinkTypes() returns stream<IssueLinkTypes, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueLinkTypes`;
        io:println(selectQuery);
        stream<IssueLinkTypes, error> resultStream = self.cdataClient->query(selectQuery, IssueLinkTypes);
        return resultStream;
    }

    isolated remote function getIssueLinkTypesById(string issueLinkTypesId) 
                                                   returns record {|IssueLinkTypes value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueLinkTypes WHERE Id = ${issueLinkTypesId}`;
        io:println(selectQuery);
        stream<IssueLinkTypes, error> resultStream = self.cdataClient->query(selectQuery, IssueLinkTypes);
        return resultStream.next();
    }

    // IssueNavigatorDefaultColumns

    isolated remote function getIssueNavigatorDefaultColumns() returns stream<IssueNavigatorDefaultColumns, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueNavigatorDefaultColumns`;
        io:println(selectQuery);
        stream<IssueNavigatorDefaultColumns, error> resultStream = 
            self.cdataClient->query(selectQuery, IssueNavigatorDefaultColumns);
        return resultStream;
    }

    // IssuePriorities

    isolated remote function getIssuePriorities() returns stream<IssuePriorities, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssuePriorities`;
        io:println(selectQuery);
        stream<IssuePriorities, error> resultStream = self.cdataClient->query(selectQuery, IssuePriorities);
        return resultStream;
    }

    isolated remote function getIssuePriorityById(string issuePrioritiesId) 
                                                  returns record {|IssuePriorities value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssuePriorities WHERE Id = ${issuePrioritiesId}`;
        io:println(selectQuery);
        stream<IssuePriorities, error> resultStream = self.cdataClient->query(selectQuery, IssuePriorities);
        return resultStream.next();
    }

    // IssueResolutions

    isolated remote function getIssueResolutions() returns stream<IssueResolutions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueResolutions`;
        io:println(selectQuery);
        stream<IssueResolutions, error> resultStream = self.cdataClient->query(selectQuery, IssueResolutions);
        return resultStream;
    }

    isolated remote function getIssueResolutionById(string issueResolutionId) 
                                                  returns record {|IssueResolutions value;|}|error? {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueResolutions WHERE Id = ${issueResolutionId}`;
        io:println(selectQuery);
        stream<IssueResolutions, error> resultStream = self.cdataClient->query(selectQuery, IssueResolutions);
        return resultStream.next();
    }

    // IssueSubtasks

    isolated remote function getIssueSubtasks() returns stream<IssueSubtasks, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueSubtasks`;
        io:println(selectQuery);
        stream<IssueSubtasks, error> resultStream = self.cdataClient->query(selectQuery, IssueSubtasks);
        return resultStream;
    }

    isolated remote function getIssueSubtasksByIssueId(int issueId) returns stream<IssueSubtasks, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueSubtasks WHERE IssueId = ${issueId}`;
        io:println(selectQuery);
        stream<IssueSubtasks, error> resultStream = self.cdataClient->query(selectQuery, IssueSubtasks);
        return resultStream;
    }

    isolated remote function getIssueSubtasksByJql(string jqlQuery) returns stream<IssueSubtasks, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueSubtasks WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<IssueSubtasks, error> resultStream = self.cdataClient->query(selectQuery, IssueSubtasks);
        return resultStream;
    }

    // IssueTransitions

    isolated remote function getIssueTransitions() returns stream<IssueTransitions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueTransitions`;
        io:println(selectQuery);
        stream<IssueTransitions, error> resultStream = self.cdataClient->query(selectQuery, IssueTransitions);
        return resultStream;
    }

    isolated remote function getIssueTransitionsByJql(string jqlQuery) returns stream<IssueTransitions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM IssueTransitions WHERE JQL = ${jqlQuery}`;
        io:println(selectQuery);
        stream<IssueTransitions, error> resultStream = self.cdataClient->query(selectQuery, IssueTransitions);
        return resultStream;
    }

    // MyPermissions

    // Error while executing SQL query: SELECT * FROM MyPermissions. The 'permissions' query parameter is required.
    isolated remote function getMyPermissions() returns stream<MyPermissions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM MyPermissions`;
        io:println(selectQuery);
        stream<MyPermissions, error> resultStream = self.cdataClient->query(selectQuery, MyPermissions);
        return resultStream;
    }

    // Permissions

    isolated remote function getPermissions() returns stream<Permissions, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM Permissions`;
        io:println(selectQuery);
        stream<Permissions, error> resultStream = self.cdataClient->query(selectQuery, Permissions);
        return resultStream;
    }

    // ProjectCategories

    isolated remote function getProjectCategories() returns stream<ProjectCategories, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectCategories`;
        io:println(selectQuery);
        stream<ProjectCategories, error> resultStream = self.cdataClient->query(selectQuery, ProjectCategories);
        return resultStream;
    }

    // ProjectRoles

    isolated remote function getProjectRoles() returns stream<ProjectRoles, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectRoles`;
        io:println(selectQuery);
        stream<ProjectRoles, error> resultStream = self.cdataClient->query(selectQuery, ProjectRoles);
        return resultStream;
    }

    isolated remote function getProjectRolesByProjectId(int projectId) returns stream<ProjectRoles, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectRoles WHERE ProjectId = ${projectId}`;
        io:println(selectQuery);
        stream<ProjectRoles, error> resultStream = self.cdataClient->query(selectQuery, ProjectRoles);
        return resultStream;
    }

    // ProjectsIssueTypes

    isolated remote function getProjectsIssueTypes() returns stream<ProjectsIssueTypes, error> {
        sql:ParameterizedQuery selectQuery = `SELECT * FROM ProjectsIssueTypes`;
        io:println(selectQuery);
        stream<ProjectsIssueTypes, error> resultStream = self.cdataClient->query(selectQuery, ProjectsIssueTypes);
        return resultStream;
    }

    isolated remote function close() returns error? {
        check self.cdataClient.close();
    }
} 
