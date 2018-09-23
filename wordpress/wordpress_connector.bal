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

import ballerina/io;
import ballerina/log;

function WordpressApiConnector::doGetOnWordpressEndpoint(string wordpressEndPoint) returns json|WordpressApiError {
   endpoint http:Client clientEndpoint = self.clientEndpoint;
    WordpressApiError wordpressApiError = {};

    log:printInfo("Calling GET request on endpoint: " + wordpressEndPoint);
    var response = clientEndpoint->get(wordpressEndPoint);   
    match response {
        http:Response resp => {
            if (resp.statusCode != http:OK_200) {
                log:printError("Received HTTP response with status code: " + resp.statusCode 
                                + " and message: " + resp.reasonPhrase);
                WordpressApiError err = {
                    statusCode: resp.statusCode,
                    message: resp.reasonPhrase
                };
                return err;
            }
            var msg = resp.getJsonPayload();
            match msg {
                json jsonResponse => {
                    log:printDebug("Reply from Wordpress API: " + jsonResponse.toString());
                    return jsonResponse;
                }
                error err => {
                    wordpressApiError.message = err.message;
                    log:printError("JSON conversion failed: " + err.message);
                    return wordpressApiError;
                }
            }
        }
        error err => {
            wordpressApiError.message = err.message;
            log:printError("GET Request failed: " + err.message);
            return wordpressApiError;
        }
    } 
}

function WordpressApiConnector::doPostOnWordpressEndpoint(string wordpressEndPoint, json jsonPayload) returns json|WordpressApiError {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    WordpressApiError wordpressApiError = {};
    http:Request req = new;
    req.setPayload(jsonPayload);

    log:printInfo("Calling POST request on endpoint: " + wordpressEndPoint);
    log:printDebug("Input paylod for POST request: " + jsonPayload.toString());
    var response = clientEndpoint->post(wordpressEndPoint, req);
    
    match response {
        http:Response resp => {
            if ((resp.statusCode != http:OK_200) && (resp.statusCode != http:CREATED_201)) {
                log:printError("Received HTTP response with status code: " + resp.statusCode 
                                + " and message: " + resp.reasonPhrase);
                WordpressApiError err = {
                    statusCode: resp.statusCode,
                    message: resp.reasonPhrase
                };
                return err;
            }
            var msg = resp.getJsonPayload();
            match msg {
                json jsonResponse => {
                    log:printDebug("Reply from Wordpress API: " + jsonResponse.toString());
                    return jsonResponse;
                }
                error err => {
                    wordpressApiError.message = err.message;
                    log:printError("JSON conversion failed: " + err.message);
                    return wordpressApiError;
                }
            }
        }
        error err => {
            wordpressApiError.message = err.message;
            log:printError("POST Request failed: " + err.message);
            return wordpressApiError;
            }    
    }
}

function WordpressApiConnector::createPost(WordpressApiPost wordpressPost) returns WordpressApiPost|WordpressApiError {
    json post = { title: wordpressPost.title, content: wordpressPost.content, status: wordpressPost.status };
    log:printDebug("Create Wordpress Post: " + post.toString());

    var response = self.doPostOnWordpressEndpoint(WORDPRESS_API_POST_ENDPOINT, post);
    match response {
        json jsonPayload => {
            return convertWordpressReplyToPost(jsonPayload);
        }
        WordpressApiError err => {
            log:printError("Post creation failed");
            return err;
        }
    }
}

function WordpressApiConnector::getAllPosts() returns WordpressApiPost[]|WordpressApiError {
    log:printDebug("Get all posts on site");

    var response =  self.doGetOnWordpressEndpoint(WORDPRESS_API_POST_ENDPOINT);
    match response {
        json jsonPayload => {
            return convertWordpressReplyToPosts(jsonPayload);
        }
        WordpressApiError err => {
            log:printError("Retrieving all posts failed");
            return err;
        }
    }
}

function WordpressApiConnector::getAllComments() returns WordpressApiComment[]|WordpressApiError {
    log:printDebug("Get all comments on site");
    var response =  self.doGetOnWordpressEndpoint(WORDPRESS_API_COMMENT_ENDPOINT);
    match response {
        json jsonPayload => {
            return convertWordpressReplyToComments(jsonPayload);
        }
        WordpressApiError err => {
            log:printError("Retrieving all comments failed");
            return err;
        }
    }
}

function WordpressApiConnector::getPostForComment(WordpressApiComment comment) returns WordpressApiPost|WordpressApiError {
    log:printDebug("Get post which belongs the comment: " + comment.id);
    var response =  self.doGetOnWordpressEndpoint(WORDPRESS_API_POST_ENDPOINT + "/" + comment.postId);
    match response {
        json jsonPayload => {
            return convertWordpressReplyToPost(jsonPayload);
        }
        WordpressApiError err => {
            log:printError("Finding post which belongs comment failed");
            return err;
        }
    }
}

function WordpressApiConnector::commentOnPost(WordpressApiPost post, WordpressApiComment comment) returns WordpressApiComment|WordpressApiError {
    log:printDebug("Apply comment: " + comment.content + " on post: " + post.id);

    json jsonComment = { post: post.id, content: comment.content, status: comment.status };
    var response = self.doPostOnWordpressEndpoint(WORDPRESS_API_COMMENT_ENDPOINT, jsonComment);
    match response {
        json jsonPayload => {
            return convertWordpressReplyToComment(jsonPayload);
        }
        WordpressApiError err => {
            log:printError("Commenting on post failed");
            return err;
        }
    }
}

function WordpressApiConnector::getAuthorForPost(WordpressApiPost post) returns WordpressApiAuthor|WordpressApiError {
    log:printDebug("Get author of post: " + post.id);
    var response =  self.doPostOnWordpressEndpoint(WORDPRESS_API_USER_ENDPOINT + "/" + post.authorId, {});
    match response {
        json jsonPayload => {
            return convertWordpressReplyToAuthor(jsonPayload);
        }
        WordpressApiError err => {
            log:printError("Get author of post failed");
            return err;
        }
    }  
}


