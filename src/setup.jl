using Pkg

Pkg.activate(".")
Pkg.update()
packages = ["HTTP", "JSON", "DataFrames", "Printf", "SQLite", "DBInterface"]

for package in packages
    Pkg.add(package)

end
