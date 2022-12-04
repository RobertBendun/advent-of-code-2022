import scala.io.Source



object Main extends App {
  val toPriority = ('a' to 'z') ++ ('A' to 'Z')
  def priority(c: Char) = toPriority.indexOf(c) + 1

  val input = Source.fromFile("./input.txt").getLines().toList

  println(
    input
      .map(line => line.splitAt(line.length()/2))
      .flatMap({ case (lhs, rhs) => (Set.from(lhs) & Set.from(rhs)).toSeq })
      .map(priority)
      .sum
  )

  println(
    input
    .grouped(3)
    .flatMap(_.map(Set.from(_)).reduceLeft(_ & _).toSeq)
    .map(priority)
    .sum
  )
}
