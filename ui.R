ui <- dashboardPage(skin = "green",
                    dbHeader,
                    dashboardSidebar(
                      fileInput('file1', 'Tölts del az értékeléseid (xlsx)',
                                accept = c(".xlsx")
                      ),
                      downloadButton("downloadData", "Minta excel letöltése"),
                      tags$hr(),
                      h3("  Ételek száma"),
                      sliderInput("monday", label = "Hétfő",
                                  min = 0,
                                  max = 10,
                                  value = 0
                      ),
                      sliderInput("tuesday", label = "Kedd",
                                  min = 0,
                                  max = 10,
                                  value = 0
                      ),
                      sliderInput("wednesday", label = "Szerda",
                                  min = 0,
                                  max = 10,
                                  value = 0
                      ),
                      sliderInput("thursday", label = "Csütörtök",
                                  min = 0,
                                  max = 10,
                                  value = 0
                      ),
                      sliderInput("friday", label = "Péntek",
                                  min = 0,
                                  max = 10,
                                  value = 0
                      ),
                      tags$hr()
                    ),
                    dashboardBody(
                      use_waiter(),
                      waiter_show_on_load(color = "#e12b2a"), # will show on load

                      box(width = 12, title = "Mi ez a projekt?",
                          p("Ennek a kis ingyenes applikációnak a lényege, hogy egy excel fájlba gyűjtött értékeléseid alapján az Interfood adott heti étlapjában keres és ajánl neked javaslatokat, hogy minél hamarabb megtaláld kedvenceidet a végtelenül nagy választékukban. :)"),
                          strong("Egyszerűen csak töltsd fel az excelt, add meg, hogy mely napokon szeretnél rendelni, és máris látod a javaslatokat."),
                          br(),
                          p("Az alkalmazás egyszerűen szavakra keres, szóval akár kedvenc ételfajáidra is kereshetsz, a teljes terméknév helyett (pl. csirkemell)."),
                          shiny::HTML(
                            '<script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="MarcellGranat" data-color="#FFDD00" data-emoji="" data-font="Cookie" data-text="Buy me a coffee" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>'
                          )
                      ),
                      box(width = 12, title = "Javaslatunk",
                          shiny::verbatimTextOutput("suggestion")
                      ),



                    )
)
