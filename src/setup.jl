"This is the setup file and should only be run one time"

using Pkg

Pkg.activate(joinpath(dirname(@__FILE__), ".."))
Pkg.update()
packages = ["HTTP", "JSON", "DataFrames", "Printf", "SQLite", "DBInterface"]

for package in packages
    Pkg.add(package)
end

Pkg.resolve()
Pkg.precompile()
