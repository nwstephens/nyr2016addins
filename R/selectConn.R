#' @export
selectConn <- function() {
  ui <- miniPage(
    gadgetTitleBar("ODBC Connect"),
    miniContentPanel(
      selectInput('server', 'Server', c(
        'SQL Server',
        'Postgres'
      ), width='100%'),
      p(strong('Port')),
      verbatimTextOutput("selectedPort"),
      textInput('database', 'Database', 'airontime', width='100%'),
      textInput('uid', 'User ID', c('rstudioadmin'), width='100%'),
      passwordInput("pwd", "Password", 'ABCd4321', width='100%')
    )
  )

  server <- function(input, output) {

    output$selectedPort <- renderText({
      port()
    })

    port <- reactive({
      switch(
        input$server,
        `SQL Server` = 1433,
        `Postgres`   = 5432
      )
    })

    serverEndpoint <- reactive({
      switch(
        input$server,
        `SQL Server`  = 'sol-eng-sqlserv.cihykudhzbgw.us-west-2.rds.amazonaws.com',
        `Progress`    = 'sol-eng-postgre.cihykudhzbgw.us-west-2.rds.amazonaws.com'
      )
    })

    driver <- reactive({
      switch(
        input$server,
        `SQL Server` = '/opt/Progress/DataDirect/Connect64_for_ODBC_71/lib/ddsqls27.so',
        `Postgres`   = '/opt/Progress/DataDirect/Connect64_for_ODBC_71/lib/ddpsql27.so'
      )
    })

    observeEvent(input$done, {

      connectionList <- list(
        Driver = driver(),
        Server = serverEndpoint(),
        Port = port(),
        Database = input$database,
        UID = input$uid,
        PWD = input$pwd
      )

      connectionString <- paste(names(connectionList), connectionList, sep = '=', collapse = ';')

      stopApp(insertText(paste0("'", connectionString, "'")))

    })

  }

  runGadget(ui, server, viewer = dialogViewer('ODBC Connection', 350, 450))

}

