
using DataFrames
using PalmerPenguins

penguins = DataFrame(PalmerPenguins.load())



pverb = fn -> (args...) -> df -> fn(df, args...)


subsetting = pverb(subset)
filtering = pverb(filter)

# this works
subset(penguins, :species => s -> s .== "Adelie")
subsetting(:species => s -> s .== "Adelie")(penguins)

subsetting(:sex => sx -> in.(sx, ["male" "female"]), skipmissing = true)(penguins)

subsetting(:sex => sx -> map(e -> e in ["male" "female"], sx), skipmissing = true)(penguins)

in.([1 2], [1 2 3])

map(x -> in(x, ["male" "female"]), ["male" "male" "no"])





# ?
filter(:sex => x -> occursin(x, ["male" "female"]), penguins)

filter(penguins, :sex => x -> in.(x, ["male" "female"]))

# this works
subset(penguins, :sex => sx -> in.(sx, Ref(["female" "male"])), skipmissing = true)
subsetting(:sex => s -> in.(s))

subsetting(:sex => sx -> in.(sx, Ref(["female" "male"])), skipmissing = true)

subset(penguins, :sex => sx -> in.(sx, Ref(["female" "male"])), skipmissing = true)

subsetting(:sex => sx -> in(sx, Ref(["female" "male"])))(penguins)



