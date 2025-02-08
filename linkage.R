library(reclin2)
# https://journal.r-project.org/articles/RJ-2022-038/

data("linkexample1", "linkexample2")

# pair(linkexample1, deduplication = TRUE)

# pairs <- pair(linkexample1, linkexample2)
pairs <- pair_blocking(linkexample1, linkexample2, "postcode")

(compare_pairs(pairs, on = c("lastname", "firstname", "address", "sex"),
              comparators = list(lastname = jaro_winkler(0.9), 
                                 firstname = jaro_winkler(0.9), 
                                 address = jaro_winkler(0.9)), 
                                 inplace = TRUE))


m <- problink_em(~ lastname + firstname + address + sex, data = pairs)
pairs <- predict(m, pairs = pairs, add = TRUE)


compare_vars(pairs, "true", on_x = "id", on_y = "id", inplace = TRUE)
mglm <- glm(true ~ lastname + firstname, data = pairs, family = binomial())
pairs[, pglm := predict(mglm, type = "response")]

pairs <- select_n_to_m(pairs, "weights", variable = "select", threshold = 0)

linked_data_set <- link(pairs, selection = "select")

