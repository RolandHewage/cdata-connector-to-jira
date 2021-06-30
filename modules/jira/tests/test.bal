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

Client cdataConnectorToJira = check new (config);

// Projects

@test:Config {
    enable: true
}
function getProjects() {
    stream<Projects, error> objectStreamResponse = cdataConnectorToJira->getProjects();
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createProject(project);
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
    record {|Projects value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectById(<int> projectId);
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectById(project);
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectByKey(project);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectById(<int> projectId);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectByKey(<string> projectKey);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createProject(project);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createProjectComponent(projectComponent);
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
    stream<ProjectComponents, error> objectStreamResponse = cdataConnectorToJira->getProjectComponents();
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
    record {|ProjectComponents value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectComponentById(
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
    record {|ProjectComponents value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectComponentByProjectId(
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
    record {|ProjectComponents value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectComponentByProjectKey(
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectComponentById(project);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectComponentById(<int> projectComponentId);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectById(<int> projectId);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createProject(project);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createProjectVersion(projectVersion);
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
    stream<ProjectVersions, error> objectStreamResponse = cdataConnectorToJira->getProjectVersions();
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
    record {|ProjectVersions value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectVersionById(
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
    record {|ProjectVersions value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectVersionByProjectId(
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectVersionById(projectVersion);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectVersionById(<int> projectVersionId);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectById(<int> projectId);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createIssueType(issueType);
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
    stream<IssueTypes, error> objectStreamResponse = cdataConnectorToJira->getIssueTypes();
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
    record {|IssueTypes value;|}|error? getObjectResponse = cdataConnectorToJira->getIssueTypeById(
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateIssueTypeById(issueType);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteIssueTypeById(<string> issueTypeId);
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
    stream<Roles, error> objectStreamResponse = cdataConnectorToJira->getRoles();
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
    record {|Roles value;|}|error? getObjectResponse = cdataConnectorToJira->getRoleById(10002);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createProject(project);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createBoard(board);
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
    stream<Boards, error> objectStreamResponse = cdataConnectorToJira->getBoards();
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
    record {|Boards value;|}|error? getObjectResponse = cdataConnectorToJira->getBoardById(1);
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
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getBoard("ROL");
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteProjectById(<int> projectId);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createSprint(sprint);
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
    stream<Sprints, error> objectStreamResponse = cdataConnectorToJira->getSprints();
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
    record {|Sprints value;|}|error? getObjectResponse = cdataConnectorToJira->getSprintById(<int> sprintId);
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateSprintById(sprint);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteSprintById(<int> sprintId);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createIssue(issue);
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
    stream<Issues, error> objectStreamResponse = cdataConnectorToJira->getIssues();
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
function getIssueId() {
    record {|Issues value;|}|error? getObjectResponse = cdataConnectorToJira->getIssueById(<int> issueId);
    if (getObjectResponse is record {|Issues value;|}) {
        io:println("Selected Issue ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Issues table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getIssueId],
    enable: true
}
function updateIssueById() { 
    Issues issue = {
        Id: <int> issueId,
        Summary: "Updated Desc FROM prod"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateIssueById(issue);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteIssueById(<int> issueId);
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
    stream<Issues, error> objectStreamResponse = cdataConnectorToJira->getIssuesByJql(jqlQuery);
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createComment(comment);
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
    stream<Comments, error> objectStreamResponse = cdataConnectorToJira->getComments();
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
    stream<Comments, error> objectStreamResponse = cdataConnectorToJira->getCommentsByIssueId(10004);
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
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateCommentByIssueId(comment);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteCommentByIssueId(<int> commentId, 10004);
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
    stream<Users, error> objectStreamResponse = cdataConnectorToJira->getUsers();
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
    stream<Users, error> objectStreamResponse = cdataConnectorToJira->getUsersOfAllGroups();
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
    stream<Users, error> objectStreamResponse = cdataConnectorToJira->getUsersOfGroup("administrators");
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->uploadAttachmentToIssueByFilePath(
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
    (string|int)?|error createObjectResponse = cdataConnectorToJira->uploadAttachmentToIssueByEncodedContent(
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
    stream<Attachments, error> objectStreamResponse = cdataConnectorToJira->getAttachments();
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
    record {|Attachments value;|}|error? getObjectResponse = cdataConnectorToJira->getAttachmentById(<int> attachmentId);
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
    stream<Attachments, error> objectStreamResponse = cdataConnectorToJira->getAttachmentsByIssueId(10022);
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
    stream<Attachments, error> objectStreamResponse = cdataConnectorToJira->getAttachmentsByJql(jqlQuery);
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
    error? deleteAccountResponse = cdataConnectorToJira->deleteAttachmentById(<int> attachmentId);
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
    stream<AdvancedSettings, error> objectStreamResponse = cdataConnectorToJira->getAdvancedSettings();
    error? e = objectStreamResponse.forEach(isolated function(AdvancedSettings jobject) {
        io:println("AdvancedSettings details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:AfterSuite { }
function afterSuite() {
    io:println("Close the connection to Jira using CData Connector");
    error? closeResponse = cdataConnectorToJira->close();
    if (closeResponse is sql:Error) {
        test:assertFail(closeResponse.message());
    }
}
