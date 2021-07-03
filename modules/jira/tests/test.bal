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

import ballerina/io;
import ballerina/os;
import ballerina/sql;
import ballerina/test;

(string|int)? projectId = ();
(string|int)? projectKey = ();
(string|int)? projectComponentId = ();
(string|int)? projectVersionId = ();
(string|int)? issueTypeId = ();
(string|int)? roleId = ();
(string|int)? boardId = ();
(string|int)? sprintId = ();
(string|int)? issueId = ();
(string|int)? commentId = ();
(string|int)? attachmentId = ();

// Connection Configurations
configurable string user = os:getEnv("USER");
configurable string apiToken = os:getEnv("API_TOKEN");
configurable string url = os:getEnv("URL");

CloudBasicAuth hostBasicAuth = {
    user: user,
    apiToken: apiToken
};

JiraBasicAuth basicAuth = {
    hostBasicAuth: hostBasicAuth,
    url: url
};

JiraConfig config = {
    basicAuth: basicAuth
};

Client cdataJiraClient = check new (config);

// Projects

@test:Config {
    enable: true
}
function getProjects() {
    stream<Projects, error> objectStreamResponse = cdataJiraClient->getProjects();
    error? e = objectStreamResponse.forEach(isolated function(Projects jobject) {
        io:println("Project details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getProjects],
    enable: true
}
function createProject() {
    Projects project = {
        Key: "EXE6",
        Name: "Inserted Project 3", 
        Description: "New business project",
        LeadAccountId: "60bd94c8d5dde800712d9772",
        LeadDisplayName: "admin", 
        ProjectTypeKey: "business"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createProject(project);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Project ID: ", createObjectResponse);
        projectId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createProject],
    enable: true
}
function getProjectById() {
    record {|Projects value;|}|error? getObjectResponse = cdataJiraClient->getProjectById(<int> projectId);
    if (getObjectResponse is record {|Projects value;|}) {
        io:println("Selected Project ID: ", getObjectResponse.value["Id"]);
        projectKey = <string> getObjectResponse.value["Key"];
    } else if (getObjectResponse is ()) {
        io:println("Project table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectById],
    enable: false
}
function updateProjectById() {
    Projects project = {
        Id: <int> projectId,
        Description: "Updated description",
        AssigneeType: "UNASSIGNED"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateProjectById(project);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Project ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectById],
    enable: true
}
function updateProjectByKey() {
    Projects project = {
        Key: "ROL",
        Description: "Updated description",
        AssigneeType: "PROJECT_LEAD"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateProjectByKey(project);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Project ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateProjectByKey],
    enable: false
}
function deleteProjectById() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectById(<int> projectId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

@test:Config {
    dependsOn: [updateProjectByKey],
    enable: true
}
function deleteProjectByKey() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectByKey(<string> projectKey);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Project Components

@test:Config {
    dependsOn: [deleteProjectByKey],
    enable: true
}
function createProject_PC() {
    Projects project = {
        Key: "EXE7",
        Name: "Inserted Project 4", 
        LeadAccountId: "60bd94c8d5dde800712d9772",
        LeadDisplayName: "admin", 
        ProjectTypeKey: "business",
        Description: "New business project"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createProject(project);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Project ID: ", createObjectResponse);
        projectId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createProject],
    enable: true
}
function createProjectComponent() {
    ProjectComponents projectComponent = {
        ProjectKey: "EXE7",
        Name: "Testing Component", 
        AssigneeType: "PROJECT_LEAD"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createProjectComponent(projectComponent);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Project Component ID: ", createObjectResponse);
        projectComponentId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createProjectComponent],
    enable: true
}
function getProjectComponents() {
    stream<ProjectComponents, error> objectStreamResponse = cdataJiraClient->getProjectComponents();
    error? e = objectStreamResponse.forEach(isolated function(ProjectComponents jobject) {
        io:println("Project Components details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getProjectComponents],
    enable: true
}
function getProjectComponentById() {
    record {|ProjectComponents value;|}|error? getObjectResponse = cdataJiraClient->getProjectComponentById(
        <int> projectComponentId);
    if (getObjectResponse is record {|ProjectComponents value;|}) {
        io:println("Selected Project Component ID: ", getObjectResponse.value["Id"]);
        projectId = <int> getObjectResponse.value["ProjectId"];
        projectKey = <string> getObjectResponse.value["ProjectKey"];
    } else if (getObjectResponse is ()) {
        io:println("Project Component table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectComponentById],
    enable: true
}
function getProjectComponentByProjectId() {
    record {|ProjectComponents value;|}|error? getObjectResponse = cdataJiraClient->getProjectComponentByProjectId(
        <int> projectId);
    if (getObjectResponse is record {|ProjectComponents value;|}) {
        io:println("Selected Project Component ID: ", getObjectResponse.value["Id"]);
        projectId = <int> getObjectResponse.value["ProjectId"];
        projectKey = <string> getObjectResponse.value["ProjectKey"];
    } else if (getObjectResponse is ()) {
        io:println("Project Component table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectComponentByProjectId],
    enable: true
}
function getProjectComponentByProjectKey() {
    record {|ProjectComponents value;|}|error? getObjectResponse = cdataJiraClient->getProjectComponentByProjectKey(
        <string> projectKey);
    if (getObjectResponse is record {|ProjectComponents value;|}) {
        io:println("Selected Project Component ID: ", getObjectResponse.value["Id"]);
        projectId = <int> getObjectResponse.value["ProjectId"];
        projectKey = <string> getObjectResponse.value["ProjectKey"];
    } else if (getObjectResponse is ()) {
        io:println("Project Component table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// TODO: 'accountId' must be the only user identifying query parameter in GDPR strict mode.
@test:Config {
    dependsOn: [getProjectComponentByProjectKey],
    enable: false
}
function updateProjectComponentById() { 
    ProjectComponents project = {
        LeadKey: "newlead"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateProjectComponentById(project);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Project Component ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectComponentByProjectKey],
    enable: true
}
function deleteProjectComponentById() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectComponentById(<int> projectComponentId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project Component ID: ", projectComponentId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

@test:Config {
    dependsOn: [deleteProjectComponentById],
    enable: true
}
function deleteProjectById_PC() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectById(<int> projectId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Project Versions

@test:Config {
    dependsOn: [deleteProjectById_PC],
    enable: true
}
function createProject_PV() {
    Projects project = {
        Key: "EXE8",
        Name: "Inserted Project 5", 
        LeadAccountId: "60bd94c8d5dde800712d9772",
        LeadDisplayName: "admin", 
        ProjectTypeKey: "business",
        Description: "New business project"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createProject(project);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Project ID: ", createObjectResponse);
        projectId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createProject_PV],
    enable: true
}
function createProjectVersion() {
    ProjectVersions projectVersion = {
        ProjectId: <int> projectId,
        Name: "HR Component", 
        Description: "Example version description",
        ReleaseDate: "2018-04-04",
        StartDate: "2018-02-02"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createProjectVersion(projectVersion);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Project Version ID: ", createObjectResponse);
        projectVersionId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createProjectVersion],
    enable: true
}
function getProjectVersions() {
    stream<ProjectVersions, error> objectStreamResponse = cdataJiraClient->getProjectVersions();
    error? e = objectStreamResponse.forEach(isolated function(ProjectVersions jobject) {
        io:println("Project Versions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getProjectVersions],
    enable: true
}
function getProjectVersionById() {
    record {|ProjectVersions value;|}|error? getObjectResponse = cdataJiraClient->getProjectVersionById(
        <int> projectVersionId);
    if (getObjectResponse is record {|ProjectVersions value;|}) {
        io:println("Selected Project Version ID: ", getObjectResponse.value["Id"]);
        projectId = <int> getObjectResponse.value["ProjectId"];
    } else if (getObjectResponse is ()) {
        io:println("Project Version table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectVersionById],
    enable: true
}
function getProjectVersionByProjectId() {
    record {|ProjectVersions value;|}|error? getObjectResponse = cdataJiraClient->getProjectVersionByProjectId(
        <int> projectId);
    if (getObjectResponse is record {|ProjectVersions value;|}) {
        io:println("Selected Project Version ID: ", getObjectResponse.value["Id"]);
        projectId = <int> getObjectResponse.value["ProjectId"];
    } else if (getObjectResponse is ()) {
        io:println("Project Version table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getProjectVersionByProjectId],
    enable: true
}
function updateProjectVersionById() { 
    ProjectVersions projectVersion = {
        Id: <int> projectVersionId,
        ReleaseDate: "2019-04-04"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateProjectVersionById(projectVersion);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Project Version ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateProjectVersionById],
    enable: true
}
function deleteProjectVersionById() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectVersionById(<int> projectVersionId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project Version ID: ", projectVersionId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

@test:Config {
    dependsOn: [deleteProjectVersionById],
    enable: true
}
function deleteProjectById_PV() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectById(<int> projectId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Issue Types

@test:Config {
    dependsOn: [deleteProjectById_PV],
    enable: true
}
function createIssueType() {
    IssueTypes issueType = {
        Name: "Issue type name 3", 
        Description: "test description",
        Subtask: false
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createIssueType(issueType);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Issue Type ID: ", createObjectResponse);
        issueTypeId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createIssueType],
    enable: true
}
function getIssueTypes() {
    stream<IssueTypes, error> objectStreamResponse = cdataJiraClient->getIssueTypes();
    error? e = objectStreamResponse.forEach(isolated function(IssueTypes jobject) {
        io:println("Issue Types details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getIssueTypes],
    enable: true
}
function getIssueTypeById() {
    record {|IssueTypes value;|}|error? getObjectResponse = cdataJiraClient->getIssueTypeById(
        <string> issueTypeId);
    if (getObjectResponse is record {|IssueTypes value;|}) {
        io:println("Selected Issue Type ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Issue Type table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getIssueTypeById],
    enable: true
}
function updateIssueTypeById() { 
    IssueTypes issueType = {
        Id: <string> issueTypeId,
        Name: "Updated Name 3",
        Description: "Updated description"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateIssueTypeById(issueType);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Issue Type ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateIssueTypeById],
    enable: true
}
function deleteIssueTypeById() {
    error? deleteAccountResponse = cdataJiraClient->deleteIssueTypeById(<string> issueTypeId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Issue Type ID: ", issueTypeId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Roles

@test:Config {
    dependsOn: [deleteIssueTypeById],
    enable: true
}
function getRoles() {
    stream<Roles, error> objectStreamResponse = cdataJiraClient->getRoles();
    error? e = objectStreamResponse.forEach(isolated function(Roles jobject) {
        io:println("Roles details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getRoles],
    enable: true
}
function getRoleById() {
    record {|Roles value;|}|error? getObjectResponse = cdataJiraClient->getRoleById(10002);
    if (getObjectResponse is record {|Roles value;|}) {
        io:println("Selected Role ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Role table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// Boards

@test:Config {
    dependsOn: [getRoleById],
    enable: true
}
function createProject_B() {
    Projects project = {
        Key: "EXE9",
        Name: "Inserted Project 6", 
        LeadAccountId: "60bd94c8d5dde800712d9772",
        LeadDisplayName: "admin", 
        ProjectTypeKey: "business",
        Description: "New business project"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createProject(project);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Project ID: ", createObjectResponse);
        projectId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    enable: false
}
function createBoard() {
    Boards board = {
        Name: "New board", 
        Type: "kanban",
        FilterId: "10001"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createBoard(board);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Board ID: ", createObjectResponse);
        boardId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createProject_B],
    enable: true
}
function getBoards() {
    stream<Boards, error> objectStreamResponse = cdataJiraClient->getBoards();
    error? e = objectStreamResponse.forEach(isolated function(Boards jobject) {
        io:println("Boards details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getBoards],
    enable: true
}
function getBoardById() {
    record {|Boards value;|}|error? getObjectResponse = cdataJiraClient->getBoardById(1);
    if (getObjectResponse is record {|Boards value;|}) {
        io:println("Selected Board ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("board table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getBoardById],
    enable: true
}
function getBoard() {
    record {|record{} value;|}|error? getObjectResponse = cdataJiraClient->getBoard("ROL");
    if (getObjectResponse is record {|record{} value;|}) {
        io:println("Selected Board ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("board table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getBoard],
    enable: true
}
function deleteProjectById_B() {
    error? deleteAccountResponse = cdataJiraClient->deleteProjectById(<int> projectId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Project ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Sprints

@test:Config {
    dependsOn: [deleteProjectById_B],
    enable: true
}
function createSprint() {
    Sprints sprint = {
        OriginBoardId: 1, 
        Name: "Inserted Sprint",
        Goal: "Complete target",
        StartDate: "2018-02-02",
        EndDate: "2018-04-04"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createSprint(sprint);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Sprint ID: ", createObjectResponse);
        sprintId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createSprint],
    enable: true
}
function getSprints() {
    stream<Sprints, error> objectStreamResponse = cdataJiraClient->getSprints();
    error? e = objectStreamResponse.forEach(isolated function(Sprints jobject) {
        io:println("Sprints details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getSprints],
    enable: true
}
function getSprintId() {
    record {|Sprints value;|}|error? getObjectResponse = cdataJiraClient->getSprintById(<int> sprintId);
    if (getObjectResponse is record {|Sprints value;|}) {
        io:println("Selected Sprint ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Sprint table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getSprintId],
    enable: true
}
function updateSprintById() { 
    Sprints sprint = {
        Id: <int> sprintId,
        State: "active"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateSprintById(sprint);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Sprint ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateSprintById],
    enable: true
}
function deleteSprintById() {
    error? deleteAccountResponse = cdataJiraClient->deleteSprintById(<int> sprintId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Sprint ID: ", sprintId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Issues

@test:Config {
    dependsOn: [deleteSprintById],
    enable: true
}
function createIssue() {
    Issues issue = {
        ProjectId: "10000", 
        Description: "My Description",
        Summary: "Desc from prod",
        IssueTypeId: "10001"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createIssue(issue);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Issue ID: ", createObjectResponse);
        issueId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createIssue],
    enable: true
}
function getIssues() {
    stream<Issues, error> objectStreamResponse = cdataJiraClient->getIssues();
    error? e = objectStreamResponse.forEach(isolated function(Issues jobject) {
        io:println("Issues details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getIssues],
    enable: true
}
function getIssueById() {
    record {|Issues value;|}|error? getObjectResponse = cdataJiraClient->getIssueById(<int> issueId);
    if (getObjectResponse is record {|Issues value;|}) {
        io:println("Selected Issue ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Issues table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getIssueById],
    enable: true
}
function updateIssueById() { 
    Issues issue = {
        Id: <int> issueId,
        Summary: "Updated Desc FROM prod"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateIssueById(issue);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Issue ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateIssueById],
    enable: true
}
function deleteIssueById() {
    error? deleteAccountResponse = cdataJiraClient->deleteIssueById(<int> issueId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Issue ID: ", issueId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

@test:Config {
    dependsOn: [deleteIssueById],
    enable: true
}
function getIssuesByJql() {
    string jqlQuery = "project = 'RolyProject1' AND Status = 'In Progress'";
    stream<Issues, error> objectStreamResponse = cdataJiraClient->getIssuesByJql(jqlQuery);
    error? e = objectStreamResponse.forEach(isolated function(Issues jobject) {
        io:println("Issues details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Comments

@test:Config {
    dependsOn: [getIssuesByJql],
    enable: true
}
function createComment() {
    Comments comment = {
        IssueId: 10004, 
        Body: "Test Comment"
    };
    (string|int)?|error createObjectResponse = cdataJiraClient->createComment(comment);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Comment ID: ", createObjectResponse);
        commentId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createComment],
    enable: true
}
function getComments() {
    stream<Comments, error> objectStreamResponse = cdataJiraClient->getComments();
    error? e = objectStreamResponse.forEach(isolated function(Comments jobject) {
        io:println("Comments details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getComments],
    enable: true
}
function getCommentsByIssueId() {
    stream<Comments, error> objectStreamResponse = cdataJiraClient->getCommentsByIssueId(10004);
    error? e = objectStreamResponse.forEach(isolated function(Comments jobject) {
        io:println("Comments details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getCommentsByIssueId],
    enable: true
}
function updateCommentsById() { 
    Comments comment = {
        Id: <int> commentId,
        IssueId: 10004,
        Body: "Updated Comment"
    };
    (string|int)?|error updateRecordResponse = cdataJiraClient->updateCommentByIssueId(comment);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Comment ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateCommentsById],
    enable: true
}
function deleteCommentByIssueId() {
    error? deleteAccountResponse = cdataJiraClient->deleteCommentByIssueId(<int> commentId, 10004);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Comment ID: ", commentId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Users

@test:Config {
    dependsOn: [deleteCommentByIssueId],
    enable: true
}
function getUsers() {
    stream<Users, error> objectStreamResponse = cdataJiraClient->getUsers();
    error? e = objectStreamResponse.forEach(isolated function(Users jobject) {
        io:println("Users details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getUsers],
    enable: true
}
function getUsersOfAllGroups() {
    stream<Users, error> objectStreamResponse = cdataJiraClient->getUsersOfAllGroups();
    error? e = objectStreamResponse.forEach(isolated function(Users jobject) {
        io:println("Users details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getUsersOfAllGroups],
    enable: true
}
function getUsersOfGroup() {
    stream<Users, error> objectStreamResponse = cdataJiraClient->getUsersOfGroup("administrators");
    error? e = objectStreamResponse.forEach(isolated function(Users jobject) {
        io:println("Users details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Attachments

@test:Config {
    enable: false
}
function uploadAttachmentToIssueByFilePath() {
    (string|int)?|error createObjectResponse = cdataJiraClient->uploadAttachmentToIssueByFilePath(
        "/home/roland/Documents/Notes/test25.txt", "ROL-23");
    if (createObjectResponse is (string|int)?) {
        io:println("Uploaded Attachment ID: ", createObjectResponse);
        attachmentId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getUsersOfGroup],
    enable: true
}
function uploadAttachmentToIssueByEncodedContent() {
    (string|int)?|error createObjectResponse = cdataJiraClient->uploadAttachmentToIssueByEncodedContent(
        "U29tZSBjb250ZW50IGhlcmU=", "Uploaded File", "ROL-23");
    if (createObjectResponse is (string|int)?) {
        io:println("Uploaded Attachment ID: ", createObjectResponse);
        attachmentId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [uploadAttachmentToIssueByEncodedContent],
    enable: true
}
function getAttachments() {
    stream<Attachments, error> objectStreamResponse = cdataJiraClient->getAttachments();
    error? e = objectStreamResponse.forEach(isolated function(Attachments jobject) {
        io:println("Attachments details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getAttachments],
    enable: true
}
function getAttachmentById() {
    record {|Attachments value;|}|error? getObjectResponse = cdataJiraClient->getAttachmentById(<int> attachmentId);
    if (getObjectResponse is record {|Attachments value;|}) {
        io:println("Selected Attachment ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Attachments table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getAttachmentById],
    enable: true
}
function getAttachmentsByIssueId() {
    stream<Attachments, error> objectStreamResponse = cdataJiraClient->getAttachmentsByIssueId(10022);
    error? e = objectStreamResponse.forEach(isolated function(Attachments jobject) {
        io:println("Attachments details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getAttachmentsByIssueId],
    enable: true
}
function getAttachmentsByJql() {
    string jqlQuery = "created > 2018-01-07";
    stream<Attachments, error> objectStreamResponse = cdataJiraClient->getAttachmentsByJql(jqlQuery);
    error? e = objectStreamResponse.forEach(isolated function(Attachments jobject) {
        io:println("Attachments details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getAttachmentsByJql],
    enable: true
}
function deleteAttachmentById() {
    error? deleteAccountResponse = cdataJiraClient->deleteAttachmentById(<int> attachmentId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Attachment ID: ", attachmentId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

//// Views

// AdvancedSettings

@test:Config {
    dependsOn: [deleteAttachmentById],
    enable: true
}
function getAdvancedSettings() {
    stream<AdvancedSettings, error> objectStreamResponse = cdataJiraClient->getAdvancedSettings();
    error? e = objectStreamResponse.forEach(isolated function(AdvancedSettings jobject) {
        io:println("AdvancedSettings details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// ApplicationRoles

@test:Config {
    dependsOn: [getAdvancedSettings],
    enable: true
}
function getApplicationRoles() {
    stream<ApplicationRoles, error> objectStreamResponse = cdataJiraClient->getApplicationRoles();
    error? e = objectStreamResponse.forEach(isolated function(ApplicationRoles jobject) {
        io:println("ApplicationRoles details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Audit

@test:Config {
    enable: false
}
function getAudit() {
    stream<Audit, error> objectStreamResponse = cdataJiraClient->getAudit("up");
    error? e = objectStreamResponse.forEach(isolated function(Audit jobject) {
        io:println("Audit details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// BoardIssues

@test:Config {
    dependsOn: [getApplicationRoles],
    enable: true
}
function getBoardIssues() {
    stream<BoardIssues, error> objectStreamResponse = cdataJiraClient->getBoardIssues(1);
    error? e = objectStreamResponse.forEach(isolated function(BoardIssues jobject) {
        io:println("BoardIssues details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// BoardSprints

@test:Config {
    dependsOn: [getBoardIssues],
    enable: true
}
function getBoardSprints() {
    stream<BoardSprints, error> objectStreamResponse = cdataJiraClient->getBoardSprints(1);
    error? e = objectStreamResponse.forEach(isolated function(BoardSprints jobject) {
        io:println("BoardSprints details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getBoardSprints],
    enable: true
}
function getSprintsOfAllBoards() {
    stream<BoardSprints, error> objectStreamResponse = cdataJiraClient->getSprintsOfAllBoards();
    error? e = objectStreamResponse.forEach(isolated function(BoardSprints jobject) {
        io:println("BoardSprints details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Configuration

@test:Config {
    dependsOn: [getSprintsOfAllBoards],
    enable: true
}
function getConfiguration() {
    stream<Configuration, error> objectStreamResponse = cdataJiraClient->getConfiguration();
    error? e = objectStreamResponse.forEach(isolated function(Configuration jobject) {
        io:println("Configuration details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Dashboards

@test:Config {
    dependsOn: [getConfiguration],
    enable: true
}
function getDashboards() {
    stream<Dashboards, error> objectStreamResponse = cdataJiraClient->getDashboards();
    error? e = objectStreamResponse.forEach(isolated function(Dashboards jobject) {
        io:println("Dashboards details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getDashboards],
    enable: true
}
function getDashboardsByFilter() {
    stream<Dashboards, error> objectStreamResponse = cdataJiraClient->getDashboardsByFilter("favourite");
    error? e = objectStreamResponse.forEach(isolated function(Dashboards jobject) {
        io:println("Dashboards details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getDashboardsByFilter],
    enable: true
}
function getDashboardById() {
    record {|Dashboards value;|}|error? getObjectResponse = cdataJiraClient->getDashboardById("10000");
    if (getObjectResponse is record {|Dashboards value;|}) {
        io:println("Selected Dashboard ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Dashboards table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// Epics

@test:Config {
    dependsOn: [getDashboardById],
    enable: true
}
function getEpics() {
    stream<Epics, error> objectStreamResponse = cdataJiraClient->getEpics();
    error? e = objectStreamResponse.forEach(isolated function(Epics jobject) {
        io:println("Epics details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getEpics],
    enable: true
}
function getEpicsOfBoard() {
    stream<Epics, error> objectStreamResponse = cdataJiraClient->getEpicsOfBoard(1);
    error? e = objectStreamResponse.forEach(isolated function(Epics jobject) {
        io:println("Epics details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    enable: false
}
function getEpicById() {
    record {|Epics value;|}|error? getObjectResponse = cdataJiraClient->getEpicById(10001);
    if (getObjectResponse is record {|Epics value;|}) {
        io:println("Selected Epic ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Epics table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    enable: false
}
function getEpicByKey() {
    record {|Epics value;|}|error? getObjectResponse = cdataJiraClient->getEpicByKey("ROL-2");
    if (getObjectResponse is record {|Epics value;|}) {
        io:println("Selected Epic ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Epics table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// FavouriteFilters

@test:Config {
    dependsOn: [getEpicsOfBoard],
    enable: true
}
function getFavouriteFilters() {
    stream<FavouriteFilters, error> objectStreamResponse = cdataJiraClient->getFavouriteFilters();
    error? e = objectStreamResponse.forEach(isolated function(FavouriteFilters jobject) {
        io:println("FavouriteFilters details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// FavouriteFilters

@test:Config {
    dependsOn: [getFavouriteFilters],
    enable: true
}
function getFields() {
    stream<Fields, error> objectStreamResponse = cdataJiraClient->getFields();
    error? e = objectStreamResponse.forEach(isolated function(Fields jobject) {
        io:println("Fields details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Filters

@test:Config {
    dependsOn: [getFields],
    enable: true
}
function getFilters() {
    stream<Filters, error> objectStreamResponse = cdataJiraClient->getFilters();
    error? e = objectStreamResponse.forEach(isolated function(Filters jobject) {
        io:println("Filters details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getFilters],
    enable: true
}
function getFilterById() {
    record {|Filters value;|}|error? getObjectResponse = cdataJiraClient->getFilterById("10001");
    if (getObjectResponse is record {|Filters value;|}) {
        io:println("Selected Filter ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Filters table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// Groups

@test:Config {
    enable: true
}
function getGroups() {
    stream<Groups, error> objectStreamResponse = cdataJiraClient->getGroups();
    error? e = objectStreamResponse.forEach(isolated function(Groups jobject) {
        io:println("Groups details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueAffectedVersions

@test:Config {
    dependsOn: [getGroups],
    enable: true
}
function getIssueAffectedVersions() {
    stream<IssueAffectedVersions, error> objectStreamResponse = cdataJiraClient->getIssueAffectedVersions();
    error? e = objectStreamResponse.forEach(isolated function(IssueAffectedVersions jobject) {
        io:println("IssueAffectedVersions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueChangelogs

@test:Config {
    dependsOn: [getIssueAffectedVersions],
    enable: true
}
function getIssueChangelogs() {
    stream<IssueChangelogs, error> objectStreamResponse = cdataJiraClient->getIssueChangelogs();
    error? e = objectStreamResponse.forEach(isolated function(IssueChangelogs jobject) {
        io:println("IssueChangelogs details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueComponents

@test:Config {
    dependsOn: [getIssueChangelogs],
    enable: true
}
function getIssueComponents() {
    stream<IssueComponents, error> objectStreamResponse = cdataJiraClient->getIssueComponents();
    error? e = objectStreamResponse.forEach(isolated function(IssueComponents jobject) {
        io:println("IssueComponents details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueCustomFieldOptions

@test:Config {
    dependsOn: [getIssueComponents],
    enable: true
}
function getIssueCustomFieldOptions() {
    stream<IssueCustomFieldOptions, error> objectStreamResponse = 
        cdataJiraClient->getIssueCustomFieldOptions(10020);
    error? e = objectStreamResponse.forEach(isolated function(IssueCustomFieldOptions jobject) {
        io:println("IssueCustomFieldOptions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueCustomFields

@test:Config {
    dependsOn: [getIssueCustomFieldOptions],
    enable: true
}
function getIssueCustomFields() {
    stream<IssueCustomFields, error> objectStreamResponse = cdataJiraClient->getIssueCustomFields();
    error? e = objectStreamResponse.forEach(isolated function(IssueCustomFields jobject) {
        io:println("IssueCustomFields details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueFixVersions

@test:Config {
    dependsOn: [getIssueCustomFields],
    enable: true
}
function getIssueFixVersions() {
    stream<IssueFixVersions, error> objectStreamResponse = cdataJiraClient->getIssueFixVersions();
    error? e = objectStreamResponse.forEach(isolated function(IssueFixVersions jobject) {
        io:println("IssueFixVersions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueLinks

@test:Config {
    dependsOn: [getIssueCustomFields],
    enable: true
}
function getIssueLinks() {
    stream<IssueLinks, error> objectStreamResponse = cdataJiraClient->getIssueLinks();
    error? e = objectStreamResponse.forEach(isolated function(IssueLinks jobject) {
        io:println("IssueLinks details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueLinkTypes

@test:Config {
    dependsOn: [getIssueLinks],
    enable: true
}
function getIssueLinkTypes() {
    stream<IssueLinkTypes, error> objectStreamResponse = cdataJiraClient->getIssueLinkTypes();
    error? e = objectStreamResponse.forEach(isolated function(IssueLinkTypes jobject) {
        io:println("IssueLinkTypes details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getIssueLinkTypes],
    enable: true
}
function getIssueLinkTypesById() {
    record {|IssueLinkTypes value;|}|error? getObjectResponse = cdataJiraClient->getIssueLinkTypesById("10000");
    if (getObjectResponse is record {|IssueLinkTypes value;|}) {
        io:println("Selected IssueLinkType ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("IssueLinkTypes table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// IssueNavigatorDefaultColumns

@test:Config {
    dependsOn: [getIssueLinkTypesById],
    enable: true
}
function getIssueNavigatorDefaultColumns() {
    stream<IssueNavigatorDefaultColumns, error> objectStreamResponse = 
        cdataJiraClient->getIssueNavigatorDefaultColumns();
    error? e = objectStreamResponse.forEach(isolated function(IssueNavigatorDefaultColumns jobject) {
        io:println("IssueNavigatorDefaultColumns details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssuePriorities

@test:Config {
    dependsOn: [getIssueNavigatorDefaultColumns],
    enable: true
}
function getIssuePriorities() {
    stream<IssuePriorities, error> objectStreamResponse = cdataJiraClient->getIssuePriorities();
    error? e = objectStreamResponse.forEach(isolated function(IssuePriorities jobject) {
        io:println("IssuePriorities details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getIssuePriorities],
    enable: true
}
function getIssuePriorityById() {
    record {|IssuePriorities value;|}|error? getObjectResponse = cdataJiraClient->getIssuePriorityById("1");
    if (getObjectResponse is record {|IssuePriorities value;|}) {
        io:println("Selected IssuePriority ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("IssuePriorities table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// IssueResolutions

@test:Config {
    dependsOn: [getIssuePriorityById],
    enable: true
}
function getIssueResolutions() {
    stream<IssueResolutions, error> objectStreamResponse = cdataJiraClient->getIssueResolutions();
    error? e = objectStreamResponse.forEach(isolated function(IssueResolutions jobject) {
        io:println("IssueResolutions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getIssueResolutions],
    enable: true
}
function getIssueResolutionById() {
    record {|IssueResolutions value;|}|error? getObjectResponse = cdataJiraClient->getIssueResolutionById("10000");
    if (getObjectResponse is record {|IssueResolutions value;|}) {
        io:println("Selected IssueResolution ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("IssueResolutions table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// IssueSubtasks

@test:Config {
    dependsOn: [getIssueResolutionById],
    enable: true
}
function getIssueSubtasks() {
    stream<IssueSubtasks, error> objectStreamResponse = cdataJiraClient->getIssueSubtasks();
    error? e = objectStreamResponse.forEach(isolated function(IssueSubtasks jobject) {
        io:println("IssueSubtasks details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getIssueSubtasks],
    enable: true
}
function getIssueSubtasksByIssueId() {
    stream<IssueSubtasks, error> objectStreamResponse = cdataJiraClient->getIssueSubtasksByIssueId(10109);
    error? e = objectStreamResponse.forEach(isolated function(IssueSubtasks jobject) {
        io:println("IssueSubtasks details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// IssueTransitions

@test:Config {
    dependsOn: [getIssueSubtasksByIssueId],
    enable: true
}
function getIssueTransitions() {
    stream<IssueTransitions, error> objectStreamResponse = cdataJiraClient->getIssueTransitions();
    error? e = objectStreamResponse.forEach(isolated function(IssueTransitions jobject) {
        io:println("IssueTransitions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// MyPermissions

@test:Config {
    enable: false
}
function getMyPermissions() {
    stream<MyPermissions, error> objectStreamResponse = cdataJiraClient->getMyPermissions();
    error? e = objectStreamResponse.forEach(isolated function(MyPermissions jobject) {
        io:println("MyPermissions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Permissions

@test:Config {
    dependsOn: [getIssueTransitions],
    enable: true
}
function getPermissions() {
    stream<Permissions, error> objectStreamResponse = cdataJiraClient->getPermissions();
    error? e = objectStreamResponse.forEach(isolated function(Permissions jobject) {
        io:println("Permissions details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// ProjectCategories

@test:Config {
    dependsOn: [getPermissions],
    enable: true
}
function getProjectCategories() {
    stream<ProjectCategories, error> objectStreamResponse = cdataJiraClient->getProjectCategories();
    error? e = objectStreamResponse.forEach(isolated function(ProjectCategories jobject) {
        io:println("ProjectCategories details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// ProjectRoles

@test:Config {
    dependsOn: [getProjectCategories],
    enable: true
}
function getProjectRoles() {
    stream<ProjectRoles, error> objectStreamResponse = cdataJiraClient->getProjectRoles();
    error? e = objectStreamResponse.forEach(isolated function(ProjectRoles jobject) {
        io:println("ProjectRoles details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getProjectRoles],
    enable: true
}
function getProjectRolesByProjectId() {
    stream<ProjectRoles, error> objectStreamResponse = cdataJiraClient->getProjectRolesByProjectId(10000);
    error? e = objectStreamResponse.forEach(isolated function(ProjectRoles jobject) {
        io:println("ProjectRoles details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// ProjectsIssueTypes

@test:Config {
    dependsOn: [getProjectRolesByProjectId],
    enable: true
}
function getProjectsIssueTypes() {
    stream<ProjectsIssueTypes, error> objectStreamResponse = cdataJiraClient->getProjectsIssueTypes();
    error? e = objectStreamResponse.forEach(isolated function(ProjectsIssueTypes jobject) {
        io:println("ProjectsIssueTypes details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// ProjectTypes

@test:Config {
    dependsOn: [getProjectsIssueTypes],
    enable: true
}
function getProjectTypes() {
    stream<ProjectTypes, error> objectStreamResponse = cdataJiraClient->getProjectTypes();
    error? e = objectStreamResponse.forEach(isolated function(ProjectTypes jobject) {
        io:println("ProjectTypes details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getProjectTypes],
    enable: true
}
function getProjectTypesByKey() {
    record {|ProjectTypes value;|}|error? getObjectResponse = cdataJiraClient->getProjectTypesByKey("software");
    if (getObjectResponse is record {|ProjectTypes value;|}) {
        io:println("Selected ProjectType Key: ", getObjectResponse.value["Key"]);
    } else if (getObjectResponse is ()) {
        io:println("ProjectTypes table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

// RoleDetails

@test:Config {
    enable: false
}
function getRoleDetails() {
    stream<RoleDetails, error> objectStreamResponse = cdataJiraClient->getRoleDetails();
    error? e = objectStreamResponse.forEach(isolated function(RoleDetails jobject) {
        io:println("RoleDetails details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// SecurityLevels

@test:Config {
    dependsOn: [getProjectTypesByKey],
    enable: true
}
function getSecurityLevels() {
    stream<SecurityLevels, error> objectStreamResponse = cdataJiraClient->getSecurityLevels();
    error? e = objectStreamResponse.forEach(isolated function(SecurityLevels jobject) {
        io:println("SecurityLevels details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// SecuritySchemes

@test:Config {
    dependsOn: [getSecurityLevels],
    enable: true
}
function getSecuritySchemes() {
    stream<SecuritySchemes, error> objectStreamResponse = cdataJiraClient->getSecuritySchemes();
    error? e = objectStreamResponse.forEach(isolated function(SecuritySchemes jobject) {
        io:println("SecuritySchemes details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// SprintIssues

@test:Config {
    dependsOn: [getSecuritySchemes],
    enable: true
}
function getSprintIssues() {
    stream<SprintIssues, error> objectStreamResponse = cdataJiraClient->getSprintIssues();
    error? e = objectStreamResponse.forEach(isolated function(SprintIssues jobject) {
        io:println("SprintIssues details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Statuses

@test:Config {
    dependsOn: [getSprintIssues],
    enable: true
}
function getStatuses() {
    stream<Statuses, error> objectStreamResponse = cdataJiraClient->getStatuses();
    error? e = objectStreamResponse.forEach(isolated function(Statuses jobject) {
        io:println("Statuses details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// TimeTrackingProviders

@test:Config {
    dependsOn: [getStatuses],
    enable: true
}
function getTimeTrackingProviders() {
    stream<TimeTrackingProviders, error> objectStreamResponse = cdataJiraClient->getTimeTrackingProviders();
    error? e = objectStreamResponse.forEach(isolated function(TimeTrackingProviders jobject) {
        io:println("TimeTrackingProviders details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Votes

@test:Config {
    dependsOn: [getTimeTrackingProviders],
    enable: true
}
function getVotes() {
    stream<Votes, error> objectStreamResponse = cdataJiraClient->getVotesByIssueKey("ROL-110");
    error? e = objectStreamResponse.forEach(isolated function(Votes jobject) {
        io:println("Votes details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Watchers

@test:Config {
    dependsOn: [getVotes],
    enable: true
}
function getWatchers() {
    stream<Watchers, error> objectStreamResponse = cdataJiraClient->getWatchersByIssueKey("ROL-110");
    error? e = objectStreamResponse.forEach(isolated function(Watchers jobject) {
        io:println("Watchers details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// Workflows

@test:Config {
    dependsOn: [getWatchers],
    enable: true
}
function getWorkflows() {
    stream<Workflows, error> objectStreamResponse = cdataJiraClient->getWorkflows();
    error? e = objectStreamResponse.forEach(isolated function(Workflows jobject) {
        io:println("Workflows details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// WorkflowStatusCategories

@test:Config {
    dependsOn: [getWorkflows],
    enable: true
}
function getWorkflowStatusCategories() {
    stream<WorkflowStatusCategories, error> objectStreamResponse = cdataJiraClient->getWorkflowStatusCategories();
    error? e = objectStreamResponse.forEach(isolated function(WorkflowStatusCategories jobject) {
        io:println("WorkflowStatusCategories details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

// WorkflowStatuses

@test:Config {
    dependsOn: [getWorkflowStatusCategories],
    enable: true
}
function getWorkflowStatuses() {
    stream<WorkflowStatuses, error> objectStreamResponse = cdataJiraClient->getWorkflowStatuses();
    error? e = objectStreamResponse.forEach(isolated function(WorkflowStatuses jobject) {
        io:println("WorkflowStatuses details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

//// Stored Procedures

// UploadAttachment

@test:Config {
    enable: true
}
function uploadAttachment() {
    UploadAttachmentResponse|error? objectResponse = 
        cdataJiraClient->uploadAttachment("/home/roland/Documents/Notes/test25.txt", issueKey = "ROL-113", 
        fileName = "MyNote");
    if (objectResponse is UploadAttachmentResponse) {
        io:println("UploadAttachmentResponse details: ", objectResponse);
    } else if (objectResponse is ()) {
        io:println("Empty response");
    } else {
        test:assertFail(objectResponse.message());
    } 
}

// DownloadAttachment

@test:Config {
    dependsOn: [uploadAttachment],
    enable: true
}
function downloadAttachment() {
    DownloadAttachmentResponse|error? objectResponse = 
        cdataJiraClient->downloadAttachment("10088", "/home/roland/Documents/Notes1/", "MyDownloadedNote", true);
    if (objectResponse is DownloadAttachmentResponse) {
        io:println("DownloadAttachmentResponse details: ", objectResponse);
    } else if (objectResponse is ()) {
        io:println("Empty response");
    } else {
        test:assertFail(objectResponse.message());
    } 
}

// GetTimeTrackingSettings

@test:Config {
    dependsOn: [downloadAttachment],
    enable: true
}
function getTimeTrackingSettings() {
    TimeTrackingSettings|error? objectResponse = cdataJiraClient->getTimeTrackingSettings();
    if (objectResponse is TimeTrackingSettings) {
        io:println("TimeTrackingSettings details: ", objectResponse);
    } else if (objectResponse is ()) {
        io:println("Empty response");
    } else {
        test:assertFail(objectResponse.message());
    } 
}

@test:AfterSuite { }
function afterSuite() {
    io:println("Close the connection to Jira using CData Connector");
    error? closeResponse = cdataJiraClient->close();
    if (closeResponse is sql:Error) {
        test:assertFail(closeResponse.message());
    }
}
