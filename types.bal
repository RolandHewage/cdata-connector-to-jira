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

# CData configuration.
#
# + jdbcUrl - The JDBC URL of the database  
# + connectionPool - The `sql:ConnectionPool` object to be used within the JDBC client.
#                    If there is no `connectionPool` provided, the global connection pool will be used and it will
#                    be shared by other clients, which have the same properties  
# + options - The database-specific JDBC client properties
public type CdataConfig record {
    string jdbcUrl;
    sql:ConnectionPool? connectionPool?;
    jdbc:Options? options?;
};
