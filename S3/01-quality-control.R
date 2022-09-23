# library('RPostgreSQL')
library('dplyr')
library('tidyr')
library("openxlsx")

## Connect to database

# pg = dbDriver("PostgreSQL")
# 
# con = dbConnect(pg, user="grieg", password="",
#                 host="localhost", port=5432, dbname="grieg")

## Load data

# query = "SELECT
# s.sid, s.code, e.respondent_id AS rid, s.ts,
# q.name, a.ord, a.val
# FROM subject s
# JOIN external_arc e ON e.sid = s.sid
# JOIN quest q ON q.sid = s.sid
# JOIN answer a ON a.qid = q.qid
# WHERE s.stid = 9 AND s.qidv_idx > 5
# AND q.name IN ('demo-0-pl', 'ICE-32-pl')
# ORDER BY s.sid, q.name, a.ord"
# 
# df = dbGetQuery(con, query)
# save(df, file = "./S3/01/input/dataset.RData")

load(file = "./S3/01/input/dataset.RData")

## Get data needed for quality control

demo = c(0,1,3,4:6) # CC concern, sex, birth, country, languages
checks = c(10,18,23) # CHECK questions

data1 = filter(df, (name == 'demo-0-pl' & ord %in% demo) | 
                   (name == 'ICE-32-pl' & ord %in% checks))

data1 = select(data1, sid, code, rid, ts, name, ord, val) %>%
  pivot_wider(id_cols = c("sid", "code", "rid", "ts"),
              names_from = c("name", "ord"),
              names_sep = ".",
              values_from = "val")

colnames(data1) = c("sid", "code", "rid", "ts", "CHECK1", "CHECK2", "CHECK3",
                    "CC", "sex", "birth", "country", "language1", "language2")

data1 = data1 %>% mutate(across(5:10, as.integer))

## Get previously acquired data needed for quality control

input1 = read.table("./S3/01/input/176496/results-survey176496.csv", header = T, sep = ",", encoding = "UTF-8")
input2 = read.table("./S3/01/input/381735/results-survey381735.csv", header = T, sep = ",", encoding = "UTF-8")

tokens1 = read.xlsx("./S3/01/input/176496/tokens-survey176496.xlsx", cols = c(3,4))
tokens2 = read.xlsx("./S3/01/input/381735/tokens-survey381735.xlsx", cols = c(3,4))

tokens = rbind(tokens1, tokens2)
colnames(tokens) = c("token", "rid")

input1 = filter(input1, !duplicated(input1['token'], fromLast = T))
input1 = tokens %>% inner_join(input1, by = "token")

input2 = filter(input2, !duplicated(input2['token'], fromLast = T))
input2 = tokens %>% inner_join(input2, by = "token")

data2 = rbind(input1[,c("token", "rid", "CC5", "GENDER", "AGE")], 
              input2[,c("token", "rid", "CC5", "GENDER", "AGE")])
colnames(data2) = c("token", "rid", "CC", "sex", "birth")

data2$sex = recode(data2$sex, "Kobieta" = 0, "Mężczyzna" = 1, "Inne" = 2)
data2$CC = recode(data2$CC, "W ogóle się tym nie martwię" = 0,
                  "Niezbyt się martwię" = 1,
                  "Trochę się martwię" = 2,
                  "Bardzo się martwię" = 3,
                  "Niezwykle się tym martwię" = 4)

data2$rid = as.character(data2$rid)

## Remove test data

data = data1 %>%
  inner_join(data2, by = "rid", suffix=c(".1",".2"))

sprintf('Initial sample size: N = %d', nrow(data)) # initial sample size

## Clean data based on quality criteria

# country & languages

data = data %>% filter(country == "Polska")
data = data %>% filter(language1 == "Polski" | language2 == "Polski")

# consistent reporting on sex
data = data %>% mutate(sex.matches = (sex.1 == sex.2))

# consistent reporting on age
data = data %>% mutate(age.matches = (birth.1 == birth.2))

# consistent reporting on CC concern, with difference of up to 2 points acceptable
data = data %>% mutate(CC.matches = (abs(CC.1 - CC.2) < 3))

# correct responses to control questions
data = data %>% mutate(acceptable.checks = ((CHECK1 == 0) + (CHECK2 == 2) + (CHECK3 == 4) > 2))

data = filter(data, sex.matches == TRUE
                & age.matches  == TRUE
                #& CC.matches == TRUE
                & acceptable.checks == TRUE)

sprintf('Final sample size: N = %d', nrow(data)) # final sample size

## Save output

subjects = data[,c("sid", "code", "rid", "token", "ts")]
save(subjects, file = "./S3/01/output/subjects.RData")
