---
title: Setup Sublime Linter for PHP
slug: setup-sublime-linter-for-php
time: 15:20:14
---
SublimeLinter is a great tool for SublimeText2, however, it took a bit of research.

Installing is easy, go here: <a href="https://github.com/SublimeLinter/SublimeLinter#installing">https://github.com/SublimeLinter/SublimeLinter#installing</a>

Setting up for PHP development is the harder part.

After a bunch of research I figured it out

I have both wamp and xampp installed on my machine, but I used xampp for this example as that's the php path I found first.

In SublimeLinter -&gt; Settings - User add the following (yes you need to \s)
<code>
{
	"sublimelinter_executable_map":
    {
    	"php": "C:\\xampp\\php\\php.exe"
    }
}
</code>

And save. I found I had to reload ST2 to get it to work properly.

After you reload, open up a php file and rename the scope of a function or something, as you type it you will see the entire line (or sometimes the line below) get highlighted. This means it's working.

If you didn't see any line highlights, open up the the command line (ctrl/cmd+~) and you will see that PHP hadn't loaded properly into ST2. Fix up the path to your php.exe in the SublimeLinter User Settings and then you will be good to go.

## Update
Sublime Linter no longer highlights syntax every milisecond, it now waits for you to stop typing a bit or save.
