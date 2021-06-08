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

# Client configuration.
#
# + basicAuth - Field Description  
public type Configuration record {
    BasicAuth basicAuth;
    *Security;
    *Caching;
    *ConnectionPooling;
    *Advance;
};

# Basic authentication.
#
# + hostBasicAuth - JIRA account basic authentication  
# + url - The URL to your JIRA endpoint  
public type BasicAuth record {
    CloudBasicAuth|ServerBasicAuth hostBasicAuth;
    string url;
};

# JIRA Cloud account basic authentication.
#
# + user - The JIRA user account used to authenticate  
# + apiToken - APIToken of the currently authenticated user  
public type CloudBasicAuth record {
    string user;
    string apiToken;
};

# JIRA Server account basic authentication.
#
# + user - The JIRA user account used to authenticate  
# + password - The password used to authenticate the user 
public type ServerBasicAuth record {
    string user;
    string password;
};


# Complete list of the SSO properties you can configure in the connection string for this provider.
#
# + loginUrl - The identity provider's login URL
# + properties - Additional properties required to connect to the identity provider in a semicolon-separated list
# + exchangeUrl - The url used for consuming the SAML response and exchanging it with JIRA specific credentials
public type Sso record {
    string loginUrl?;
    string properties?;
    string exchangeUrl?;
};

# Complete list of the SSL properties you can configure in the connection string for this provider.
#
# + clientCert - The TLS/SSL client certificate store for SSL Client Authentication (2-way SSL)
# + clientCertType - The type of key store containing the TLS/SSL client certificate 
# + clientCertPassword - The password for the TLS/SSL client certificate
# + clientCertSubject - The subject of the TLS/SSL client certificate
# + serverCert - The certificate to be accepted from the server when connecting using TLS/SSL
public type Ssl record {
    string clientCert?;
    string clientCertType?;
    string clientCertPassword?;
    string clientCertSubject?;
    string serverCert?;
};




public type Security record {
    string ssoProperties?;
    string sslServerCert?;
};

public type Caching record {
    boolean autoCacheEnabled?;
    string cacheConnection?;
    string cacheDriver?;
    string cacheLocation?;
    boolean cacheMetadata?;
    string cacheTolerance?;
};

public type ConnectionPooling record {
    boolean poolingEnabled?;
    int maxOpenConnections?;
    decimal maxConnectionLifeTime?;
    int minIdleConnections?;
};

public type Advance record {
    int queryTimeout?;
    int maxRows?;
    int batchSize?;
};
