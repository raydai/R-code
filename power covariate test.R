
# Power analysis for covariate control
rm(list=ls())
possible.ns <- seq(from=20, to=150, by=2)         # The sample sizes we'll be considering
powers <- rep(NA, length(possible.ns))            # Empty object to collect simulation estimates
powers.cov <- rep(NA, length(possible.ns))        # Need a second empty vector
alpha <- 0.05                                     # Standard significance level
sims <- 2000                                      # Number of simulations to conduct for each N

#simulated dataset
# install.packages("mvtnorm")
library(mvtnorm)
sigma<-matrix(c(28,16.5,16.5,16.5,256,128,16.5,128,256), ncol=3)                 #set up covaraince matrix      
group <- rmvnorm(n=2000, mean=c(26.3,122,122), sigma=sigma, method="chol")       #create a dataset for sbp control group
row.names(group)<-c(1:length(group[,1]))                                         #Set the row name for the dataset
colnames(group)<-c("bmi","sbp1","sbp2")                                          #Set the column name for the dataset

#### Outer loop to vary the number of subjects ####
for (j in 1:length(possible.ns)){
  N <- possible.ns[j]                                   # Pick the jth value for N

  significant.experiments <- rep(NA, sims)              # Empty object to count significant experiments
  significant.experiments.cov <- rep(NA, sims)          # Need a second empty vector here too

  #### Inner loop to conduct experiments "sims" times over for each N ####
  for (i in 1:sims){
  
    gp1<-group[sample(nrow(group),size=N,replace=FALSE),] # Random sample our dataset
    Y0<-gp1[,2]                                           # Assign sbp1 to the new variable Y0
    bmi<-gp1[,1]                                          # Assign value to bmi
    
    
    ## Define the treatment effect on differnet groups##
    tau <- -10                                          # Hypothesize treatment effect
    Y1 <- Y0 + tau                                      # Post SBP value
    Z.sim <- rbinom(n=N, size=1, prob=.5)               # Random assign case and control group
    Y.sim <- Y1*Z.sim + Y0*(1-Z.sim)                    # Random pick subjects and assigne their post SBP value
    fit.sim <- lm(Y.sim ~ Z.sim)                        # Do analysis (Simple regression)
    
    ## This is the regression analysis -- including BMI covariate##
    fit.sim.cov <- lm(Y.sim ~ Z.sim  + bmi)
    
    ## extract p-values and calculate significance ##
    p.value <- summary(fit.sim)$coefficients[2,4]                # Extract p-values
    p.value.cov <- summary(fit.sim.cov)$coefficients[2,4]
    significant.experiments[i] <- (p.value <= alpha)             # Determine significance according to p <= 0.05
    significant.experiments.cov[i] <- (p.value.cov <= alpha)
  }
  powers[j] <- mean(significant.experiments)            # Store average success rate (power) for each N
  powers.cov[j] <- mean(significant.experiments.cov)
}

#Plot power function curve
plot(possible.ns, powers, ylim=c(0,1), type = "l",lty=2, main = "Power simulation", xlab = "Sample size", ylab = "Power")
points(possible.ns, powers.cov, col="red", type = "l")
abline(h=0.8, col="red",lty = 2)
legend("topleft",legend=c("With BMI", "No BMI"),lty=c(1,2),col=c("red","black"),bg="white",lwd=1,cex=1, pt.cex =0.5)
grid()


powerdata<-data.frame(possible.ns,powers,powers.cov)                  # Whole results
newdata2 <- powerdata[ which(powers>=0.8 |  powers.cov >= 0.8),]      # Dataset with sample size and their power values
newdata2