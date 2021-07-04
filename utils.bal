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

// public isolated function generateJdbcUrl(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     if (configuration?.enableSso == true) {
//         jdbcUrl = jdbcUrl + handleSsoProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableOAuth == true) {
//         jdbcUrl = jdbcUrl + handleOAuthProperties(jdbcUrl, configuration);
//     } 
//     if (configuration?.enableSsl == true) {
//         jdbcUrl = jdbcUrl + handleSslProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableFirewall == true) {
//         jdbcUrl = jdbcUrl + handleFirewallProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableProxy == true) {
//         jdbcUrl = jdbcUrl + handleProxyProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableLogging == true) {
//         jdbcUrl = jdbcUrl + handleLoggingProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableSchema == true) {
//         jdbcUrl = jdbcUrl + handleSchemaProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableCaching == true) {
//         jdbcUrl = jdbcUrl + handleCachingProperties(jdbcUrl, configuration);
//     }
//     if (configuration?.enableMiscellaneous == true) {
//         jdbcUrl = jdbcUrl + handleMiscellaneousProperties(jdbcUrl, configuration);
//     }
//     return (url + jdbcUrl);
// }

// isolated function handleSsoProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("SSOLoginUrl", configuration?.ssoLoginUrl);
//     jdbcUrl = jdbcUrl + handleProperties("SSOProperties", configuration?.ssoProperties);
//     jdbcUrl = jdbcUrl + handleProperties("SSOExchangeUrl", configuration?.ssoExchangeUrl);
//     return jdbcUrl;
// }

// isolated function handleOAuthProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("InitiateOAuth", configuration?.initiateOAuth);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthVersion", configuration?.oauthVersion);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthClient Id", configuration?.oauthClientId);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthClientSecret", configuration?.oauthClientSecret);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthAccessToken", configuration?.oauthAccessToken);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthAccessTokenSecret", configuration?.oauthAccessTokenSecret);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthSettingsLocation", configuration?.oauthSettingsLocation);
//     jdbcUrl = jdbcUrl + handleProperties("CallbackURL", configuration?.callbackUrl);
//     jdbcUrl = jdbcUrl + handleProperties("CloudId", configuration?.cloudId);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthVerifier", configuration?.oauthVerifier);
//     jdbcUrl = jdbcUrl + handleProperties("AuthToken", configuration?.authToken);
//     jdbcUrl = jdbcUrl + handleProperties("AuthKey", configuration?.authKey);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthRefreshToken", configuration?.oauthRefreshToken);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthExpiresIn", configuration?.oauthExpiresIn);
//     jdbcUrl = jdbcUrl + handleProperties("OAuthTokenTimestamp", configuration?.oauthTokenTimestamp);
//     jdbcUrl = jdbcUrl + handleProperties("CertificateStoreType", configuration?.certificateStoreType);
//     jdbcUrl = jdbcUrl + handleProperties("CertificateStore", configuration?.certificateStore);
//     jdbcUrl = jdbcUrl + handleProperties("CertificateSubject", configuration?.certificateSubject);
//     jdbcUrl = jdbcUrl + handleProperties("CertificateStorePassword", configuration?.certificateStorePassword);
//     return jdbcUrl;
// }

// isolated function handleSslProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("SSLClientCert", configuration?.sslClientCert);
//     jdbcUrl = jdbcUrl + handleProperties("SSLClientCertType", configuration?.sslClientCertType);
//     jdbcUrl = jdbcUrl + handleProperties("SSLClientCertPassword", configuration?.sslClientCertPassword);
//     jdbcUrl = jdbcUrl + handleProperties("SSLClientCertSubject", configuration?.sslClientCertSubject);
//     jdbcUrl = jdbcUrl + handleProperties("SSLServerCert", configuration?.sslServerCert);
//     return jdbcUrl;
// }

// isolated function handleFirewallProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("FirewallType", configuration?.firewallType);
//     jdbcUrl = jdbcUrl + handleProperties("FirewallServer", configuration?.firewallServer);
//     jdbcUrl = jdbcUrl + handleProperties("FirewallPort", configuration?.firewallPort);
//     jdbcUrl = jdbcUrl + handleProperties("FirewallUser", configuration?.firewallUser);
//     jdbcUrl = jdbcUrl + handleProperties("FirewallPassword", configuration?.firewallPassword);
//     return jdbcUrl;
// }

// isolated function handleProxyProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("ProxyAutoDetect", configuration?.proxyAutoDetect);
//     jdbcUrl = jdbcUrl + handleProperties("ProxyServer", configuration?.proxyServer);
//     jdbcUrl = jdbcUrl + handleProperties("ProxyPort", configuration?.proxyPort);
//     jdbcUrl = jdbcUrl + handleProperties("ProxyAuthScheme", configuration?.proxyAuthScheme);
//     jdbcUrl = jdbcUrl + handleProperties("ProxyUser", configuration?.proxyUser);
//     jdbcUrl = jdbcUrl + handleProperties("ProxyPassword", configuration?.proxyPassword);
//     jdbcUrl = jdbcUrl + handleProperties("ProxySSLType", configuration?.proxySslType);
//     jdbcUrl = jdbcUrl + handleProperties("ProxyExceptions", configuration?.proxyExceptions);
//     return jdbcUrl;
// }

// isolated function handleLoggingProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("Logfile", configuration?.logFile);
//     jdbcUrl = jdbcUrl + handleProperties("Verbosity", configuration?.verbosity);
//     jdbcUrl = jdbcUrl + handleProperties("LogModules", configuration?.logModules);
//     jdbcUrl = jdbcUrl + handleProperties("MaxLogFileSize", configuration?.maxLogFileSize);
//     jdbcUrl = jdbcUrl + handleProperties("MaxLogFileCount", configuration?.maxLogFileCount);
//     return jdbcUrl;
// }

// isolated function handleSchemaProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("Location", configuration?.location);
//     jdbcUrl = jdbcUrl + handleProperties("BrowsableSchemas", configuration?.browsableSchemas);
//     jdbcUrl = jdbcUrl + handleProperties("Tables", configuration?.tables);
//     jdbcUrl = jdbcUrl + handleProperties("Views", configuration?.views);
//     return jdbcUrl;
// }

// isolated function handleCachingProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("AutoCache", configuration?.autoCache);
//     jdbcUrl = jdbcUrl + handleProperties("CacheDriver", configuration?.cacheDriver);
//     jdbcUrl = jdbcUrl + handleProperties("CacheConnection", configuration?.cacheConnection);
//     jdbcUrl = jdbcUrl + handleProperties("CacheLocation", configuration?.cacheLocation);
//     jdbcUrl = jdbcUrl + handleProperties("CacheTolerance", configuration?.cacheTolerance);
//     jdbcUrl = jdbcUrl + handleProperties("Offline", configuration?.offline);
//     jdbcUrl = jdbcUrl + handleProperties("CacheMetadata", configuration?.cacheMetadata);
//     return jdbcUrl;
// }

// isolated function handleMiscellaneousProperties(string url, CommonConfig? configuration = ()) returns string {
//     string jdbcUrl = "";
//     jdbcUrl = url + handleProperties("BatchSize", configuration?.batchSize);
//     jdbcUrl = jdbcUrl + handleProperties("ConnectionLifeTime", configuration?.connectionLifeTime);
//     jdbcUrl = jdbcUrl + handleProperties("ConnectOnOpen", configuration?.connectOnOpen);
//     jdbcUrl = jdbcUrl + handleProperties("IncludeCustomFields", configuration?.includeCustomFields);
//     jdbcUrl = jdbcUrl + handleProperties("MaxRows", configuration?.maxRows);
//     jdbcUrl = jdbcUrl + handleProperties("MaxThreads", configuration?.maxThreads);
//     jdbcUrl = jdbcUrl + handleProperties("Other", configuration?.other);
//     jdbcUrl = jdbcUrl + handleProperties("Pagesize", configuration?.pageSize);
//     jdbcUrl = jdbcUrl + handleProperties("PoolIdleTimeout", configuration?.poolIdleTimeout);
//     jdbcUrl = jdbcUrl + handleProperties("PoolMaxSize", configuration?.poolMaxSize);
//     jdbcUrl = jdbcUrl + handleProperties("PoolMinSize", configuration?.poolMinSize);
//     jdbcUrl = jdbcUrl + handleProperties("PoolWaitTime", configuration?.poolWaitTime);
//     jdbcUrl = jdbcUrl + handleProperties("PseudoColumns", configuration?.pseudoColumns);
//     jdbcUrl = jdbcUrl + handleProperties("Readonly", configuration?.'readonly);
//     jdbcUrl = jdbcUrl + handleProperties("RTK", configuration?.rtk);
//     jdbcUrl = jdbcUrl + handleProperties("SupportEnhancedSQL", configuration?.supportEnhancedSql);
//     jdbcUrl = jdbcUrl + handleProperties("Timeout", configuration?.timeout);
//     jdbcUrl = jdbcUrl + handleProperties("Timezone", configuration?.timezone);
//     jdbcUrl = jdbcUrl + handleProperties("UseConnectionPooling", configuration?.useConnectionPooling);
//     jdbcUrl = jdbcUrl + handleProperties("UseDefaultOrderBy", configuration?.useDefaultOrderBy);
//     return jdbcUrl;
// }

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
