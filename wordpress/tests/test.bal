// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/test;
import ballerina/time;
import ballerina/system;
import ballerina/config;
import ballerina/io;
import ballerina/math;

@final string wordpressSiteUrl = config:getAsString("SITE_URL");
@final string testUsername = config:getAsString("USERNAME");
@final string testPassword = config:getAsString("PASSWORD");
@final string testAuthorEmail = config:getAsString("AUTHOR_EMAIL");

WordpressApiPost wordpressPostInContext;
WordpressApiComment wordpressCommentInContext;

@final int randomPostIdLowerLimit = 0;
@final int randomPostIdUpperLimit = 1000;

//OAuth2 not yet supported on Wordpress REST API.
endpoint WordpressApiClient wordpressApiClient {
    url: wordpressSiteUrl,
    userName: testUsername,
    password: testPassword   
};

@test:Config
function testCreatePost() {
    WordpressApiPost wordpressTestPost = {
        title: "Test Post " + math:randomInRange(randomPostIdLowerLimit,randomPostIdUpperLimit),
        content: "Test content " + math:random(),
        status: WORDPRESS_POST_STATUS_PUBLISH
    };
   
    var wordpressApiResponse = wordpressApiClient->createPost(wordpressTestPost);

    match wordpressApiResponse {
        WordpressApiPost wordpressResponsePost => {
            wordpressPostInContext = wordpressResponsePost;
            test:assertTrue(wordpressResponsePost.title.contains(wordpressTestPost.title));
        }
        WordpressApiError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    enable: true,
    dependsOn: ["testCreatePost"]
}
function testGetAllPosts() {    
    var wordpressApiResponse = wordpressApiClient->getAllPosts();

    match wordpressApiResponse {
        WordpressApiPost[] wordpressPosts => {
            boolean foundTestPostInReply = false;
            foreach wordpressPost in wordpressPosts {
                if (wordpressPost.id == wordpressPostInContext.id) {
                    foundTestPostInReply = true;
                }
            }
            test:assertTrue(foundTestPostInReply);
        }
        WordpressApiError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    enable:true,
    dependsOn: ["testCommentOnPost"]
}
function testGetAllComments() {    
    var wordpressApiResponse = wordpressApiClient->getAllComments();

    match wordpressApiResponse {
        WordpressApiComment[] wordpressComments => {
            boolean foundTestCommentInReply = false;
            foreach wordpressComment in wordpressComments {
                if (wordpressComment.id == wordpressCommentInContext.id) {
                    foundTestCommentInReply = true;
                }
            }
            test:assertTrue(foundTestCommentInReply);
        }
        WordpressApiError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testCreatePost"]
}
function testCommentOnPost() {
    WordpressApiComment wordpressInputComment = {
        postId: wordpressPostInContext.id,
        content: "Test comment " + math:random(),
        status: WORDPRESS_POST_STATUS_PUBLISH
    };
    
    var wordpressApiResponse = wordpressApiClient->commentOnPost(wordpressPostInContext, wordpressInputComment);

    match wordpressApiResponse {
        WordpressApiComment wordpressResponseComment => {
            wordpressCommentInContext = wordpressResponseComment;
            test:assertTrue(wordpressResponseComment.content.contains(wordpressInputComment.content));
        }
        WordpressApiError err => {
            test:assertFail(msg = err.message);
        }
    }

}

@test:Config {
    dependsOn: ["testCommentOnPost"]
}
function testGetPostForComment() {

    var wordpressApiResponse = wordpressApiClient->getPostForComment(wordpressCommentInContext);

    match wordpressApiResponse {
        WordpressApiPost wordpressResponsePost => {
            test:assertTrue(wordpressResponsePost.title.contains(wordpressPostInContext.title));
        }
        WordpressApiError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testCreatePost"]
}
function testGetAuthorForPost() {

    var wordpressApiResponse = wordpressApiClient->getAuthorForPost(wordpressPostInContext);

    match wordpressApiResponse {
        WordpressApiAuthor wordpressResponseAuthor => {
            test:assertTrue(wordpressResponseAuthor.email.contains(testAuthorEmail));
        }
        WordpressApiError err => {
            test:assertFail(msg = err.message);
        }
    }
}
