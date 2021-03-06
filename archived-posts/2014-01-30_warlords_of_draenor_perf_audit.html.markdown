---
title: Warlords of Draenor Performance Audit
slug: warlords-of-draenor-perf-audit
time: 01:11:00
---

#Warlords of Draenor Microsite Performance Audit

I noticed when I looked at the Warlods of Draenor microsite that it took quite awhile to load the page. After my initial investigation I found out that it had 96 assets on the pages (including the HMTL file itself), and was 5MB in size.

To pinpoint some of the issues I had a look at 4 different performance tools. Chrome Devtools Network Tab, Google PageSpeed Browser Plugin, Google Devtools Audit, and Webpagetest.org.

Along the way I'll be adding in what the Total requests would be and what the Total file size would be if what I had found were to be implemented. Keep in mind I haven't actually implemented it so the Total file size is based off data from the tools. For example, I mentioning combining images into an image sprite. If separately 4 images are 5KB I'm unsure if put into an image sprite that they'd be 20KB. So the Total file size will be based off the data, not actually results.

## Network Tab Results
The network tab is where I found out that it has 96 requests. The total size sent is 5.0 MB. It took 38.66 seconds to send and display everything.

The 96 requests was bothersome. It's generally pretty easy to get it down under 50 requests with little effort (Image Sprites and combining JS or CSS files). Web browsers can only handle so many requests at a time, so the fewer total requests, the faster everything displays. It feels like some of the files could be borrowed from a general "Blizzard" style or js library(s), however, using a build tool that combines them before deploying like Grunt, or using something like mod_pagespeed could take care of that if, for some reason, they're unable to to manually combine those files.

## Google PageSpeed Browser Plugin Results
Running this pulled up only a few things. Of the 27 tests it runs it only found 9 things to improve on, so that's a plus.

1. Reduce blocking resources
Inline small JS.
http://us.battle.net/.../carousels.js?v37, http://us.battle.net/.../main.js?v37, http://us.battle.net/.../map.js?v37, http://us.battle.net/.../questing.js?v37 are all very small files, and could be inlined into the page itself to remove 4 requests. As well, since JS files block page rendering having fewer is rather ideal. If these could just be included into one or two "main" JS files then that'd be okay. Again, Grunt could accomplish something like that.

Total requests: 92
Total size: 5.0MB

2. Minimize payload (reduce filesize and reduce requests)
	1. Optimize images
	A lot of the images look to be optimized already, however, this tool did pull up that more could be done. 93KB could be removed from the total size. Not lots, but when you have 5.0MB to reduce, starting with removing 93KB is an okay start. If there's a way to automate image compression with a tool during development this would be ideal, so that it doesn't get missed.

	Total requests: 92
	Total size: 4.91MB

	2. Combine images into CSS sprites.
	5 images are listed as being good candidates to combining into an image sprite. Doing so would reduce the number of requests by another 4 (because we're adding one for the sprite).

	Total requests: 88
	Total size: 4.91MB

	3. Minify JavaScript
	Could reduce the total size by 19KB. Automate this in the build.

	Total requests: 88
	Total size: 4.72MB

	4. Minify CSS
	I use Sass so this is automated for me, however there are other build tools that could be used. CSS is also typically not very beneficial to minify, however, if it's automated then it isn't an issue. Can reduce file size by 1.3KB (yea, see, very little gain)

	Total requests: 88
	Total size: 4.707MB

	5. Minify HTML
	Typically overlooked, minifying HTML can crunch out a bit from the total size. In this case it's 930B (or 0.90KB)

	Total requests: 88
	Total size: 4.706KB

3. Other
	1. Leverage browser caching
	There's about 30 files set to expire after 1 day. It could be possible to setup the files to have a far future expiration date and still have them versioned or be replaced nicely. For example. Naming the file login.37.js instead of login.js with a query string at the end and then having the markup updated automatically to pull it in if updated to login.38.js would be ideal. Can be awkward to setup at first but there are several solutions out there to provide this.
	2. Defer parsing of JavaScript
	According to this tool some JS is being grabbed before it's needed. Moving it lower into the code would speed how soon a user sees information.
	3. Remove quest string from static resources
	Some proxy caching servers have problems with ? in the file name. The solution I mentioned under Leverage browser caching would take care of this.

## Google Devtools Audit Results
This pulled up some great information

1. Combine external JavaScript (20 files)
Either manually put perferrably automate this. Being able to remove 19 requests with a small amount of wrok is a wonderful gain for performance.

Total requests: 69
Total size: 4.706KB

2. Enable gzip compression (4)
It isn't being used on the .webm files. Could save 1.2MB

Total requests: 69
Total size: 3.5MB

3. Remove unused CSS rules (61%)
Likely a lot of these rules come from the fact that the CSS files are used across the site. I'm going to guess that removing 61% of the code from the file would reduce the filesize of the 59.8KB CSS files (total size), even though it isn't 100% accurate. So 39% of 59.8KB is 22.72KB (according to Google anyways)

Total requests: 69
Total size: 3.47MB

I was surprised it didn't pull up more for image combining nor point out that there's 3 CSS files and that they could easily be 1. So, let's combine the 3 CSS files into 1. The real trick with web performance is to keep applying it during the initial creation of the site. Coming to it after the site is done often ends with fewer possible improvements.

Total requests: 67
Total size: 3.47MB

## WebPageTest.org Results
The site did quite well on the test: http://www.webpagetest.org/result/140101_ER_3EP/1/performance_optimization/

1. Compress Images: 81/100
This found that it was possible to get 434.4KB savings, as opposed to the 93KB that Google Page Speed said. So let's use the bigger number of savings. 3.47MB + 93KB - 434KB (I'm assuming that the two image compression results are not cumulative).

Total requests: 67
Total size: 3.2MB

2. Use Progressive JPEGs: 14/100
So far I've mainly only mentioned ways to reduce file size and number of assets that come acorss. Progressize JPEGs is something entirely different. Progressive JPEGs render differenly to the user. A poor quality image is displayed and then a higher quality image is displayed in layers several times over until the final version displays. Demo video: https://www.youtube.com/watch?v=TOc15-2apY0

The images can sometimes be sligthly larger, however, they give the user something to see near instantly, whereas "non-interlaced" JPEGs do not display everything until the entire image as been downloaded.

Progressive JPEGs can give the user something to see sooner, so that's the performance boost. I admit, I haven't tested them out too much.

3. Leverage browser caching of static assets: 65/100
WebPageTest pulled up that a lot of the images need better caching. This is consistent with what Google PageSpeed pulled up

4. Use a CDN for all static assets: 15/100
Pretty much all Images, JS, and CSS files are listed. I was surprised that CSS files were listed, as if they're used on a CDN then you can end up with a pretty bad FOUT (flash of unstyled text) while it's loading it from a separate domain. CSS should ideally be on the same domain as the HTML file, to display a styled site as quickly as possible.

CDNs are typically a great place to store your static assets for quick download. Easier to link to Wikipedia than try and explain it :) http://en.wikipedia.org/wiki/Content_delivery_network

# Conclusion
When looking at web page performance improvement after a site has been completed, typically the only thing that gets looked at is reducing file size and reducing requests. While these do provide a large improvement to overall page speed performance, these things should be looked at during the initial creation. By looking at performance earlier on in a project, it's easier to focus on improving JavaScript and CSS performance, which wasn't really discussed.

I won't fault the developers for not completing some of these things that I've listed above. When we're working on a project we have priorities, and things end up changing on us, and we have deadlines, and so forth. Sometimes we, as developers, simply don't know about these things, or if we do, cannot make the time to complete them, or are unable to convince others that it's worth our time to complete.

I don't know how much traffic http://us.battle.net/wow/en/warlords-of-draenor/ gets on a monthly basis. However, 1.8MB per user per visit being removed can have major improvements to a company's overall bandwidth charges. 10,000 visitors * 1.8MB = 17.6GB. And since this is Blizzard I'm assuming the number is much higher.
