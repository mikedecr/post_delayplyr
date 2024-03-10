library(dplyr)
library(memoise)
library(purrr)
library(palmerpenguins)

# delay a verb; return a fn dv
# dv returns takes args and returns an "intention": a function of .data
# the intention is memoised so it won't recompute on repeated applications
curry_verb <- function(verb) {
    function(...) {
        intention <- function(.data) {
            return(purrr::partial(verb)(.data, ...))
        }
        memoise(intention)
    }
}

# curry <- function(verb, ...) {
#     function(...) {
#         f = partial(verb, ...)
#         intention <- function(...) {
#             return(f(...))
#         }
#         memoise(intention)
#     }
# }

# interface layer:
# functions from ... to fn: df -> df
# feels kinda like transducers in clojure:
#    functional intent, data not required up front
filtering = curry(filter)
summarizing = curry(summarize)
grouping = curry(group_by)

# composition operators let us "pipe" these steps into a recipe without eagerly evaluating
`%.%` = function(g, f) function(...) g(f(...))
`%|%` = function(f, g) function(...) g(f(...))

# we use the "curried" verbs to functionalize "pipeline steps".
# but because we can name the steps as fns, it is very easy reorder and compose them
smz_mass = summarizing(
    mean_mass = mean(body_mass_g, na.rm = TRUE),
    sd_mass = sd(body_mass_g, na.rm = TRUE),
    n = n(),
    .groups = "drop"
)
by_sex = grouping(sex)
flts = filtering(!is.na(sex), species == "Adelie")


# value prop: I wrote the summarizing step one time.
# I can reapply it in many contexts without rewriting it.
smz_mass(penguins)
(smz_mass %.% by_sex)(penguins)
(smz_mass %.% by_sex %.% flts)(penguins)

