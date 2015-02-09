cube <- function(x, n) {
  x^3
}
cube(3)
#
x <- 1:10
if(x > 5) {
  x <- 0
}else { 
  20
}
#3
f <- function(x) {
  g <- function(y) {
    y + z
  }
  z <- 4
  x + g(x)
}
z <- 10
f(3)
#4
x <- 5
y <- if(x < 3) {
  NA
} else {
  10
}
#What is the value of 'y' after evaluating this expression?
#5
h <- function(x, y = NULL, d = 3L) {
  z <- cbind(x, d)
  if(!is.null(y))
    z <- z + y
  else
    z <- z + f
  g <- x + y / z
  if(d == 3L)
    return(g)
  g <- g + 10
  g
}
h(1,2)
#Which symbol in the above function is a free variable?
f <- function(x) {
  g <- function(y) {
    y + z
  }
  z <- 4
  x + g(x)
}
z <- 10
f(3)
#
x <- 5
y <- if(x < 3) {
  NA
} else {
  10
}
