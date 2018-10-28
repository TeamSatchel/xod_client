# Xod Client

Fetch Groupcall's [Xporter on Demand](https://xporter.groupcall.com) data with ease.

## Installation

Add gem to Gemfile as usual

```ruby
gem 'xod_client'
```

## Usage

First initialize XoD client with _relying party_, _estab_ and _secret password_ components: 

```ruby
client = XodClient.init('relying-party.com', '3281101', 'secret')
```

Optionally you can pass previously remembered token options, to avoid refresh token request:

```ruby
token_options = { token: 'abcd', token_expires_at: Time.iso8601('2018-06-24T18:55:26.1852229Z') }
client = XodClient.init('relying-party.com', '3281101', 'secret', token_options)
```

You can request a new token in the following way:

```ruby
client.refresh_token
client.token #=> 'new-token'
client.token_expires_at #=> new-expiry-time
```

By calling any endpoint current token is checked and if it's stale a new one is requested automatically.

## Calling XoD endpoints

You can call any endpoint described in [XoD documentation](https://xporter.groupcall.com/) by its name, eg.:

```ruby
client.endpoint('school.schoolinfo').fetch
#-OR-
client.endpoint(endpoint_name: 'school.schoolinfo').fetch 
```

For many endpoints there are handy shortcuts, eg.:

```ruby
# info endpoints:
client.token_details
client.scopes
client.queries
client.logs
client.usage
client.gdpr_ids

# data endpoints:
client.groups
client.school_info
client.staff
client.students
client.timetable
client.timetable_model
```

You can pass arguments to endpoints, eg.:

```ruby
client.groups(type: 'RegGrp', options: %w(includeStaffMembers includeStudentMembers), page_size: 10)
```

Note: `options` and `select` arguments can be passed as an array or string of values concatenated by `,`

## Fetcher methods

To fetch results from endpoint you can use these methods:

```ruby
client.groups.fetch #=> returns json response
client.groups(page_size: 100).fetch { |endpoint| } #=> fetches page by page and passes endpoint object to a block
client.groups.each { |group| } #=> returns each group json to a block
client.groups.first #=> returns first group json

```

## Exceptions handling

In case of connection failures the code tries to call endpoint up to 3 times. Then it throws default Net HTTP errors.

If XoD returns a JSON error response then `XodClient::ResponseError` exception is raised.

## License
`xod_client` is MIT licensed. See the [accompanying file](LICENSE.txt) for the full text.
