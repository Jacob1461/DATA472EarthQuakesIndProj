
FROM julia:latest

WORKDIR /app

COPY src/ /app

RUN julia --project=@. -e "using Pkg; Pkg.instantiate();"

CMD ["julia", "--project=@.", "Earthquakes.jl"]

#Chatgpt was used to help create Dockerfile