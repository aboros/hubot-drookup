# hubot-drookup

A hubot script that allows hubot to do some useful lookups on various Drupal topics

See [`src/drookup.coffee`](src/drookup.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-drookup --save`

Then add **hubot-drookup** to your `external-scripts.json`:

```json
[
  "hubot-drookup"
]
```

## Sample Interaction

```
user>> dapi Node::render
hubot>> https://api.drupal.org/api/drupal/core%21modules%21node%21src%21Plugin%21views%21field%21Node.php/function/Node%3A%3Arender/8.4.x
```

## NPM Module

https://www.npmjs.com/package/hubot-drookup
