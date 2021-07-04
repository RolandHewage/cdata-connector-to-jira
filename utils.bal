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
import ballerinax/java.jdbc;

public isolated function handleProperties(string 'key, anydata value) returns string {
    string suffix = "";
    if (value is string|int|float|decimal|boolean) {
        suffix = string `${'key}` + EQUAL + string `${value}` + SEMI_COLON;
    } 
    return suffix;
}

public isolated function handleConnectionPooling(ConnectionPooling? pooling = ()) returns sql:ConnectionPool? {
    if (pooling?.enablePooling is true) {
        sql:ConnectionPool connPool = {
            maxOpenConnections: pooling?.maxOpenConnections ?: 15,
            maxConnectionLifeTime: pooling?.maxConnectionLifeTime ?: 1800,
            minIdleConnections: pooling?.minIdleConnections ?: 15
        };
        return connPool;
    }
    return;
}

public isolated function handleOptions(CommonConfig? commonConfig = ()) returns jdbc:Options? {
    if !(commonConfig is ()) {
        map<anydata> commonConfigMap = <map<anydata>>commonConfig;
        jdbc:Options options = {
            properties: commonConfigMap
        };
        return options;
    }
    return;
}
