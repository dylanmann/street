##Organization of site

######Parent tag : //article[@class = "standard hidden-xs"]/div

* title

  * ./div/h4/a/

* url

  * ./div/h4/a/@href

* author

  * ./div/aside/p/span[1]

* date 

  * ./div/aside/p/span[2]

* image

  * ./a/div/img/@src

* abstract

  * ./div/p[not(contains(@class, " "))]

* category

  * ./div/p[contains(@class, "section")]
  
* features

  * work in progress
  
  
We should talk with Andrew about commitment to the tags on the site and likelyhood that they are changed.  If it is possible for them to change, we should consider asking him to name them with unique ids that won't change, as they would make parsing better and more reliable.  
