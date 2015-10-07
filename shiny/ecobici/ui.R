shinyUI(fluidPage(
        headerPanel('EcoBici Mexico'),
        mainPanel(
                tabsetPanel(id = "tabs1",
                        tabPanel('Info General',
                                column(6,
                                plotOutput("distPlot")),
                                column(6,
                                plotOutput("conteo_genero"))
                                )
                        )
                )
        )
)