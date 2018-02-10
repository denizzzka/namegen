/// People name generator
module namegen.people;

struct Name
{
    string first;
    string last;
}

Name createName()
{
    Name ret;

    ret.first = selectName(maleFirst);

    return ret;
}

unittest
{
    import std.stdio;

    writeln(createName);
    writeln(createName);
    writeln(createName);
}

private:

import std.random;

auto rndg = Random(42);

string selectName(in NameRecord[] names)
{
    enum cumMax = 90.5f;

    assert(names[$-1].cumulative < cumMax);

    float selected = uniform(0.0f, cumMax, rndg);

    foreach(const ref n; names)
    {
        if(n.cumulative > selected)
            return n.name;
    }

    assert(false);
}

struct NameRecord
{
    import std.string: isNumeric, capitalize;
    import std.conv: to;

    string name;
    float cumulative;

    this(string[] a)
    {
        assert(a.length == 4);
        assert(!a[0].isNumeric);
        assert(a[1].isNumeric);
        assert(a[2].isNumeric);
        assert(a[3].isNumeric);

        name = a[0].capitalize;
        cumulative = a[2].to!float;

        assert(cumulative > 0);
    }
}

NameRecord[] getNamesRecords(string filename)()
{
    import std.string: splitLines;
    import std.array: split;

    enum lines = import(filename).splitLines;

    NameRecord[] recs;

    static foreach(string line; lines)
        recs ~= NameRecord(line.split);

    return recs;
}

immutable maleFirst = getNamesRecords!"dist.male.first";
//~ immutable femaleFirst = getNamesRecords!"dist.female.first";
//~ immutable last = getNamesRecords!"dist.all.last";

unittest
{
    assert(maleFirst[0].name == "James", maleFirst[0].name);
    assert(maleFirst[1218].name == "Alonso", maleFirst[1218].name);
}
