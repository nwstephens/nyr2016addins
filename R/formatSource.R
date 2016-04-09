formatSource <- function() {
    
    context <- rstudioapi::getActiveDocumentContext()
    formatted <- formatR::tidy_source(text = context$contents, output = FALSE)
    contents <- paste0(formatted$text.tidy, collapse = "\n")
    rstudioapi::setDocumentContents(contents, id = context$id)
    
}
