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

function convertWordpressReplyToPost(json jsonStatus) returns (WordpressApiPost) {
    WordpressApiPost post = {};
    post.createdAt = jsonStatus.modified_gmt != null ? jsonStatus.modified_gmt.toString() : "";
    post.id = jsonStatus.id != null ? convertToInt(jsonStatus.id) : 0;
    post.title = jsonStatus.title != null ? jsonStatus.title.rendered.toString() : "";
    post.content = jsonStatus.content != null ? jsonStatus.content.raw.toString() : "";
    post.status = jsonStatus.status != null ? jsonStatus.status.raw.toString() : "";
    post.authorId = jsonStatus.author != null ? convertToInt(jsonStatus.author) : 0;
    return post;
}

function convertWordpressReplyToPosts(json jsonStatuses) returns WordpressApiPost[] {
    WordpressApiPost[] posts = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        posts[i] = convertWordpressReplyToPost(jsonStatus);
        i = i + 1;
    }
    return posts;
}

function convertWordpressReplyToComment(json jsonStatus) returns (WordpressApiComment) {
    WordpressApiComment comment = {};
    comment.date = jsonStatus.modified_gmt != null ? jsonStatus.modified_gmt.toString() : "";
    comment.id = jsonStatus.id != null ? convertToInt(jsonStatus.id) : 0;
    comment.authorEmail = jsonStatus.author_email != null ? jsonStatus.author_email.rendered.toString() : "";
    comment.content = jsonStatus.content != null ? jsonStatus.content.rendered.toString() : "";
    comment.postId = jsonStatus.post != null ? convertToInt(jsonStatus.post) : 0;
    return comment;
}

function convertWordpressReplyToComments(json jsonStatuses) returns WordpressApiComment[] {
    WordpressApiComment[] comments = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        comments[i] = convertWordpressReplyToComment(jsonStatus);
        i = i + 1;
    }
    return comments;
}

function convertWordpressReplyToAuthor(json jsonStatus) returns (WordpressApiAuthor) {
    WordpressApiAuthor author = {};
    author.id = jsonStatus.id != null ? convertToInt(jsonStatus.id) : 0;
    author.email = jsonStatus.email != null ? jsonStatus.email.toString() : "";
    return author;
}

function convertToInt(json jsonVal) returns (int) {
    string stringVal = jsonVal.toString();
    if (stringVal != "") {
        return check <int>stringVal;
    } else {
        return 0;
    }
}

function convertToBoolean(json jsonVal) returns (boolean) {
    string stringVal = jsonVal.toString();
    return <boolean>stringVal;
}

function convertToFloat(json jsonVal) returns (float) {
    string stringVal = jsonVal.toString();
    return check <float>stringVal;
}










