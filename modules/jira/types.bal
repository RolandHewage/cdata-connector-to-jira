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

# Client configuration.
#
# + basicAuth - Field Description  
public type JiraConfig record {
    JiraBasicAuth basicAuth;
    *cdata:CommonConfig;
};

# Basic authentication.
#
# + hostBasicAuth - JIRA account basic authentication    
# + url - The URL to your JIRA endpoint  
public type JiraBasicAuth record {
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
