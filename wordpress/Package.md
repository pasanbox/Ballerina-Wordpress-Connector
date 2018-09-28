Connects to Wordpress from Ballerina.

# Package Overview
This is a [Ballerina](http://ballerina.io) wrapper for [Wordpress REST API](https://developer.wordpress.org/rest-api/).
It allows a user to submit a post, comment on a post, retrieve posts and comments and find author detials for posts.
It uses plugin [authentication](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/) using [Application Passwords](https://wordpress.org/plugins/application-passwords/) plugin.

## Prerequisites
You need a Wordpress site installed with [Application Passwords](https://wordpress.org/plugins/application-passwords/) plugin.
For the user/s you wish to use with the API follow the steps mentioned [here](https://wordpress.org/plugins/application-passwords/) and create a password. Then you can use those credentials for authentication.

## Compatibility
| Ballerina Language Version | Wordpress API version  |
| -------------------------- | --------------------   |
| 0.981.1                    | 4.9.8                  |



The following sections provide you with information on how to use the Ballerina Wordpress connector.

- [Working with Wordpress Connector actions](#working-with-wordpress-connector-actions)
- [Example](#example)


## Working with Wordpress Connector actions
First, import pasanw/wordpress package into your Ballerina project.
```ballerina
import pasanw/wordpress;
```

All the actions return valid response or **WordpressApiError**. If the action is a success, the requested resource such as **WordPressPost**, **WordpressApiComment** or **WordpressApiAuthor** will be returned. Else a **WordpressApiError** object will be returned.

In order for you to use the Wordpress Connector, first you need to create a Wordpress Client endpoint.

```ballerina
endpoint wordpress:Client wordpressClient {
    url: "wordpressSiteUrl", //Provide in format http://localhost:8888/wordpress/wp-json/
    userName: "testUsername",
    password: "testPassword" //Use the password generated through Application Passwords plugin
};
```

## Examples

### Create a blog post

Define the **WordpressApiClient** using the credential obtained earlier.
Create a **WordpressApiPost** object with following parameters.

- title - Title of the blog post
- content - Content of the blog post
- status - This can be publish or draft as required

Then you can call the createPost method of the **WordpressApiClient** object passing this
**WordpressApiPost** object as its argument. 

```ballerina
import pasanw/wordpress;

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
        wordpress:WordpressApiPost wordpressPost => {
            //Post successfully created
        }
        WordpressApiError err => {
            //Handle error
        }
    }
}
```

This will return response when matched will resolve to a **WordpressApiResponse** on success and **WordpressApiError** on failure.



### Comment on a post

This package allows its users to comment on a post. 

We need to have a **WordpressApiPost** object which we have in the program's context by retrieving or initially posting. For this example we will use the same post we obtained by matching the response from **Wordpres REST API**.
Similar to the above you can use a **match** to resolve the reply from Wordpress.

```ballerina
WordpressApiComment wordpressInputComment = {
        content: "Test comment " + math:random(),
        status: WORDPRESS_POST_STATUS_PUBLISH
    };
    
    var wordpressApiResponse = wordpressApiClient->commentOnPost(wordpressPost, 
        wordpressInputComment);

    match wordpressApiResponse {
        WordpressApiComment wordpressResponseComment => {
            testContext.wordpressComment = wordpressResponseComment;
            test:assertTrue(wordpressResponseComment.content.contains(wordpressInputComment.content));
        }
        WordpressApiError err => {
            test:assertFail(msg = getErrorDescription(err));
        }
    }
```



### Retrieve all posts

Retrieves all posts from the website (subject to Wordpress API constraints). Please refer the [tests](https://github.com/pasanbox/ballerina-wordpress-connector/blob/master/wordpress/tests/test.bal) for an implementation example.

### Retrive all comments

Retrieves all comments from the website (subject to Wordpress API constraints). Please refer the [tests](https://github.com/pasanbox/ballerina-wordpress-connector/blob/master/wordpress/tests/test.bal) for an implementation example.

### Get author of a given post

Retrieves the author of the given post as a **WordpressApiAuthor** object. Please refer the [tests](https://github.com/pasanbox/ballerina-wordpress-connector/blob/master/wordpress/tests/test.bal) for an implementation example.