server<- shinyServer(function(input, output, session){

  Sys.sleep(.3)
  waiter::waiter_hide()

  output$suggestion <- renderText({

    req(input$file1)

    tryCatch(
      {

        inFile <- input$file1

        my_ratings <- readxl::read_excel(inFile$datapath, 1) |>
          set_names("food", "rate") |>
          drop_na()

      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        return("Töltsd fel az értékeléseidet tartalmazó excel fájlt, hogy az eheti menüből tudjunk neked javasolni! :)")
      }
    )

    if (!exists("my_ratings")) {

      "Tölts fel az értékeléseidet :)"
    }

    tryCatch({
    my_ratings |>
      (\(x) {walk2(x$food, x$rate, \(f, r) {
        menu <<- menu |>
          mutate(
            rate = ifelse(str_detect(str_to_lower(food), str_to_lower(f)), r, rate)
          )
      })}) ()

    s <- menu |>
      group_by(delivery_day) |>
      filter(!is.na(rate)) |>
      arrange(desc(rate)) |>
      filter(
        (delivery_day == "hétfő" & row_number() <= input$monday) |
          (delivery_day == "kedd" & row_number() <= input$tuesday) |
          (delivery_day == "szerda" & row_number() <= input$wednesday) |
          (delivery_day == "csütörtök" & row_number() <= input$thursday) |
          (delivery_day == "péntek" & row_number() <= input$friday)
      ) |>
      group_by(day, category) |>
      summarise(food = str_flatten(food, "; ")) |>
      ungroup() |>
      arrange(day, category) |>
      group_by(day) |>
      mutate(
        food = str_c(
          ifelse(row_number() != n(), " ├── ", " └── "),
          category, ": ", food
        )
      ) |>
      summarise(
        food = str_flatten(food, "\n")
      ) |>
      mutate(
        food = str_c("\n", str_to_title(day), ":\n", food)
      ) |>
      pull(food)

    return(s)

  })

  })

  output$downloadData <- downloadHandler(
    filename = function() {
      "my_ratings.xlsx"
    },
    content = function(file) {
      openxlsx::write.xlsx(tibble::tibble(food = c("Hortobágyi húsos palacsinta", "Bolognai spagetti", "pulykamell"), rate = c(5, 4, 3)), file)
    }
  )

})
