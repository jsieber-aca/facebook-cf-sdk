﻿/**
  * Copyright 2011 Affinitiz, Inc.
  * Author: Benoit Hediard (hediard@affinitiz.com)
  *
  * Licensed under the Apache License, Version 2.0 (the "License"); you may
  * not use this file except in compliance with the License. You may obtain
  * a copy of the License at
  * 
  *  http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
  * License for the specific language governing permissions and limitations
  * under the License.
  *
  * @displayname Facebook Graph API
  * @hint A client wrapper to call Facebook Graph API
  * 
  */
component extends="FacebookBase" {
	
	/*
	 * @description Facebook Graph API constructor
	 * @hint Requires an application or user accessToken, appId is only used to invalidate current session if an invalid token is detected
	 */
	public Any function init(String accessToken = "", Numeric appId = 0, Numeric timeout = 10) {
		super.init(appId=arguments.appId);
		variables.ACCESS_TOKEN = arguments.accessToken;
		variables.TIMEOUT = arguments.timeout;
		return this;
	}
	
	/*
	 * @description Block a user from a page.
	 * @hint Requires the manage_pages permission.
	 */
	public Boolean function blockUser(required String pageId, required String userId) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.pageId#/blocked/#arguments.userId#", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Create a subscription for the application
	 * @hint Requires an application accessToken
	 */
	public Any function createSubscription(required String appId, required String callbackUrl, required String fields, required String object, required String verifyToken = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.appId#/subscriptions", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="object", value="#arguments.object#");
		httpService.addParam(type="formField", name="fields", value=arguments.fields);
		httpService.addParam(type="formField", name="callback_url", value="#arguments.callbackUrl#");
		httpService.addParam(type="formField", name="verify_token", value="#arguments.verifyToken#");
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Create a test user
	 * @hint Requires an application accessToken
	 */
	public Struct function createTestUser(required String appId, Boolean installed = false, String permissions = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.appId#/accounts/test-users", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="installed", value="#arguments.installed#");
		httpService.addParam(type="url", name="permissions", value="#arguments.permissions#");
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Create a test user friend connection
	 * @hint Requires user1 accessToken
	 */
	public Boolean function createTestUserFriendConnection(required String userId1, required String userId2) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.userId1#/friends/#arguments.userId2#", method="POST", timeout=variables.TIMEOUT);
		var result = false;
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Remove a like from a post.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function deleteLike(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#/likes", method="DELETE", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Delete a graph object.
	 * @hint 
	 */
	public Boolean function deleteObject(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#", method="DELETE", timeout=variables.TIMEOUT);
		var result = false;
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Remove a subscription for an application
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function deleteSubscription(required String appId, String object = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.appId#/subscriptions", method="DELETE", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if(len(arguments.object)) {
			httpService.addParam(type="formField", name="object", value="#arguments.object#");
		}
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Get blocked users for a page.
	 * @hint 
	 */
	public Array function getBlockedUsers(required String pageId) {
		var users = [];
		var httpService = new Http(url="https://graph.facebook.com/#arguments.pageId#/blocked", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			users = result.data;
		}
		return users;
	}
	
	/*
	 * @description Get graph object connections.
	 * @hint 
	 *		Supported connections type for album : comments, photos
	 *		Supported connections type for event : attending, declined, feed, invited, maybe, noreply, picture
	 *		Supported connections type for group : feed, members, picture
	 *		Supported connections type for link : comments
	 *		Supported connections type for message : comments
	 *		Supported connections type for note : comments
	 *		Supported connections type for page : albums, events, feed, groups, links, notes, photos, picture, posts, statuses, tagged, videos
	 *		Supported connections type for photo : comments
	 *		Supported connections type for post : comments
	  *		Supported connections type for user : albums, activities, books, checkins, events, feed, friends, groups, interests, home, links, likes, music, movies, notes, photos, picture, posts, statuses, tagged, television, thread, updates, videos
	 *		Supported connections type for video : comments
	 */
	public Array function getConnections(required String id, required String type, Numeric limit=-1, Numeric offset=-1, Date since, Date until) {
		var connections = [];
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#/#arguments.type#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (arguments.limit > 0) httpService.addParam(type="url", name="limit", value="#arguments.limit#");
		if (arguments.offset > 0) httpService.addParam(type="url", name="offset", value="#arguments.offset#");
		if (structKeyExists(arguments, "since") && isDate(arguments.since)) httpService.addParam(type="url", name="since", value="#dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.since)#");
		if (structKeyExists(arguments, "until") && isDate(arguments.until)) httpService.addParam(type="url", name="until", value="#dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.until)#");
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			connections = result.data;
		}
		return connections;
	}
	
	/*
	 * @description Get OAuth access token.
	 * @hint
	 */
	public String function getOAuthAccessToken(String clientId = "", String clientSecret = "", String code = "", String grantType = "", String redirectUri) {
		var accessToken = "";
		var httpService = new Http(url="https://graph.facebook.com/oauth/access_token", timeout=variables.TIMEOUT);
		var queryString = "";
		if (arguments.clientId != "") httpService.addParam(type="url", name="client_id", value=arguments.clientId);
		if (arguments.clientSecret != "") httpService.addParam(type="url", name="client_secret", value=arguments.clientSecret);
		if (arguments.code != "") httpService.addParam(type="url", name="code", value=arguments.code);
		if (arguments.grantType != "") httpService.addParam(type="url", name="grant_type", value=arguments.grantType);
		if (structKeyExists(arguments, "redirectUri")) httpService.addParam(type="url", name="redirect_uri", value=arguments.redirectUri); // RedirectUri can be empty (when JS SDK is used to connect)
		var result = callAPIService(httpService);
		if (structKeyExists(result, "access_token")) {
			accessToken = result["access_token"];
		}	
		return accessToken;
	}
	
	/*
	 * @description Get graph object.
	 * @hint 
	 */
	public Struct function getObject(required String id, String fields = "", Numeric metadata = 0) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value=arguments.fields);
		if (arguments.metadata == 1) httpService.addParam(type="url", name="metadata", value="1");
		result = callAPIService(httpService);
		if (!isStruct(result)) result = {};
		return result;
	}

	/*
	 * @description Get multiple graph objects in a single batched request.
	 * @hint 
	 */
	public Array function getObjectsBatched(required Array relativeUrls) {
		var httpService = new Http(url="https://graph.facebook.com", method="POST", timeout=variables.TIMEOUT);
		var response = {};
		var result = {};
		var results = [];
		var batch = [];
		var query = {};
		for (var relativeUrl in arguments.relativeUrls) {
			query = {};
			query["method"] = "GET";
			query["relative_url"] = relativeUrl;
			arrayAppend(batch, query);
		}
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="batch", value="#serializeJSON(batch)#");
		result = callAPIService(httpService);
		if (isArray(result)) {
			for (response in result) {
				if (response["code"] == 200) {
					arrayAppend(results, deserializeJSON(response["body"]));
				} else {
					arrayAppend(results, {});
				}
			}
		}
		return results;
	}
	
	/*
	 * @description Get multiple graph objects.
	 * @hint 
	 */
	public Struct function getObjects(required String ids, String fields = "", Numeric metadata = 0) {
		var httpService = new Http(url="https://graph.facebook.com", timeout=variables.TIMEOUT);
		var results = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value=arguments.fields);
		if (arguments.metadata == 1) httpService.addParam(type="url", name="metadata", value="1");
		httpService.addParam(type="url", name="ids", value=arguments.ids);
		results = callAPIService(httpService);
		if (!isStruct(results)) results = {};
		return results;
	}
	
	/*
	 * @description List all application's subscriptions
	 * @hint Requires an application accessToken
	 */
	public Struct function getSubscriptions(required String appId) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.appId#/subscriptions", method="GET", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Get test users
	 * @hint Requires an application accessToken
	 */
	public Array function getTestUsers(required String appId) {
		var users = [];
		var httpService = new Http(url="https://graph.facebook.com/#arguments.appId#/accounts/test-users", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="installed", value="#arguments.installed#");
		httpService.addParam(type="url", name="permissions", value="#arguments.permissions#");
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			users = result.data;
		}
		return users;
	}
	
	/*
	 * @description Check if a user has liked a page
	 * @hint Requires a user accessToken
	 */
	public Boolean function isPageLiked(required String pageId, required String userId) {
		var liked = false;
		var httpService = new Http(url="https://graph.facebook.com/#arguments.userId#/likes/#arguments.pageId#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			liked = true;
		}
		return liked;
	}
	
	/*
	 * @description Check if a user is blocked on a page
	 * @hint Requires a user page accessToken, requires the manage_pages permission
	 */
	public Boolean function isUserBlocked(required String pageId, required String userId) {
		var blocked = false;
		var httpService = new Http(url="https://graph.facebook.com/#arguments.pageId#/blocked/#arguments.userId#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			blocked = true;
		}
		return blocked;
	}
	
	/*
	 * @description Add an album to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishAlbum(required String profileId, required String name, required String description) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/albums", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="name", value="#arguments.name#");
		httpService.addParam(type="formField", name="description", value="#arguments.description#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a comment to a post
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishComment(required String postId, required String message) {
		var result = {};
		var httpService = new Http(url="https://graph.facebook.com/#arguments.postId#/comments", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="message", value="#arguments.message#");
		result = callAPIService(httpService);
		return result["id"];
	}
		
	/*
	 * @description Add an event to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishEvent(required String profileId, required Date startTime, required Date endTime, String name = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="start_time", value="#dateformat(arguments.startTime, "yyyy-mm-dd")#T#TimeFormat(arguments.startTime, "HH:mm:ss")#");
		httpService.addParam(type="formField", name="end_time", value="#dateformat(arguments.startTime, "yyyy-mm-dd")#T#TimeFormat(arguments.startTime, "HH:mm:ss")#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Change event status
	 * @hint Available status are attending, maybe or declined.Requires the publish_stream permission.
	 */
	public Boolean function publishEventStatus(required String eventId, String status = "attending") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.eventId#/#arguments.status#", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Add a like to a post.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishLike(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#/likes", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Add a link to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishLink(required String profileId, required String link, String caption = "", String description = "", String message = "", String name = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/links", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="link", value="#arguments.link#");
		if (trim(arguments.caption) != "") httpService.addParam(type="formField", name="caption", value="#arguments.caption#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a note to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishNote(required String profileId, required String subject, required String message) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/notes", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.subject) != "") httpService.addParam(type="formField", name="subject", value="#arguments.subject#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add an entry to a profile's feed.
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishPost(required String profileId, String actions = "", String caption = "", String description = "",  String link = "", String message = "", String picture = "", String privacy = "", String name = "", String source = "", String targeting = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/feed", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="formField", name="access_token", value=variables.ACCESS_TOKEN);
		if (trim(arguments.actions) != "") httpService.addParam(type="formField", name="actions", value="#arguments.actions#");
		if (trim(arguments.caption) != "") httpService.addParam(type="formField", name="caption", value="#arguments.caption#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.link) != "") httpService.addParam(type="formField", name="link", value="#arguments.link#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.picture) != "") httpService.addParam(type="formField", name="picture", value="#arguments.picture#");
		if (trim(arguments.privacy) != "") httpService.addParam(type="formField", name="privacy", value="#arguments.privacy#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		if (trim(arguments.source) != "") httpService.addParam(type="formField", name="source", value="#arguments.source#");
		if (trim(arguments.targeting) != "") httpService.addParam(type="formField", name="targeting", value="#arguments.targeting#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a photo to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishPhoto(required String profileId, required String sourcePath, String message = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/photos", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="file", name="source", file="#arguments.sourcePath#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a video to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishVideo(required String sourcePath, String description = "", String title = "") {
		var httpService = new Http(url="https://graph-video.facebook.com/me/videos", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="file", name="source", file="#arguments.sourcePath#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.title) != "") httpService.addParam(type="formField", name="title", value="#arguments.title#");
		result = callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Search for objects of a given type.
	 * @hint Supported search object type : post, user, page, event, group. Requires the publish_stream permission.
	 */
	public Array function search(required String text, String type = "", Numeric limit = -1, Numeric offset = -1) {
		var httpService = new Http(url="https://graph.facebook.com/search", timeout=variables.TIMEOUT);
		var result = {};
		var results = [];
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (trim(arguments.text) != "") httpService.addParam(type="url", name="q", value="#URLEncodedFormat(trim(arguments.text))#");
		if (trim(arguments.type) != "") httpService.addParam(type="url", name="type", value="#arguments.type#");
		if (arguments.limit > 0) httpService.addParam(type="url", name="limit", value="#arguments.limit#");
		if (arguments.offset > 0) httpService.addParam(type="url", name="offset", value="#arguments.offset#");
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			results = result.data;
		}
		return results;
	}
	
	/*
	 * @description Remove a blocked user.
	 * @hint Requires the manage_pages permission.
	 */
	public Boolean function unblockUser(required String pageId, required String userId) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.pageId#/blocked/#arguments.userId#", method="DELETE", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	

}