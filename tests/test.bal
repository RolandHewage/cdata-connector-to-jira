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
string[] accountIds = [];
string objectName = "Projects";

// Connection Configurations
configurable string user = os:getEnv("USER");
configurable string apiToken = os:getEnv("API_TOKEN");
configurable string url = os:getEnv("URL");

CloudBasicAuth hostBasicAuth = {
    user: user,
    apiToken: apiToken
};

BasicAuth basicAuth = {
    hostBasicAuth: hostBasicAuth,
    url: url
};

Configuration config = {
    basicAuth: basicAuth
};

Client cdataConnectorToJira = check new (config);

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
    (string|int)?|sql:Error createObjectResponse = cdataConnectorToJira->createObject(objectName, project);
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
    (string|int)?|sql:Error updateRecordResponse = cdataConnectorToJira->updateObject(objectName, <int> projectId, 
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
    sql:Error? deleteAccountResponse = cdataConnectorToJira->deleteObject(objectName, <int> projectId);
    if (deleteAccountResponse is ()) {
        io:println("Deleted Object ID: ", projectId);
    } else {
        test:assertFail(deleteAccountResponse.message());
    }
}

// @test:Config {
//     dependsOn: [deleteRecord],
//     enable: true
// }
// function batchInsertAccount() {
//     Account account1 = {
//         Id: "ACC_000001",
//         Name: "Test Account 1", 
//         Type: "Customer - Direct", 
//         AccountNumber: "CD355120-TEST",
//         Industry: "Energy", 
//         Description: "Test account 1 desc."
//     };
//     Account account2 = {
//         Id: "ACC_000002",
//         Name: "Test Account 2", 
//         Type: "Customer - Direct", 
//         AccountNumber: "CD355120-TEST",
//         Industry: "Energy", 
//         Description: "Test account 2 desc."
//     };
//     Account account3 = {
//         Id: "ACC_000003",
//         Name: "Test Account 3", 
//         Type: "Customer - Direct", 
//         AccountNumber: "CD355120-TEST",
//         Industry: "Energy", 
//         Description: "Test account 3 desc."
//     };
//     Account[] batchRecords = [account1, account2, account3];
//     string[]|sql:Error createAccountResponse = cdataConnectorToSalesforce->batchInsertAccounts(batchRecords);
//     if (createAccountResponse is string[]) {
//         io:println("Created Account IDs: ", createAccountResponse);
//         foreach var item in createAccountResponse {
//             accountIds.push(item);
//         }
//     } else {
//         test:assertFail(createAccountResponse.message());
//     }
// }

// @test:Config {
//     dependsOn: [batchInsertAccount],
//     enable: true
// }
// function batchUpdateAccount() {
//     Account account1 = {
//         Id: accountIds[0],
//         Name: "Test Account 1 Updated", 
//         Type: "Customer - Direct", 
//         AccountNumber: "CD355120-TEST",
//         Industry: "Energy", 
//         Description: "Test account 1 desc."
//     };
//     Account account2 = {
//         Id: accountIds[1],
//         Name: "Test Account 2 Updated", 
//         Type: "Customer - Direct", 
//         AccountNumber: "CD355120-TEST",
//         Industry: "Energy", 
//         Description: "Test account 2 desc."
//     };
//     Account account3 = {
//         Id: accountIds[2],
//         Name: "Test Account 3 Updated", 
//         Type: "Customer - Direct", 
//         AccountNumber: "CD355120-TEST",
//         Industry: "Energy", 
//         Description: "Test account 3 desc."
//     };
//     Account[] batchRecords = [account1, account2, account3];
//     string[]|sql:Error batchUpdateAccountResponse = cdataConnectorToSalesforce->batchUpdateAccounts(batchRecords);
//     if (batchUpdateAccountResponse is string[]) {
//         io:println("Updated Account IDs: ", batchUpdateAccountResponse);
//     } else {
//         test:assertFail(batchUpdateAccountResponse.message());
//     }
// }

// @test:Config {
//     dependsOn: [batchUpdateAccount],
//     enable: true
// }
// function batchDeleteAccount() {
//     sql:Error? batchDeleteAccountResponse = cdataConnectorToSalesforce->batchDeleteAccounts(accountIds);
//     if (batchDeleteAccountResponse is ()) {
//         io:println("Deleted Account IDs: ", accountIds);
//     } else {
//         test:assertFail(batchDeleteAccountResponse.message());
//     }
// }

// @test:Config {
//     dependsOn: [batchDeleteAccount],
//     enable: true
// }
// function getUserInformation() {
//     stream<record{}, sql:Error>|sql:Error? userInformationResponse = cdataConnectorToSalesforce->getUserInformation();
//     if (userInformationResponse is stream<record{}, sql:Error>) {
//         sql:Error? e = userInformationResponse.forEach(isolated function(record{} user) {
//             io:println("User details: ", user);
//         });
//         if (e is error) {
//             test:assertFail(e.message());
//         }
//     } else if (userInformationResponse is ()) {
//         io:println("Empty result is returned from the `GetUserInformation`.");
//     } else {
//         test:assertFail(userInformationResponse.message());
//     }
// }

@test:AfterSuite { }
function afterSuite() {
    io:println("Close the connection to Jira using CData Connector");
    sql:Error? closeResponse = cdataConnectorToJira->close();
    if (closeResponse is sql:Error) {
        test:assertFail(closeResponse.message());
    }
}
