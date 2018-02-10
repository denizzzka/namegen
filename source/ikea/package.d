/**
IKEA Name Generator

Based on code by Kate McFaul:
https://github.com/craftykate/ikea-name-generator
*/
module namegen.ikea;

//~ pure:

string generateName()
{
    import std.conv: to;

    return generateNameWide.to!string;
}

wchar[] generateNameWide()
{
    wchar[] word;

    ubyte minLength = 3;
    ubyte maxLength = 10;
    const ubyte wordLength = uniform(minLength, maxLength, rndg);

    for (ubyte i = 0; i < wordLength; i++)
        word ~= returnNextLetter(word);

    // Checks if word ended with two consonants. For readability, end with an extra vowel
    word.endWord;

    // Format name to add Swedish characters if possible
    word.formatSwedish;

    import std.string: capitalize;

    return word.capitalize;
}

unittest
{
    import std.stdio;

    foreach(i; 0 .. 13)
    {
        auto s = generateName;

        assert(i != 0 || s == "Åökpe", s);
        assert(i != 5 || s == "Öålih", s);
        assert(i != 12 || s == "Tigra", s);
    }
}

private:

static import alphabet = namegen.ikea.alphabet;
import std.random;

// Seed a random generator with a constant
auto rndg = Random(42);

// Main function to get and return the next letter
char returnNextLetter(in wchar[] word)
{
    static ubyte numConsonants;
    static ubyte numVowels;

    char nextLetter;

    // If it's the first letter, grab any letter
    if (word.length == 0)
    {
        nextLetter = grabAnyLetter();

    }
    // If it's not the first letter...
    // And there are too many consonants before it, grab a vowel
    // Or it's the second letter and the first wasn't a vowel (this makes sure there's a vowel in the first two letters for readability)
    else if (numConsonants == 2 || (word.length == 1 && numConsonants == 1))
    {
        nextLetter = grabAVowel();
    }
    // Or if there are too many vowels grab a consonant
    else if (numVowels == 2)
    {
        nextLetter = grabAConsonant();
        numConsonants++;
        numVowels = 0;
    }
    else // Otherwise, grab the next acceptable letter
    {
        nextLetter = grabNextGoodLetter(word);
        numVowels++;
        numConsonants=0;
    }

    return nextLetter;
}

/// Get random letter from string of letters
char grabRandomLetter(in string str)
{
    auto idx = uniform(0, str.length, rndg);

    return str[idx];
}

/// Get any letter from alphabet
char grabAnyLetter()
{
    return alphabet.whole.grabRandomLetter;
}

char grabAVowel()
{
    return alphabet.vowels.grabRandomLetter;
}

char grabAConsonant()
{
    return alphabet.consonants.grabRandomLetter;
}

/// Get a letter than can follow the last letter
char grabNextGoodLetter(in wchar[] word)
{
    const lastLetter = word[$-1];

    return alphabet.after[lastLetter].grabRandomLetter;
}

import std.algorithm.searching: canFind;

bool isVowel(wchar c)
{
    return alphabet.vowels.canFind(c);
}

// For readability, make sure word has a vowel in the last two letters
void endWord(ref wchar[] word)
{
    if(!word[$-2].isVowel && !word[$-1].isVowel)
        word ~= grabAVowel();
}

// Change first a and o (if present) to swedish characters
void formatSwedish(ref wchar[] word)
{
    // 50/50 chance of changing first 'a'
    if(dice(rndg, 50, 50) == 0)
        word.replaceFirst('a', 'å');

    // 50/50 chance of changing first 'o'
    if(dice(rndg, 50, 50) == 0)
        word.replaceFirst('o', 'ö');
}

void replaceFirst(ref wchar[] word, char from, wchar to)
{
    auto idx = canFind(word, from);
    word[idx] = to;
}
