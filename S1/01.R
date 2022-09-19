library('dplyr')
library('tidyr')

## Load data

# Across all data sources, each participant can be uniquely identified by `token`
input1 = read.table("./01/input/176496/results-survey176496.csv", header = T, sep = ",", encoding = "UTF-8") # general population dataset 1 (recruited by the company)
input2 = read.table("./01/input/381735/results-survey381735.csv", header = T, sep = ",", encoding = "UTF-8") # general population dataset 2 (recruited by the company)
input3 = read.table("./01/input/977613/results-survey977613.csv", header = T, sep = ",", encoding = "UTF-8") # activists' dataset

# Remove duplicated tokens (test participants), keep the last entry
input1 = filter(input1, !duplicated(input1['token'], fromLast = T))
input2 = filter(input2, !duplicated(input2['token'], fromLast = T))

# Manually create tokens for the activists' dataset
tokens = paste(replicate(n=nrow(input3), 'activist'), as.character(1:nrow(input3)), sep="")
input3 = input3 %>% mutate(token=tokens, .after=seed)

# Merge datasets
df = rbind(input1[,c(6, 7, 14:206)], # token, timestamp, data
           input2[,c(6, 7, 14:206)],
           input3[,c(6, 7, 14:206)])

df = df %>% rename(ts = startdate)

save(df, file = "./01/input/dataset.RData")

## Get activists' data

activists = df %>% filter(grepl("^activist", token))

## Get data needed for quality control (applicable to general population data only)

demo = c("CC5", "GENDER", "AGE") # CC concern, sex, birth

data1 = df %>% filter(!grepl("^activist", token)) %>% select("token" | "ts" | contains("CHECK") | all_of(demo))

colnames(data1) = c("token", "ts", "CHECK1", "CHECK2", "CHECK3",
                    "CC", "sex", "birth")

data1$age = 2021 - as.integer(data1$birth)

data1$sex = recode(data1$sex, "Kobieta" = 0, "Mężczyzna" = 1, "Inne" = 2)
data1$CC = recode(data1$CC, "W ogóle się tym nie martwię" = 0,
                  "Niezbyt się martwię" = 1,
                  "Trochę się martwię" = 2,
                  "Bardzo się martwię" = 3,
                  "Niezwykle się tym martwię" = 4)

## Get company data needed for quality control (applicable to general population data only)

recruited1 = read.table("./01/input/176496/recruited.csv", skip = 1, sep = ";", encoding = "UTF-8")
recruited2 = read.table("./01/input/381735/recruited.csv", skip = 1, sep = ";", encoding = "UTF-8")

data2 = rbind(recruited1, recruited2)
data2 = data2[,c(3,12,4,6)]

colnames(data2) = c("token", "CC", "sex", "age")

## Remove test data

data = data1 %>%
  inner_join(data2, by = "token", suffix=c(".1",".2"))

sprintf('Initial sample size: N = %d', nrow(data)+nrow(activists)) # initial sample size

## Clean data based on quality criteria (applicable to general population data only)

# consistent reporting on sex
data = data %>% mutate(sex.matches = (sex.1 + 1 == sex.2))

# consistent reporting on age, with difference of 1 year acceptable
data = data %>% 
  mutate(age.matches = case_when(age.2 == 2 & age.1 >= 18 & age.1 <= 24 ~ TRUE, 
                                 age.2 == 3 & age.1 >= 23 & age.1 <= 36 ~ TRUE,
                                 age.2 == 4 & age.1 >= 35 & age.1 <= 56 ~ TRUE,
                                 age.2 == 5 & age.1 >= 55 & age.1 <= 73 ~ TRUE,
                                 TRUE ~ FALSE))

# consistent reporting on CC concern, with difference by no more than 1 point acceptable
data = data %>% mutate(CC.matches = (abs(CC.1 + 1 - CC.2) < 2))

# correct responses to control questions
data = data %>% mutate(acceptable.checks = ((CHECK1 == "Zdecydowanie nie") + 
                                            (CHECK2 == "Zdecydowanie tak") + 
                                            (CHECK3 == "Ani tak, ani nie") > 2))

data = filter(data, sex.matches == TRUE 
                & age.matches  == TRUE
                & CC.matches == TRUE 
                & acceptable.checks == TRUE)

sprintf('Final sample size: N = %d', nrow(data)+nrow(activists)) # final sample size

## Save output

subjects = rbind(data[,c("token", "ts")],
                 activists[,c("token", "ts")])

save(subjects, file = "./01/output/subjects.RData")
