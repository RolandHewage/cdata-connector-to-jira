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

# Issues table representation in Jira.
#
# + Id - The Id of the issue 
# + Key - The key of the issue
# + IssueTypeId - The issue type Id
# + IssueTypeName - The issue type name
# + ProjectId - The project Id of the issue 
# + ProjectName - The project name of the issue
# + ProjectKey - The project key of the issue
# + ParentId - The Id of the issue's parent if the issue is a subtask
# + ParentKey - The key of the issue's parent if the issue is a subtask
# + ResolutionId - The resolution Id of the issue
# + ResolutionName - The resolution name of the issue
# + ResolutionDescription - The resolution description of the issue
# + ResolutionDate - The resolution date of the issue
# + Workratio - The work ratio of the issue
# + LastViewed - The last time that the issue was viewed
# + WatchCount - The number of watches of the issue
# + IsWatching - Whether the currently authenticated user is watching the issue
# + Created - The creation date of the issue
# + PriorityId - The priority Id of the issue
# + PriorityName - The priority name of the issue
# + TimeSpentSeconds - The time spent in seconds on the issue
# + TimeSpent - The time spent on the issue
# + RemainingEstimateSeconds - The time estimate in seconds of the issue
# + RemainingEstimate - The time estimate of the issue
# + OriginalEstimateSeconds - The original time estimate in seconds of the issue
# + OriginalEstimate - The original time estimate of the issue
# + AggregateTimeSpent - The aggregate time spent of the issue
# + AggregateTimeOriginalEstimate - The original aggregate time estimate of the issue
# + AggregateTimeEstimate - The aggregate time estimate of the issue
# + AssigneeDisplayName - Assignee display name
# + AssigneeKey - The assignee key of the issue
# + AssigneeName - The assignee name of the issue
# + AssigneeEmail - The assignee email of the issue
# + Updated - The updated date of the issue
# + StatusId - The status Id of the issue
# + StatusName - The status name of the issue
# + Description - The description of the issue
# + Summary - The summary of the issue
# + CreatorDisplayName - Issue creator display name
# + CreatorName - The creator name of the issue
# + CreatorKey - The creator key of the issue
# + CreatorEmail - The creator email of the issue 
# + ReporterDisplayName - Issue reporter display name
# + ReporterName - The reporter name of the issue
# + ReporterKey - The reporter key of the issue
# + ReporterEmail - The reporter email of the issue
# + AggregateProgress - The aggregate progress of the issue
# + TotalProgress - The aggregate total progress of the issue 
# + Votes - Votes of the issue
# + HasVotes - The vote status of the issue
# + DueDate - The due date of the issue
# + Labels - The labels of an issue
# + Environment - The environment of an issue
# + SecurityLevel - The security level of an issue
# + FixVersionsAggregate - The fix versions of the issue
# + ComponentsAggregate - Aggregate list of components included in the issue
# + IssueLinksAggregate - The issue links of the issue
# + AffectedVersionsAggregate - The affected versions of the issue
# + SubtasksAggregate - The subtasks of the issue
# + AssigneeAccountId - The account ID of the assignee
public type Issues record {
    readonly int Id?;
    readonly string Key?;
    string IssueTypeId?;
    readonly string IssueTypeName?;
    string ProjectId?;
    readonly string ProjectName?;
    string ProjectKey?;
    int ParentId?;
    readonly string ParentKey?;
    readonly string ResolutionId?;
    readonly string ResolutionName?;
    readonly string ResolutionDescription?;
    readonly string ResolutionDate?;
    readonly int Workratio?;
    readonly string LastViewed?;
    readonly int WatchCount?;
    readonly boolean IsWatching?;
    readonly string Created?;
    string PriorityId?;
    readonly string PriorityName?;
    readonly int TimeSpentSeconds?;
    readonly string TimeSpent?;
    readonly int RemainingEstimateSeconds?;
    string RemainingEstimate?;
    readonly int OriginalEstimateSeconds?;
    string OriginalEstimate?;
    readonly int AggregateTimeSpent?;
    readonly int AggregateTimeOriginalEstimate?;
    readonly int AggregateTimeEstimate?;
    readonly string AssigneeDisplayName?;
    readonly string AssigneeKey?;
    string AssigneeName?;
    readonly string AssigneeEmail?;
    readonly string Updated?;
    readonly string StatusId?;
    readonly string StatusName?;
    string Description?;
    string Summary?;
    readonly string CreatorDisplayName?;
    readonly string CreatorName?;
    readonly string CreatorKey?;
    readonly string CreatorEmail?;
    readonly string ReporterDisplayName?;
    string ReporterName?;
    readonly string ReporterKey?;
    readonly string ReporterEmail?;
    readonly int AggregateProgress?;
    readonly int TotalProgress?;
    readonly int Votes?;
    readonly boolean HasVotes?;
    string DueDate?;
    string Labels?;
    string Environment?;
    string SecurityLevel?;
    string FixVersionsAggregate?;
    string ComponentsAggregate?;
    string IssueLinksAggregate?;
    string AffectedVersionsAggregate?;
    readonly string SubtasksAggregate?;
    string AssigneeAccountId?; // Not available in docs
};

# Comments table representation in Jira.
#
# + Id - The Id of the comment
# + IssueId - The Id of the issue
# + IssueKey - The key of the issue
# + IssueCreatedDate - The date the comment's issue was created 
# + IssueUpdatedDate - The date the comment's issue was last updated 
# + AuthorDisplayName - The display name of the author who made the comment
# + AuthorEmail - The email address of the author who made the comment
# + UpdateDisplayName - The display name of the author who changed the comment 
# + UpdateAuthorEmail - The email address of the author who edited the comment
# + Body - The body of the comment
# + RenderedBody - The rendered body of the comment 
# + Created - The date the comment was created
# + Updated - The date the comment was updated
# + VisibilityType - The visibility type of the comment
# + VisibilityValue - The visibility value of the comment
# + AuthorAccountName - The name of the author who made the comment
# + AuthorAccountKey - The key of the author who made the comment
# + UpdateAuthorAccountKey - The Id of the author who edited the comment
# + UpdateAuthorAccountName - The name of the author who edited the comment
# + AuthorAccountId - The name of the author who made the comment
# + UpdateAuthorAccountId - The Id of the author who edited the comment  
public type Comments record {
    readonly int Id?;
    int IssueId ?;
    string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string AuthorDisplayName?;
    readonly string AuthorEmail?;
    readonly string UpdateDisplayName?;
    readonly string UpdateAuthorEmail?;
    string Body?;
    readonly string RenderedBody?;
    readonly string Created?;
    readonly string Updated?;
    string VisibilityType?;
    string VisibilityValue?;
    readonly string AuthorAccountName?;
    readonly string AuthorAccountKey?;
    readonly string UpdateAuthorAccountKey?;
    readonly string UpdateAuthorAccountName?;
    readonly string AuthorAccountId?;
    readonly string UpdateAuthorAccountId?;
};

# Users table representation in Jira.
#
# + GroupName - The group the user is part of
# + DisplayName - The display name of the user
# + EmailAddress - The email address of the user
# + Active - Indicates whether the user is active
# + TimeZone - The time zone specified in the user's profile
# + Locale - The locale of the user
# + AccountId - The accountId of the user, which uniquely identifies the user across all Atlassian products 
# + AccountType - The accountType of the user
# + Key - The key of the user
# + Name - The name of the user
public type Users record {
    readonly string GroupName?;
    string DisplayName?;
    string EmailAddress?;
    readonly boolean Active?;
    readonly string TimeZone?;
    readonly string Locale?;
    readonly string AccountId?;
    string AccountType?;
    readonly string Key?;
    string Name?;
};

# Attachments table representation in Jira.
#
# + Id - The Id of the attachment
# + IssueId - The Id of the issue
# + IssueKey - The key of the issue
# + IssueCreatedDate - The date the attachment's issue was created 
# + IssueUpdatedDate - The date the attachment's issue was last updated
# + Filename - The filename of the attachment
# + AuthorName - The name of the author of the attachment
# + AuthorDisplayName - The display name of the author of the attachment
# + Created - The creation date of the attachment
# + Size - The size of the attachment
# + MimeType - The MIME type of the attachment
# + Content - The URI of the actual attached file
# + Thumbnail - The thumbnail of the attachment
# + AuthorAccountId - The account Id of the author of the attachment
# + AuthorKey - The author key of the attachment
public type Attachments record {
    int Id?;
    int IssueId?;
    string IssueKey?;
    string IssueCreatedDate?;
    string IssueUpdatedDate?;
    string Filename?;
    string AuthorName?;
    string AuthorDisplayName?;
    string Created?;
    int Size?;
    string MimeType?;
    string Content?;
    string Thumbnail?;
    string AuthorAccountId?;
    string AuthorKey?;
};

// Views

# AdvancedSettings view representation in Jira. The application properties that are accessible on the Advanced Settings page. 
#
# + Id - The ID of the application property
# + Name - The name of the application property
# + Description - The description of the application property
# + Type - The data type of the application property
# + Value - The new value
# + DefaultValue - The default value of the application property
# + AllowedValues - The allowed values, if applicable
public type AdvancedSettings record {
    readonly string Id?;
    readonly string Name?;
    readonly string Description?;
    readonly string Type?;
    readonly string Value?;
    readonly string DefaultValue?;
    readonly string AllowedValues?;
};

# ApplicationRoles view representation in Jira. All application roles. 
# In Jira, application roles are managed using the Application access configuration page. 
#
# + Key - The key of the application role
# + Name - The display name of the application role
# + Groups - The groups associated with the application role
# + DefaultGroups - The groups that are granted default access for this application role
# + SelectedByDefault - Determines whether this application role should be selected by default on user creation
# + NumberOfSeats - The maximum count of users on your license
# + RemainingSeats - The count of users remaining on your license
# + UserCount - The number of users counting against your license
# + UserCountDescription - The type of users being counted against your license
# + HasUnlimitedSeats - Determines whether this application role has unlimited seats
# + Platform - Indicates if the application role belongs to Jira platform (jira-core)
public type ApplicationRoles record {
    readonly string Key?;
    readonly string Name?;
    readonly string Groups?;
    readonly string DefaultGroups?;
    readonly boolean SelectedByDefault?;
    readonly int NumberOfSeats?;
    readonly int RemainingSeats?;
    readonly int UserCount?;
    readonly string UserCountDescription?;
    readonly boolean HasUnlimitedSeats?;
    readonly boolean Platform?;
};

# Audit view representation in Jira. The audit log of your JIRA account. 
#
# + RecordId - The Id of the audit record 
# + Summary - Summary of the change
# + RemoteAddress - The remote address of the record
# + AuthorKey - Key of the author that made the change
# + Created - Date on when the change was made
# + Category - Category of the change
# + EventSource - What triggered the event
# + Description - Description of the change
# + ItemId - Unique identifier of the object item
# + ItemName - Name of the object item
# + ItemTypeName - Typename of the object item 
# + ItemParentId - Identifier of the parent of the object item
# + ItemParentName - Parent name of the object item
# + FieldName - The name of the changed field
# + ChangedFrom - The updated value
# + ChangedTo - The previous value
public type Audit record {
    readonly int RecordId?;
    readonly string Summary?;
    readonly string RemoteAddress?;
    readonly string AuthorKey?;
    readonly string Created?;
    readonly string Category?;
    readonly string EventSource?;
    readonly string Description?;
    readonly string ItemId?;
    readonly string ItemName?;
    readonly string ItemTypeName?;
    readonly string ItemParentId?;
    readonly string ItemParentName?;
    readonly string FieldName?;
    readonly string ChangedFrom?;
    readonly string ChangedTo?;
};

# BoardIssues view representation in Jira. The agile Board Issues in Jira. 
#
# + Id - The Id of the issue
# + Key - The key of the issue
# + BoardId - The board the issue is included in
# + IssueTypeId - The issue type Id
# + IssueTypeName - The issue type name
# + StatusId - The issue status Id
# + StatusName - The issue status name
# + ProjectId - The project Id of the issue
# + ProjectKey - The project key of the issue
# + ProjectName - The project name of the issue
# + ClosedSprintsAggregate - The issue's previous sprints that have been closed
# + Created - The creation date of the issue
# + Updated - The updated date of the issue
public type BoardIssues record {
    readonly int Id?;
    readonly string Key?;
    readonly int BoardId?;
    readonly string IssueTypeId?;
    readonly string IssueTypeName?;
    readonly int StatusId?;
    readonly string StatusName?;
    readonly int ProjectId?;
    readonly string ProjectKey?;
    readonly string ProjectName?;
    readonly string ClosedSprintsAggregate?;
    readonly string Created?;
    readonly string Updated?;
};

# BoardSprints view representation in Jira. The agile Sprints related to a Jira Board. 
#
# + Id - The Id of the sprint
# + BoardId - The board Id the sprint is in 
# + Name - The name of the sprint
# + State - The state of the sprint. The sprint state can only transition from 'future' to 'active', and 
#           from 'active' to 'close'. The allowed values are future, active, closed. 
# + Goal - The goal assigned for the sprint
# + OriginBoardId - The board Id the sprint originated from. This field cannot be updated 
# + StartDate - The date when the sprint was started
# + EndDate - The date when the sprint has ended
# + CompleteDate - Field Description  
public type BoardSprints record {
    readonly int Id?;
    readonly int BoardId?;
    readonly string Name?;
    readonly string State?;
    readonly string Goal?;
    readonly int OriginBoardId?;
    readonly string StartDate?;
    readonly string EndDate?;
    readonly string CompleteDate?;
};

# Configuration view representation in Jira. The available Configurations in JIRA. 
#
# + VotingEnabled - Configuration for voting
# + WatchingEnabled - Configuration for watching
# + UnassignedIssuesAllowed - Configuration to allow unassigned issues 
# + SubTasksEnabled - Configuration to enable subtasks
# + IssueLinkingEnabled - Configuration to enable issue linking
# + TimeTrackingEnabled - Configuration to enable time tracking 
# + AttachmentsEnabled - Configuration to enable attachments
# + WorkingHoursPerDay - Configuration of the working hours per day
# + WorkingDaysPerWeek - Configuration of the working days per week
# + TimeFormat - Configuration of the time format
# + DefaultUnit - Configuration of the default unit
public type Configuration record {
    readonly boolean VotingEnabled?;
    readonly boolean WatchingEnabled?;
    readonly boolean UnassignedIssuesAllowed?;
    readonly boolean SubTasksEnabled?;
    readonly boolean IssueLinkingEnabled?;
    readonly boolean TimeTrackingEnabled?;
    readonly boolean AttachmentsEnabled?;
    readonly float WorkingHoursPerDay?;
    readonly float WorkingDaysPerWeek?;
    readonly string TimeFormat?;
    readonly string DefaultUnit?;
};

# Dashboards view representation in Jira. The available Dashboards in JIRA. 
#
# + Id - The Id of the dashboard
# + Name - The name of the dashboard
# + View - The view URL of the dashboard
public type Dashboards record {
    readonly string Id?;
    readonly string Name?;
    readonly string View?;
};

# Epics view representation in Jira. All the Epics. 
#
# + Id - The Id of the Epic
# + Key - The key of the Epic
# + BoardId - The board Id the Epic is in
# + Name - The name of the Epic
# + Done - Whether or not the Epic is done. The allowed values are true, false.
# + ColorKey - The key of the Epic's color 
# + Summary - A brief summary for the Epic
public type Epics record {
    readonly int Id?;
    readonly string Key?;
    readonly int BoardId?;
    readonly string Name?;
    readonly boolean Done?;
    readonly string ColorKey?;
    readonly string Summary?;
};

# FavouriteFilters view representation in Jira. The favourite Filters in JIRA. 
#
# + Id - The Id of the favourite filter
# + Name - The name assigned to the favourite filter
# + JQLExpression - The JQL by which the favourite filter will search issues by
# + Description - The description given to the favourite filter
# + OwnerDisplayName - The display name of the user who owns the favourite filter
# + OwnerAccountId - The account ID of the user who owns the favourite filter
# + Count - How many users have this filter as a favourite
# + OwnerKey - The key of the user who owns the favourite filter
public type FavouriteFilters record {
    readonly int Id?;
    readonly string Name?;
    readonly string JQLExpression?;
    readonly string Description?;
    readonly string OwnerDisplayName?;
    readonly string OwnerAccountId?;
    readonly int Count?;
    readonly string OwnerKey?;
};

# Fields view representation in Jira. The available System and Custom Fields in JIRA. 
#
# + Id - The Id of the field
# + Key - The key of the field
# + Name - The name of the field
# + Custom - A boolean indicating if the field is custom
# + Orderable - A boolean indicating if the field is orderable
# + Navigable - A boolean indicating if the field is navigable
# + Searchable - A boolean indicating if the field is searchable 
public type Fields record {
    readonly string Id?;
    readonly string Key?;
    readonly string Name?;
    readonly boolean Custom?;
    readonly boolean Orderable?;
    readonly boolean Navigable?;
    readonly boolean Searchable?;
};

# Filters view representation in Jira. The set up Filters in JIRA. 
#
# + Id - The Id of the filter
# + Name - The name assigned to the filter
# + JQLExpression - The JQL by which the filter will search issues by
# + Description - The description given to the filter
# + OwnerDisplayName - The board Id the sprint originated from
# + Favourite - Whether you have set this filter as a favourite
# + FavouritedCount - How many users have this filter as a favourite 
# + SubscriptionsAggregate - Collection of user subscriptions to the filter
# + SharePermissionsAggregate - Aggregate of share permissions to the filter 
public type Filters record {
    readonly string Id?;
    readonly string Name?;
    readonly string JQLExpression?;
    readonly string Description?;
    readonly string OwnerDisplayName?;
    readonly boolean Favourite?;
    readonly int FavouritedCount?;
    readonly string SubscriptionsAggregate?;
    readonly string SharePermissionsAggregate?;
};

# Groups view representation in Jira. The available Groups in JIRA. 
#
# + Name - The name of the group 
# + Html - The HTML of the group
# + LabelsAggregate - The labels of the group
public type Groups record {
    readonly string Name?;
    readonly string Html?;
    readonly string LabelsAggregate?;
};

# IssueAffectedVersions view representation in Jira. The Affected Versions of an issue in JIRA. 
#
# + VersionId - The Id of the affected version
# + IssueId - The issue Id of the affected version 
# + IssueKey - The issue key of the affected version
# + IssueCreatedDate - The date the affected version's issue was created
# + IssueUpdatedDate - The date the affected version's issue was last updated
# + Name - The name of the affected version
# + Archived - A boolean indicating if the affected is archived
# + Released - A boolean indicating if the affected is released
# + ReleaseDate - The release date
public type IssueAffectedVersions record {
    readonly string VersionId?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string Name?;
    readonly boolean Archived?;
    readonly boolean Released?;
    readonly string ReleaseDate?;
};

# IssueChangelogs view representation in Jira. The available IssueChangelogs in JIRA. 
#
# + HistoryId - Field Description  
# + IssueId - Field Description  
# + IssueKey - Field Description  
# + Created - Field Description  
# + IssueCreatedDate - Field Description  
# + IssueUpdatedDate - Field Description  
# + ItemField - Field Description  
# + ItemFieldType - Field Description  
# + ItemFrom - Field Description  
# + ItemFromString - Field Description  
# + ItemTo - Field Description  
# + ItemToString - Field Description  
# + AuthorDisplayName - Field Description  
# + AuthorAccountId - Field Description  
# + AuthorName - Field Description  
# + AuthorAccountKey - Field Description  
# + AuthorAccountName - Field Description  
public type IssueChangelogs record {
    readonly int HistoryId?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string Created?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string ItemField?;
    readonly string ItemFieldType?;
    readonly string ItemFrom?;
    readonly string ItemFromString?;
    readonly string ItemTo?;
    readonly string ItemToString?;
    readonly string AuthorDisplayName?;
    readonly string AuthorAccountId?;
    readonly string AuthorName?;
    readonly string AuthorAccountKey?;
    readonly string AuthorAccountName?;
};

# IssueComponents view representation in Jira. The available IssueComponents in JIRA. 
#
# + Id - The Id of the component
# + Name - The name of the component
# + IssueId - The issue Id of the component
# + IssueKey - The issue key of the component
# + IssueCreatedDate - The date the component's issue was created
# + IssueUpdatedDate - The date the component's issue was last updated
# + Description - The description of the component
public type IssueComponents record {
    readonly string Id?;
    readonly string Name?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string Description?;
};

# IssueCustomFieldOptions view representation in Jira. Issue Custom Field Options in JIRA. 
#
# + Id - The ID of the custom field option
# + CustomFieldId - The ID of the custom field
# + Name - The name of the custom field option
public type IssueCustomFieldOptions record {
    readonly int Id?;
    readonly int CustomFieldId?;
    readonly string Name?;
};

# IssueCustomFields view representation in Jira. The available Custom Fields in JIRA. 
#
# + Id - The Id of the custom field
# + Key - The key of the custom field
# + CustomId - The custom ID of the field
# + Name - The name of the custom field
# + CDataName - The name of the custom field on the Issues table provided by CData, when IncludeCustomFields=true
# + Orderable - A boolean indicating if the field is orderable
# + Navigable - A boolean indicating if the field is navigable
# + Searchable - A boolean indicating if the field is searchable
public type IssueCustomFields record {
    readonly string Id?;
    readonly string Key?;
    readonly int CustomId?;
    readonly string Name?;
    readonly string CDataName?;
    readonly boolean Orderable?;
    readonly boolean Navigable?;
    readonly boolean Searchable?;
};

# IssueFixVersions view representation in Jira. The available IssueFixVersions in JIRA.  
#
# + VersionId - The Id of the fix version
# + IssueId - The issue Id of the fix version
# + IssueKey - The issue key of the fix version
# + IssueCreatedDate - The date the fix version's issue was created
# + IssueUpdatedDate - The date the fix version's issue was last updated
# + Name - The name of the fix version
# + Archived - A boolean indicating if the fix is archived
# + Released - A boolean indicating if the fix is released
# + ReleaseDate - The release date
public type IssueFixVersions record {
    readonly string VersionId?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string Name?;
    readonly boolean Archived?;
    readonly boolean Released?;
    readonly string ReleaseDate?;
};

# IssueLinks view representation in Jira. The available IssueLinks in JIRA. 
#
# + Id - The Id of the link 
# + InwardIssueId - The Id of the issue targeting this issue in the link
# + InwardIssueKey - The Key of the issue targeting this issue in the link
# + OutWardIssueId - The Id of the issue this link is targeting 
# + OutwardIssueKey - The Key of the issue this link is targeting
# + IssueId - The link's original issue Id
# + IssueKey - The link's original issue Key
# + IssueCreatedDate - The date the link's issue was created
# + IssueUpdatedDate - The date the links's issue was last updated
# + TypeId - The Id of the link type
# + TypeName - The Name of the link type
public type IssueLinks record {
    readonly string Id?;
    readonly int InwardIssueId?;
    readonly string InwardIssueKey?;
    readonly int OutWardIssueId?;
    readonly string OutwardIssueKey?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string TypeId?;
    readonly string TypeName?;
};

# IssueLinkTypes view representation in Jira. All the issue link types. 
#
# + Id - Unique identifier of the issue link type
# + Name - The name of the issue link type
# + Inward - The description of the issue link type inward link
# + Outward - The description of the issue link type outward link
public type IssueLinkTypes record {
    readonly string Id?;
    readonly string Name?;
    readonly string Inward?;
    readonly string Outward?;
};

# IssueNavigatorDefaultColumns view representation in Jira. The default issue navigator columns.
#
# + Label - The issue navigator column label 
# + Value - The issue navigator column value
public type IssueNavigatorDefaultColumns record {
    readonly string Label?;
    readonly string Value?;
};

# IssuePriorities view representation in Jira. The list of all issue priorities.
#
# + Id - The ID of the issue priority
# + Name - The name of the issue priority
# + Description - The description of the issue priority
# + URL - The URL of the issue priority
# + StatusColor - The color used to indicate the issue priority
# + IconUrl - The URL of the icon for the issue priority
public type IssuePriorities record {
    readonly string Id?;
    readonly string Name?;
    readonly string Description?;
    readonly string URL?;
    readonly string StatusColor?;
    readonly string IconUrl?;
};

# IssueResolutions view representation in Jira. The list of all issue resolution values. 
#
# + Id - The ID of the issue resolution
# + Name - The name of the issue resolution 
# + Description - The description of the issue resolution
# + URL - The URL of the issue resolution
public type IssueResolutions record {
    readonly string Id?;
    readonly string Name?;
    readonly string Description?;
    readonly string URL?;
};

# IssueSubtasks view representation in Jira. The available IssueSubtasks in JIRA. 
#
# + SubtaskId - The Id of the subtask
# + SubtaskKey - The key of the subtask 
# + IssueId - The Id of the parent issue
# + IssueKey - The key of the parent issue
# + IssueCreatedDate - The date the subtask's issue was created
# + IssueUpdatedDate - The date the subtask's issue was last updated
# + Summary - The summary of the subtask
# + TypeId - The issue type Id of the subtask
# + TypeName - The issue type name of the subtask
# + TypeDescription - The issue type description of the subtask
# + TypeSubtask - A boolean indicating if the issue is a subtask
# + PriorityId - The priority Id of the subtask
# + PriorityName - The priority name of the subtask
# + StatusId - The status Id of the subtask
public type IssueSubtasks record {
    readonly string SubtaskId?;
    readonly string SubtaskKey?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string Summary?;
    readonly string TypeId?;
    readonly string TypeName?;
    readonly string TypeDescription?;
    readonly boolean TypeSubtask?;
    readonly string PriorityId?;
    readonly string PriorityName?;
    readonly string StatusId?;
};

# IssueTransitions view representation in Jira. The available IssueTransitions in JIRA. 
#
# + Id - The Id of the transition
# + IssueId - The Id of the issue
# + IssueKey - The key of the issue
# + IssueCreatedDate - The date the transition's issue was created
# + IssueUpdatedDate - The date the transition's issue was last updated
# + HasScreen - Whether the transition has a screen
# + Name - The name of the transition
# + ToDescription - The description of the status the issue is transitioning to 
# + ToId - The Id of the status the issue is transitioning to
# + ToName - The name of the status the issue is transitioning to
# + StatusCategoryId - The status category Id of the transition
# + StatusCategoryKey - The status category key of the transition
# + StatusCategoryName - The status category name of the transition
public type IssueTransitions record {
    readonly string Id?;
    readonly int IssueId?;
    readonly string IssueKey?;
    readonly string IssueCreatedDate?;
    readonly string IssueUpdatedDate?;
    readonly string HasScreen?;
    readonly string Name?;
    readonly string ToDescription?;
    readonly string ToId?;
    readonly string ToName?;
    readonly string StatusCategoryId?;
    readonly string StatusCategoryKey?;
    readonly string StatusCategoryName?;
};

# MyPermissions view representation in Jira. The available Permissions of the current user in JIRA. 
#
# + Id - The Id of the permission
# + Key - The key of the permission
# + Name - The name of the permission
# + Type - The type of the permission
# + Description - The description of the permission
# + HavePermission - Boolean indicating if the permission is set or not
# + DeprecatedKey - Boolean indicating if the permission is deprecated
# + Permissions - Permissions as comma seperated values
public type MyPermissions record {
    readonly int Id?;
    readonly string Key?;
    readonly string Name?;
    readonly string Type?;
    readonly string Description?;
    readonly boolean HavePermission?;
    readonly boolean DeprecatedKey?;
    readonly string Permissions?;
};

# Permissions view representation in Jira. The available Permissions in JIRA. 
#
# + Key - The key of the permission
# + Name - The name of the permission
# + Type - The type of the permission
# + Description - The description of the permission
public type Permissions record {
    readonly string Key?;
    readonly string Name?;
    readonly string Type?;
    readonly string Description?;
};

# ProjectCategories view representation in Jira. All the project categories. 
#
# + Id - Unique identifier of the project category
# + Name - Name of the project category
# + Description - Description of the project category
# + Link - Link to this project category
public type ProjectCategories record {
    readonly int Id?;
    readonly string Name?;
    readonly string Description?;
    readonly string Link?;
};

# ProjectRoles view representation in Jira. Roles for all projects in JIRA. 
#
# + RoleId - The Id of the role
# + RoleName - The name of the role 
# + ProjectId - The Id of the project associated with the role
# + ProjectKey - The key of the project associated with the role
public type ProjectRoles record {
    readonly int RoleId?;
    readonly string RoleName?;
    readonly int ProjectId?;
    readonly string ProjectKey?;
};

# ProjectRoles view representation in Jira. The available Issue Types of projects. 
#
# + Id - The Id of the issue type
# + ProjectId - The Id of the project
# + ProjectName - The name of the project
# + Name - The name of the issue type
# + Description - The description of the issue type
# + Subtask - The subtask of the issue type. Not applicable for update
# + IconUrl - The icon URL of the issue type
# + AvatarId - The id of the avatar 
public type ProjectsIssueTypes record {
    readonly string Id?;
    readonly int ProjectId?;
    readonly string ProjectName?;
    readonly string Name?;
    readonly string Description?;
    readonly boolean Subtask?;
    readonly string IconUrl?;
    readonly string AvatarId?;
};

# ProjectTypes view representation in Jira. The list of all project types. 
#
# + Key - The key of the project type 
# + DescriptionKey - The key of the project type's description 
# + Icon - The icon of the project type
# + Color - The color of the project type
public type ProjectTypes record {
    readonly string Key?;
    readonly string DescriptionKey?;
    readonly string Icon?;
    readonly string Color?;
};

# RoleDetails view representation in Jira. Role Details in JIRA. 
#
# + Id - The Id of the details of the role 
# + ProjectId - The Id of the project associated with the details of the role
# + ProjectKey - The key of the project associated with the details of the role
# + Name - The name of the details of the role
# + Description - The description of the details of the role
public type RoleDetails record {
    readonly int Id?;
    readonly int ProjectId?;
    readonly string ProjectKey?;
    readonly string Name?;
    readonly string Description?;
};

# SecurityLevels view representation in Jira. All the created security levels. 
#
# + Id - The ID of the issue level security item
# + SecuritySchemeId - Link to this security level
# + Name - The name of the issue level security item
# + Description - The description of the issue level security item
public type SecurityLevels record {
    readonly int Id?;
    readonly int SecuritySchemeId?;
    readonly string Name?;
    readonly string Description?;
};

# SecuritySchemes view representation in Jira. All the created security schemes. 
#
# + Id - The ID of the issue security scheme
# + Name - The name of the issue security scheme
# + Description - The description of the issue security scheme
# + DefaultSecurityLevelId - The ID of the default security level
public type SecuritySchemes record {
    readonly int Id?;
    readonly string Name?;
    readonly string Description?;
    readonly int DefaultSecurityLevelId?;
};

# SprintIssues view representation in Jira. The agile Sprint Issues in Jira. 
#
# + Id - The Id of the issue
# + Key - The key of the issue
# + SprintId - The sprint the issue is assigned to
# + IssueTypeId - The issue type Id
# + IssueTypeName - The issue type name
# + StatusId - The issue status Id
# + StatusName - The issue status name 
# + ProjectId - The project Id of the issue
# + ProjectKey - The project key of the issue
# + ProjectName - The project name of the issue
# + ClosedSprintsAggregate - The issue's previous sprints that have been closed
# + Created - The creation date of the issue
# + Updated - The updated date of the issue
public type SprintIssues record {
    readonly int Id?;
    readonly string Key?;
    readonly int SprintId?;
    readonly string IssueTypeId?;
    readonly string IssueTypeName?;
    readonly int StatusId?;
    readonly string StatusName?;
    readonly int ProjectId?;
    readonly string ProjectKey?;
    readonly string ProjectName?;
    readonly string ClosedSprintsAggregate?;
    readonly string Created?;
    readonly string Updated?;
};

# Statuses view representation in Jira. The possible Statuses in Jira. 
#
# + Id - The Id of the status
# + Name - The name of the status
# + Description - The description of the status
# + CategoryId - The Category Id of the status
# + CategoryKey - The Category Key of the status
public type Statuses record {
    readonly int Id?;
    readonly string Name?;
    readonly string Description?;
    readonly int CategoryId?;
    readonly string CategoryKey?;
};

# TimeTrackingProviders view representation in Jira. The list of all time tracking providers. 
#
# + Key - The key for the time tracking provider. For example, JIRA
# + Name - The name of the time tracking provider. For example, JIRA provided time tracking
# + URL - The URL of the configuration page for the time tracking provider app. For example, /example/config/url. This property is only returned if the adminPageKey property is set in the module descriptor of the time tracking provider app
public type TimeTrackingProviders record {
    readonly string Key?;
    readonly string Name?;
    readonly string URL?;
};

# Votes view representation in Jira. The available Votes in JIRA. 
#
# + Key - The key of the vote
# + Name - The name of the vote
# + DisplayName - The display name of the vote
# + Active - Boolean indicating if the vote is active
public type Votes record {
    readonly string Key?;
    readonly string Name?;
    readonly string DisplayName?;
    readonly boolean Active?;
};

# Watchers view representation in Jira. The available Watchers in JIRA. 
#
# + DisplayName - The displayed name of the watcher
# + EmailAddress - The email address of the watcher
# + AccountId - The accountId of the watcher
# + Key - The key of the watcher
# + Name - The name of the watcher
public type Watchers record {
    readonly string DisplayName?;
    readonly string EmailAddress?;
    readonly string AccountId?;
    readonly string Key?;
    readonly string Name?;
};

# Workflows view representation in Jira. The available Workflows in Jira. 
#
# + Name - The name of the workflow
# + Description - The description of the workflow
# + LastModifiedDate - The last modified date of the workflow
# + LastModifiedUser - The user who last modified the workflow
# + Steps - The steps of the workflow  
# + IsDefault - Boolean indicating if the workflow is set as the default
public type Workflows record {
    readonly string Name?;
    readonly string Description?;
    readonly string LastModifiedDate?;
    readonly string LastModifiedUser?;
    readonly int Steps?;
    readonly boolean IsDefault?;
};

# WorkflowStatusCategories view representation in Jira. The list of all status categories. 
#
# + Id - The ID of the status category
# + Key - The key of the status category
# + Name - The name of the status category
# + ColorName - The name of the color used to represent the status category
# + URL - The URL of the status category
public type WorkflowStatusCategories record {
    readonly int Id?;
    readonly string Key?;
    readonly string Name?;
    readonly string ColorName?;
    readonly string URL?;
};

# WorkflowStatuses view representation in Jira. The list of all statuses associated with workflows. 
#
# + Id - The ID of the status 
# + StatusCategoryId - The ID of the status category 
# + Name - The name of the status
# + Description - The description of the status
# + URL - The description of the status
# + IconUrl - The URL of the icon used to represent the status
public type WorkflowStatuses record {
    readonly string Id?;
    readonly int StatusCategoryId?;
    readonly string Name?;
    readonly string Description?;
    readonly string URL?;
    readonly string IconUrl?;
};

# UploadAttachment stored procedure result set representation in Jira. Upload attachment on a specific Issue.
#
# + Success - This value shows whether the operation was successful or not  
# + attachmentId - Attachment ID
public type UploadAttachmentResponse record {
    readonly string Success?;
    readonly string attachmentId?;
};

# DownloadAttachment stored procedure result set representation in Jira. Download attachment by specifying its Id. 
#
# + Success - This value shows whether the operation was successful or not
public type DownloadAttachmentResponse record {
    readonly string Success?;
};

# GetTimeTrackingSettings stored procedure result set representation in Jira. The time tracking settings. 
#
# + WorkingHoursPerDay - The number of hours in a working day
# + WorkingDaysPerWeek - The number of days in a working week
# + TimeFormat - The format that will appear on an issue's Time Spent field
# + DefaultUnit - The default unit of time applied to logged time
public type TimeTrackingSettings record {
    readonly int WorkingHoursPerDay?;
    readonly float WorkingDaysPerWeek?;
    readonly string TimeFormat?;
    readonly string DefaultUnit?;
};

# SetTimeTrackingSettings stored procedure result set representation in Jira. Sets the time tracking settings.  
#
# + Success - This value shows whether the operation was successful or not
public type SetTimeTrackingSettingsResponse record {
    readonly string Success?;
};