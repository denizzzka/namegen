/// People name generator
module namegen.people;

struct Name
{
    string first;
    string last;

    string full() const
    {
        return first~" "~last;
    }
}

Name createName(bool isFemale = false)
{
    Name ret;

    ret.first = selectName(isFemale ? femaleFirst : maleFirst);

    ret.last = selectName(lastNames);

    return ret;
}

unittest
{
    assert(createName(false).full == "Kevin Toll");
    assert(createName(false).full == "Rob Price");

    assert(createName(true).full == "Erika Ressler");
    assert(createName(true).full == "Sally Coe");
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
        assert(a[1].isNumeric);
        assert(a[2].isNumeric);
        assert(a[3].isNumeric);

        name = a[0].capitalize;
        cumulative = a[2].to!float;

        assert(cumulative > 0);
    }
}

// Compile time parsing for big text files is too slow by now, therefore this function is unused
NameRecord[] getNamesRecordsCTFE(string filename)()
{
    enum text = import(filename);

    return getNamesRecordsFromText(text);
}

NameRecord[] getNamesRecordsFromText(string text)
{
    string line;
    NameRecord[] recs;

    foreach(c; text)
    {
        if(c != '\n')
        {
            line ~= c;
        }
        else
        {
            import std.array: split;

            recs ~= NameRecord(line.split);
            line.length = 0;
        }
    }

    return recs;
}

const NameRecord[] maleFirst;
const NameRecord[] femaleFirst;
const NameRecord[] lastNames;

static this()
{
    immutable maleFirstTextLines = import("dist.male.first");
    immutable femaleFirstLines = import("dist.female.first");
    immutable lastTextLines = import("dist.all.last");

    maleFirst = getNamesRecordsFromText(maleFirstTextLines);
    femaleFirst = getNamesRecordsFromText(femaleFirstLines);
    lastNames = getNamesRecordsFromText(lastTextLines);
}

unittest
{
    assert(maleFirst[0].name == "James", maleFirst[0].name);
    assert(maleFirst[1218].name == "Alonso", maleFirst[1218].name);
}
