#############################################
#Install package from github
#############################################
if (!require('devtools')) install.packages('devtools');
#make sure you have Rtools installed first! if not, then run:
#install.packages('installr')
#install.Rtools()
if (!require('installr')) devtools::install_github('talgalili/installr')
require('installr')
#############################################
#Get the list of most downloaded Rpackages
#############################################
#This step takes a lot of time if you set a large range of date
RStudio_CRAN_data_folder <-
  download_RStudio_CRAN_data(START = '2016-07-01',END = '2016-09-21')
my_RStudio_CRAN_data <- read_RStudio_CRAN_data(RStudio_CRAN_data_folder)
my_RStudio_CRAN_data <- format_RStudio_CRAN_data(my_RStudio_CRAN_data)
most_downloaded_packages(my_RStudio_CRAN_data)
top_packages <- names(most_downloaded_packages(my_RStudio_CRAN_data))
lineplot_package_downloads(pkg_names = top_packages, dataset = my_RStudio_CRAN_data)