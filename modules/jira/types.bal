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

import cdata;

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

# Projects table representation in Jira.
#
# + Id - The Id of the project 
# + Key - The key of the project 
# + Name - The name of the project 
# + Description - The description of the project 
# + LeadEmailAddress - The email address of the project lead 
# + LeadDisplayName - The display name of the project lead
# + ComponentsAggregate - The components of the project 
# + IssueTypesAggregate - The issue types of the project
# + Url - The URL of the project
# + Email - The email of the project
# + AssigneeType - The assignee type of the project
# + VersionsAggregate - The versions of the project 
# + RolesAggregate - The roles of the project  
# + ProjectKeysAggregate - The project keys of the project 
# + ProjectCategoryId - The Id of the project category  
# + ProjectCategoryName - The name of the project category
# + ProjectCategoryDescription - The description of the project category
# + ProjectTypeKey - The key of the project type. Not applicable for update
# + LeadAccountId - The Id of the project lead
# + LeadAccountKey - The Key of the project lead
# + LeadAccountName - The user name of the project lead
public type Projects record {
    readonly int Id?;
    string Key?;
    string Name?;
    string Description?;
    readonly string LeadEmailAddress?;
    readonly string LeadDisplayName?;
    readonly string ComponentsAggregate?;
    readonly string IssueTypesAggregate?;
    readonly string Url?;
    readonly string Email?;
    string AssigneeType?;
    readonly string VersionsAggregate?;
    readonly string RolesAggregate?;
    readonly string ProjectKeysAggregate?;
    string ProjectCategoryId?;
    readonly string ProjectCategoryName?;
    readonly string ProjectCategoryDescription?;
    string ProjectTypeKey?;
    string LeadAccountId?;
    readonly string LeadAccountKey?;
    string LeadAccountName?;
};

# Project Components table representation in Jira.
#
# + Id - The Id of the component
# + ProjectId - The selected project's id 
# + ProjectKey - The selected project's key 
# + Name - The name of the component
# + Description - The description of the component
# + LeadDisplayName - The display name of the component's lead
# + LeadKey - The key of the component's lead 
# + AssigneeType - The type of the component's default assignee. 
#                  The allowed values are PROJECT_DEFAULT, COMPONENT_LEAD, PROJECT_LEAD, UNASSIGNED.
# + AssigneeDisplayName - The display name of the component's default assignee 
# + AssigneeKey - The key of the component's default assignee
# + IsAssigneeTypeValid - Whether the assignee type is valid
public type ProjectComponents record {
    readonly int Id?;
    readonly int ProjectId?;
    string ProjectKey?;
    string Name?;
    string Description?;
    readonly string LeadDisplayName?;
    string LeadKey?;
    string AssigneeType?;
    readonly string AssigneeDisplayName?;
    readonly string AssigneeKey?;
    readonly boolean IsAssigneeTypeValid?;
};

# Project Versions table representation in Jira.
#
# + Id - The Id of the version 
# + ProjectId - The selected project's id
# + ProjectKey - The selected project's key
# + Name - The name of the version
# + Description - The description of the version
# + Released - Whether the version has been released
# + ReleaseDate - Release date of the version
# + StartDate - Optional start date of the version
# + Overdue - Whether the version is overdue for release
# + Archived - Whether the version has been archived. When a new version is created, this field is always set to False.
# + UserStartDate - User optional start date of the version
# + UserReleaseDate - User release date of the version
public type ProjectVersions record {
    readonly int Id?;
    int ProjectId?;
    string ProjectKey?;
    string Name?;
    string Description?;
    boolean Released?;
    string ReleaseDate?;
    string StartDate?;
    readonly boolean Overdue?;
    boolean Archived?;
    string UserStartDate?;
    string UserReleaseDate?;
};

# Issue Types table representation in Jira.
#
# + Id - The Id of the issue type
# + Name - The name of the issue type 
# + Description - The description of the issue type
# + Subtask - The subtask of the issue type. Not applicable for update.
# + IconUrl - The icon URL of the issue type
public type IssueTypes record {
    readonly string Id?;
    string Name?;
    string Description?;
    boolean Subtask?;
    readonly string IconUrl?;
};

# Roles table representation in Jira.
#
# + Id - The Id of the role  
# + Name - The name of the role
# + Description - The description of the role  
# + Actors - The list of users who act in this role
# + Scope - The scope of the role
# + IsAdmin - Whether this role is the admin role for the project  
# + IsDefault - Whether this role is the default role for the project
public type Roles record {
    int Id?;
    string Name?;
    string Description?;
    string Actors?;
    string Scope?;
    boolean IsAdmin?;
    boolean IsDefault?;
};

# Boards table representation in Jira.
#
# + Id - The Id of the board
# + Name - The name of the board 
# + Type - The type of the board. The allowed values are scrum, kanban, simple.
# + ProjectKeyOrId - Filter the agile boards based on the project they are located in
# + FilterId - ID of a filter that the user has permissions to view. Not supported for next-gen boards.
public type Boards record {
    readonly int Id?;
    string Name?;
    string Type?;
    string ProjectKeyOrId?;
    string FilterId?;
};

# Sprints table representation in Jira.
#
# + Id - The Id of the sprint
# + Name - The name of the sprint
# + State - The state of the sprint. A newly created sprint starts in the 'future' state. The state can only transition 
#           from 'future' to 'active', and from 'active' to 'closed'. The allowed values are future, active, closed.
# + Goal - The goal assigned for the sprint 
# + OriginBoardId - The board Id the sprint originated from. This field cannot be updated
# + StartDate - The date when the sprint was started
# + EndDate - The date when the sprint has ended
# + CompleteDate - The date when the sprint was completed 
public type Sprints record {
    readonly int Id?;
    string Name?;
    string State?;
    string Goal?;
    int OriginBoardId?;
    string StartDate?;
    string EndDate?;
    readonly string CompleteDate?;
};
