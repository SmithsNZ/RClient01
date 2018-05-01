library("ggplot2")
data("diamonds")
View(diamonds)
help(diamonds)

ggplot(diamonds, aes(x=carat, y=price)) + geom_point()

ggplot(diamonds, aes(x=carat, y=price, color=clarity)) + geom_point()
ggplot(diamonds, aes(x=carat, y=price, color=color)) + geom_point()
ggplot(diamonds, aes(x=carat, y=price, color=clarity, size=cut)) + geom_point()
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth()
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + facet_wrap(~ clarity)
ggplot(diamonds, aes(x=carat, y=price, color=clarity)) + geom_point() + facet_wrap(~ cut)
ggplot(diamonds, aes(x=price)) + geom_histogram(binwidth=2000)
ggsave("diamonds_hist.png")
q()


