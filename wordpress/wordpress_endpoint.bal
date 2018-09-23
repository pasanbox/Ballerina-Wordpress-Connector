//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
//

import ballerina/http;

function WordpressApiClient::init(WordpressApiConfiguration config) {
    config.clientConfig.url = config.url;

    http:AuthConfig auth = {};
    auth.scheme = http:BASIC_AUTH; //Will be upgraded to OAuth2 after Wordpress.org introduces it
    auth.username = config.userName;
    auth.password = config.password;
    config.clientConfig.auth = auth;

    self.wordpressApiConnector.clientEndpoint.init(config.clientConfig);
}

function WordpressApiClient::getCallerActions() returns WordpressApiConnector {
    return self.wordpressApiConnector;
}
