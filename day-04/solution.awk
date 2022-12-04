function min(a, b) { if (a < b) return a; return b }
function max(a, b) { if (a > b) return a; return b }

{
	if (($1 <= $3 && $4 <= $2) || ($3 <= $1 && $2 <= $4)) ++part1
	if (max($1,$3) <= min($2,$4))                         ++part2
}

END { print part1 "\n" part2 }
