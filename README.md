# Markov Chain Generator
A reasonably efficient markov chain implementation in ruby.

See [this](https://blog.codinghorror.com/markov-and-you/) blog post for a good
explanation from Jeff Atwood.

## Usage:
```
$ ruby markov_generator.rb demo_text_1.txt demo_text_2.txt
Model contains 263517 words
Trump on christie:
"christie is approved, it down, they turn a really doesn't help and indeed the
people."
```


## Implementation
The general idea for the implementation is pretty straightforward:

- Read through each pair of words in the source text
- Using the first word as an index into a hashtable, add the second word to a
  datastructure of possible outcomes.
- Using a seed word (or random key from the hashtable), sample each word until
  you reach a period and bam, you have a markov chain generated sentence.

I used the __inverse transform sampling__ method for sampling each word as
described in this [stackoverflow
post.](http://stackoverflow.com/questions/17250568/randomly-choosing-from-a-list-with-weighted-probabilities)

This should give nlogn performance with n memory, so even with large corpus, it
should be relatively quick.

Running this with ~250,000 words in the corpus takes ~.9 seconds to run on my
2014 mbp.
