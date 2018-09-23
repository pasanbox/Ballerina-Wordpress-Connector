Connects to Wordpress from Ballerina.

# Package Overview
This is a [Ballerina](http://ballerina.io) wrapper for [Wordpress REST API](https://developer.wordpress.org/rest-api/).
It allows a user to submit a post, comment on a post, retrieve posts and comments and find author detials for posts.
It uses plugin [authentication](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/) using [Application Passwords](https://wordpress.org/plugins/application-passwords/) plugin.

## Prerequisites
You need a Wordpress site installed with [Application Passwords](https://wordpress.org/plugins/application-passwords/) plugin.
For the user/s you wish to use with the API follow the steps mentioned [here](Application Passwords](https://wordpress.org/plugins/application-passwords/) plugin) and create a password. Then you can use those credentials for authentication.

**Wordpress REST API does not natively support OAuth 2.0 at the moment. Hence we used Application Passwords plugin as [recommended](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/#authentication-plugins) by Wordpress.**

## Compatibility
| Ballerina Language Version | Wordpress API version  |
| -------------------------- | --------------------   |
| 0.981.1                    | 4.9.8                  |


The following sections provide you with information on how to use the Ballerina Wordpress connector.

- [Working with Wordpress Connector actions](#working-with-wordpress-connector-actions)
- [Example](#example)


## Working with Wordpress Connector actions

All the actions return valid response or **WordpressError**. If the action is a success, the requested resource such as **WordPressPost**, **WordpressComment** or **WordpressAuthor** will be returned. Else a **WordpressError** object will be returned.

In order for you to use the Wordpress Connector, first you need to create a Wordpress Client endpoint.

```ballerina
endpoint wordpress:Client wordpressClient {
    url: "wordpressSiteUrl", //Provide in format http://localhost:8888/wordpress/wp-json/
    userName: "testUsername",
    password: "testPassword" //Use the password generated through Application Passwords plugin
};
```

## Example

```ballerina
import pasanbox/ballerina-wordpress-connector;

function main(string... args) {
    endpoint wordpress:WordpressApiClient wordpressApiClient {
      url: wordpressSiteUrl,
      userName: testUsername,
      password: testPassword   
    };

    wordpress:WordpressApiPost wordpressTestPost = {
        title: "Test Post",
        content: "Test content ",
        status: WORDPRESS_POST_STATUS_PUBLISH
    };

    var wordpressApiResponse = wordpressApiClient->createPost(wordpressTestPost);

    match wordpressApiResponse {
        wordpress:WordpressApiPost wordpressResponsePost => {
            //Post successfully created
        }
        WordpressApiError err => {
            //Handle error
        }
    }
}
```
