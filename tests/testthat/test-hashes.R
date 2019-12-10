

context("hashes")

test_that("coldist", {
  data(flowers)
  library(digest)

  # JND transform  
  vis.flowers <- vismodel(flowers, visual = "apis")
  cd.flowers <- coldist(vis.flowers, n = c(1, 1, 1))
  jnd.flowers <- jnd2xyz(cd.flowers)
  # expect_equal(digest::sha1(jndrot(jnd2xyz(coldist(vismodel(flowers, achromatic = "bt.dc", relative = FALSE), achromatic = TRUE))), digits = 4),
  #              "07064d68561bad24d8f02c0413611b5ba49ec53a")
  
  # Output
  expect_equal(digest::sha1(coldist(colspace(vismodel(flowers, visual = 'canis', achromatic = 'ml')), achromatic = TRUE), digits = 4), 
               "bc460149b2263a857c9d573e77169556fa641f56")
  # expect_equal(digest::sha1(coldist(vismodel(flowers, visual = 'canis', achromatic = 'ml'), achromatic = TRUE, n = c(1, 1)), digits = 4),
  #              "7329a3c550fe1d2939423e4104066c868891914f")
  expect_equal(digest::sha1(coldist(colspace(vismodel(flowers, visual = "canis", achromatic = "all")), n = c(1, 2), achromatic = TRUE, subset = "Hibbertia_acicularis"), digits = 4), 
               "27ab9af8efe2b1651cd36f8506262f87e2b127a7")
  expect_equal(digest::sha1(coldist(colspace(vismodel(flowers, visual = "apis", achromatic = "all", relative = FALSE, vonkries = TRUE), space = "hexagon"), n = c(1, 2), achromatic = TRUE, subset = c("Hibbertia_acicularis", "Grevillea_buxifolia")), digits = 4), 
               "754c01809100bdacc80d40db2359797f41180c23")
  expect_equal(digest::sha1(coldist(colspace(vismodel(flowers, visual = "segment")), achromatic = TRUE), digits = 4), 
               "d65c018342664ae9c8dca35e715c57dde28de30a")

})

test_that("colspace", {
  library(digest)
  data(flowers)
  
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "canis", achromatic = "all")), digits = 4),
               "443206b9f30dbf9fabb1025890e9c5953efb3b43") # dispace
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "apis", achromatic = "l")), digits = 4), 
               "1c8c2087dc1cb245a77b56c3e194002205cf4d20") # trispace
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "bluetit", achromatic = "ch.dc")), digits = 4), 
               "3e32a9a99b2bd284b8cf2077ae4668f0bb83ca9a") # tcs
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "musca", achro = "md.r1"), space = "categorical"), digits = 4), 
               "681486ec527c0f6e50e6dde1e23831f6c407895e") # categorical
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "segment", achromatic = "bt.dc"), space = "segment"), digits = 4), 
               "f47081fbc5f3f896fc50b2223937d91b6f61069e") # segment
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "apis", relative = FALSE, qcatch = "Ei", vonkries = TRUE, achromatic = "l"), space = "coc"), digits = 4), 
               "d6e5c22dd45d2604c0d2fc16509b8887cb7812d2") # coc
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "apis", qcatch = "Ei", vonkries = TRUE, relative = FALSE, achromatic = "l"), space = "hexagon"), digits = 4), 
               "2b51da258f4c5bcaf3a8a851e4e13cbd011c400f") # hexagon
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "cie10"), space = "ciexyz"), digits = 4), 
               "4738ecfa2f5859134d0578d84bdd103ad7912983") # ciexyz
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "cie10"), space = "cielab"), digits = 4), 
               "dfc481f4410e335fd63112db92712e4857f6515e") # cielab
  expect_equal(digest::sha1(colspace(vismodel(flowers, visual = "cie10"), space = "cielch"), digits = 4), 
               "f4e4cc8da4fdffddc80c51f2f830b88adba3779d") # cielch
  
  expect_equal(digest::sha1(summary(colspace(vismodel(flowers, visual = "cie10"), space = "cielch")), digits = 4),
               "8d9c05ec7ae28b219c4c56edbce6a721bd68af82")
  expect_equivalent(round(sum(summary(colspace(vismodel(flowers)))), 5), 4.08984)
  expect_equivalent(round(sum(summary(colspace(vismodel(flowers))), by = 3), 5), 7.08984)
  
})

test_that("processing & general", {
  library(digest)
  
  # Sensdata
  expect_equal(digest::sha1(sensdata(illum = 'all', bkg = 'all', trans = 'all'), digits = 4),
               "4e25ee65b1a5d3a993baf4ba11b6ad7c15348704")
  # Peakshape
  expect_equivalent(
    digest::sha1(peakshape(flowers, absolute.min = TRUE), digits = 5),
    "d257957d21449f28fd24a9a0a33220dcd9a371bd"
  )
  
  # Merge
  data(teal)
  teal1 <- teal[, c(1, 3:5)]
  teal2 <- teal[, c(1, 2, 6:12)]
  expect_equal(digest::sha1(merge(teal1, teal2, by = "wl"), digits = 4),
               "8c0579ca0ebb379ddd163f0b0d1b1c6b21c4c88c")
  
  # Subset
  data(sicalis)
  vis.sicalis <- vismodel(sicalis)
  tcs.sicalis <- colspace(vis.sicalis, space = "tcs")
  expect_equal(digest::sha1(subset(vis.sicalis, "C"), digits = 4),
               "4d77fb3cbccb2520faa75c427345e0e630fc4938")
  expect_equal(digest::sha1(subset(sicalis, "T", invert = TRUE), digits = 4),
                 "332a97ed1c25045b70d871a8686e268d09cefd76")
  
})

test_that("images", {
  library(digest)
  suppressWarnings(RNGversion("3.5.0")) # back compatibility for now
  set.seed(2231)
  
  papilio <- getimg(system.file("testdata/images/papilio.png", package = "pavo"))
  snakes <- getimg(system.file("testdata/images/snakes", package = "pavo"))
  
  expect_equal(digest::sha1(summary(papilio), digits = 4),
               "b133bda5cc2567ff80a35bdb6d1e5b89e87af8a5")
  expect_equal(digest::sha1(summary(snakes), digits = 4),
               "001fb04576b913633f04ea890edef83b41f07e16")
})

test_that("vismodel", {
  library(digest)
  data(flowers)
  
  # Output
  expect_equal(digest::sha1(vismodel(flowers, visual = "canis", achromatic = "all", illum = "bluesky"), digits = 4),
               "7885f3c09e3fa529cfca3658e214b22fac81f9eb")
  expect_equal(digest::sha1(vismodel(flowers, visual = "apis", qcatch = "fi", achromatic = "ml", scale = 10000), digits = 4),
               "cb9471e72e3261269799e6193d44c2067a36188d")
  expect_equal(digest::sha1(vismodel(flowers, visual = "bluetit", achromatic = "ch.dc", trans = "bluetit"), digits = 4),
               "d50c261f4a31527fe3ba4281fef66eabb9b9261f")
  expect_equal(digest::sha1(vismodel(flowers, visual = "musca", achromatic = "md.r1", relative = FALSE), digits = 4),
               "07c41c78516ef09dde394d6eec27cefe66c3bc77")
  expect_equal(digest::sha1(vismodel(flowers, visual = "apis", relative = FALSE, qcatch = "Ei", bkg = "green", vonkries = TRUE, achromatic = "l"), digits = 4),
               "7b348f76891decb04b06ad398cbef1ece1370a4f")
  expect_equal(digest::sha1(vismodel(flowers, visual = "cie10"), digits = 4),
               "ac896df0004fc14da08394ab6ade8f3764e0498a")
  
  # Attributes
  expect_equal(digest::sha1(attributes(vismodel(flowers, visual = "canis", achromatic = "all", illum = "bluesky")), digits = 4),
               "457f2380406720be0fb65d2c7d3efe4efcca5009")
  expect_equal(digest::sha1(attributes(vismodel(flowers, visual = "apis", qcatch = "fi", achromatic = "ml", scale = 10000)), digits = 4),
               "1692dd3afc83d7524d8d971af695f68794c673f2")
  expect_equal(digest::sha1(attributes(vismodel(flowers, visual = "bluetit", achromatic = "ch.dc", trans = "bluetit")), digits = 4),
               "81e59dc34d535e29bec068d7fcf7c828d9c3acef")
  # expect_equal(digest::sha1(attributes(vismodel(flowers, visual = 'musca', achro = 'md.r1', relative = FALSE)), digits = 4),  "3fcd2c3eb74ed4e6d2e505b2c207ca558f287d16")
  # expect_equal(digest::sha1(attributes(vismodel(flowers, visual = 'apis', relative = FALSE, qcatch = 'Ei', bkg = 'green', vonkries = TRUE, achromatic = 'l')), digits = 4),  "e1dc6128b9c4ce47a0664394f0e453e53ba6c9db")
  # expect_equal(digest::sha1(attributes(vismodel(flowers, visual = 'cie10')), digits = 4),  "38c06f479375903ba566d9fd7187f9efcf134761")
})
















  