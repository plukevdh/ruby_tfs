# ruby_tfs
TFS.rb is a wapper around the odata API for TFS

- [The project](http://www.microsoft.com/en-us/download/details.aspx?id=36230)
- [The specification][1]

[![Build Status](https://travis-ci.org/BFGCOMMUNICATIONS/ruby_tfs.png?branch=master)](https://travis-ci.org/BFGCOMMUNICATIONS/ruby_tfs)

## Disclaimer
This wrapper is mostly a shell around the `ruby_odata` gem to provide a "kinder"api specific to TFS and the capabilities within. If you want to get access beyond what this api provides, you can simply access the `TFS::Client.connection` object and run direct queries against odata, though if you want that kind of flexibility, it's probably better just got straight to the `ruby_odata` gem and skip this wrapper.

## API

The [TFS OData api][1] supports the following object types:

- Builds
- Build Definitions
- Changesets
- Changes
- Branches
- WorkItems
- Attachments
- Links
- Projects
- Queries
- AreaPaths
- IterationPaths

Currently, we support the following (due to my own purposes) with plans to further support the rest as well:

- Builds
- Changesets
- WorkItems
- Projects
- WorkItems

### Querying

All queries require a call to `#run` to finalize the query. This also makes it possible in most cases where you are defining a query to instead use `#to_query` to see the actual url-based query that will be run.

## Notes
While the api for `ruby_tfs` looks similar to Rails' `ActiveRecord` api, it is not meant to be an exact translation. The base type objects (`TFS::Builds`, `TFS::Projects`, etc) are setup to follow more of the [Repository pattern](http://martinfowler.com/eaaCatalog/repository.html) rather than an ORM-like pattern. The objects returned from the repository are actually from the [`ruby_odata`][2] library, which is a core dependency of this project. The odata lib does a great job of representing the OData… data, so I felt no need to re-wrap in a secondary set of layers. This opionon may change depending on the direction of the [`ruby_data`][2] project.

## Plans
The query engine currently works against the actual [OData api](http://www.odata.org/documentation/uri-conventions#QueryStringOptions). Eventually it'd be great to have a more "Ruby Way™" of doing this by doing some sort of query compilation between a Ruby DSL and the OData api. That will come in time.

## Credits
- Thanks to Damien White ([visoft](https://github.com/visoft)) for his [`ruby_odata`][2] wrapper. It made this project very painless to write.
- Thanks to Microsoft for allowing an OData wrapper to exist for TFS. It makes writing third-party, non .NET apps much more fun. Go open source!

## License
Apache v2

See the LICENSE.md file for more details.

[1]: https://tfsodata.visualstudio.com/
[2]: https://github.com/visoft/ruby_odata