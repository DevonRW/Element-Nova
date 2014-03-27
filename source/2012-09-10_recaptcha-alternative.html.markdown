---
title: Recaptcha alternative
slug: recaptcha-alternative
time: 03:16:33
---
We used to think that recaptcha was great. All we had to do was drop a small script into our server side driven site, and BOOM no more spam.

We were not paying attention to what we actually did, however. We made it annoying for our users. Every single one of our users then had to squint at a screen and enter two barely readable (and more and more recently it became completely unreadable) words.

We took our problem and made it our users' problem. That is terrible. We're engineers and scientists and other fancy words/phrases that make use sound super smart. We solve the problem, not pass the buck.

Now there is an unusable element on all of our forms that needs to be removed.

We found a, better, alternative.
<blockquote>Stop the spam on the server.</blockquote>
We rolled a couple of our own solutions in one of our client's sites. I'm not sure of the correct naming of the second technique we used but the first one used is called "Honey Pot" and the second one is called "timestamp token....thingy technique" (see, no idea on the name)

I won't put the code we used here, but I'll tell you HOW it works.

## Honey Pot
Most bots will fill out every single field on a form for submitting. Some bots only fill out basic fields like name, email, address. So, we're going to catch poor old Pooh-bear with his hand in the honey jar.

Add an additional input (type text) field with a name of "name" (you could also use "address") to the start of your form.

On submission, if the field has ANYTHING entered into it, the form will not submit. We set it up to just appear like everything is fine but the form didn't pass validation, even though it appears that everything is fine.

Now, there is a form with an input field that you cannot put anything into. That isn't very user friendly.

We added 3 more things to clear this up.

1. We added a comment of "do not fill out this field" into the same element that was typically used for displaying the "required" field red *.
2. We added a style to the label of the honey pot field that made it hidden. Do that in your stylesheet, not inline.
3. We removed the label and input field from the DOM using Javascript.

So, there is only one possible way for someone to see that field now. Their web browser must not be able to handle basic css and cannot handle basic Javascript. Any other situation and it will not display.

Our users do not see the field, the high high high majority of web bots do not understand javascript so they element remains in the DOM for them to stick their dirty little fingers into. And after they fill out that field and submit to spam away, nothing happens. The form comes back and it appears that everything is okay but the submission just did not work.

I admit, I was a little bit concerned that a bot would get stuck in an infinite loop on our site, but I figured one connection constantly loading a page for now until who knows when would be acceptable since it takes more than one form being submitted every 20 seconds to do a DDOS attack.

## Timestamp Token ... Thingy Technique
Another thing we learned while researching how bots work is that they submit forms almost instantly.

So, if you completely fill out a form and it's submitted in &lt;= 3 seconds. No worky.

Nothing was required for the front end of the site for this except a timestamp in a random hidden field. We also encrypted the timestamp and the name of the field is something that looks like it's required for some bizarre CMS.

On the server the field is unencrypted, checked that it's a valid timestamp and that it's from more than 4 seconds ago. If it isn't, the form appears that there is a problem and will not submit, just like the honey pot, but there isn't anything obvious about what is wrong.

Every now and then I was able to trigger this as a human by submitting the field and having a field be wrong (email address not formatted properly, or something of the like). If I VERY quickly fixed the error that I had created and submitted the form I could get the timestamp to be submitted too quickly. But this was on one of about nine or ten tries.

I'm not concerned about something like that as only people who are very familiar with these particular contact forms would be able to trigger this error. Also, if you submit a form and it says everything is fine but it doesn't submit, you end up spending a few seconds going over the form with a fine-tooth comb and realizing it should work, and click submit again in which it now works.

I had to sell myself a little bit on this that it wouldn't be a burden to our client's clients. However, the chances of someone running into this situation is a little bit less rare than a non-CSS/non-JS web browser coming by and using the form (in my opinion).

## The fruits of our labour
We've had the forms now live on our client's site for almost 2 weeks now, and guess what, 0 spam. We've seen about a 50% increase in form submissions (I'm guessing at that number, I do see a higher amount of submissions come through than before) and no spam.

To do this as opposed to integrating recaptcha into our site would have been the smart move back in 2008, since, based on the code we saw, it looks like it took about the same amount of time to put in these 2 techniques as it would have taken to integrate recaptcha into this home-grown CMS.
