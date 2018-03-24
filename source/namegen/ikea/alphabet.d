module namegen.ikea.alphabet;

package:

string whole = "abcdefghijklmnoprstuvy";
string consonants =  "bcdfghjklmnprstvy";
string vowels = "aeiou";

string[wchar] after;

static this()
{
    string[wchar] a;

    a['a'] = "abcdefghijklmnoprstuvy";
    a['b'] = a['a'];
    a['c'] = "abdefghijklmnoprstuvy";
    a['d'] = "abcefghijklmnoprstuvy";
    a['e'] = a['a'];
    a['f'] = "abcdeghijklmnoprstuvy";
    a['g'] = "abcdefhijklmnoprstuvy";
    a['h'] = "abcdefgijklmnoprstuvy";
    a['i'] = a['a'];
    a['j'] = "abcdefghiklmnoprstuvy";
    a['k'] = "abcdefghijlmnoprstuvy";
    a['l'] = a['a'];
    a['m'] = "abcdefghijklnoprstuvy";
    a['n'] = a['a'];
    a['o'] = a['a'];
    a['p'] = a['a'];
    a['r'] = a['p'];
    a['s'] = "abcdefghijklmnoprtuvy";
    a['t'] = a['a'];
    a['u'] = a['a'];
    a['v'] = "abcdefghijklmnoprstuy";
    a['y'] = "abcdefghijklmnoprstuv";

    after = a;
}

unittest
{
    import std.stdio;

    foreach(ref s; after.keys)
    {
        foreach(si; after.keys)
        {
            //~ if(s != si && after[s] == after[si])
                //~ assert(false, s~" equals "~si);
        }
    }
}
