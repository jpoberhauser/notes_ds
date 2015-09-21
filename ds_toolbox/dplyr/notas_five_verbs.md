also called verbs:
select(), which returns a subset of the columns,
filter(), that is able to return a subset of the rows,
arrange(), that reorders the rows according to single or multiple variables,
mutate(), used to add columns from existing data,
summarise(), which reduces each group to a single row by calculating aggregate measures.

select == variables
=====
select(df, Group, Sum)
returns everythings but this set of columns
select(hflights, -(DepTime:AirTime))
starts_with("X"): every name that starts with "X",
ends_with("X"): every name that ends with "X",
contains("X"): every name that contains "X",
matches("X"): every name that matches "X", which can be a regular expression,
num_range("x", 1:5): the variables named x01, x02, x03, x04 and x05,
one_of(x): every name that appears in x, which should be a character vector.

mutate == observations
====================
mutate(df, loss =   arrDelay- depDelay)

m1 <- mutate(hflights, loss = ArrDelay - DepDelay, loss_percent = (ArrDelay - DepDelay) / DepDelay * 100)

# Remove the redundancy from your previous exercise and reuse loss to define the loss_percent variable.
# Assign the result to m2
m2 <- mutate(hflights, loss = ArrDelay - DepDelay, loss_percent = loss / DepDelay * 100)

# Add the three variables as described in the third exercise and save the result to m3
m3 <- mutate(hflights, TotalTaxi = TaxiIn + TaxiOut, 
                       ActualGroundTime = ActualElapsedTime - AirTime, 
                       Diff = TotalTaxi - ActualGroundTime)
                       
filter == variables
=========
                       


arrange == observations


summarize == groups
