using Pkg

Pkg.activate(@__DIR__)
Pkg.instantiate()
Pkg.update()
packages = ["HTTP", "JSON", "DataFrames", "Printf", "DBInterface", "AWS", "AWSS3", "Oxygen", "JSON3", "MySQL", "DataStructures"]

for package in packages
    Pkg.add(package)
end

Pkg.resolve()

Pkg.precompile()

using HTTP
using JSON
using DataFrames
using Printf
using DBInterface
using AWS
using AWSS3
using Oxygen
using JSON3
using MySQL
using DataStructures
