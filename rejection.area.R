#draw a normal distribution plot
plot(seq(-3.2,3.2,length=50),dnorm(seq(-3,3,length=50),0,1),type="l",xlab="",ylab="",ylim=c(0,0.5))
segments(x0 = c(-3,3),y0 = c(-1,-1),x1 = c(-3,3),y1=c(1,1))
text(x=0,y=0.45,labels = expression("99.7% of the data within 3" ~ sigma))
arrows(x0=c(-2,2),y0=c(0.45,0.45),x1=c(-3,3),y1=c(0.45,0.45))
segments(x0 = c(-2,2),y0 = c(-1,-1),x1 = c(-2,2),y1=c(0.4,0.4))
text(x=0,y=0.3,labels = expression("95% of the data within 2" ~ sigma))
arrows(x0=c(-1.5,1.5),y0=c(0.3,0.3),x1=c(-2,2),y1=c(0.3,0.3))
segments(x0 = c(-1,1),y0 = c(-1,-1),x1 = c(-1,1),y1=c(0.25,0.25))
text(x=0,y=0.15,labels = expression("68% of the data within 1" * sigma),cex=0.9)

##another example to draw a rejection area.
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
## Here below is another way to draw the rejection area(change the geom_ribbon() to geom_linerange()).
##  geom_linerange(data=gg[gg$x>qchisq(p,df,lower.tail=F),],
##aes(x, ymin=0, ymax=y),
##fill="red", alpha=0.1)
