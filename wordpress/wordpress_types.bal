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

documentation {
    Define the Wordpress connector
    F{{clientEndpoint}} - HTTP client endpoint
}
public type WordpressApiConnector object {

    // public string userName;
    // public string password;
    public http:Client clientEndpoint = new;

    public function createPost(WordpressApiPost wordpressPost) returns WordpressApiPost|WordpressApiError;
    public function getAllPosts() returns WordpressApiPost[]|WordpressApiError;
    public function getAllComments() returns WordpressApiComment[]|WordpressApiError;
    public function getPostForComment(WordpressApiComment comment) returns WordpressApiPost|WordpressApiError;
    public function commentOnPost(WordpressApiPost post, WordpressApiComment comment) 
        returns WordpressApiComment|WordpressApiError;
    public function getAuthorForPost(WordpressApiPost post) returns WordpressApiAuthor|WordpressApiError;
    private function doGetOnWordpressEndpoint(string wordpressEndPoint) returns json|WordpressApiError;
    private function doPostOnWordpressEndpoint(string wordpressEndPoint, json jsonPayload) 
        returns json|WordpressApiError;
};

documentation {
    Wordpress Client object
    E{{}}
    F{{wordpressApiConfig}} - Wordpress connector configurations
    F{{wordpressApiConnector}} - WordpressConnector Connector object
}
public type WordpressApiClient object {

    public WordpressApiConfiguration wordpressApiConfig = {};
    public WordpressApiConnector wordpressApiConnector = new;

    documentation {Wordpress connector endpoint initialization function
        P{{config}} - Wordpress connector configuration
    }
    public function init(WordpressApiConfiguration config);

    documentation {Return the Wordpress connector client
        R{{}} - Wordpress connector client
    }
    public function getCallerActions() returns WordpressApiConnector;

};

documentation {
    Wordpress connector configurations can be setup here
    F{{url}} - The Wordpress API URL: given in format http://localhost:8888/wordpress/wp-json/
    F{{userName}} - The user name of the Wordpress account
    F{{password}} - The password of the Wordpress account
    F{{clientConfig}} - Client endpoint configurations provided by the user
}
public type WordpressApiConfiguration record {
    string url;
    string userName;
    string password;
    http:ClientEndpointConfig clientConfig = {};
};

documentation {
    Define the status
    F{{modifiedGmt}} - Modified time of the wordpress post in GMT
    F{{id}} - Unique ID of the post. API can access post using this id.
    F{{title}} - Title of the post
    F{{content}} - Content of the post
    F{{status}} - Status of the post. i.e publish/draft/future/pending/trash
    F{{authorId}} - Unique ID of the author of the post. API can access this author using user endpoint

}
public type WordpressApiPost record {
    string modifiedGmt;
    int id;
    string title;
    string content;
    string status;
    int authorId;
};

documentation {
    Define the status
    F{{date}} - Created time of the wordpress comment in GMT
    F{{id}} - Unique ID of the comment. API can access this using comments endpoint.
    F{{content}} - Content of the comment
    F{{status}} - Status of the comment. i.e publish/draft/future/pending/trash
    F{{postId}} - Unique ID of the post this comment belongs to

}
public type WordpressApiComment record {
    string date;
    int id;
    int postId;
    string authorEmail;
    string content;
    string status;
};

public type WordpressApiAuthor record {
    int id;
    string email;
};

documentation {
    Wordpress Client Error
    F{{message}} - Error message of the response
    F{{cause}} - The error which caused the Wordpress error
    F{{statusCode}} - Status code of the response
}
public type WordpressApiError record {
    string message;
    error? cause;
    int statusCode;
};
