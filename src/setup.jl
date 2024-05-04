using Pkg
Pkg.activate(".")

packages = ["HTTP", "JSON", "DataFrames", "Printf"]

for package in packages
    Pkg.add(package)

end
