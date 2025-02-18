# --- MRQAP_Polarization_asnipe.R
#install.packages("pacman")         # Install pacman package

library('pacman')
p_load(asnipe, igraph, dplyr, ggplot2)

rm(list = ls())
setwd("/home/.samba/homes/mwindzio")
# setwd("E:/projekte/FGZ_segmentation/daten/andere/more_in_common/")
# path_data <- "E:/projekte/FGZ_segmentation/daten/andere/more_in_common"
#path_out <- "E:/projekte/FGZ_diskr_inst/0_publikationen/polarisierung_MC/out"
#path_data <- "E:/projekte/FGZ_diskr_inst/0_publikationen/polarisierung_MC/data"
path_out <- "~/Moral_foundations_polarization/out"
path_data <- "~/Moral_foundations_polarization/data" # BSS server


#data_sets <- c(1:20,2000)
data_sets <- c(1:1)

attr <- list()
net <- list()
bin_net <- list()
net_mat <- list()

# --- built data sets for valued networks: adjajecreny matrix and actor attributes
# --- later: data sets can be also list of countries

for (i in data_sets){
  
  # --- here data with unconstrained similarity
  #tempn  <- paste(path_data,"/0_RS2025_more_in_common_similarity_network",i,".dat", sep="")
  #tempn_ <- as.matrix(read.table(file=tempn, header = FALSE, na.strings = "-99"))
  #print(dim(tempn_))
  #net_mat[[i]] <- as.matrix(tempn_)
  #net[[i]] <- graph_from_adjacency_matrix(tempn_, mode="undirected", weighted=TRUE)
 
  tempn  <- paste(path_data,"/0_RS2025_more_in_common_two_mode_actors",i,".dat", sep="")
  attr[[i]] <- read.table(file=tempn, header = TRUE, na.strings = "-99")
  
  # -- here robustness check: maximal similarity truncated at 100
  tempn  <- paste(path_data,"/0_RS2025_more_in_common_similarity_network_TRUNC100",i,".dat", sep="")
  tempn_ <- as.matrix(read.table(file=tempn, header = FALSE, na.strings = "-99"))
  print(dim(tempn_))
  net_mat[[i]] <- as.matrix(tempn_)
  net[[i]] <- graph_from_adjacency_matrix(tempn_, mode="undirected", weighted=TRUE)
}

head(net_mat[[1]])
network <- net_mat[[1]]
network_rand <-  net_mat[[1]]
actors <- attr[[1]]
head(actors)
head(actors$Care)

actors[c(1:20), 16]

dim(network)

# -- distribution
network_vector <- as.vector(network)
head(network_vector)
network_vector %>% data.frame(network_vector) %>% ggplot(aes(x=network_vector)) + geom_density()

v <- c(1, 3, 5, 7)
distance_matrix <- as.matrix(dist(v))
distance_matrix

Care_d <- as.matrix(dist(actors$Care))
Care_d[c(1:20),c(1:20)]

# -- continuous variables: just compute the absolute difference to get abs_diff_
head(actors$Care)
head(actors$religiousness)
table(actors$soc_trust)
table(actors$reli_group)
table(actors$relig_comm)

abs_diff_Care      <- as.matrix(dist(actors$Care))
abs_diff_Fairness  <- as.matrix(dist(actors$Fairness))
abs_diff_Authority <- as.matrix(dist(actors$Authority))
abs_diff_Loyalty   <- as.matrix(dist(actors$Loyalty))
abs_diff_Purity    <- as.matrix(dist(actors$Purity))
abs_diff_Liberty   <- as.matrix(dist(actors$Liberty))
abs_diff_hh_income_i <- as.matrix(dist(actors$hh_income_i))
abs_diff_religiousness <- as.matrix(dist(actors$religiousness))
abs_diff_soc_trust <- as.matrix(dist(actors$soc_trust))



# -- discrete variables: just compute the absolute difference, set 0 to one, rest to 0
# -- and replace the main diagonal (== 1, because it was 0 previously) with 0 => 'sameness' same_
# -- ifelse(same_var == 0, 1, 0): if distance == 0 sameness =1, else sameness = 0 
same_schulabschl <- as.matrix(dist(actors$schulabschl)) # -- create distance matrix 
same_schulabschl[] <- ifelse(same_schulabschl == 0, 1, 0) # -- recode distances into 'sameness' 
diag(same_schulabschl) <- 0 # -- replace main diagonal with 0

same_frau <- as.matrix(dist(actors$frau))
same_frau[] <- ifelse(same_frau == 0, 1, 0)
diag(same_frau) <- 0

same_migrant <- as.matrix(dist(actors$migrant))
same_migrant[] <- ifelse(same_migrant == 0, 1, 0)
diag(same_migrant) <- 0

same_age_cat <- as.matrix(dist(actors$alter))
same_age_cat[] <- ifelse(same_age_cat == 0, 1, 0)
diag(same_age_cat) <- 0


same_reli_group <- as.matrix(dist(actors$reli_group))
same_reli_group[] <- ifelse(same_reli_group == 0, 1, 0)
diag(same_reli_group) <- 0

same_relig_comm <- as.matrix(dist(actors$relig_comm))
same_relig_comm[] <- ifelse(same_relig_comm == 0, 1, 0)
diag(same_relig_comm) <- 0

head(actors$schulabschl)
head(actors$frau)
head(actors)
head(actors$relig_comm)


# --- check abs_diff
head(actors$religiousness)
abs_diff_religiousness[1:6,1:6]
# --- check same
head(actors$frau)
same_frau[1:6,1:6]


# ---------------------------------------
# ---- models here ----------------------
# ---------------------------------------

# -- two data sets: one where similarity is truncated at maximum of 100
# -- activate correct name of output file

#sink(paste(path_out,"/RS_plarization_models_2025_01_31.txt", sep=""))
sink(paste(path_out,"/RS_plarization_models_TRUNC_100_2025_01_32.txt", sep=""))
# Run mrqap.dsp, runs over matrices as separate objects 

paste(Sys.time(),'time of begin of estimation')

# -- only social and demographic structure
reg0 <- mrqap.dsp(network ~ 
                    same_frau + same_migrant + same_age_cat + abs_diff_hh_income_i + same_schulabschl 
                  , randomisations=1000) # will take a while =1000
reg0

# -- only moral foundations
reg1 <- mrqap.dsp(network ~ 
                    abs_diff_Care + abs_diff_Fairness + abs_diff_Authority + abs_diff_Loyalty + abs_diff_Purity +
                    abs_diff_Liberty  , randomisations=1000) # will take a while =1000
reg1

# -- social and demographic structure + moral foundations, without religion
reg2 <- mrqap.dsp(network ~ 
                same_frau + same_migrant + same_age_cat + abs_diff_hh_income_i + same_schulabschl +  
                abs_diff_Care + abs_diff_Fairness + abs_diff_Authority + abs_diff_Loyalty + abs_diff_Purity +
                abs_diff_Liberty   , randomisations=1000) # will take a while =1000
reg2

# -- social and demographic structure + moral foundations + religion
reg3 <- mrqap.dsp(network ~ 
                    same_frau + same_migrant + same_age_cat + abs_diff_hh_income_i + same_schulabschl +  
                    abs_diff_religiousness + same_relig_comm +
                    abs_diff_Care + abs_diff_Fairness + abs_diff_Authority + abs_diff_Loyalty + abs_diff_Purity +
                    abs_diff_Liberty
                   , randomisations=1000) # will take a while =1000
reg3

# -- social and demographic structure + moral foundations + religion + social trust
reg4 <- mrqap.dsp(network ~ 
                    same_frau + same_migrant + same_age_cat + abs_diff_hh_income_i + same_schulabschl +  
                    abs_diff_religiousness + same_relig_comm + abs_diff_soc_trust +
                    abs_diff_Care + abs_diff_Fairness + abs_diff_Authority + abs_diff_Loyalty + abs_diff_Purity +
                    abs_diff_Liberty
                    , randomisations=1000) # will take a while =1000
reg4


paste(Sys.time(),'end of estimation, now summarize the models')

reg0
reg1
reg2
reg3
reg4

print(reg0)
print(reg1)
print(reg2)
print(reg3)
print(reg4)

sink()



# --- check creating objects in loop with assign






