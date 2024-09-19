### Special Characters and Concepts of vim regexp From AI

1. Word Boundaries
   - `\b`: Matches a word boundary (start or end of a word)
   - Example: `/hello\b world/` matches "world" but not "worldly"

2. Anchors
   - `^`: Matches the start of a line
   - `$`: Matches the end of a line
   - Example: `/^Hello/` matches lines starting with "Hello"
   - `/World$/` matches lines ending with "World"

3. Quantifiers
   - `*`: Zero or more occurrences
     - Example: `/a*b/` matches "a", "ab", "abb", etc.
   - `+`: One or more occurrences
     - Example: `/a+b/` matches "ab", "abb", etc.
   - `?`: Optional (zero or one occurrence)
     - Example: `/a?b/` matches "b" or "ab"
   - `{n}`: Exactly n occurrences
     - Example: `/a{3}b/` matches "aab"
   - `{n,m}`: Between n and m occurrences
     - Example: `/a{2,3}b/` matches "aab" or "abb"

4. Character Classes
   - `[abc]`: Matches any character in the class
   - `[^abc]`: Matches any character not in the class
   - Example: `/[a-zA-Z]/` matches any letter
   - `/[^0-9]/` matches any non-digit character

5. Special Character Classes
   - `\d`: Matches any digit
   - `\D`: Matches any non-digit character
   - `\w`: Matches any word character (letter, digit, or underscore)
   - `\W`: Matches any non-word character
   - `\s`: Matches any whitespace character
   - `\S`: Matches any non-whitespace character
   - `\l`: Matches any lowercase letter
   - `\L`: Matches any non-lowercase character
   - `\u`: Matches any uppercase letter
   - `\U`: Matches any non-uppercase character
   - `\h`: Matches any hexadecimal digit
   - `\H`: Matches any non-hexadecimal digit

6. Grouping
   - `\(...\)`: Creates a capture group
   - Example: `/(\w+)\s+(\w+)/` captures words separated by spaces

7. Lookahead Assertions
   - `(?=pattern)`: Positive lookahead
   - Example: `/\w+(?=ing)/` matches words ending with "ing"
   - `(?!pattern)`: Negative lookahead
   - Example: `/\w+(?!ing)/` matches words not ending with "ing"

8. Lookbehind Assertions
   - `(?<=pattern)`: Positive lookbehind
   - Example: `/(?<=\w+)ing/` matches "ing" preceded by a word
   - `(?<!pattern)`: Negative lookbehind
   - Example: `/(?<!\w+)ing/` matches "ing" not preceded by a word

9. Backreferences
   - `\1`, `\2`, etc.: Refer to captured groups
   - Example: `/(\w+)\s+\1/` matches repeated words

10. Escaping
    - `\`: Escapes special characters
    - Example: `/\\` matches a backslash

11. Special Modes
    - `\v`: Very magic mode (treats most characters as special)
    - `\m`: Magic mode (default)
    - `\V`: No very magic mode
    - `\M`: No magic mode

12. Substitution Patterns
    - `\=`: Used in substitution to insert the result of a Vim expression
    - Example: `:%s/\(.*\)/\=substitute(submatch(1), '\n', '', '')/g`

13. Line Numbers
    - `\%N`: Matches the Nth line
    - Example: `/^\%2/` matches the second line

14. Column Numbers
    - `\%mN`: Matches column N on line m
    - Example: `/^\%2,5/` matches columns 1 through 5 on line 2

15. Repetition Operators
    - `*`: Zero or more occurrences
    - `+`: One or more occurrences
    - `?`: Optional (zero or one occurrence)
    - `{n}`: Exactly n occurrences
    - `{n,m}`: Between n and m occurrences

16. Alternation
    - `|`: OR operator
    - Example: `/a|b/` matches "a" or "b"

17. Character Properties
    - `\p`: Matches any Unicode property value
    - Example: `/\p{Lu}/` matches any uppercase letter

18. Negation
    - `[^...]`: Matches anything not in the set
    - Example: `/[^a-zA-Z]/` matches any non-letter character

19. Word Boundary
    - `\b`: Matches a word boundary
    - Example: `/hello\b world/` matches "world" but not "worldly"

20. Whitespace
    - `\s`: Matches any whitespace character
    - `\S`: Matches any non-whitespace character
    - Example: `/\s\+/` matches one or more whitespace characters

21. Case Sensitivity
    - `\c`: Makes the match case-sensitive
    - Example: `/hello\c world/` matches "world" regardless of case

22. Greedy vs. Lazy Matching
    - `*`: Greedy (matches as much as possible)
    - `*?`: Lazy (matches as little as possible)
    - Example: `/a\*?b/` matches "ab" or "aab"

23. Conditional Expressions
    - `(?if-then-else)`: Conditional expression
    - Example: `/^(?i:hello)/` matches "hello" case-insensitively

24. Named Groups
    - `\k<name>`: Defines a named group
    - Example: `/(\k<word>\s+\k<word>)/` defines named groups for words

25. Unicode Support
    - `\u`: Matches any Unicode character
    - `\U`: Matches any non-Unicode character
    - Example: `/\u{1F600}/` matches the emoji face smiling

26. POSIX Character Classes
    - `[:class:]`: Matches any character in the POSIX class
    - Example: `/[[:alpha:]]/` matches any letter

27. Extended Regular Expressions
    - `//e`: Enables extended regex syntax
    - Example: `/\v(everything)/e` enables extended regex syntax

28. Substitution Flags
    - `&`: Replaces with the entire match
    - Example: `/(&)/` replaces with the entire match

29. Substitution Functions
    - `\=`: Used in substitution to evaluate a Vim expression
    - Example: `:%s/\(.*\)/\=substitute(submatch(1), '\n', '', '')/g`

30. Line Anchors
    - `\m`: Matches the start of a line
    - `\M`: Matches the end of a line
    - Example: `/^Hello/` matches lines starting with "Hello"
    - `/World$/` matches lines ending with "World"

31. Word Anchors
    - `\B`: Matches a position where a word character is not allowed
    - Example: `/\B\w/` matches a word character not at a word boundary

32. Possessives
    - `++`: Possessive quantifier (greedy but cannot backtrack)
    - Example: `/a\++/` matches "aa" or "aaa" but not "aba"

33. Atomic Groups
    - `(?>...)`: Atomic group (cannot be split across multiple lines)
    - Example: `/((?>\w+)\s+(?>\w+))/` creates atomic groups for words

34. Branch Reset Groups
    - `\K`: Resets the branch reset group
    - Example: `/\K\w/` resets the branch reset group

35. Recursive Patterns
    - `(?R)`: Recurses to the previous set of parentheses
    - Example: `/((?R))\s*\1/` matches repeated words

36. Subroutine Definitions
    - `(?P<name>...)`: Defines a subroutine
    - Example: `/(?P<word>\w+)\s+(?P=word)/` defines a subroutine for words

37. Conditional Substitutions
    - `(?if-then-else)`: Conditional substitution
    - Example: `:%s/(?i:hello)/\=substitute(submatch(0), 'hello', 'HELLO', '')/g`

38. Extended Substitutions
    - `//E`: Enables extended substitution syntax
    - Example: `/(&)/E` enables extended substitution syntax

39. Substitution Functions
    - `\=`: Used in substitution to evaluate a Vim expression
    - Example: `:%s/\(.*\)/\=substitute(submatch(1), '\n', '', '')/g`

40. Substitution Flags
    - `&`: Replaces with the entire match
    - Example: `/(&)/` replaces with the entire match

41. Substitution Functions
    - `\=`: Used in substitution to evaluate a Vim expression
    - Example: `:%s/\(.*\)/\=substitute(submatch(1), '\n', '', '')/g`

42. Line Anchors
    - `\m`: Matches the start of a line
    - `\M`: Matches the end of a line
    - Example: `/^Hello/` matches lines starting with "Hello"
    - `/World$/` matches lines ending with "World"

43. Word Anchors
    - `\B`: Matches a position where a word character is not allowed
    - Example: `/\\B\w/` matches a word character not at a word boundary

44. Possessives
    - `++`: Possessive quantifier (greedy but cannot backtrack)
    - Example: `/a\++/` matches "aa" or "aaa" but not "aba"

45. Atomic Groups
    - `(?>...)`: Atomic group (cannot be split across multiple lines)
    - Example: `/((?>\w+)\s+(?>\w+))/` creates atomic groups for words

46. Branch Reset Groups
    - `\K`: Resets the branch reset group
    - Example: `/\\K\w/` resets the branch reset group

47. Recursive Patterns
    - `(?R)`: Recurses to the previous set of parentheses
    - Example: `/((?R))\\s*\\1/` matches repeated words

48. Subroutine Definitions
    - `(?P<name>...)`: Defines a subroutine
    - Example: `/(?P<word>\\w+)\\s+(?P=word)/` defines a subroutine for words

49. Conditional Substitutions
    - `(?if-then-else)`: Conditional substitution
    - Example: `:%s/(?i:hello)/\\=substitute(submatch(0), 'hello', 'HELLO', '')/g`

50. Extended Substitutions
    - `//E`: Enables extended substitution syntax
    - Example: `/(&)/E` enables extended substitution syntax

51. Substitution Functions
    - `\\=`: Used in substitution to evaluate a Vim expression
    - Example: `:%s/(.*)/\\=substitute(submatch(1), '\\n', '', '')/g`

52. Substitution Flags
    - `&`: Replaces with the entire match
    - Example: `/




Citations:
[1] https://dev.to/iggredible/learning-vim-regex-26ep
[2] https://vimregex.com/
[3] https://stackoverflow.com/questions/28466634/how-do-i-match-any-sequence-of-letters-and-something-else-in-vim
[4] https://www.reddit.com/r/vim/comments/ni37c9/why_are_vivim_regex_special_characters/
[5] https://thevaluable.dev/regular-expression-basics-vim-grep/
[6] https://vi.stackexchange.com/questions/9092/search-and-replace-with-multiple-special-characters
[7] https://learnbyexample.github.io/vim_reference/Regular-Expressions.html
[8] https://unix.stackexchange.com/questions/60481/match-word-containing-characters-beyond-a-za-z
[9] https://thevaluable.dev/vim-regular-expressions-in-depth/
[10] https://superuser.com/questions/1435061/vim-regex-pattern-unable-to-search-and-replace-characters-that-are-between-brace
