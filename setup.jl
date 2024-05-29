using Pkg

# Activate the environment located in the same directory as this file
Pkg.activate(@__DIR__)

# Ensure that all dependencies specified in the Project.toml and Manifest.toml files are installed
Pkg.instantiate()

# Update all installed packages
Pkg.update()

# List of packages to add (if not already included in Project.toml)
packages = ["HTTP", "JSON", "DataFrames", "Printf", "DBInterface", "AWS", "AWSS3", "Oxygen", "JSON3", "MySQL", "DataStructures"]

# Add each package to the environment
for package in packages
    Pkg.add(package)
end

# Resolve any dependencies
Pkg.resolve()

# Precompile all installed packages
Pkg.precompile()

# Now it's safe to import the packages
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
