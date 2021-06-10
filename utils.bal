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

public isolated function generateSelectAllQuery(string objectName) returns string {
    return string `SELECT * FROM (${objectName})`;
}

public isolated function generateInsertQuery(string objectName, map<anydata> payload) returns string {
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

public isolated function generateSelectQuery(string objectName, int recordId, string[] fields) returns string {
    string selectQuery = string `SELECT `;
    string keys = string ``;
    string queryLogic = string `FROM ${objectName} WHERE Id = ${recordId}`;
    int count = 1;
    foreach var item in fields {
        keys = keys + item + string `${(count == fields.length()) ? " " : ","}`;
        count = count + 1;
    }
    selectQuery = selectQuery + keys + queryLogic;
    return selectQuery;
}

public isolated function generateUpdateQuery(string objectName, int recordId, map<anydata> payload) returns string {
    string updateQuery = string `UPDATE ${objectName} `;
    string values = string `SET `;
    string queryLogic = string ` WHERE Id = ${recordId}`;
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

public isolated function generateDeleteQuery(string objectName, int recordId) returns string {
    return string `DELETE FROM ${objectName} WHERE Id = ${recordId}`;
}

public isolated function generateConditionalSelectAllQuery(string objectName, WhereCondition[]? whereCondition = ()) 
                                                    returns string {
    if (whereCondition is WhereCondition[]) {
        string condition = "";
        foreach var item in whereCondition {
            anydata conditionValue = item.value;
            if (conditionValue is string) {
                if (item?.operation.toString() == NOT) {
                    condition = condition + "NOT " + item.'key + string `${item.operator.toString()}` + 
                        string `'${conditionValue}'` + " ";
                } else {
                    condition = condition + item.'key + string `${item.operator.toString()}` + 
                        string `'${conditionValue}'` + " " + item?.operation.toString() + " ";
                }
            } else if (conditionValue is int|float|decimal|boolean) {
                if (item?.operation.toString() == NOT) {
                    condition = condition + "NOT " + item.'key + string `${item.operator.toString()}` + 
                        string `${conditionValue}` + " ";
                } else {
                    condition = condition + item.'key + string `${item.operator.toString()}` + 
                        string `${conditionValue}` + " " + item?.operation.toString() + " ";
                }
            } else if (conditionValue is ()) {
                if (item?.operation.toString() == NOT) {
                    condition = condition + "NOT " + item.'key + string `${item.operator.toString()}` + 
                        string `NULL` + " ";
                } else {
                    condition = condition + item.'key + string `${item.operator.toString()}` + 
                        string `NULL` + " " + item?.operation.toString() + " ";
                }
            }    
        }
        return string `SELECT * FROM (${objectName}) WHERE ${condition}`;
    }                                                 
    return string `SELECT * FROM (${objectName})`;
}

public isolated function generateJdbcUrl(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    if (configuration?.enableSso == true) {
        jdbcUrl = jdbcUrl + handleSsoProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableOAuth == true) {
        jdbcUrl = jdbcUrl + handleOAuthProperties(jdbcUrl, configuration);
    } 
    if (configuration?.enableSsl == true) {
        jdbcUrl = jdbcUrl + handleSslProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableFirewall == true) {
        jdbcUrl = jdbcUrl + handleFirewallProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableProxy == true) {
        jdbcUrl = jdbcUrl + handleProxyProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableLogging == true) {
        jdbcUrl = jdbcUrl + handleLoggingProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableSchema == true) {
        jdbcUrl = jdbcUrl + handleSchemaProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableCaching == true) {
        jdbcUrl = jdbcUrl + handleCachingProperties(jdbcUrl, configuration);
    }
    if (configuration?.enableMiscellaneous == true) {
        jdbcUrl = jdbcUrl + handleMiscellaneousProperties(jdbcUrl, configuration);
    }
    return (url + jdbcUrl);
}

isolated function handleSsoProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("SSO Login URL", configuration?.ssoLoginUrl);
    jdbcUrl = jdbcUrl + handleProperties("SSO Properties", configuration?.ssoProperties);
    jdbcUrl = jdbcUrl + handleProperties("SSO Exchange Url", configuration?.ssoExchangeUrl);
    return jdbcUrl;
}

isolated function handleOAuthProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Initiate OAuth", configuration?.initiateOAuth);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Version", configuration?.oauthVersion);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Client Id", configuration?.oauthClientId);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Client Secret", configuration?.oauthClientSecret);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Access Token", configuration?.oauthAccessToken);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Access Token Secret", configuration?.oauthAccessTokenSecret);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Settings Location", configuration?.oauthSettingsLocation);
    jdbcUrl = jdbcUrl + handleProperties("Callback URL", configuration?.callbackUrl);
    jdbcUrl = jdbcUrl + handleProperties("Cloud Id", configuration?.cloudId);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Verifier", configuration?.oauthVerifier);
    jdbcUrl = jdbcUrl + handleProperties("Auth Token", configuration?.authToken);
    jdbcUrl = jdbcUrl + handleProperties("Auth Key", configuration?.authKey);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Refresh Token", configuration?.oauthRefreshToken);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Expires In", configuration?.oauthExpiresIn);
    jdbcUrl = jdbcUrl + handleProperties("OAuth Token Timestamp", configuration?.oauthTokenTimestamp);
    jdbcUrl = jdbcUrl + handleProperties("Certificate Store Type", configuration?.certificateStoreType);
    jdbcUrl = jdbcUrl + handleProperties("Certificate Store", configuration?.certificateStore);
    jdbcUrl = jdbcUrl + handleProperties("Certificate Subject", configuration?.certificateSubject);
    jdbcUrl = jdbcUrl + handleProperties("Certificate Store Password", configuration?.certificateStorePassword);
    return jdbcUrl;
}

isolated function handleSslProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("SSL Client Cert", configuration?.sslClientCert);
    jdbcUrl = jdbcUrl + handleProperties("SSL Client Cert Type", configuration?.sslClientCertType);
    jdbcUrl = jdbcUrl + handleProperties("SSL Client Cert Password", configuration?.sslClientCertPassword);
    jdbcUrl = jdbcUrl + handleProperties("SSL Client Cert Subject", configuration?.sslClientCertSubject);
    jdbcUrl = jdbcUrl + handleProperties("SSL Server Cert", configuration?.sslServerCert);
    return jdbcUrl;
}

isolated function handleFirewallProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Firewall Type", configuration?.firewallType);
    jdbcUrl = jdbcUrl + handleProperties("Firewall Server", configuration?.firewallServer);
    jdbcUrl = jdbcUrl + handleProperties("Firewall Port", configuration?.firewallPort);
    jdbcUrl = jdbcUrl + handleProperties("Firewall User", configuration?.firewallUser);
    jdbcUrl = jdbcUrl + handleProperties("Firewall Password", configuration?.firewallPassword);
    return jdbcUrl;
}

isolated function handleProxyProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Proxy Auto Detect", configuration?.proxyAutoDetect);
    jdbcUrl = jdbcUrl + handleProperties("Proxy Server", configuration?.proxyServer);
    jdbcUrl = jdbcUrl + handleProperties("Proxy Port", configuration?.proxyPort);
    jdbcUrl = jdbcUrl + handleProperties("Proxy Auth Scheme", configuration?.proxyAuthScheme);
    jdbcUrl = jdbcUrl + handleProperties("Proxy User", configuration?.proxyUser);
    jdbcUrl = jdbcUrl + handleProperties("Proxy Password", configuration?.proxyPassword);
    jdbcUrl = jdbcUrl + handleProperties("Proxy SSL Type", configuration?.proxySslType);
    jdbcUrl = jdbcUrl + handleProperties("Proxy Exceptions", configuration?.proxyExceptions);
    return jdbcUrl;
}

isolated function handleLoggingProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Logfile", configuration?.logFile);
    jdbcUrl = jdbcUrl + handleProperties("Verbosity", configuration?.verbosity);
    jdbcUrl = jdbcUrl + handleProperties("Log Modules", configuration?.logModules);
    jdbcUrl = jdbcUrl + handleProperties("Max Log File Size", configuration?.maxLogFileSize);
    jdbcUrl = jdbcUrl + handleProperties("Max Log File Count", configuration?.maxLogFileCount);
    return jdbcUrl;
}

isolated function handleSchemaProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Location", configuration?.location);
    jdbcUrl = jdbcUrl + handleProperties("Browsable Schemas", configuration?.browsableSchemas);
    jdbcUrl = jdbcUrl + handleProperties("Tables", configuration?.tables);
    jdbcUrl = jdbcUrl + handleProperties("Views", configuration?.views);
    return jdbcUrl;
}

isolated function handleCachingProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Auto Cache", configuration?.autoCache);
    jdbcUrl = jdbcUrl + handleProperties("Cache Driver", configuration?.cacheDriver);
    jdbcUrl = jdbcUrl + handleProperties("Cache Connection", configuration?.cacheConnection);
    jdbcUrl = jdbcUrl + handleProperties("Cache Location", configuration?.cacheLocation);
    jdbcUrl = jdbcUrl + handleProperties("Cache Tolerance", configuration?.cacheTolerance);
    jdbcUrl = jdbcUrl + handleProperties("Offline", configuration?.offline);
    jdbcUrl = jdbcUrl + handleProperties("Cache Metadata", configuration?.cacheMetadata);
    return jdbcUrl;
}

isolated function handleMiscellaneousProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Batch Size", configuration?.batchSize);
    jdbcUrl = jdbcUrl + handleProperties("Connection Life Time", configuration?.connectionLifeTime);
    jdbcUrl = jdbcUrl + handleProperties("Connect On Open", configuration?.connectOnOpen);
    jdbcUrl = jdbcUrl + handleProperties("Include Custom Fields", configuration?.includeCustomFields);
    jdbcUrl = jdbcUrl + handleProperties("Max Rows", configuration?.maxRows);
    jdbcUrl = jdbcUrl + handleProperties("Max Threads", configuration?.maxThreads);
    jdbcUrl = jdbcUrl + handleProperties("Other", configuration?.other);
    jdbcUrl = jdbcUrl + handleProperties("Pagesize", configuration?.pageSize);
    jdbcUrl = jdbcUrl + handleProperties("Pool Idle Timeout", configuration?.poolIdleTimeout);
    jdbcUrl = jdbcUrl + handleProperties("Pool Max Size", configuration?.poolMaxSize);
    jdbcUrl = jdbcUrl + handleProperties("Pool Min Size", configuration?.poolMinSize);
    jdbcUrl = jdbcUrl + handleProperties("Pool Wait Time", configuration?.poolWaitTime);
    jdbcUrl = jdbcUrl + handleProperties("Pseudo Columns", configuration?.pseudoColumns);
    jdbcUrl = jdbcUrl + handleProperties("Readonly", configuration?.'readonly);
    jdbcUrl = jdbcUrl + handleProperties("RTK", configuration?.rtk);
    jdbcUrl = jdbcUrl + handleProperties("Support Enhanced SQL", configuration?.supportEnhancedSql);
    jdbcUrl = jdbcUrl + handleProperties("Timeout", configuration?.timeout);
    jdbcUrl = jdbcUrl + handleProperties("Timezone", configuration?.timezone);
    jdbcUrl = jdbcUrl + handleProperties("Use Connection Pooling", configuration?.useConnectionPooling);
    jdbcUrl = jdbcUrl + handleProperties("Use Default Order By", configuration?.useDefaultOrderBy);
    return jdbcUrl;
}

public isolated function handleProperties(string 'key, anydata value) returns string {
    string suffix = "";
    if (value is string|int|float|decimal|boolean) {
        suffix = string `${'key}` + EQUAL + string `${value}` + SEMI_COLON;
    } 
    return suffix;
}
