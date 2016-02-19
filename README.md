# hubot-loggly [![Build Status](https://travis-ci.org/efacilitation/hubot-loggly.svg?branch=master)](https://travis-ci.org/efacilitation/hubot-loggly)

A hubot script to query the Loggly API

See [`src/loggly.coffee`](src/loggly.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-loggly --save`

Then add **hubot-loggly** to your `external-scripts.json`:

```json
[
  "hubot-loggly"
]
```

## Sample Interaction

```
user1>> hubot loggly get from -5d until now
```
