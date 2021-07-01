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
function getIssueById() {
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
    dependsOn: [getIssueById],
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

// ApplicationRoles

@test:Config {
    dependsOn: [getAdvancedSettings],
    enable: true
}
function getApplicationRoles() {
    stream<ApplicationRoles, error> objectStreamResponse = cdataConnectorToJira->getApplicationRoles();
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
    stream<Audit, error> objectStreamResponse = cdataConnectorToJira->getAudit("up");
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
    stream<BoardIssues, error> objectStreamResponse = cdataConnectorToJira->getBoardIssues(1);
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
    stream<BoardSprints, error> objectStreamResponse = cdataConnectorToJira->getBoardSprints(1);
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
    stream<BoardSprints, error> objectStreamResponse = cdataConnectorToJira->getSprintsOfAllBoards();
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
    stream<Configuration, error> objectStreamResponse = cdataConnectorToJira->getConfiguration();
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
    stream<Dashboards, error> objectStreamResponse = cdataConnectorToJira->getDashboards();
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
    stream<Dashboards, error> objectStreamResponse = cdataConnectorToJira->getDashboardsByFilter("favourite");
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
    record {|Dashboards value;|}|error? getObjectResponse = cdataConnectorToJira->getDashboardById("10000");
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
    stream<Epics, error> objectStreamResponse = cdataConnectorToJira->getEpics();
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
    stream<Epics, error> objectStreamResponse = cdataConnectorToJira->getEpicsOfBoard(1);
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
    record {|Epics value;|}|error? getObjectResponse = cdataConnectorToJira->getEpicById(10001);
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
    record {|Epics value;|}|error? getObjectResponse = cdataConnectorToJira->getEpicByKey("ROL-2");
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
    stream<FavouriteFilters, error> objectStreamResponse = cdataConnectorToJira->getFavouriteFilters();
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
    stream<Fields, error> objectStreamResponse = cdataConnectorToJira->getFields();
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
    stream<Filters, error> objectStreamResponse = cdataConnectorToJira->getFilters();
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
    record {|Filters value;|}|error? getObjectResponse = cdataConnectorToJira->getFilterById("10001");
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
    stream<Groups, error> objectStreamResponse = cdataConnectorToJira->getGroups();
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
    stream<IssueAffectedVersions, error> objectStreamResponse = cdataConnectorToJira->getIssueAffectedVersions();
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
    stream<IssueChangelogs, error> objectStreamResponse = cdataConnectorToJira->getIssueChangelogs();
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
    stream<IssueComponents, error> objectStreamResponse = cdataConnectorToJira->getIssueComponents();
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
        cdataConnectorToJira->getIssueCustomFieldOptions(10020);
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
    stream<IssueCustomFields, error> objectStreamResponse = cdataConnectorToJira->getIssueCustomFields();
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
    stream<IssueFixVersions, error> objectStreamResponse = cdataConnectorToJira->getIssueFixVersions();
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
    stream<IssueLinks, error> objectStreamResponse = cdataConnectorToJira->getIssueLinks();
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
    stream<IssueLinkTypes, error> objectStreamResponse = cdataConnectorToJira->getIssueLinkTypes();
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
    record {|IssueLinkTypes value;|}|error? getObjectResponse = cdataConnectorToJira->getIssueLinkTypesById("10000");
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
        cdataConnectorToJira->getIssueNavigatorDefaultColumns();
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
    stream<IssuePriorities, error> objectStreamResponse = cdataConnectorToJira->getIssuePriorities();
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
    record {|IssuePriorities value;|}|error? getObjectResponse = cdataConnectorToJira->getIssuePriorityById("1");
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
    stream<IssueResolutions, error> objectStreamResponse = cdataConnectorToJira->getIssueResolutions();
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
    record {|IssueResolutions value;|}|error? getObjectResponse = cdataConnectorToJira->getIssueResolutionById("10000");
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
    stream<IssueSubtasks, error> objectStreamResponse = cdataConnectorToJira->getIssueSubtasks();
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
    stream<IssueSubtasks, error> objectStreamResponse = cdataConnectorToJira->getIssueSubtasksByIssueId(10109);
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
    stream<IssueTransitions, error> objectStreamResponse = cdataConnectorToJira->getIssueTransitions();
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
    stream<MyPermissions, error> objectStreamResponse = cdataConnectorToJira->getMyPermissions();
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
    stream<Permissions, error> objectStreamResponse = cdataConnectorToJira->getPermissions();
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
    stream<ProjectCategories, error> objectStreamResponse = cdataConnectorToJira->getProjectCategories();
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
    stream<ProjectRoles, error> objectStreamResponse = cdataConnectorToJira->getProjectRoles();
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
    stream<ProjectRoles, error> objectStreamResponse = cdataConnectorToJira->getProjectRolesByProjectId(10000);
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
    stream<ProjectsIssueTypes, error> objectStreamResponse = cdataConnectorToJira->getProjectsIssueTypes();
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
    stream<ProjectTypes, error> objectStreamResponse = cdataConnectorToJira->getProjectTypes();
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
    record {|ProjectTypes value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectTypesByKey("software");
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
    stream<RoleDetails, error> objectStreamResponse = cdataConnectorToJira->getRoleDetails();
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
    stream<SecurityLevels, error> objectStreamResponse = cdataConnectorToJira->getSecurityLevels();
    error? e = objectStreamResponse.forEach(isolated function(SecurityLevels jobject) {
        io:println("SecurityLevels details: ", jobject);
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
