pacman::p_load("tidyverse", "rvest", "openxlsx")

scrape_day <- function(d) {
  read_html("https://www.interfood.hu/etlap-es-rendeles/") |>
    html_nodes(paste0(".cell:nth-child(", d, ") .food-etlap-szoveg")) |>
    html_text() |>
    enframe(name = NULL, value = "food") |>
    filter(str_starts(food, "\r\n        \\d{1,} kcal", negate = TRUE), str_squish(food) != "") |>
    mutate(
      food = str_remove(food, " V$"),
      food = str_squish(food),
      day = c("hétfő", "kedd", "szerda", "csütörtök", "péntek", "szombat")[d]
    )
}

menu <- map_dfr(1:6, scrape_day) |>
  group_by(day) |>
  mutate(
    rate = NA_integer_,
    category = case_when(
      day != "szombat" & row_number() <= 6 ~ "leves",
      day != "szombat" & row_number() <= 8 ~ "saláta",
      day != "szombat" & row_number() <= 16 ~ "fitness",
      day != "szombat" & row_number() <= 26 ~ "rántott",
      day != "szombat" & row_number() <= 34 ~ "főzelék",
      day != "szombat" & row_number() <= 36 ~ "világkonyha",
      day != "szombat" & row_number() <= 50 ~ "főétel",
      day != "szombat" & row_number() <= 52 ~ "vadvilág",
      day != "szombat" & row_number() <= 55 ~ "menük",
      day != "szombat" & row_number() <= 56 ~ "hidegtál",
      day != "szombat" & row_number() <= 59 ~ "desszert",
      day != "szombat" & row_number() <= 64 ~ "vegán",
      day != "szombat" & row_number() <= 70 ~ "paleo",
      day != "szombat" & row_number() <= 72 ~ "savanyúság",
      day != "szombat" & row_number() <= 74 ~ "pékáru",
      day != "szombat" & row_number() <= 87 ~ "karcsúsító",
      day != "szombat" & row_number() <= 92 ~ "eisberg",
      day == "szombat" & row_number() <= 2 ~ "leves",
      day == "szombat" & row_number() <= 8 ~ "rántott",
      day == "szombat" & row_number() <= 12 ~ "főétel",
      day == "szombat" & row_number() <= 15 ~ "menük",
      day == "szombat" & row_number() <= 17 ~ "desszert",
      TRUE ~ "egyéb"
    ),
    category = factor(category, levels = c("leves", "saláta", "fitness", "rántott", "főzelék", "világkonyha", "főétel", "vadvilág", "menük",
                                  "hidegtál", "desszert", "vegán", "paleo", "savanyúság", "pékáru", "karcsúsító", "eisberg", "egyéb"), ordered = TRUE),
    delivery_day = ifelse(day == "szombat", "péntek", day),
    day = factor(day, levels = c("hétfő", "kedd", "szerda", "csütörtök", "péntek"), ordered = TRUE)
  ) |>
  ungroup() |>
  distinct_all()


