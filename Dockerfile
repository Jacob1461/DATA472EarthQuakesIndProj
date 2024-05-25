
FROM julia:latest

WORKDIR /app

COPY . /app

RUN julia -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

CMD ["julia", "--project=@.", "Earthquakes_main.jl"]

#Chatgpt was used to help create Dockerfile