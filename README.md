Metarepo is a service for storing and retrieving metadata about files in
a repository.

Metarepo is both a standalone server (for receiving and storing metadata via
a WebSocket connection) and a library (npm module) for querying stored metadata.

The typical use case is an application that displays files in a repository
such as Git or Subversion where there is additional information about files
that can't live in Git/Subversion. For example:

* Comments or discussions about a file
* Information about a line in a file

Metarepo stores this extra information (metadata) about files.
Each little piece of information has the following attributes:

* `url` (what repository is it)
* `rev` (what branch does the file live in)
* `rev` (what revision of the file is it)
* `group` (grouping metadata for the same url+rev) - typically a CI run id.
* `path` (where is the file)
* `location` (where in the file should the metadata be attached - currently a line number)
* `mime_type` (what kind of data)
* `json_body` (the metadata)

This is split up over 3 tables:

    +-------+       +--------+       +-----------+
    | repos +-----> | group  +-----> | metadata  |
    +-------+       +--------+       +-----------+
    | url   |       | branch |       | path      |
    +-------+       | rev    |       | location  |
                    | group  |       | mime_type |
                    +--------+       | json_body |
                                     +-----------+


Here are some examples of metadata:

## Ruby Stacktrace

    mime_type: text/vnd.cucumber-pro.stacktrace.ruby+plain
    json_body: { "text" : "some ruby stacktrace" }

## Screenshot

    mime_type: image/png
    json_body: { "path" : "path/within/s3" }

See below about the protocol for storing binary attachments.

## Test Case result (typically a Cucumber Scenario, but could also be from RSpec, JUnit etc)

    mime_type: application/vnd.cucumber-pro.test-case-result+json
    json_body: { "status" : "failed" }


## Test Step result (Cucumber Step)

    application/vnd.cucumber.test-step-result+json
    json_body: { "status" : "failed" }

## Discussion

    mime_type: application/vnd.cucumber-pro.discussion-message+json
    json_body: { "who": "matt", "message": "I like this" }

Metadata can be stored with WebSockets (for the standalone mode) and retrieved with method calls
(in the npm module mode).

# Hacking

## Create the local databases

```
createdb metarepo-test
createdb metarepo-development
createuser -s -r postgres
```

Run the tests (this will automatically migrate the databases):

```
npm test
```

# Try it out

## Fire up the server

```
DEBUG="metarepo:*,omnirepo:*,svnlite:*" npm start
```

## Store some metadata over the WebSocket API

First, you need the `authToken` of a cpro user, which you will find in mongodb.

Connect a WebSocket

```
./node_modules/.bin/wscat --connect ws://localhost:5000/ws?token=authToken
```

Or if you want to do it on Heroku:

```
./node_modules/.bin/wscat --no-check --connect wss://results.cucumber.pro/ws?token=authToken
```

Initiate the session

```json
{ "repo_url": "memory://metarepo/test", "rev": "1", "branch": "master", "group": "run-1", "info": {} }
```

Store some metadata

```json
{ "path": "hello/world.feature", "location": 2, "mime_type": "application/vnd.cucumber.test-case-result+json", "body": { "status": "passed" } }
{ "path": "hello/world.feature", "location": 3, "mime_type": "application/vnd.cucumber.test-case-result+json", "body": { "status": "failed" } }
{ "path": "hello/world.feature", "location": 4, "mime_type": "application/vnd.cucumber.test-case-result+json", "body": { "status": "pending" } }
```

## Query the database:

Who has sent us results:

```sql
SELECT DISTINCT info->>'cucumber_pro_email' as email, info->>'client_version' as client, info->>'tool_version' as tool FROM groups;
```

## Storing blobs

The protocol for storing metadata where the body is a blob (such as an image) is
to send two messages where the first one is a regular metadata JSON message
*without* the body field set.

When the `body` field is not set, metarepo expects the next message to be a *binary* message.
The body of the binary message will be stored in an external store (S3), and the metadata record
in the database will point to the path of the file in S3.

## BUGS

2) Not storing timezones

See http://www.craigkerstiens.com/2014/05/07/Postgres-datatypes-the-ones-youre-not-using/

## Release process

    npm version NEW_VERSION
    npm publish
    git push --tags
