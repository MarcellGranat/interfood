library(shiny)
library(shinymanager)
library(shinydashboard)
library(leaflet)
library(googlesheets4)
library(tidyverse)
library(plotly)
library(waiter)

# setup -------------------------------------------------------------------

spinner <- tagList(
  spin_chasing_dots(),
  span("Loading stuff...", style="color:white;")
)

options(scipen = 999)

dbHeader <- dashboardHeader(title = "Interfood ajánló",
                            tags$li(a(href = 'https://marcellgranat.com',
                                      img(src = 'icon.png',
                                          title = "Marcell Granát", height = "30px"),
                                      style = "padding-top:10px; padding-bottom:10px;"),
                                    class = "dropdown"))

inactivity <- "function idleTimer() {
var t = setTimeout(logout, 120000);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions

function logout() {
window.close();  //close the window
}

function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, 120000);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();"
