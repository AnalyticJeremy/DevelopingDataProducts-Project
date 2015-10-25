require(shiny);

shinyUI(pageWithSidebar(
    headerPanel("Iris-o-Matic"),
    sidebarPanel(
       p("Like most people, you probably see irises every day and wonder, \"What species is that?\" This tool can help you find the answer!"),
       h3("Instructions"),
       p("To use the tool, simply measure the width and length of the petal of an iris.  Then enter the measurements in the input fields provided.  The species will be automatically determined for you!"),
       h4("Notes"),
       tags$ul(
           tags$li("All measurements must be specified in centimeters."),
           tags$li("The petal width must be between 0.1 and 2.5 centimeters for an accurate prediction."),
           tags$li("The petal length must be between 1.0 and 6.9 centimeters for an accurate prediction."),
           tags$li(HTML("This tool can only identify the following species:  <i>Iris setosa</i>, <i>versicolor</i>, and <i>virginica</i>.")),
           tags$li("Please note that it may take a few seconds for the display to update after you change your input.")
       )
   ),
    mainPanel(
        h1("1. Enter Measurements"),
        numericInput("petal.width", "Petal Width (cm)", 0.1, min=0.1, max=2.5, step=0.1),
        numericInput("petal.length", "Petal Length (cm)", 1.0, min=1.0, max=6.9, step=0.1),
        hr(),
        h1("2. Results"),
        p("You entered:"),
        htmlOutput("petalWidthText"),
        htmlOutput("petalLengthText"),
        htmlOutput("speciesText"),
        p("The plot below shows how your iris compares to other irises of a known species."),
        plotOutput("irisPlot"),
        p(htmlOutput("accuracyText")),
        p("Data for this tool comes from the \"iris\" data set in R.")
    )
));