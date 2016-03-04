df   <- 24
p    <- 0.05
gg   <- data.frame(x=seq(5,50,0.1))
gg$y <- dchisq(gg$x,df)

library(ggplot2)
ggplot(gg) + 
  geom_path(aes(x,y)) +

geom_ribbon(data=gg[gg$x>qchisq(p,df,lower.tail=F),],
             aes(x, ymin=0, ymax=y),
             fill="red", alpha=0.45)
## Here below is another way to draw the rejection area.
##  geom_linerange(data=gg[gg$x>qchisq(p,df,lower.tail=F),],
##aes(x, ymin=0, ymax=y),
##fill="red", alpha=0.1)