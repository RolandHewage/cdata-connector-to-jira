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

# CData configuration.
#
# + jdbcUrl - The JDBC URL of the database
# + connectionPool - The `sql:ConnectionPool` object to be used within the JDBC client.
#                    If there is no `connectionPool` provided, the global connection pool will be used and it will
#                    be shared by other clients, which have the same properties
public type CdataConfig record {
    string jdbcUrl;
    sql:ConnectionPool? connectionPool?;
};

# Common configuration.
public type CommonConfig record {
    *SSO;
    *OAuth;
    *SSL;
    *Firewall;
    *Proxy;
    *Logging;
    *Schema;
    *Caching;
    *Miscellaneous;
    *Pooling;
};

// Connection Properties

# Complete list of the SSO properties you can configure in the connection string for this provider.
#
# + enableSso - Enable configuring SSO properties 
# + ssoLoginUrl - The identity provider's login URL  
# + ssoProperties - Additional properties required to connect to the identity provider in a semicolon-separated list  
# + ssoExchangeUrl - The url used for consuming the SAML response and exchanging it with JIRA specific credentials
public type SSO record {
    boolean enableSso?;
    string ssoLoginUrl?;
    string ssoProperties?;
    string ssoExchangeUrl?;
};

# Complete list of the OAuth properties you can configure in the connection string for this provider.
#
# + enableOAuth - Enable configuring OAuth properties 
# + initiateOAuth - Set this property to initiate the process to obtain or refresh the OAuth access token when you connect    
# + oauthVersion - Field Description  
# + oauthClientId - The client ID assigned when you register your application with an OAuth authorization server     
# + oauthClientSecret - The client secret assigned when you register your application with an OAuth authorization server    
# + oauthAccessToken - The access token for connecting using OAuth    
# + oauthAccessTokenSecret - The OAuth access token secret for connecting using OAuth     
# + oauthSettingsLocation - The location of the settings file where OAuth values are saved when InitiateOAuth is set to GETANDREFRESH or REFRESH. Alternatively, this can be held in memory by specifying a value starting with memory      
# + callbackUrl - The OAuth callback URL to return to when authenticating. This value must match the callback URL you specify in your app settings    
# + cloudId - The Cloud Id for the Atlassian site that was authorized     
# + oauthVerifier - The verifier code returned from the OAuth authorization URL    
# + authToken - The authentication token used to request and obtain the OAuth Access Token    
# + authKey - The authentication secret used to request and obtain the OAuth Access Token    
# + oauthRefreshToken - The OAuth refresh token for the corresponding OAuth access token    
# + oauthExpiresIn - The lifetime in seconds of the OAuth AccessToken    
# + oauthTokenTimestamp - The Unix epoch timestamp in milliseconds when the current Access Token was created    
# + certificateStoreType - The type of certificate store used with Jira Private Application authentication    
# + certificateStore - The certificate store used for JIRA authentication  
# + certificateSubject - The subject of the certificate used with Jira Private Application authentication     
# + certificateStorePassword - The password of the certificate store used with Jira authentication
public type OAuth record {
    boolean enableOAuth?;
    string initiateOAuth?;
    string oauthVersion?;
    string oauthClientId?;
    string oauthClientSecret?;
    string oauthAccessToken?;
    string oauthAccessTokenSecret?;
    string oauthSettingsLocation?;
    string callbackUrl?;
    string cloudId?;
    string oauthVerifier?;
    string authToken?;
    string authKey?;
    string oauthRefreshToken?;
    string oauthExpiresIn?;
    string oauthTokenTimestamp?;
    string certificateStoreType?;
    string certificateStore?;
    string certificateSubject?;
    string certificateStorePassword?;
};

# Complete list of the SSL properties you can configure in the connection string for this provider.
#
# + enableSsl - Enable configuring SSL properties 
# + sslClientCert - The TLS/SSL client certificate store for SSL Client Authentication (2-way SSL)  
# + sslClientCertType - The type of key store containing the TLS/SSL client certificate   
# + sslClientCertPassword - The password for the TLS/SSL client certificate  
# + sslClientCertSubject - The subject of the TLS/SSL client certificate  
# + sslServerCert - The certificate to be accepted from the server when connecting using TLS/SSL
public type SSL record {
    boolean enableSsl?;
    string sslClientCert?;
    string sslClientCertType?;
    string sslClientCertPassword?;
    string sslClientCertSubject?;
    string sslServerCert?;
};

# Complete list of the Firewall properties you can configure in the connection string for this provider.
#
# + enableFirewall - Enable configuring Firewall properties 
# + firewallType - Field Description  
# + firewallServer - The name or IP address of a proxy-based firewall  
# + firewallPort - The TCP port for a proxy-based firewall    
# + firewallUser - The user name to use to authenticate with a proxy-based firewall  
# + firewallPassword - A password used to authenticate to a proxy-based firewall
public type Firewall record {
    boolean enableFirewall?;
    string firewallType?;
    string firewallServer?;
    int firewallPort?;
    string firewallUser?;
    string firewallPassword?;
};

# Complete list of the Proxy properties you can configure in the connection string for this provider.
#
# + enableProxy - Enable configuring Proxy properties 
# + proxyAutoDetect - This indicates whether to use the system proxy settings or not. This takes precedence over other proxy settings, so you'll need to set ProxyAutoDetect to FALSE in order use custom proxy settings  
# + proxyServer - The hostname or IP address of a proxy to route HTTP traffic through  
# + proxyPort - The TCP port the ProxyServer proxy is running on  
# + proxyAuthScheme - The authentication type to use to authenticate to the ProxyServer proxy  
# + proxyUser - A user name to be used to authenticate to the ProxyServer proxy  
# + proxyPassword - A password to be used to authenticate to the ProxyServer proxy  
# + proxySslType - The SSL type to use when connecting to the ProxyServer proxy  
# + proxyExceptions - A semicolon separated list of destination hostnames or IPs that are exempt from connecting through the ProxyServer
public type Proxy record {
    boolean enableProxy?;
    boolean proxyAutoDetect?;
    string proxyServer?;
    int proxyPort?;
    string proxyAuthScheme?;
    string proxyUser?;
    string proxyPassword?;
    string proxySslType?;
    string proxyExceptions?;
};

# Complete list of the Logging properties you can configure in the connection string for this provider.
#
# + enableLogging - Enable configuring Logging properties 
# + logFile - A filepath which designates the name and location of the log file  
# + verbosity - The verbosity level that determines the amount of detail included in the log file  
# + logModules - Core modules to be included in the log file  
# + maxLogFileSize - A string specifying the maximum size in bytes for a log file (for example, 10 MB)  
# + maxLogFileCount - A string specifying the maximum file count of log files
public type Logging record {
    boolean enableLogging?;
    string logFile?;
    string verbosity?;
    string logModules?;
    string maxLogFileSize?;
    string maxLogFileCount?;
};

# Complete list of the Schema properties you can configure in the connection string for this provider.
#
# + enableSchema - Enable configuring Schema properties 
# + location - A path to the directory that contains the schema files defining tables, views, and stored procedures  
# + browsableSchemas - This property restricts the schemas reported to a subset of the available schemas. For example, BrowsableSchemas=SchemaA,SchemaB,SchemaC  
# + tables - This property restricts the tables reported to a subset of the available tables. For example, Tables=TableA,TableB,TableC  
# + views - Restricts the views reported to a subset of the available tables. For example, Views=ViewA,ViewB,ViewC
public type Schema record {
    boolean enableSchema?;
    string location?;
    string browsableSchemas?;
    string tables?;
    string views?;
};

# Complete list of the Caching properties you can configure in the connection string for this provider.
#
# + enableCaching - Enable configuring Caching properties 
# + autoCache - Automatically caches the results of SELECT queries into a cache database specified by either CacheLocation or both of CacheConnection and CacheProvider  
# + cacheDriver - The database driver to be used to cache data  
# + cacheConnection - The connection string for the cache database. This property is always used in conjunction with CacheProvider . Setting both properties will override the value set for CacheLocation for caching data  
# + cacheLocation - Specifies the path to the cache when caching to a file  
# + cacheTolerance - The tolerance for stale data in the cache specified in seconds when using AutoCache   
# + offline - Use offline mode to get the data from the cache instead of the live source  
# + cacheMetadata - This property determines whether or not to cache the table metadata to a file store
public type Caching record {
    boolean enableCaching?;
    boolean autoCache?;
    string cacheDriver?;
    string cacheConnection?;
    string cacheLocation?;
    int cacheTolerance?;
    boolean offline?;
    boolean cacheMetadata?;
};

# Complete list of the Miscellaneous properties you can configure in the connection string for this provider.
#
# + enableMiscellaneous - Enable configuring Miscellaneous properties 
# + batchSize - The maximum size of each batch operation to submit  
# + connectionLifeTime - The maximum lifetime of a connection in seconds. Once the time has elapsed, the connection object is disposed  
# + connectOnOpen - This property species whether to connect to the JIRA when the connection is opened  
# + includeCustomFields - A boolean indicating if you would like to include custom fields in the column listing  
# + maxRows - Limits the number of rows returned rows when no aggregation or group by is used in the query. This helps avoid performance issues at design time  
# + maxThreads - Specifies the number of concurrent requests  
# + other - These hidden properties are used only in specific use cases  
# + pageSize - The maximum number of results to return per page from JIRA  
# + poolIdleTimeout - The allowed idle time for a connection before it is closed  
# + poolMaxSize - The maximum connections in the pool  
# + poolMinSize - The minimum number of connections in the pool  
# + poolWaitTime - The max seconds to wait for an available connection  
# + pseudoColumns - This property indicates whether or not to include pseudo columns as columns to the table  
# + 'readonly - Field Description  
# + rtk - The runtime key used for licensing  
# + supportEnhancedSql - This property enhances SQL functionality beyond what can be supported through the API directly, by enabling in-memory client-side processing  
# + timeout - The value in seconds until the timeout error is thrown, canceling the operation  
# + timezone - Specify the timezone of the Jira instance in order to use the datetime filters accordingly and retrieve the results according to your timezone. An example of a timezone would be America/New_York  
# + useConnectionPooling - This property enables connection pooling  
# + useDefaultOrderBy - Indicates if a default order by should be applied if none is specified in the query
public type Miscellaneous record {
    boolean enableMiscellaneous?;
    int batchSize?;
    int connectionLifeTime?;
    boolean connectOnOpen?;
    boolean includeCustomFields?;
    int maxRows?;
    string maxThreads?;
    string other?;
    int pageSize?;
    int poolIdleTimeout?;
    int poolMaxSize?;
    int poolMinSize?;
    int poolWaitTime?;
    string pseudoColumns?;
    boolean 'readonly?;
    string rtk?;
    boolean supportEnhancedSql?;
    int timeout?;
    string timezone?;
    boolean useConnectionPooling?;
    boolean useDefaultOrderBy?;
};

# Represents the properties which are used to configure DB connection pool.
#
# + enablePooling - Enable configuring connection pooling properties 
# + maxOpenConnections - The maximum number of open connections that the pool is allowed to have, including both 
#                        idle and in-use connections. Default value is 15
# + maxConnectionLifeTime - The maximum lifetime (in seconds) of a connection in the pool. 
#                           Default value is 1800 seconds (30 minutes)
# + minIdleConnections - The minimum number of idle connections that pool tries to maintain in the pool. 
#                        Default is the same as maxOpenConnections
public type Pooling record {
    boolean enablePooling?;
    int maxOpenConnections?;
    decimal maxConnectionLifeTime?;
    int minIdleConnections?;
};

// OAuth Connection String Options

public enum InitiateOAuth {
    OFF,
    GETANDREFRESH,
    REFRESH
}

// Firewall Connection String Options

public enum FirewallType {
    NONE,
    TUNNEL,
    SOCKS4,
    SOCKS5
}

// Proxy Connection String Options

public enum ProxyAuthScheme {
    BASIC,
    DIGEST,
    NEGOTIATE,
    PROPRIETARY
}
