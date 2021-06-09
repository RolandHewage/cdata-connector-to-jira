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

isolated function generateSelectAllQuery(string objectName) returns string {
    return string `SELECT * FROM (${objectName})`;
}

isolated function generateInsertQuery(string objectName, map<anydata> payload) returns string {
    string insertQuery = string `INSERT INTO ${objectName} `;
    string keys = string `(`;
    string values = string `VALUES (`;
    int count = 1;
    foreach var [key, value] in payload.entries() {
        keys = keys + key + string `${(count == payload.length()) ? ") " : ","}`;
        if (value is string) {
            values = values + string `"${value}"` + string `${(count == payload.length()) ? ")" : ","}`;
        } else if (value is int|float|decimal|boolean) {
            values = values + string `${value}` + string `${(count == payload.length()) ? ")" : ","}`;
        } else if (value is ()) {
            values = values + string `NULL` + string `${(count == payload.length()) ? ")" : ","}`;
        }  
        count = count + 1;
    }
    insertQuery = insertQuery + keys + values;
    return insertQuery;
}

isolated function generateSelectQuery(string objectName, int objectId, string[] fields) returns string {
    string selectQuery = string `SELECT `;
    string keys = string ``;
    string queryLogic = string `FROM ${objectName} WHERE Id = ${objectId}`;
    int count = 1;
    foreach var item in fields {
        keys = keys + item + string `${(count == fields.length()) ? " " : ","}`;
        count = count + 1;
    }
    selectQuery = selectQuery + keys + queryLogic;
    return selectQuery;
}

isolated function generateUpdateQuery(string objectName, int objectId, map<anydata> payload) returns string {
    string updateQuery = string `UPDATE ${objectName} `;
    string values = string `SET `;
    string queryLogic = string ` WHERE Id = ${objectId}`;
    int count = 1;
    foreach var [key, value] in payload.entries() {
        if (value is string) {
            values = values + key + " = " + string `'${value}'` + string `${(count == payload.length()) ? "" : ","}`;
        } else if (value is int|float|decimal|boolean) {
            values = values + key + " = " + string `${value}` + string `${(count == payload.length()) ? "" : ","}`;
        } else if (value is ()) {
            values = values + key + " = " + string `NULL` + string `${(count == payload.length()) ? "" : ","}`;
        }  
        count = count + 1;
    }
    updateQuery = updateQuery + values + queryLogic;
    return updateQuery;
}

isolated function generateDeleteQuery(string objectName, int objectId) returns string {
    return string `DELETE FROM ${objectName} WHERE Id = ${objectId}`;
}

isolated function generateJdbcUrl(Configuration configuration) returns string {
    string jdbcUrl = "jdbc:cdata:jira:";
    return jdbcUrl;
}
