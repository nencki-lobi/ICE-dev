# library('RPostgreSQL')
library('dplyr')
library('tidyr')

## Connect to database

# pg = dbDriver("PostgreSQL")
# 
# con = dbConnect(pg, user="grieg", password="",
#                 host="localhost", port=5432, dbname="grieg")

## Load data

# query = "SELECT 
# s.sid, s.code, e.respondent_id AS rid,
# q.name, a.ord, a.val
# FROM subject s 
# JOIN external_arc e ON e.sid = s.sid
# JOIN quest q ON q.sid = s.sid
# JOIN answer a ON a.qid = q.qid
# WHERE s.stid = 3 AND s.qidv_idx > 14
# AND q.name IN ('demo-0-pl', 'ICE-60-pl')
# ORDER BY s.sid, q.name, a.ord"
# 
# df = dbGetQuery(con, query)
# save(df, file = "./S2/01/input/dataset.RData")

load(file = "./S2/01/input/dataset.RData")

## Get data needed for quality control

demo = c(0,1,3,4:6) # CC concern, sex, birth, country, languages
checks = c(19,34,44) # CHECK questions

data1 = filter(df, (name == 'demo-0-pl' & ord %in% demo) | 
                   (name == 'ICE-60-pl' & ord %in% checks))

data1 = select(data1, sid, code, rid, name, ord, val) %>%
  pivot_wider(id_cols = c("sid", "code", "rid"),
              names_from = c("name", "ord"),
              names_sep = ".",
              values_from = "val")

colnames(data1) = c("sid", "code", "rid", "CHECK1", "CHECK2", "CHECK3",
                    "CC", "sex", "birth", "country", "language1", "language2")

data1 = data1 %>% mutate(across(4:9, as.integer))

data1$age = 2022 - data1$birth

## Get company data needed for quality control

data2 = read.table("./S2/01/input/recruited.csv", header = T, sep = ",", encoding = "UTF-8")
data2 = data2[,c(3,12,4,6)]

colnames(data2) = c("rid", "CC", "sex", "age")

data2$rid = as.character(data2$rid)

## Remove test data

data = data1 %>%
  inner_join(data2, by = "rid", suffix=c(".1",".2"))

sprintf('Final sample size: N = %d', nrow(data)) # initial sample size

## Clean data based on quality criteria

# country & languages

data = data %>% filter(country == "Polska")
data = data %>% filter(language1 == "Polski" | language2 == "Polski")

# consistent reporting on sex
data = data %>% mutate(sex.matches = (sex.1 + 1 == sex.2))

# consistent reporting on age, with difference of 1 year acceptable
data = data %>% 
  mutate(age.matches = case_when(age.2 == 2 & age.1 >= 18 & age.1 <= 24 ~ TRUE, 
                                 age.2 == 3 & age.1 >= 23 & age.1 <= 36 ~ TRUE,
                                 age.2 == 4 & age.1 >= 35 & age.1 <= 56 ~ TRUE,
                                 age.2 == 5 & age.1 >= 55 & age.1 <= 73 ~ TRUE,
                                 TRUE ~ FALSE))

# consistent reporting on CC concern, with difference of up to 2 points acceptable
data = data %>% mutate(CC.matches = (abs(CC.1 + 1 - CC.2) < 3))

# correct responses to control questions
data = data %>% mutate(acceptable.checks = ((CHECK1 == 0) + (CHECK2 == 2) + (CHECK3 == 4) > 2))

data = filter(data, sex.matches == TRUE 
                & age.matches  == TRUE
                #& CC.matches == TRUE 
                & acceptable.checks == TRUE)

sprintf('Final sample size: N = %d', nrow(data)) # final sample size

## Save output

subjects = data[,c("sid", "code", "rid")]
save(subjects, file = "./S2/01/output/subjects.RData")
