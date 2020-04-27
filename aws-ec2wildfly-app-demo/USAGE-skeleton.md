# Blueprint skeleton

Now that you've created your blueprint skeleton, there are a few more steps:

1. If your blueprint is related to one of technologies (e.g. `aws`), move it to that directory before committing it
2. If your blueprint is for a whole new technology, create that directory, then move your blueprint to that directory before committing it
3. When you're done reading this file, delete it, as it should not be part of your blueprint

The files in this skeleton make up a basic blueprint with the most common elements. For more detail, refer to the online documentation:
* [Blueprint YAML format](https://docs.xebialabs.com/xl-deploy/concept/blueprint-yaml-format/)
* [Go Templates](https://golang.org/pkg/text/template/)
* [Using Go Templates](https://blog.gopheracademy.com/advent-2017/using-go-templates/)

## Notes:

In the blueprints, all places where you should substitute your own values is marked like `_VALUE_HERE_`.