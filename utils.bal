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

public isolated function generateConditionalSelectAllQuery(string objectName, WhereCondition[]? whereConditions = ()) 
                                                           returns string {
    if (whereConditions is WhereCondition[]) {
        string condition = handleWhereCondition(whereConditions);
        return string `SELECT * FROM (${objectName})${condition}`;
    }                                                 
    return string `SELECT * FROM (${objectName})`;
}

public isolated function generateConditionalSelectQuery(string objectName, string[] fields, 
                                                        WhereCondition[]? whereConditions) returns string {
    string selectQuery = string `SELECT `;
    string keys = string ``;
    string queryLogic = string `FROM ${objectName}`;
    int count = 1;
    foreach var item in fields {
        keys = keys + item + string `${(count == fields.length()) ? " " : ","}`;
        count = count + 1;
    }
    selectQuery = selectQuery + keys + queryLogic;

    if (whereConditions is WhereCondition[]) {
        string condition = handleWhereCondition(whereConditions);
        return (selectQuery + string `${condition}`);
    }                                                 
    return selectQuery;
}

public isolated function generateConditionalUpdateQuery(string objectName, map<anydata> payload, 
                                                        WhereCondition[] whereConditions) returns string {
    string updateQuery = string `UPDATE ${objectName} `;
    string values = string `SET `;
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
    updateQuery = updateQuery + values;
    
    string condition = handleWhereCondition(whereConditions);
    return (updateQuery + string `${condition}`);
}

public isolated function generateConditionalDeleteQuery(string objectName, WhereCondition[] whereConditions) 
                                                        returns string {
    string condition = handleWhereCondition(whereConditions);
    return string `DELETE FROM ${objectName}${condition}`;
}

isolated function handleWhereCondition(WhereCondition[] whereConditions) returns string {
    string condition = " WHERE ";
    foreach var item in whereConditions {
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
    return condition;
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
    jdbcUrl = url + handleProperties("SSOLoginUrl", configuration?.ssoLoginUrl);
    jdbcUrl = jdbcUrl + handleProperties("SSOProperties", configuration?.ssoProperties);
    jdbcUrl = jdbcUrl + handleProperties("SSOExchangeUrl", configuration?.ssoExchangeUrl);
    return jdbcUrl;
}

isolated function handleOAuthProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("InitiateOAuth", configuration?.initiateOAuth);
    jdbcUrl = jdbcUrl + handleProperties("OAuthVersion", configuration?.oauthVersion);
    jdbcUrl = jdbcUrl + handleProperties("OAuthClient Id", configuration?.oauthClientId);
    jdbcUrl = jdbcUrl + handleProperties("OAuthClientSecret", configuration?.oauthClientSecret);
    jdbcUrl = jdbcUrl + handleProperties("OAuthAccessToken", configuration?.oauthAccessToken);
    jdbcUrl = jdbcUrl + handleProperties("OAuthAccessTokenSecret", configuration?.oauthAccessTokenSecret);
    jdbcUrl = jdbcUrl + handleProperties("OAuthSettingsLocation", configuration?.oauthSettingsLocation);
    jdbcUrl = jdbcUrl + handleProperties("CallbackURL", configuration?.callbackUrl);
    jdbcUrl = jdbcUrl + handleProperties("CloudId", configuration?.cloudId);
    jdbcUrl = jdbcUrl + handleProperties("OAuthVerifier", configuration?.oauthVerifier);
    jdbcUrl = jdbcUrl + handleProperties("AuthToken", configuration?.authToken);
    jdbcUrl = jdbcUrl + handleProperties("AuthKey", configuration?.authKey);
    jdbcUrl = jdbcUrl + handleProperties("OAuthRefreshToken", configuration?.oauthRefreshToken);
    jdbcUrl = jdbcUrl + handleProperties("OAuthExpiresIn", configuration?.oauthExpiresIn);
    jdbcUrl = jdbcUrl + handleProperties("OAuthTokenTimestamp", configuration?.oauthTokenTimestamp);
    jdbcUrl = jdbcUrl + handleProperties("CertificateStoreType", configuration?.certificateStoreType);
    jdbcUrl = jdbcUrl + handleProperties("CertificateStore", configuration?.certificateStore);
    jdbcUrl = jdbcUrl + handleProperties("CertificateSubject", configuration?.certificateSubject);
    jdbcUrl = jdbcUrl + handleProperties("CertificateStorePassword", configuration?.certificateStorePassword);
    return jdbcUrl;
}

isolated function handleSslProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("SSLClientCert", configuration?.sslClientCert);
    jdbcUrl = jdbcUrl + handleProperties("SSLClientCertType", configuration?.sslClientCertType);
    jdbcUrl = jdbcUrl + handleProperties("SSLClientCertPassword", configuration?.sslClientCertPassword);
    jdbcUrl = jdbcUrl + handleProperties("SSLClientCertSubject", configuration?.sslClientCertSubject);
    jdbcUrl = jdbcUrl + handleProperties("SSLServerCert", configuration?.sslServerCert);
    return jdbcUrl;
}

isolated function handleFirewallProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("FirewallType", configuration?.firewallType);
    jdbcUrl = jdbcUrl + handleProperties("FirewallServer", configuration?.firewallServer);
    jdbcUrl = jdbcUrl + handleProperties("FirewallPort", configuration?.firewallPort);
    jdbcUrl = jdbcUrl + handleProperties("FirewallUser", configuration?.firewallUser);
    jdbcUrl = jdbcUrl + handleProperties("FirewallPassword", configuration?.firewallPassword);
    return jdbcUrl;
}

isolated function handleProxyProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("ProxyAutoDetect", configuration?.proxyAutoDetect);
    jdbcUrl = jdbcUrl + handleProperties("ProxyServer", configuration?.proxyServer);
    jdbcUrl = jdbcUrl + handleProperties("ProxyPort", configuration?.proxyPort);
    jdbcUrl = jdbcUrl + handleProperties("ProxyAuthScheme", configuration?.proxyAuthScheme);
    jdbcUrl = jdbcUrl + handleProperties("ProxyUser", configuration?.proxyUser);
    jdbcUrl = jdbcUrl + handleProperties("ProxyPassword", configuration?.proxyPassword);
    jdbcUrl = jdbcUrl + handleProperties("ProxySSLType", configuration?.proxySslType);
    jdbcUrl = jdbcUrl + handleProperties("ProxyExceptions", configuration?.proxyExceptions);
    return jdbcUrl;
}

isolated function handleLoggingProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Logfile", configuration?.logFile);
    jdbcUrl = jdbcUrl + handleProperties("Verbosity", configuration?.verbosity);
    jdbcUrl = jdbcUrl + handleProperties("LogModules", configuration?.logModules);
    jdbcUrl = jdbcUrl + handleProperties("MaxLogFileSize", configuration?.maxLogFileSize);
    jdbcUrl = jdbcUrl + handleProperties("MaxLogFileCount", configuration?.maxLogFileCount);
    return jdbcUrl;
}

isolated function handleSchemaProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("Location", configuration?.location);
    jdbcUrl = jdbcUrl + handleProperties("BrowsableSchemas", configuration?.browsableSchemas);
    jdbcUrl = jdbcUrl + handleProperties("Tables", configuration?.tables);
    jdbcUrl = jdbcUrl + handleProperties("Views", configuration?.views);
    return jdbcUrl;
}

isolated function handleCachingProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("AutoCache", configuration?.autoCache);
    jdbcUrl = jdbcUrl + handleProperties("CacheDriver", configuration?.cacheDriver);
    jdbcUrl = jdbcUrl + handleProperties("CacheConnection", configuration?.cacheConnection);
    jdbcUrl = jdbcUrl + handleProperties("CacheLocation", configuration?.cacheLocation);
    jdbcUrl = jdbcUrl + handleProperties("CacheTolerance", configuration?.cacheTolerance);
    jdbcUrl = jdbcUrl + handleProperties("Offline", configuration?.offline);
    jdbcUrl = jdbcUrl + handleProperties("CacheMetadata", configuration?.cacheMetadata);
    return jdbcUrl;
}

isolated function handleMiscellaneousProperties(string url, CommonConfig configuration) returns string {
    string jdbcUrl = "";
    jdbcUrl = url + handleProperties("BatchSize", configuration?.batchSize);
    jdbcUrl = jdbcUrl + handleProperties("ConnectionLifeTime", configuration?.connectionLifeTime);
    jdbcUrl = jdbcUrl + handleProperties("ConnectOnOpen", configuration?.connectOnOpen);
    jdbcUrl = jdbcUrl + handleProperties("IncludeCustomFields", configuration?.includeCustomFields);
    jdbcUrl = jdbcUrl + handleProperties("MaxRows", configuration?.maxRows);
    jdbcUrl = jdbcUrl + handleProperties("MaxThreads", configuration?.maxThreads);
    jdbcUrl = jdbcUrl + handleProperties("Other", configuration?.other);
    jdbcUrl = jdbcUrl + handleProperties("Pagesize", configuration?.pageSize);
    jdbcUrl = jdbcUrl + handleProperties("PoolIdleTimeout", configuration?.poolIdleTimeout);
    jdbcUrl = jdbcUrl + handleProperties("PoolMaxSize", configuration?.poolMaxSize);
    jdbcUrl = jdbcUrl + handleProperties("PoolMinSize", configuration?.poolMinSize);
    jdbcUrl = jdbcUrl + handleProperties("PoolWaitTime", configuration?.poolWaitTime);
    jdbcUrl = jdbcUrl + handleProperties("PseudoColumns", configuration?.pseudoColumns);
    jdbcUrl = jdbcUrl + handleProperties("Readonly", configuration?.'readonly);
    jdbcUrl = jdbcUrl + handleProperties("RTK", configuration?.rtk);
    jdbcUrl = jdbcUrl + handleProperties("SupportEnhancedSQL", configuration?.supportEnhancedSql);
    jdbcUrl = jdbcUrl + handleProperties("Timeout", configuration?.timeout);
    jdbcUrl = jdbcUrl + handleProperties("Timezone", configuration?.timezone);
    jdbcUrl = jdbcUrl + handleProperties("UseConnectionPooling", configuration?.useConnectionPooling);
    jdbcUrl = jdbcUrl + handleProperties("UseDefaultOrderBy", configuration?.useDefaultOrderBy);
    return jdbcUrl;
}

public isolated function handleProperties(string 'key, anydata value) returns string {
    string suffix = "";
    if (value is string|int|float|decimal|boolean) {
        suffix = string `${'key}` + EQUAL + string `${value}` + SEMI_COLON;
    } 
    return suffix;
}
