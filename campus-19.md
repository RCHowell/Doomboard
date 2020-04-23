# Campus-19

## Purpose
...

## Generating Problems
This subheading speaks to me on an emotional level.

### Approach 1 - All the Possibilities.
I have twelve holds labeled A-L. Generating problems by permuting the holds would result in 12! ~ 480 million routes. This number goes to (12^12) 8.9 trillion if you allow repeats. Nice -- I'll never run out. Unfortunately, I do not want to browse a sample space that big -- I already do that on Instagram. Also, I'd rather not include problems with fewer than four holds and greater than ~7.

### Approach 2 - Some of the Possiblities.
I can drastically decrease the sample space by using combinations instead of permutations. It would be nice to have the generated problems *force* sequences by having the holds in a specfic order; however, I know that the quality of the problems would suffer without human ~imagination~.

Like Approach 1, counting routes with combinations is pretty easy. This is a good opportunity for a classic "sum of combinations" identity.

For each hold we have one choice when forming a problem: should I include this hold or not? There are 2 outcomes for [N] holds which is 2^N routes. 

We can also count the total number of problems by summing the number of routes with 1 hold, 2 holds, 3 holds, ..., up to [N] holds. Let XcY be (X choose Y). This is a counting proof for the classic Nc0+Nc1+Nc2+....+NcN = 2^N. Plug in N = 12 and we get 4096 routes. Better, but that's still way too many.

We have at least two issues. First, both of these counting methods include the problem with zero holds. I'd really like to do this problem, but I haven't figure out how to start it. More generally, it includes routes outside the length \in [4, 7] range. Second, there are no repeated holds. In practice, I've noticed that using a particular hold more than once creates many fun variations.


### Approach 3 - ... Fewer of the Possibilities

By dropping problems with fewer than four holds and greater than seven holds, we don't only decrease the sample space by 20%. This is easy to see with the heavily weighted interior of [Pascal's triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle).

```
(12 chose 4) + (12 choose 5) + (12 choose 6) + (12 choose 7) = 3003
```



### Approach 4 - 

### Best Twelve Letters

Most Common First Letters of 3 Letter Words
```
cat /usr/share/dict/words | cut -b 1 | tr '[:upper:]' '[:lower:]' | uniq -c | sort -nr
```

Most Common Laster Letters of 3 Letter Words
```
awk 'length($0) == 3 {print substr($0,length,1)}' /usr/share/dict/words | sort | uniq -c | sort -nr
```


