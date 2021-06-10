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

import cdata as cdata;

isolated function generateJdbcUrl(JiraConfig configuration) returns string {
    string jdbcUrl = "jdbc:cdata:jira:";
    if (configuration.basicAuth.hostBasicAuth is CloudBasicAuth) {
        jdbcUrl = jdbcUrl + cdata:handleProperties("User", configuration.basicAuth?.hostBasicAuth.user);
        jdbcUrl = jdbcUrl + cdata:handleProperties("APIToken", configuration.basicAuth?.hostBasicAuth?.apiToken);
        jdbcUrl = jdbcUrl + cdata:handleProperties("Url", configuration.basicAuth.url);
    }
    if (configuration.basicAuth.hostBasicAuth is ServerBasicAuth) {
        jdbcUrl = jdbcUrl + cdata:handleProperties("User", configuration.basicAuth?.hostBasicAuth.user);
        jdbcUrl = jdbcUrl + cdata:handleProperties("Password", configuration.basicAuth?.hostBasicAuth?.password);
        jdbcUrl = jdbcUrl + cdata:handleProperties("Url", configuration.basicAuth.url);
    }
    return cdata:generateJdbcUrl(jdbcUrl, configuration);
}
