string input = File.ReadAllText(@"input.txt");

int IndexOfFirstMarker<T>(List<T> list, int size) {
    return list
        .Where((element, index) => index <= list.Count() - size)
        .Select((element, index) => (subsequence: list.GetRange(index, size), index: index))
        .First(pair => pair.subsequence.Count() == pair.subsequence.Distinct().Count())
        .index + size;
}

int star1() {
    List<char> characters = new List<char>(input.ToCharArray());
    return IndexOfFirstMarker(characters, 4);
}

int star2() {
    List<char> characters = new List<char>(input.ToCharArray());
    return IndexOfFirstMarker(characters, 14);
}

void PrintUsage() {
    Console.WriteLine("Usage: {0} ( 1 | 2 )", System.AppDomain.CurrentDomain.FriendlyName);
}

if (args.Length == 0) {
    PrintUsage();
} else if (args[0] == "1") {
    Console.WriteLine(star1());
} else if (args[0] == "2") {
    Console.WriteLine(star2());
} else {
    PrintUsage();
}

