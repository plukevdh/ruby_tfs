# ruby_tfs
TFS.rb is a wapper around the odata API for TFS

- [The project](http://www.microsoft.com/en-us/download/details.aspx?id=36230)
- [The specification][1]

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

## Credits
- Thanks to Damien White ([visoft](https://github.com/visoft)) for his [`ruby_odata`](https://github.com/visoft/ruby_odata) wrapper. It made this project very painless to write.
- Thanks to Microsoft for allowing an OData wrapper to exist for TFS. It makes writing third-party, non .NET apps much more fun. Go open source!

## License
Apache v2

See the LICENSE.md file for more details.

[1]: https://tfsodata.visualstudio.com/