v1 <- c(1, 0, 0)
v2 <- c(0, 1, 0)

score <- function(self, foe) {
	rot  <- t(matrix(c(0,0,1, 1,0,0, 0,1,0), nrow=3))
	win  <- 6 * (self %*% (rot %*% foe))
	draw <- 3 * (self %*% foe)
	sel  <- c(1, 2, 3) %*% self
	return(sel + draw + win)
}

input <- read.delim("./input.txt", header=FALSE, sep=" ")

part1 <- function() {
	num <- list(
		'X' = c(1,0,0), 'Y' = c(0,1,0), 'Z' = c(0,0,1),
		'A' = c(1,0,0), 'B' = c(0,1,0), 'C' = c(0,0,1))

	foe  <- sapply(input$V1, function(x) { return(num[[x]]) })
	self <- sapply(input$V2, function(x) { return(num[[x]]) })

	total <- 0
	for (n in 1:ncol(self)) {
		total <- total + score(self[,n], foe[,n])
	}
	print(total)
}

part2 <- function() {
	num <- list(
		'A' = c(1,0,0), 'B' = c(0,1,0), 'C' = c(0,0,1))

	foe  <- sapply(input$V1, function(x) { return(num[[x]]) })
	self <- lapply(input$V2, function(x) { switch(x,
		"X" = matrix(c(0,0,1, 1,0,0, 0,1,0), nrow=3),
		"Y" = matrix(c(1,0,0, 0,1,0, 0,0,1), nrow=3),
		"Z" = matrix(c(0,1,0, 0,0,1, 1,0,0), nrow=3))
	})

	total <- 0
	for (n in 1:ncol(foe)) {
		f <- foe[,n]
		s <- t(self[[n]] %*% f)[1,]
		total <- total + score(s, f)
	}
	print(total)
}

part1()
part2()
