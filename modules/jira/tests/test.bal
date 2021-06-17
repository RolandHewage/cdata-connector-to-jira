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
import cdata as cdata;

(string|int)? projectId = ();
(string|int)? projectKey = ();
(string|int)? projectComponentId = ();
(string|int)? projectVersionId = ();
(string|int)? issueTypeId = ();
string objectName = "Projects";

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

// Generic Objects

@test:Config {
    enable: true
}
function getObjects() {
    stream<record{}, error> objectStreamResponse = cdataConnectorToJira->getObjects(objectName);
    error? e = objectStreamResponse.forEach(isolated function(record{} jobject) {
        io:println("Object details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getObjects],
    enable: true
}
function createObject() {
    map<anydata> project = {
        Key: "EXE4",
        Name: "Inserted Project 1", 
        LeadAccountId: "60bd94c8d5dde800712d9772",
        LeadDisplayName: "admin", 
        ProjectTypeKey: "business",
        Description: "New business project"
    };
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createObject(objectName, project);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Object ID: ", createObjectResponse);
        projectId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createObject],
    enable: true
}
function getObject() {
    string Id = "Id";
    string Name = "Name";
    string Key = "Key";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getObject(objectName, 
        <int> projectId, Id, Name, Key);
    if (getObjectResponse is record {|record{} value;|}) {
        io:println("Selected Object ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Object table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getObject],
    enable: false
}
function updateObject() {
    map<anydata> project = {
        Description: "Updated description",
        AssigneeType: "UNASSIGNED"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateObject(objectName, <int> projectId, 
        project);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Object ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [getObject],
    enable: true
}
function deleteObject() {
    error? deleteAccountResponse = cdataConnectorToJira->deleteObject(objectName, <int> projectId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Object ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Generic Conditional Objects

@test:Config {
    dependsOn: [deleteObject],
    enable: true
}
function getConditionalObjects() {
    cdata:WhereCondition one = {
        'key: "Id",
        value: <int> projectId,
        operator: "=",
        operation: "OR"
    };
    cdata:WhereCondition two = {
        'key: "Name",
        value: "RolyProject1",
        operator: "="
    };
    stream<record{}, error> conditionalObjectStreamResponse = cdataConnectorToJira->getConditionalObjects(objectName, 
        [one, two]);
    error? e = conditionalObjectStreamResponse.forEach(isolated function(record{} jobject) {
        io:println("Conditional Object details: ", jobject);
    });
    if (e is error) {
        test:assertFail(e.message());
    }
}

@test:Config {
    dependsOn: [getConditionalObjects],
    enable: true
}
function createConditionalObject() {
    map<anydata> project = {
        Key: "EXE5",
        Name: "Inserted Project 2", 
        LeadAccountId: "60bd94c8d5dde800712d9772",
        LeadDisplayName: "admin", 
        ProjectTypeKey: "business",
        Description: "New business project"
    };
    (string|int)?|error createObjectResponse = cdataConnectorToJira->createObject(objectName, project);
    if (createObjectResponse is (string|int)?) {
        io:println("Created Conditional Object ID: ", createObjectResponse);
        projectId = createObjectResponse;
    } else {
        test:assertFail(createObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [createConditionalObject],
    enable: true
}
function getConditionalObject() {
    cdata:WhereCondition whereCondition = {
        'key: "Id",
        value: <int> projectId,
        operator: "="
    };
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getConditionalObject(objectName, 
        ["Id", "Name", "Key"], [whereCondition]);
    if (getObjectResponse is record {|record{} value;|}) {
        io:println("Selected Conditional Object ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Conditional Object table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
    }
}

@test:Config {
    dependsOn: [getConditionalObject],
    enable: true
}
function updateConditionalObject() {
    cdata:WhereCondition whereCondition = {
        'key: "Key",
        value: "ROL",
        operator: "="
    };
    map<anydata> project = {
        Description: "Updated description",
        AssigneeType: "UNASSIGNED"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateConditionalObject(objectName, 
        project, [whereCondition]);
    if (updateRecordResponse is (string|int)?) {
        io:println("Updated Conditional Object ID: ", updateRecordResponse);
    } else {
        test:assertFail(updateRecordResponse.message());
    }
}

@test:Config {
    dependsOn: [updateConditionalObject],
    enable: true
}
function deleteConditionalObject() {
    cdata:WhereCondition whereCondition = {
        'key: "Id",
        value: <int> projectId,
        operator: "="
    };
    error? deleteAccountResponse = cdataConnectorToJira->deleteConditionalObject(objectName, [whereCondition]);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Conditional Object ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// Projects

@test:Config {
    dependsOn: [deleteConditionalObject],
    enable: true
}
function getProjects() {
    stream<record{}, error> objectStreamResponse = cdataConnectorToJira->getProjects();
    error? e = objectStreamResponse.forEach(isolated function(record{} jobject) {
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
    map<anydata> project = {
        Key: "EXE6",
        Name: "Inserted Project 3", 
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
function getProjectById() {
    string Id = "Id";
    string Name = "Name";
    string Key = "Key";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectById(<int> projectId, 
        Id, Name, Key);
    if (getObjectResponse is record {|record{} value;|}) {
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
    map<anydata> project = {
        Description: "Updated description",
        AssigneeType: "UNASSIGNED"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectById(<int> projectId, project);
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
    map<anydata> project = {
        Description: "Updated description",
        AssigneeType: "PROJECT_LEAD"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectByKey("ROL", project);
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
    map<anydata> project = {
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
    map<anydata> projectComponent = {
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
    stream<record{}, error> objectStreamResponse = cdataConnectorToJira->getProjectComponents();
    error? e = objectStreamResponse.forEach(isolated function(record{} jobject) {
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
    string Id = "Id";
    string Name = "Name";
    string ProjectId = "ProjectId";
    string ProjectKey = "ProjectKey";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectComponentById(
        <int> projectComponentId, Id, Name, ProjectId, ProjectKey);
    if (getObjectResponse is record {|record{} value;|}) {
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
    string Id = "Id";
    string Name = "Name";
    string ProjectId = "ProjectId";
    string ProjectKey = "ProjectKey";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectComponentByProjectId(
        <int> projectId, Id, Name, ProjectId, ProjectKey);
    if (getObjectResponse is record {|record{} value;|}) {
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
    string Id = "Id";
    string Name = "Name";
    string ProjectId = "ProjectId";
    string ProjectKey = "ProjectKey";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectComponentByProjectKey(
        <string> projectKey, Id, Name, ProjectId, ProjectKey);
    if (getObjectResponse is record {|record{} value;|}) {
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
    map<anydata> project = {
        LeadKey: "newlead"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectComponentById(
        <int> projectComponentId, project);
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
    map<anydata> project = {
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
    map<anydata> projectVersion = {
        ProjectId: projectId,
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
    stream<record{}, error> objectStreamResponse = cdataConnectorToJira->getProjectVersions();
    error? e = objectStreamResponse.forEach(isolated function(record{} jobject) {
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
    string Id = "Id";
    string Name = "Name";
    string ProjectId = "ProjectId";
    string ProjectKey = "ProjectKey";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectVersionById(
        <int> projectVersionId, Id, Name, ProjectId, ProjectKey);
    if (getObjectResponse is record {|record{} value;|}) {
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
    string Id = "Id";
    string Name = "Name";
    string ProjectId = "ProjectId";
    string ProjectKey = "ProjectKey";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getProjectVersionByProjectId(
        <int> projectId, Id, Name, ProjectId, ProjectKey);
    if (getObjectResponse is record {|record{} value;|}) {
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
    map<anydata> projectVersion = {
        Released: true
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateProjectVersionById(
        <int> projectVersionId, projectVersion);
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
    map<anydata> issueType = {
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
    stream<record{}, error> objectStreamResponse = cdataConnectorToJira->getIssueTypes();
    error? e = objectStreamResponse.forEach(isolated function(record{} jobject) {
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
    string Id = "Id";
    string Name = "Name";
    string Description = "Description";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getIssueTypeById(
        <string> issueTypeId, Id, Name, Description);
    if (getObjectResponse is record {|record{} value;|}) {
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
    map<anydata> issueType = {
        Name: "Updated Name 3",
        Description: "Updated description"
    };
    (string|int)?|error updateRecordResponse = cdataConnectorToJira->updateIssueTypeById(
        <string> issueTypeId, issueType);
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
    stream<record{}, error> objectStreamResponse = cdataConnectorToJira->getRoles();
    error? e = objectStreamResponse.forEach(isolated function(record{} jobject) {
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
    string Id = "Id";
    string Name = "Name";
    string Description = "Description";
    record {|record{} value;|}|error? getObjectResponse = cdataConnectorToJira->getRoleById(
        10002, Id, Name, Description);
    if (getObjectResponse is record {|record{} value;|}) {
        io:println("Selected Role ID: ", getObjectResponse.value["Id"]);
    } else if (getObjectResponse is ()) {
        io:println("Role table is empty");
    } else {
        test:assertFail(getObjectResponse.message());
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
