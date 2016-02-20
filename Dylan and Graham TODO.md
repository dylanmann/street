## TODO 

###Backend

######This Iteration
* turn WKwebview into just html string viewer rather than URL viewer

  * get formatted html

  * parse article text, article titles, info boxes, main images, authors, sharing, etc, using xpath

  * should be separate class that returns article object that contains all that information


######Later/If Time
* Pull features from RSS features list

  * images, authors, titles, abstracts etc.

  * confirm that this is the features list they want to use for homepage
  
* hardcode section URLS, assume they don't change
  
  * parse the category pages for article links, images, abstracts so we can use it differently
  
* text size (probably [preferably] part of the CSS)

* other user story stuff


###Frontend

######This Iteration

* homepage view/ controller

  * features, categories, most recent?, images for both
  
######Later
  
* separate category views?  have to decide if/ how we want to deal with this

* format html, custom CSS for article html because theirs is bad and we want our own

* put logo stuff in top of every view (GET LOGOS?) that links to home page
